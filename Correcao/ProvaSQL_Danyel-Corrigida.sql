CREATE OR ALTER PROCEDURE [dbo].[SP_ListarRankingProdutosMaisVendidos]
    @Ano INT = NULL,
    @Mes INT = NULL
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

                            DECLARE @DataInicio DATETIME = GETDATE(),
                                    @Retorno INT;

                            EXEC @Retorno = [dbo].[SP_ListarRankingProdutosMaisVendidos] 2024, 1

                            SELECT  @Retorno AS Retorno,
                                    DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao

                        ROLLBACK TRAN
    Retorno...........: 00 - Sucesso.
                        01 - Erro, algum dos parametros nao foi passado.
                        02 - Erro, verifique se foi executado corretamente.
                        03 - O banco de dados nao possui registros para esse mes e ano.
    */
    BEGIN
        -- Declarando variaveis necessarias
        DECLARE @Linha INT,
                @Erro INT;

        -- Analisando se os parametros foram passados corretamente
        IF @Ano IS NULL OR @Mes IS NULL OR (@Mes > 12 OR @Mes < 1)
            RETURN 1;

        -- Calculando o estoque inicial do inicio do mes
        WITH CTE_EstoqueInicial AS (
            SELECT  ep.IdProduto,
                    SUM (
                            CASE WHEN mep.IdTipoMovimentacao = 1 THEN mep.Quantidade
                                ELSE mep.Quantidade * (-1)
                            END
                        ) AS EstoqueInicial
                FROM [dbo].[EstoqueProduto] ep WITH(NOLOCK)
                    INNER JOIN [dbo].[MovimentacaoEstoqueProduto] mep WITH(NOLOCK)
                        ON ep.IdProduto = mep.IdEstoqueProduto
                WHERE mep.DataMovimentacao < DATEFROMPARTS(@Ano, @Mes, 01)
                GROUP BY ep.IdProduto
        ),

        -- Calculando o estoque final do final do mes
        CTE_EstoqueFinal AS (
            SELECT  ep.IdProduto,
                    SUM (
                            CASE WHEN mep.IdTipoMovimentacao = 1 THEN mep.Quantidade
                                ELSE mep.Quantidade * (-1)
                            END
                        ) AS EstoqueFinal
                FROM [dbo].[EstoqueProduto] ep WITH(NOLOCK)
                    INNER JOIN [dbo].[MovimentacaoEstoqueProduto] mep WITH(NOLOCK)
                        ON ep.IdProduto = mep.IdEstoqueProduto
                WHERE mep.DataMovimentacao < DATEFROMPARTS(@Ano, @Mes + 1, 01)
                GROUP BY ep.IdProduto
        ), 

        -- Calculando a quantidade total e media produzida
        CTE_CalculoProducao AS (
            SELECT  pp.IdProduto,
                SUM(p.Quantidade) AS QuantidadeProduzida,
                AVG(p.Quantidade) AS MediaQuantidadeProduzidaDia
            FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                INNER JOIN [dbo].[Producao] p WITH(NOLOCK)
                    ON pp.Id = p.IdPedidoProduto
                INNER JOIN [dbo].[AuditoriaMovimetacaoEntradaEstoqueProduto] ameep WITH(NOLOCK)
                    ON p.Id = ameep.IdProducao
            WHERE YEAR(p.DataTermino) = @Ano
                AND  MONTH(p.DataTermino) = @Mes
            GROUP BY pp.IdProduto
        ), 
        
        -- Calculando a contagem, media e somatoria total de vendas do produto
        CTE_Vendas AS (
            SELECT  pp.IdProduto,
                    COUNT(p.Id) AS VendaDeProduto,
                    AVG(pp.Quantidade) AS MediaDeVendaProduto,
                    SUM(pp.Quantidade) AS QuantidadeVendida
                FROM [dbo].[Pedido] p WITH(NOLOCK)
                    INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        ON p.Id = pp.IdPedido
                WHERE YEAR(p.DataEntrega) = @Ano
                    AND  MONTH(p.DataEntrega) = @Mes
                GROUP BY pp.IdProduto
        )

        -- Montando a estrutura solicitada na questao da prova
        SELECT  p.Id AS CodigoProduto,
                p.Nome AS NomeProduto,
                cte4.VendaDeProduto AS QuantidadeDeVendas,
                cte4.MediaDeVendaProduto AS MediaDeVendasNoMes,
                cte1.EstoqueInicial,
                cte2.EstoqueFinal,
                cte3.QuantidadeProduzida,
                cte3.MediaQuantidadeProduzidaDia AS MediaDeProducaoDiaria,
                DENSE_RANK() OVER (ORDER BY cte4.VendaDeProduto DESC) AS Ranking
            FROM [CTE_EstoqueInicial] cte1
                INNER JOIN [CTE_EstoqueFinal] cte2
                    ON cte1.IdProduto = cte2.IdProduto
                INNER JOIN [CTE_CalculoProducao] cte3
                    ON cte1.IdProduto = cte3.IdProduto
                INNER JOIN [CTE_Vendas] cte4
                    ON cte1.IdProduto = cte4.IdProduto
                INNER JOIN [dbo].[Produto] p WITH(NOLOCK)
                    ON cte1.IdProduto = p.Id

        SELECT  @Linha = @@ROWCOUNT,
                @Erro = @@ERROR;

        IF @Erro <> 0
            RETURN 2;

        IF @Linha = 0
            RETURN 3;
        
        RETURN 0;
    END
GO