/*
5. Criar um demonstrativo dos produtos que mais demandaram producao dentro do mes
    a. Receber o ano e mes do processamento
    b. Deve apresentar as colunas:
        i. CodigoProduto (produto.Id)
       ii. nomeProduto (produto.Nome)
      iii. QuantidadeProduzida --> (producao.Quantidade)
       iv. Somatoria da quantidade de quilos da materia prima consumida
*/

CREATE OR ALTER PROCEDURE [dbo].[SP_ProdutosMaisProduzidosNoMes]
    @Ano INT,
    @Mes INT
    AS
    /*
    Documentacao
    Arquivo fonte...: Prova_Olivio.sql
    Objetivo........: Listar os produtos que demandaram mais producao dentro de um mes especifico
    Autor...........: Olivio Freitas
    Data............: 06/06/2024
    Exemplo.........:   DBCC DROPCLEANBUFFERS;
                        DBCC FREEPROCCACHE;
                        DBCC FREESYSTEMCACHE('ALL');

                        DECLARE @DataInicio DATETIME = GETDATE()

                        EXEC [dbo].[SP_ProdutosMaisProduzidosNoMes] @Ano = 2024, @Mes = 12

                        SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao
    */
    BEGIN
        -- Listo os produtos com mais demanda no ano e mês passado por parâmetro
        WITH CTE_ProdutoMaisProduzido AS(
            SELECT
                p.Id AS CodigoProduto,
                p.Nome AS NomeProduto,
                SUM(pp.Quantidade) AS QuantidadeProduzida
                FROM [dbo].[Produto] p WITH(NOLOCK)
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        on ep.IdProduto = p.Id
                    inner join [dbo].[Producao] pr WITH(NOLOCK)
                        on pr.IdEtapaProducao = ep.Id
                    inner join [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        on pp.IdProduto = p.Id
                WHERE YEAR(pr.DataInicio) = @Ano
                    AND MONTH(pr.DataInicio) = @Mes
                GROUP BY    p.Id,
                            p.Nome
            ),
            -- Somo quantidade da composicao de materia prima para fazer um produto
            CTE_SomatoriaMateriaPrimaConsumida AS(
                SELECT  pmp.CodigoProduto,
                        SUM(CAST(co.Quantidade AS DECIMAL(10,3)))/ 1000.0 AS TotalMateriaPrimaProducao
                    FROM CTE_ProdutoMaisProduzido pmp WITH(NOLOCK)
                        INNER JOIN [dbo].[Composicao] co WITH(NOLOCK)
                            ON co.IdProduto = pmp.CodigoProduto
                    GROUP BY    pmp.CodigoProduto,
                                pmp.QuantidadeProduzida
            )

            -- Apresento o resultado com o cálculo da MateriaPrimaConsumida * QuantidadeProduzida
            SELECT  pmp.CodigoProduto,
                    pmp.NomeProduto,
                    pmp.QuantidadeProduzida,
                    CONCAT(ROUND(smpc.TotalMateriaPrimaProducao * pmp.QuantidadeProduzida, 3), 'Kg') AS MateriaPrimaConsumida
                from CTE_ProdutoMaisProduzido pmp
                    inner join CTE_SomatoriaMateriaPrimaConsumida smpc
                        on smpc.CodigoProduto = pmp.CodigoProduto
                GROUP BY    pmp.CodigoProduto,
                            pmp.NomeProduto,
                            pmp.QuantidadeProduzida,
                            smpc.TotalMateriaPrimaProducao
                ORDER BY pmp.QuantidadeProduzida DESC
    END
GO




/*
DECLARE @Gramas DECIMAL(10,3) = 500.0
select @Gramas / 1000;


select  co.Quantidade
    from produto pr
        inner join composicao co
            on co.IdProduto = pr.id
    WHERE pr.Id = 13


select  pr.Id,
        CONCAT(SUM(CAST(co.Quantidade AS DECIMAL(10,3)))/ 1000 , 'Kg') MateriaPrimaConsumida
    from produto pr
        inner join composicao co
            on co.IdProduto = pr.id
    WHERE pr.Id = 25
    GROUP BY pr.Id;


WITH CTE_ProdutoMaisProduzido AS(
            SELECT
                p.Id AS CodigoProduto,
                p.Nome AS NomeProduto,
                SUM(pp.Quantidade) AS QuantidadeProduzida
                FROM [dbo].[Produto] p WITH(NOLOCK)
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        on ep.IdProduto = p.Id
                    inner join [dbo].[Producao] pr WITH(NOLOCK)
                        on pr.IdEtapaProducao = ep.Id
                    inner join [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        on pp.IdProduto = p.Id
                WHERE YEAR(pr.DataInicio) = 2023        -- @Ano
                    AND MONTH(pr.DataInicio) = 5        -- @Mes
                GROUP BY    p.Id,
                            p.Nome
        
            )
SELECT  pmp.CodigoProduto,
        pmp.NomeProduto,
        pmp.QuantidadeProduzida,
        CONCAT(SUM(CAST(co.Quantidade AS DECIMAL(10,3)))/ 1000 , 'Kg') MateriaPrimaConsumida
        --,MateriaPrimaConsumida * QuantidadeProduzida AS AjudaDeus
    from CTE_ProdutoMaisProduzido pmp
        inner join composicao co
            on co.IdProduto = pmp.CodigoProduto
    --WHERE CodigoProduto = 25
    GROUP BY    pmp.CodigoProduto,
                pmp.NomeProduto,
                pmp.QuantidadeProduzida
    ORDER BY pmp.QuantidadeProduzida DESC
*/