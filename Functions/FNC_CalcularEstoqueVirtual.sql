CREATE OR ALTER FUNCTION [dbo].[FNC_CalcularEstoqueVirtual]	(
																@IdProduto INT
															)
	RETURNS INT
	AS
	/*
		Documentacao
		Arquivo Fonte.....: FNC_CalcularEstoqueVirtual.sql
		Objetivo..........: Calcular o estoque virtual para o produto passado como parametro
		Autor.............: Odlavir Florentino
		Data..............: 23/05/2024
		Ex................:
							DBCC FREEPROCCACHE
							DBCC DROPCLEANBUFFERS
							DBCC FREESYSTEMCACHE('ALL')

							DECLARE @DataInicio DATETIME = GETDATE();

							SELECT [dbo].[FNC_CalcularEstoqueVirtual](1) AS EstoqueVirtual;

							SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;
	*/
	BEGIN

		-- Declarando variáveis necessarias para a solucao
		DECLARE @EstoqueVirtual INT;
		
		-- Calcular a quantidade de produto que ainda esta sendo produzida
		WITH EtapaMaxima AS (
			-- Capturar o valor máximo do número de etapa para o produto passado como parãmetro
			SELECT	IdProduto,
					MAX(NumeroEtapa) AS EtapaFinal
				FROM [dbo].[EtapaProducao] WITH(NOLOCK)
				GROUP BY IdProduto
		), ProducaoFinalizada AS (
			-- Capturar os Ids de producoes finalizadas
			SELECT p.IdPedidoProduto
				FROM [dbo].[Producao] p WITH(NOLOCK)
					INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
						ON p.IdEtapaProducao = ep.Id
					INNER JOIN EtapaMaxima em
						ON ep.IdProduto = em.IdProduto
				WHERE ep.NumeroEtapa = em.EtapaFinal AND p.DataTermino IS NOT NULL
		)	
			-- Calcular a quantidade que está sendo produzida e atribuir o valor a variavel declarada
			SELECT	@EstoqueVirtual = ISNULL(SUM(DISTINCT Quantidade), 0)
				FROM [dbo].[Producao] WITH(NOLOCK)
				WHERE IdPedidoProduto NOT IN	(
													SELECT IdPedidoProduto
														FROM ProducaoFinalizada
												)

		-- Retornar o valor da variável
		RETURN @EstoqueVirtual;
	END