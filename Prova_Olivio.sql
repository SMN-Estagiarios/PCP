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

                        DECLARE @DataInicio DATETIME = GETDATE(),
                                @Ret INT

                        EXEC @Ret = [dbo].[SP_ProdutosMaisProduzidosNoMes] @Ano = 2024, @Mes = 5

                        SELECT  DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao,
                                @Ret AS RETORNO
                             
    Retornos........:   0 - Sucesso
                        1 - ERRO - Ano nao pode ser maior que o ano atual
                        1 - ERRO - Mes deve ser um valor valido
    */
    BEGIN
        -- Validacao do Ano, passado por parametro
        IF @Ano > YEAR(GETDATE())
            BEGIN
                RETURN 1
            END;

        -- Validacao do Mes, passado por parametro
        IF @Mes NOT BETWEEN 1 AND 12
            BEGIN
                RETURN 2
            END;

        -- Listo os produtos com mais demanda no ano e mes, passado por parametro e que a producao foi concluida
        WITH CTE_ProdutoMaisProduzido AS(
            SELECT  p.Id AS CodigoProduto,
                    p.Nome AS NomeProduto,
                    SUM(pr.Quantidade) AS QuantidadeProduzida
                FROM [dbo].[Produto] p WITH(NOLOCK)
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        on ep.IdProduto = p.Id
                    inner join [dbo].[Producao] pr WITH(NOLOCK)
                        on pr.IdEtapaProducao = ep.Id
                WHERE YEAR(pr.DataInicio) = @Ano
                    AND MONTH(pr.DataInicio) = @Mes
                    AND pr.DataTermino IS NOT NULL
                GROUP BY    p.Id,
                            p.Nome
            ),
            -- Somo quantidade da composicao de materia prima necessaria para fazer um produto
            CTE_SomatoriaMateriaPrimaConsumida AS(
                SELECT  pmp.CodigoProduto,
                        SUM(CAST(co.Quantidade AS DECIMAL(10,3))) / 1000.0 AS MateriaPrimaProducaoKg
                    FROM CTE_ProdutoMaisProduzido pmp WITH(NOLOCK)
                        INNER JOIN [dbo].[Composicao] co WITH(NOLOCK)
                            ON co.IdProduto = pmp.CodigoProduto
                    GROUP BY    pmp.CodigoProduto,
                                pmp.QuantidadeProduzida
            )

            -- Apresento o resultado com o cálculo do consimo de materia prima, baseado na quantidade produzida
            SELECT  pmp.CodigoProduto,
                    pmp.NomeProduto,
                    pmp.QuantidadeProduzida,
                    CONCAT(ROUND(smpc.MateriaPrimaProducaoKg * pmp.QuantidadeProduzida, 3), 'Kg') AS MateriaPrimaConsumidaKg
                from CTE_ProdutoMaisProduzido pmp
                    inner join CTE_SomatoriaMateriaPrimaConsumida smpc
                        on smpc.CodigoProduto = pmp.CodigoProduto
                GROUP BY    pmp.CodigoProduto,
                            pmp.NomeProduto,
                            pmp.QuantidadeProduzida,
                            smpc.MateriaPrimaProducaoKg
                ORDER BY pmp.QuantidadeProduzida DESC;

            RETURN 0
    END
GO