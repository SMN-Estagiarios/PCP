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
    Autor alteracao.: Adriel Alexander, Olivio Freitas
    Data alteracao..: 07/06/2024
    Exemplo.........:   DBCC DROPCLEANBUFFERS;
                        DBCC FREEPROCCACHE;
                        DBCC FREESYSTEMCACHE('ALL');

                        DECLARE @DataInicio DATETIME = GETDATE(),
                                @Ret INT

                        EXEC @Ret = [dbo].[SP_ProdutosMaisProduzidosNoMes] @Ano = 2022, @Mes = NULL

                        SELECT  DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao,
                                @Ret AS RETORNO;
                             
    Retornos........:   0 - Sucesso
                        1 - ERRO - Ano não pode ser nulo ou Maior que o ano atual
                        2 - ERRO - Mes deve ser um valor valido
    */
    BEGIN
        -- Validacao do Ano, passado por parametro
        IF @Ano > YEAR(GETDATE()) OR @Ano IS NULL 
            BEGIN
                RETURN 1
            END;

        -- Validacao do Mes, passado por parametro
        IF @Mes NOT BETWEEN 1 AND 12 OR @Mes IS NULL
            BEGIN
                RETURN 2
            END;

        -- Capturo a etapa maxima de producao dos produtos
        WITH CTE_EtapaMaxima AS 
            (
                SELECT  IdProduto,
                        MAX(NumeroEtapa) EtapaMaxima 
                    FROM [dbo].[EtapaProducao]
                    GROUP BY IdProduto
            ),
            -- Listo os produtos com mais demanda no ano e mes, passado por parametro e que a producao foi concluida
            CTE_ProdutoMaisProduzido AS
            (
                SELECT  p.Id AS CodigoProduto,
                        p.Nome AS NomeProduto,
                        SUM(pr.Quantidade) AS QuantidadeProduzida
                    FROM [dbo].[Produto] p WITH(NOLOCK)
                        INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                            ON ep.IdProduto = p.Id
                        INNER JOIN [dbo].[Producao] pr WITH(NOLOCK)
                            ON pr.IdEtapaProducao = ep.Id
                        INNER JOIN [CTE_EtapaMaxima] em
                            ON em.IdProduto = ep.IdProduto
                    WHERE em.EtapaMaxima = ep.NumeroEtapa
                            AND YEAR(pr.DataInicio) = @Ano
                            AND MONTH(pr.DataInicio) = @Mes
                            AND pr.DataTermino IS NOT NULL
                    GROUP BY    p.Id,
                                p.Nome
             ),
            -- Somo quantidade da composicao de materia prima necessaria para fazer um produto
            CTE_SomatoriaMateriaPrimaConsumida AS
            (
                SELECT  pmp.CodigoProduto,
                        CAST(SUM(co.Quantidade) / 1000.0 AS DECIMAL(10,3))  AS MateriaPrimaProducaoKg
                    FROM [CTE_ProdutoMaisProduzido] pmp
                        INNER JOIN [dbo].[Composicao] co WITH(NOLOCK)
                            ON co.IdProduto = pmp.CodigoProduto
                    GROUP BY    pmp.CodigoProduto,
                                pmp.QuantidadeProduzida
            )
            -- Apresento o resultado com o calculo do consumo de materia prima, baseado na quantidade produzida
            SELECT  pmp.CodigoProduto,
                    pmp.NomeProduto,
                    pmp.QuantidadeProduzida,
                    CONCAT(smpc.MateriaPrimaProducaoKg * pmp.QuantidadeProduzida, 'Kg') AS MateriaPrimaConsumidaKg
                FROM [CTE_ProdutoMaisProduzido] pmp
                    INNER JOIN [CTE_SomatoriaMateriaPrimaConsumida] smpc
                        ON smpc.CodigoProduto = pmp.CodigoProduto
                GROUP BY    pmp.CodigoProduto,
                            pmp.NomeProduto,
                            pmp.QuantidadeProduzida,
                            smpc.MateriaPrimaProducaoKg
                ORDER BY pmp.QuantidadeProduzida DESC;
            RETURN 0
    END
GO