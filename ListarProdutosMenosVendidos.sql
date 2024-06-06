CREATE OR ALTER PROCEDURE [dbo].[SP_ListarDezProdutosMenosVendidosEmDadoMes]
    @Ano INT = NULL,
    @Mes INT = NULL
AS 
/*
    Documentacao
    Arquivo Fonte...: ListarProdutosMenosVendidos.sql
    Objetivo........: Listar 10 Produtos Menos Vendidos em um determinado mes e ano com base nas vendas realizadas com o total
                      Do que foi vendido ao mês virgente, anterior e anterior ao anterior. Ainda Faz a média mensal das vendas do
                      ano virgente e do ano anterior para aquele produto  
    Autor...........: Adriel Alexander de Sousa
    Data............: 2024/06/06
    Exemplo.........: DBCC DROPCLEANBUFFERS
                      DBCC FREEPROCCACHE

                        DECLARE @DataInicio DATETIME = GETDATE(),   
                                @RET INT

                        EXEC @RET =  [dbo].[SP_ListarDezProdutosMenosVendidosEmDadoMes] 2022, 12

                        SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao,
                                @RET AS Retorno

    Retornos.........: 0 - Sucesso,
                       1 - Error: os valores para ano e mês não podem ser nulos    
*/
    BEGIN 
        --Declarando variaveis pertinentes ao processamento
        DECLARE @DataInicio DATE,
                @AnoAnterior INT,
                @MesAnterior INT,
                @MesAnteriorAoAnterior INT

        --Faz o tratamento caso os paramentros da procedure sejam passados como nulos 
        IF @Ano IS NULL OR @Mes  IS NULL
            BEGIN
                RETURN 1
            END

        --atribui valor a data do mês/ano passado como parametro e calcular os valores de mes e anos anteriores
        SELECT  @DataInicio = DATEFROMPARTS(@Ano, @Mes, DAY(GETDATE())),
                @AnoAnterior = YEAR(DATEADD(YEAR, -1, @DataInicio)),
                @MesAnterior = MONTH(DATEADD(MONTH,-1,@DataInicio)),
                @MesAnteriorAoAnterior = MONTH(DATEADD(MONTH,-2, @DataInicio));
            
        --Inicia a construção da cte para analisar as vendas do produto com base no no ano atual e anterior
        WITH SeparaMesesProduto AS
            (  
                 --seleciona os 12 meses para cada idProduto para calcular a media anual com base nos meses
                SELECT DISTINCT  MONTH(p.DataPedido) AS MesesDoAno,
                                 pp.IdProduto
                        FROM [dbo].[Pedido] p WITH(NOLOCK)
                            INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                                ON pp.IdPedido = p.Id
            ),
             SeleciocaMediaVendaAnoAtual AS
            ( 
                --seleciona a soma das quantidade vendidas em cada mes para ano passado como parametro 
                SELECT  pp.IdProduto,
                        smp.MesesDoAno,
                        SUM(pp.Quantidade) AS SomaQuantidadeVendidaPorMesAnoAtual
                    FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
                            ON p.id = pp.idPedido
                        INNER JOIN [SeparaMesesProduto] smp
                            ON smp.IdProduto = pp.IdProduto
                    WHERE YEAR(p.DataPedido) = @Ano
                        AND MONTH(p.DataPedido) = smp.MesesDoAno
                    GROUP BY pp.IdProduto, smp.MesesDoAno
            ),
            SelecionaMediaVendaAnoAnterior AS
            ( 
                --seleciona a soma das quantidade vendidas em cada mes para ano anterior ao passado como parametro
                SELECT  pp.IdProduto,
                        smp.MesesDoAno,
                        SUM(pp.Quantidade) AS SomaQuantidadeVendidaPorMesAnoAnterior
                    FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
                            ON p.id = pp.idPedido
                        INNER JOIN [SeparaMesesProduto] smp
                            ON smp.IdProduto = pp.IdProduto
                    WHERE YEAR(p.DataPedido) = @AnoAnterior
                        AND MONTH(p.DataPedido) = smp.MesesDoAno
                    GROUP BY pp.IdProduto, smp.MesesDoAno
            ),
            SelecionaInfoProdutoMesAnterior AS 
            (  
                --Seleciona Soma total das quantidades do produto para o mes anterior 
                SELECT  pp.IdProduto,
                        SUM(pp.Quantidade) AS QuantidadeVendidaMesAnterior
                    FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
                            ON p.id = pp.idPedido
                    WHERE DATEDIFF(MONTH, p.DataPedido, @DataInicio) = @MesAnterior 
                    GROUP BY pp.IdProduto
            ),
            SelecionaInfoProdutoMesAnteriorAoAnterior AS 
            (
                --Seleciona Soma total das quantidades do produto para o mes anterior ao anterior
                SELECT  pp.IdProduto,
                        SUM(pp.Quantidade) AS QuantidadeVendidaMesAnteriorAoAnterior
                    FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
                            ON p.id = pp.idPedido
                    WHERE DATEDIFF(MONTH, p.DataPedido, @DataInicio) = @MesAnteriorAoAnterior
                    GROUP BY pp.IdProduto
            ),
            SelecionaRankDosProdutosMenosVendidosNoMes AS 
            (
                --seleciona o rank dos top 10 produtos menos vendidos para o mês de processamento e soma as quantidade vendidas no mes vigente
                SELECT  pp.idProduto AS IdProduto,
                        DENSE_RANK() OVER (ORDER BY SUM(pp.Quantidade)) AS Rank,
                        SUM(pp.Quantidade) AS QuantidadeVendidaNoMes
                    FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
                            ON p.Id = pp.IdPedido
                    WHERE MONTH(p.DataEntrega) = @Mes 
                        AND YEAR(p.DataEntrega) = @Ano  
                    GROUP BY pp.IdProduto
            )
            --seleciona os top 10 produtos menos vendidos ordenados pelo rank 
            SELECT TOP 10   p.Id AS CodigoProduto,
                            p.Nome AS NomeProduto, 
                            rpmv.QuantidadeVendidaNoMes,
                            pma.QuantidadeVendidaMesAnterior,
                            pmaa.QuantidadeVendidaMesAnteriorAoAnterior,
                            AVG(mva.SomaQuantidadeVendidaPorMesAnoAtual) AS QuantidadeMediaDeVendaNoAnoCorrente,
                            AVG(mvp.SomaQuantidadeVendidaPorMesAnoAnterior) AS QuantidadeMediaDeVendaNoAnoPassado
                    FROM [dbo].[Produto] p WITH(NOLOCK)
                        INNER JOIN [SeleciocaMediaVendaAnoAtual] mva
                            ON mva.IdProduto = p.Id
                        INNER JOIN [SelecionaMediaVendaAnoAnterior] mvp
                            ON mvp.IdProduto = p.id
                        INNER JOIN [SelecionaInfoProdutoMesAnterior] pma
                            ON pma.IdProduto = p.Id
                        INNER JOIN [SelecionaInfoProdutoMesAnteriorAoAnterior] pmaa
                            ON pmaa.idProduto = p.Id
                        INNER JOIN [SelecionaRankDosProdutosMenosVendidosNoMes] rpmv
                            ON rpmv.IdProduto = p.Id
                    GROUP BY  p.Id,
                              p.Nome,
                              rpmv.QuantidadeVendidaNoMes,
                              pma.QuantidadeVendidaMesAnterior,
                              pmaa.QuantidadeVendidaMesAnteriorAoAnterior,
                              Rank
                    ORDER BY rpmv.Rank
        RETURN 0
    END