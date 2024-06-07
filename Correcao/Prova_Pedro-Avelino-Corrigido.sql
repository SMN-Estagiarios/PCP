CREATE OR ALTER PROCEDURE [dbo].[SP_PedidoAtrasado] 
    @Ano INT,
    @Mes INT
AS
/*
    Documentação
    Arquivo Fonte.....: Prova_Pedro-Avelino.sql
    Objetivo..........: Listar todos os pedidos que sofreram atraso na entrega devido a atrasos na produção, referentes a algum ano e mês específico;
    Autor.............: Pedro Avelino;
    Data..............: 06/06/24
    Ex................:
                        BEGIN TRAN
                            DBCC DROPCLEANBUFFERS
                            DBCC FREEPROCCACHE
                            DBCC FREESYSTEMCACHE('ALL')                                

                            DECLARE @DataInicio DATETIME = GETDATE(),
                                    @Retorno INT;

                            EXEC @Retorno = [dbo].[SP_PedidoAtrasado] 2020, 1; 

                            SELECT  @Retorno AS Retorno,
                                    DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;
                        ROLLBACK TRAN

    Retornos..........: 3 - Ano inválido
                        2 - Mês inválido
                        1 - Não há registros de pedidos no mês especificado
                        0 - Sucesso                     
*/
BEGIN

    --Declaração da variável referente a data atual
    DECLARE @DataAtual DATETIME = GETDATE(); 

    --Verificação da validade do ano 
    IF @Ano IS NOT NULL AND (@Ano < 2020 OR @Ano > YEAR(GETDATE()))
        BEGIN            
            RETURN 3;
        END

    -- Verificação da validade do mês
    IF @Mes IS NOT NULL AND (@Mes < 1 OR @Mes > 12)
        BEGIN             
            RETURN 2;
        END;

    --Verificação se existem pedidos naquele período especificado
    IF NOT EXISTS (
                    SELECT TOP 1 1
                        FROM [dbo].[Pedido] p
                        WHERE (@Ano IS NOT NULL)
                        AND(@Mes IS NOT NULL)
    )
        BEGIN             
            RETURN 1;
        END

    --Consulta do pedido junto com detalhes do produto e as etapas; select * from pedido where 
    SELECT  DISTINCT pdd.Id AS 'Id do Pedido',
            pdt.Id AS 'Código do Produto',
            pdt.Nome AS 'Nome do Produto',
            ep.NumeroEtapa AS "Etapa de Atraso", 
            pd.QTD AS 'Dias de Atraso do Pedido',          
            CASE                 
                WHEN (memap.IdTipoMovimentacao = 1)
                    THEN 'Sim'
                    ELSE 'Não' 
                END AS 'Houve a necessidade de compra de matéria-prima?'
        FROM [dbo].[Pedido] pdd WITH(NOLOCK)
            INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                ON pdd.Id = pp.IdPedido 
            INNER JOIN [dbo].[Produto] pdt WITH(NOLOCK)
                ON pdt.Id = pp.IdProduto 
             INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                ON pdt.Id = ep.IdProduto
            INNER JOIN [dbo].[Producao] pdc WITH(NOLOCK)
                ON pp.Id = pdc.IdPedidoProduto
            INNER JOIN [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima] amem WITH(NOLOCK)
                ON pdd.Id = amem.IdPedido         
            INNER JOIN [MovimentacaoEstoqueMateriaPrima] memap WITH(NOLOCK)
                ON memap.Id = amem.IdMovimentacaoEstoqueMateriaPrima
            INNER JOIN  (
                            SELECT  Id, 
                                    DATEDIFF(DAY, DataPromessa, ISNULL(DataEntrega, @DataAtual)) QTD
                                FROM Pedido
                        ) pd
                ON pdd.Id = pd.Id
            WHERE YEAR(pdd.DataPedido) = @Ano 
                AND MONTH(pdd.DataPedido) = @Mes 
                AND DATEDIFF(MINUTE, pdc.DataInicio, pdc.DataTermino) > ep.Duracao                
                AND (pdd.DataPromessa < ISNULL(pdd.DataEntrega,@DataAtual))                               
            GROUP BY pdd.Id, pdt.Id, pdt.Nome, ep.NumeroEtapa, memap.Quantidade, pd.QTD, memap.IdTipoMovimentacao               
            ORDER BY pdd.Id,pdt.Id ;
    RETURN 0;
END;
