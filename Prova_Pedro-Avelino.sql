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
                        DBCC DROPCLEANBUFFERS
                        DBCC FREEPROCCACHE
                        DBCC FREESYSTEMCACHE('ALL')

                        DECLARE @DataInicio DATETIME = GETDATE();

                        EXEC [dbo].[SP_PedidoAtrasado] @Ano = 2020, @Mes = 1; 

                        SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;
    
    Retornos..........: 2 - Ano inválido
                        1 - Mês inválido
                        0 - Sucesso                     
*/

BEGIN

    --Declaração da variável referente a data atual
    DECLARE @DataAtual DATETIME = GETDATE(); 

    --Verificação da validade do ano 
    IF @Ano IS NOT NULL AND (@Ano < 2020 OR @Ano > YEAR(GETDATE()))
        BEGIN 
            RAISERROR('Ano inválido. Por favor, insira um ano entre 2020 e o ano atual', 16, 1);
            RETURN 2;
        END

    -- Verificação da validade do mês
    IF @Mes IS NOT NULL AND (@Mes < 1 OR @Mes > 12)
        BEGIN 
            RAISERROR('Mês inválido. Por favor, insira um mês entre 1 e 12', 16, 1);
            RETURN 1;
        END;


    --Consulta do pedido junto com detalhes do produto e as etapas;
    SELECT  pdd.Id AS 'Id do Pedido',
            pdt.Id AS 'Código do Produto',
            pdt.Nome AS 'Nome do Produto',
            ep.NumeroEtapa AS "Etapa de Atraso",
            DATEDIFF(DAY, pdd.DataPromessa, ISNULL(pdd.DataEntrega, @DataAtual)) AS 'Quantidade de dias de atraso do pedido',
            CASE 
                WHEN (memap.Quantidade > 0) 
                    THEN 'Sim'
                    ELSE 'Não' 
                END AS 'Houve a necessidade de compra de matéria-prima?'
        FROM [dbo].[Pedido] pdd 
            INNER JOIN [dbo].[PedidoProduto] pp 
                ON pdd.Id = pp.IdPedido
            INNER JOIN [dbo].[Produto] pdt
                ON pdt.Id = pp.IdProduto 
             INNER JOIN [dbo].[EtapaProducao] ep
                ON pdt.Id = ep.IdProduto
            INNER JOIN [dbo].[Producao] pdc
                ON pp.Id = pdc.IdPedidoProduto
            INNER JOIN [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima] amem
                ON pdd.Id = amem.IdPedido
            INNER JOIN [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima] amemp
                ON pdd.Id = amemp.IdPedido
            INNER JOIN MovimentacaoEstoqueMateriaPrima memap
                ON memap.Id = amemp.IdMovimentacaoEstoqueMateriaPrima
            WHERE YEAR(pdd.DataPedido) = @Ano 
                AND MONTH(pdd.DataPedido) = @Mes 
                AND DATEDIFF(MINUTE, pdc.DataInicio, pdc.DataTermino) > Duracao
                AND ((DataEntrega IS NULL AND DataPromessa > @DataAtual) 
                    OR (DataEntrega IS NOT NULL AND DataPromessa < DataEntrega))
            GROUP BY pdd.Id, pdt.Id, pdt.Nome, ep.NumeroEtapa, pdd.DataPromessa, pdd.DataEntrega, memap.Quantidade
            ORDER BY pdd.Id;
    RETURN 0;
END;


