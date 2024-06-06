CREATE OR ALTER PROCEDURE [dbo].[SP_ListarProducoesTempoReal]
    AS
    /*
        Documentação
        Arquivo Fonte........:  ProvaJoao.sql
        Objetivo.............:  Procedure para listar todas as produções que estão sendo realizadas no momento da chamada (Questão 7)
        Autor................:  João Victor Maia
        Data.................:  06/06/2024
        Exemplo..............:  BEGIN TRAN

                                    --Limpar cache
                                    DBCC FREEPROCCACHE
                                    DBCC DROPCLEANBUFFERS
                                    DBCC FREESYSTEMCACHE('ALL')

                                    --Declarar variáveis
                                    DECLARE @Ret INT,
                                            @DataInicio DATETIME = GETDATE()

                                    --Inserção para exemplo
                                    UPDATE [dbo].[EstoqueMateriaPrima]
                                        SET QuantidadeFisica = 9999999
                                        WHERE IdMateriaPrima IN(1, 2, 3)

                                    INSERT INTO [dbo].[Pedido](IdCliente, DataPedido, DataPromessa)
                                        VALUES(1, GETDATE(), GETDATE() + 10)

                                    INSERT INTO [dbo].[PedidoProduto](IdPedido, IdProduto, Quantidade)
                                        VALUES(IDENT_CURRENT('Pedido'), 1, 69)

                                    INSERT INTO [dbo].[Producao](IdEtapaProducao, IdPedidoProduto, DataInicio, DataTermino, Quantidade)
                                        VALUES (1, IDENT_CURRENT('PedidoProduto'), GETDATE(), NULL, 1)

                                    --Capturar retorno
                                    EXEC @Ret = [dbo].[SP_ListarProducoesTempoReal]

                                    --Listar retorno e tempo
                                    SELECT  @Ret as Retorno,
                                            DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao
                                    
                                ROLLBACK TRAN
        Retornos.............:  0 - Sucesso
                                1 - Não há produções em tempo real
    */ --idprod = 104915    idpedprod = 29944
    BEGIN
        
        --Declarar variável
        DECLARE @DataAtual DATETIME = GETDATE()

        --Checar se há alguma produção em tempo real
        IF NOT EXISTS   (
                            SELECT TOP 1 1
                                FROM [dbo].[Producao] pr WITH(NOLOCK)
                                WHERE pr.DataTermino IS NULL
                        )
            BEGIN
                RETURN 1
            END;

        --Buscar a data da última produção de cada produto
        WITH UltimaProducao AS
        (
            SELECT  pp.IdProduto,
                    MAX(pr.DataTermino) AS DataUltimaProducao
                FROM [dbo].[Producao] pr WITH(NOLOCK)
                    INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        ON pr.IdPedidoProduto = pp.Id
                WHERE pr.DataTermino IS NOT NULL  
                GROUP BY pp.IdProduto
        ),
        --Checar se houve compra de matéria prima
        CompraMateriaPrima AS
        (
            SELECT  DISTINCT    pr.Id AS IdProducao,
                                (
                                    CASE WHEN memp.idTipoMovimentacao = 1 THEN 'Sim'
                                    END
                                ) AS Compra
                FROM [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima] amemp WITH(NOLOCK)
                    INNER JOIN [dbo].[Pedido] pe WITH(NOLOCK)
                        ON amemp.IdPedido = pe.Id
                    INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        ON pe.Id = pp.IdPedido
                    INNER JOIN [dbo].[Producao] pr WITH(NOLOCK)
                        ON pp.Id = pr.IdPedidoProduto
                    INNER JOIN [dbo].[MovimentacaoEstoqueMateriaPrima] memp WITH(NOLOCK)
                        ON amemp.IdMovimentacaoEstoqueMateriaPrima = memp.Id
        )
            --Listar as produções em tempo real
            SELECT  pe.Id AS IdPedido,
                    po.Id AS IdProduto,
                    po.Nome AS NomeProduto,
                    pr.Quantidade AS QuantidadeProducao,
                    (   
                        CASE    WHEN DATEDIFF(MINUTE, pr.DataInicio, @DataAtual) > ep.Duracao THEN 'Sim'
                                ELSE 'Não'
                        END
                    ) AS Atraso,
                    up.DataUltimaProducao,
                    cmp.Compra
                FROM [dbo].[Producao] pr WITH(NOLOCK)
                    INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        ON pr.IdPedidoProduto = pp.Id
                    INNER JOIN [dbo].[Pedido] pe WITH(NOLOCK)
                        ON pp.IdPedido = pe.Id
                    INNER JOIN [dbo].[Produto] po WITH(NOLOCK)
                        ON pp.IdProduto = po.Id
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        ON pr.IdEtapaProducao = ep.Id
                    INNER JOIN [UltimaProducao] up
                        ON pp.IdProduto = up.IdProduto
                    INNER JOIN [CompraMateriaPrima] cmp
                        ON pp.Id = cmp.IdProducao
                WHERE   pr.DataTermino IS NULL
                        AND cmp.Compra IS NOT NULL
                ORDER BY pr.Id DESC
    END
GO

