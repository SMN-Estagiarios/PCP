-- Existe uma observacao ao fim desta procedure, leve ela em consideracao.

CREATE OR ALTER PROCEDURE [dbo].[SP_ListarDemonstrativoDePrazoMedioDeEntregaPorProduto]
    @Ano INT = NULL,
    @Mes INT = NULL
    AS
    /*
        Documentacao
        Arquivo Fonte.....: ProvaOdlavir.sql
        Objetivo..........: Listar todo o demonstrativo de prazo medio de entrega por produto, ponderando pelo total de KG
                            de materia prima envolvida de determinado ano e mes.
        Autor.............: Odlavir Florentino
        Data..............: 06/06/2024
        Ex................: DBCC FREEPROCCACHE
                            DBCC FREESYSTEMCACHE('ALL')
                            DBCC DROPCLEANBUFFERS

                            DECLARE @DataInicio DATETIME = GETDATE(),
                                    @Retorno INT;

                            EXEC @Retorno = [dbo].[SP_ListarDemonstrativoDePrazoMedioDeEntregaPorProduto] 2023, 06

                            SELECT  @Retorno AS Retorno,
                                    DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao;
        Retorno...........: 00 - Sucesso.
                            01 - Erro, algum dos parametros nao foi passado.
                            02 - Erro, verifique se foi executado corretamente.
                            03 - O banco de dados nao possui registros para esse mes e ano.
    */
    BEGIN
        DECLARE @Linha INT,
                @Erro INT;

        IF @Ano IS NULL OR @Mes IS NULL
            RETURN 1;

        WITH CalculoDePrazoPorPedido AS (
            -- Capturando os prazos de entrega por pedido para o ano e mes passados como parametros
            SELECT  p.Id AS IdPedido,
                    IIF(DATEDIFF(DAY, p.DataPedido, p.DataEntrega) = 0, 1, DATEDIFF(DAY, p.DataPedido, p.DataEntrega)) AS PrazoEntrega
                FROM [dbo].[Pedido] p WITH(NOLOCK)
                WHERE p.DataEntrega IS NOT NULL
                    AND YEAR(p.DataEntrega) = @Ano
                    AND MONTH(p.DataEntrega) = @Mes
        ), CalculoDoPesoDeMateriaPrimaPorProduto AS (
            -- Capturando o peso total de materia prima em kgs utilizada para desenvolver um produto.
            SELECT  p.Id AS IdProduto,
                    CAST(SUM(Quantidade / 1000.00) AS DECIMAL(15,2)) AS Kg
                FROM [dbo].[Produto] p WITH(NOLOCK)
                    INNER JOIN [dbo].[Composicao] c WITH(NOLOCK)
                        ON p.Id = c.IdProduto
                GROUP BY p.Id
        ), CalculoTotalDeKgPorProdutoEntregue AS (
            -- Capturando o peso total de materia prima em kgs utilizada para a producao de todos os produtos entregues no mes e ano passados.
            SELECT  kgmt.IdProduto AS IdProduto,
                    SUM(pp.Quantidade * kgmt.Kg) AS PesoTotalEmKg
                FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                    INNER JOIN [CalculoDoPesoDeMateriaPrimaPorProduto] AS kgmt
                        ON pp.IdProduto = kgmt.IdProduto
                GROUP BY kgmt.IdProduto
        ), PrazosPorProduto AS (
            -- Capturando os prazos de entrega (medio, maior e menor) para cada produto.
            SELECT  pr.Id AS CodigoProduto,
                    pr.Nome AS NomeProduto,
                    AVG(cppp.PrazoEntrega) AS PrazoMedioEntrega,
                    MAX(cppp.PrazoEntrega) AS MaiorPrazoEntrega,
                    MIN(cppp.PrazoEntrega) AS MenorPrazoEntrega
            FROM CalculoDePrazoPorPedido cppp
                INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                    ON cppp.IdPedido = pp.IdPedido
                RIGHT JOIN [dbo].[Produto] pr WITH(NOLOCK)
                    ON pr.Id = pp.IdProduto
            GROUP BY    pr.Id,
                        pr.Nome
        )
        -- Montando a estrutura necessaria para a resolucao da questao da prova.
        SELECT  ppp.CodigoProduto,
                ppp.NomeProduto,
                ppp.PrazoMedioEntrega,
                ppp.MaiorPrazoEntrega,
                ppp.MenorPrazoEntrega,
                (ppp.PrazoMedioEntrega * ct.PesoTotalEmKg) AS PrazoMedioEntregaXKgMateriaPrima
            FROM PrazosPorProduto ppp
                INNER JOIN CalculoTotalDeKgPorProdutoEntregue ct
                    ON ct.IdProduto = ppp.CodigoProduto
            ORDER BY    ppp.CodigoProduto;
        
        SELECT  @Linha = @@ROWCOUNT,
                @Erro = @@ERROR;

        IF @Erro <> 0
            RETURN 2;

        IF @Linha = 0
            RETURN 3;
        
        RETURN 0;
    END

/* OBS: Fiz o calculo da coluna 'PrazoMedioEntregaXKgMateriaPrima' de acordo com o que Ricardo disse,
        levei em consideracao o prazo medio de entrega * a somatoria do peso de todos os produtos.
        Caso o correto seja prazo medio de entrega * o peso de cada pedido produto, so executar a
        procedure que esta comentada logo a baixo.
*/

-- CREATE OR ALTER PROCEDURE [dbo].[SP_ListarDemonstrativoDePrazoMedioDeEntregaPorProduto]
--     @Ano INT = NULL,
--     @Mes INT = NULL
--     AS
--     /*
--         Documentacao
--         Arquivo Fonte.....: ProvaOdlavir.sql
--         Objetivo..........: Listar todo o demonstrativo de prazo medio de entrega por produto, ponderando pelo total de KG
--                             de materia prima envolvida de determinado ano e mes.
--         Autor.............: Odlavir Florentino
--         Data..............: 06/06/2024
--         Ex................: DBCC FREEPROCCACHE
--                             DBCC FREESYSTEMCACHE('ALL')
--                             DBCC DROPCLEANBUFFERS

--                             DECLARE @DataInicio DATETIME = GETDATE(),
--                                     @Retorno INT;

--                             EXEC @Retorno = [dbo].[SP_ListarDemonstrativoDePrazoMedioDeEntregaPorProduto] 2023, 6

--                             SELECT  @Retorno AS Retorno,
--                                     DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao;
--         Retorno...........: 00 - Sucesso.
--                             01 - Erro, algum dos parametros nao foi passado.
--                             02 - Erro, verifique se foi executado corretamente.
--                             03 - O banco de dados nao possui registros para esse mes e ano.
--     */
--     BEGIN
--         DECLARE @Linha INT,
--                 @Erro INT;

--         IF @Ano IS NULL OR @Mes IS NULL
--             RETURN 1;

--         WITH CalculoDePrazoPorPedido AS (
--             -- Capturando os prazos de entrega por pedido para o ano e mes passados como parametros
--             SELECT  p.Id AS IdPedido,
--                     IIF(DATEDIFF(DAY, p.DataPedido, p.DataEntrega) = 0, 1, DATEDIFF(DAY, p.DataPedido, p.DataEntrega)) AS PrazoEntrega
--                 FROM [dbo].[Pedido] p WITH(NOLOCK)
--                 WHERE p.DataEntrega IS NOT NULL
--                     AND YEAR(p.DataEntrega) = @Ano
--                     AND MONTH(p.DataEntrega) = @Mes
--         ), CalculoDoPesoDeMateriaPrimaPorProduto AS (
--             -- Capturando o peso total de materia prima em kgs utilizada para desenvolver um produto.
--             SELECT  IdProduto,
--                     CAST(SUM(Quantidade / 1000.00) AS DECIMAL(15,2)) AS Kg
--                 FROM [dbo].[Produto] p WITH(NOLOCK)
--                     INNER JOIN [dbo].[Composicao] c WITH(NOLOCK)
--                         ON p.Id = c.IdProduto
--                 GROUP BY IdProduto
--         ), CalculoDeKgPorPedidoProduto AS (
--             -- Capturando o peso total de materia prima em kgs utilizada para o pedido produto entregue.
--             SELECT  pp.Id AS IdPedidoProduto,
--                     kgmt.IdProduto AS IdProduto,
--                     (pp.Quantidade * kgmt.Kg) AS KgPorPedidoProduto
--                 FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
--                     INNER JOIN [CalculoDoPesoDeMateriaPrimaPorProduto] AS kgmt
--                         ON pp.IdProduto = kgmt.IdProduto
--         ), PrazosPorProduto AS (
--             -- Capturando os prazos de entrega (medio, maior e menor) para cada produto.
--             SELECT  pr.Id AS CodigoProduto,
--                     pr.Nome AS NomeProduto,
--                     AVG(cppp.PrazoEntrega) AS PrazoMedioEntrega,
--                     MAX(cppp.PrazoEntrega) AS MaiorPrazoEntrega,
--                     MIN(cppp.PrazoEntrega) AS MenorPrazoEntrega
--             FROM CalculoDePrazoPorPedido cppp
--                 INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
--                     ON cppp.IdPedido = pp.IdPedido
--                 RIGHT JOIN [dbo].[Produto] pr WITH(NOLOCK)
--                     ON pr.Id = pp.IdProduto
--             GROUP BY    pr.Id,
--                         pr.Nome
--         )
--         -- Montando a estrutura necessaria para a resolucao da questao da prova.
--         SELECT  ppp.CodigoProduto,
--                 ppp.NomeProduto,
--                 ppp.PrazoMedioEntrega,
--                 ppp.MaiorPrazoEntrega,
--                 ppp.MenorPrazoEntrega,
--                 (ppp.PrazoMedioEntrega * x.KgPorPedidoProduto) AS PrazoMedioEntregaXKgMateriaPrima
--             FROM PrazosPorProduto ppp
--                 CROSS APPLY (
--                             SELECT cdkppp.KgPorPedidoProduto
--                                     FROM CalculoDeKgPorPedidoProduto cdkppp
--                                     WHERE cdkppp.IdProduto = ppp.CodigoProduto
--                             ) x
--             ORDER BY ppp.CodigoProduto
                        
        
--         SELECT  @Linha = @@ROWCOUNT,
--                 @Erro = @@ERROR;

--         IF @Erro <> 0
--             RETURN 2;

--         IF @Linha = 0
--             RETURN 3;
        
--         RETURN 0;
--     END



