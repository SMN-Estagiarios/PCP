CREATE OR ALTER PROCEDURE [dbo].[SP_ListarRankingProdutosMaisVendidos]
    @Ano INT,
    @Mes INT
    AS
    /*
    Documentacao
    Arquivo Fonte.....: RelatorioPedidoProduto.sql
	Objetivo..........: Listar ranking dos produtos que mais vendidos.
	Autor.............: Danyel Targino
	Data..............: 06/06/2024
	Ex................: BEGIN TRAN

                            DBCC FREEPROCCACHE;
                            DBCC DROPCLEANBUFFERS;

                            DECLARE @DataInicio DATETIME = GETDATE()

                            EXEC [dbo].[SP_ListarRankingProdutosMaisVendidos] 2020, 3

                            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao

                        ROLLBACK TRAN
    */
    BEGIN
        -- Calculando o estoque inicial do inicio do mes
        WITH CTE_EstoqueInicial AS (
                                    SELECT  pp.IdProduto,
                                            SUM(pp.Quantidade) AS EstoqueInicial
                                    FROM [dbo].[Pedido] pe WITH (NOLOCK)
                                        INNER JOIN [dbo].[PedidoProduto] pp WITH (NOLOCK)
                                            ON pp.IdPedido = pe.Id
                                    WHERE pe.DataPedido < DATEFROMPARTS(@Ano, @Mes, 1)
                                    GROUP BY pp.IdProduto
        ),

        -- Calculando o estoque final do final do mes
        CTE_EstoqueFinal AS (
                                SELECT  pp.IdProduto,
                                        SUM(pp.Quantidade) AS EstoqueFinal
                                    FROM [dbo].[Pedido] pe WITH (NOLOCK)
                                        INNER JOIN [dbo].[PedidoProduto] pp WITH (NOLOCK)
                                            ON pp.IdPedido = pe.Id
                                    WHERE pe.DataPedido < DATEFROMPARTS(@Ano, @Mes + 1, 1)
                                    GROUP BY pp.IdProduto
        ),

        -- Calculo de vendas e producao
        CTE_DadosVendas AS (

                            SELECT  pp.IdProduto,
                                    pd.Nome,
                                    SUM(pp.Quantidade) AS TotalQuantidadeVendida,
                                    AVG(pp.Quantidade) AS MediaQuantidadeVendida,
                                    COUNT(DISTINCT pe.DataEntrega) AS VendasDiarias,
                                    AVG(pp.Quantidade / COUNT(DISTINCT pe.DataEntrega)) OVER (PARTITION BY pp.IdProduto) AS ProducaoDiaria
                            FROM [dbo].[Pedido] pe WITH (NOLOCK)
                                INNER JOIN [dbo].[PedidoProduto] pp WITH (NOLOCK)
                                    ON pp.IdPedido = pe.Id
                                INNER JOIN [dbo].[Produto] pd WITH (NOLOCK)
                                    ON pd.Id = pp.IdProduto
                            WHERE YEAR(pe.DataEntrega) = @Ano AND MONTH(pe.DataEntrega) = @Mes
                            GROUP BY pp.IdProduto, pd.Nome, pp.Quantidade
        )

        -- Gerando o relatorio final
        SELECT  cdv.IdProduto AS CodigoProduto,
                cdv.Nome AS NomeProduto,
                cdv.TotalQuantidadeVendida AS TotalQuantidadeVendida,
                cdv.MediaQuantidadeVendida AS MediaQuantidadeVendida,
                ISNULL(cei.EstoqueInicial, 0) AS EstoqueInicial,
                cef.EstoqueFinal AS EstoqueFinal,
                cdv.ProducaoDiaria AS MediaProducaoDiaria,
                DENSE_RANK() OVER (ORDER BY cdv.TotalQuantidadeVendida DESC) AS Ranking
            FROM CTE_DadosVendas cdv
                LEFT JOIN CTE_EstoqueInicial cei 
                    ON cdv.IdProduto = cei.IdProduto
                LEFT JOIN CTE_EstoqueFinal cef 
                    ON cdv.IdProduto = cef.IdProduto
            GROUP BY    cdv.IdProduto,
                        cdv.Nome,
                        cdv.TotalQuantidadeVendida,
                        cdv.MediaQuantidadeVendida,
                        cei.EstoqueInicial,
                        cef.EstoqueFinal
    END
GO