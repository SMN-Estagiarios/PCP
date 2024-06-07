CREATE OR ALTER PROCEDURE [dbo].[SP_ListarDezProdutosMenosVendidosEmDadoMes]
    @Ano INT,
    @Mes INT
AS 
/*
    Documentacao
    Arquivo Fonte...: SP_ListarProdutosMenosVendidosEmDadoMesAdriel.sql
    Objetivo........: Listar 10 Produtos Menos Vendidos em um determinado mes e ano com base nas vendas realizadas com o total
                      Do que foi vendido ao mês vigente, anterior e anterior ao anterior. Ainda Faz a média mensal das vendas do
                      ano vigente e do ano anterior para os 10 produtos menos vendidos  
    Autor...........: Adriel Alexander de Sousa
    Data............: 06/06/2024
    Autor Alteracao.: Olivio Freitas, Adriel Alexander
    Data Alteracao..: 07/06/2024
    Exemplo.........: DBCC DROPCLEANBUFFERS
                      DBCC FREEPROCCACHE

                        DECLARE @DataInicio DATETIME = GETDATE(),   
                                @RET INT

                        EXEC @RET = [dbo].[SP_ListarDezProdutosMenosVendidosEmDadoMes] 2022, 12;

                        SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao,
                                @RET AS Retorno

    Retornos.........: 0 - Sucesso,   
                       1 - Error: Deve ser passado um mês valido para processamento de dados     
                       2 - Error: O ano passado por parâmentro não pode ser maior que o ano atual ou nulo
*/
    BEGIN 
        -- Declarando variaveis pertinentes ao processamento
        DECLARE @DataProcessamento DATE,
                @AnoAnterior INT,
                @MesAnterior INT,
                @MesAnteriorAoAnterior INT

        -- Validacao do Mes, passado por parametro
        IF  @Mes > 12 OR @Mes <-12 OR @Mes IS NULL
            BEGIN
                RETURN 1
            END

        -- Validacao do Ano, passado por parametro
        IF @Ano > YEAR(GETDATE()) OR @Ano IS NULL
            BEGIN
                RETURN 2
            END;

        -- Atribui valor a data do mês/ano passado como parametro e calcular os valores de mes e anos anteriores
        SELECT  @DataProcessamento = DATEFROMPARTS(ABS(@Ano), ABS(@Mes), DAY(GETDATE())),
                @AnoAnterior = YEAR(DATEADD(YEAR, -1, @DataProcessamento)),
                @MesAnterior = MONTH(DATEADD(MONTH,-1,@DataProcessamento)),
                @MesAnteriorAoAnterior = MONTH(DATEADD(MONTH,-2, @DataProcessamento));

        --seleciona os 12 meses para cada idProduto para calcular a media anual com base nos meses
        WITH SeparaMesesProduto AS
            (  
                SELECT DISTINCT MONTH(p.DataPedido) AS MesesDoAno,
                                pp.IdProduto
                    FROM [dbo].[Pedido] p WITH(NOLOCK)
                        INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                            ON pp.IdPedido = p.Id
            ),
            --executa a sumarização dentro os registros de pedido para o mes virgente e os dois anteriores a data de processamento
			VendasPorPeriodoMes AS 
			(
				SELECT	pp.IdProduto,
						SUM(CASE WHEN YEAR(p.DataPedido) = @Ano AND MONTH(p.DataPedido) = @Mes 
								    THEN pp.Quantidade 
									ELSE 0 
							END) AS QuantidadeVendidaNoMes,
						SUM(CASE WHEN DATEDIFF(MONTH, p.DataPedido, @DataProcessamento) = @MesAnterior 
									THEN pp.Quantidade 
									ELSE 0 
							END) AS QuantidadeVendidaMesAnterior,
						SUM(CASE WHEN DATEDIFF(MONTH, p.DataPedido, @DataProcessamento) = @MesAnteriorAoAnterior
									THEN pp.Quantidade 
									ELSE 0 
							END) AS QuantidadeVendidaMesAnteriorAoAnterior
					FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
						INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
							ON pp.IdPedido = p.Id
						GROUP BY pp.IdProduto
			),
            -- Executa o somatório de vendas por mês em um determinado ano para fazer a média mensal para o ano atual e anterior
			VendasMensalPorAnoProcessamento AS
			(	
				SELECT  pp.IdProduto,
						smp.MesesDoAno,
						SUM(CASE WHEN YEAR(p.DataPedido) = @Ano AND MONTH(p.DataPedido) = smp.MesesDoAno 
									  THEN pp.Quantidade 
									  ELSE 0 
							END) AS SomaQuantidadeVendidaPorMesAnoAtual,
						SUM(CASE WHEN YEAR(p.DataPedido) = @AnoAnterior AND MONTH(p.DataPedido) = smp.MesesDoAno 
									THEN pp.Quantidade 
									ELSE 0 
							END) AS SomaQuantidadeVendidaPorMesAnoAnterior
					FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
						INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
						    ON pp.IdPedido = p.Id
						INNER JOIN [SeparaMesesProduto] smp
							ON smp.IdProduto = pp.idProduto
						GROUP BY pp.IdProduto, smp.MesesDoAno
            )
            -- Seleciona os top 10 produtos menos vendidos ordenados pelo rank asc e faz a média das vendas do ano por mês
            SELECT TOP 10   p.Id AS CodigoProduto,
                            p.Nome AS NomeProduto, 
                            vpp.QuantidadeVendidaNoMes,
                            vpp.QuantidadeVendidaMesAnterior,
                            vpp.QuantidadeVendidaMesAnteriorAoAnterior,
                            AVG(vmp.SomaQuantidadeVendidaPorMesAnoAtual) AS QuantidadeMediaDeVendaNoAnoCorrente,
                            AVG(vmp.SomaQuantidadeVendidaPorMesAnoAnterior) AS QuantidadeMediaDeVendaNoAnoPassado
                FROM [dbo].[Produto] p WITH(NOLOCK)
                    INNER JOIN [VendasPorPeriodoMes]vpp
                        ON vpp.IdProduto = p.id
                    INNER JOIN [VendasMensalPorAnoProcessamento] vmp
                        ON vmp.IdProduto = p.id
                GROUP BY    p.Id,
                            p.Nome,
                            vpp.QuantidadeVendidaNoMes,
                            vpp.QuantidadeVendidaMesAnterior,
                            vpp.QuantidadeVendidaMesAnteriorAoAnterior
                ORDER BY vpp.QuantidadeVendidaNoMes
        RETURN 0
    END
GO