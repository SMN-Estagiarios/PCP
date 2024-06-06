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
		DECLARE @EstoqueVirtual INT,
				@EtapaMaxima INT;
		
		-- Setando a variavel @EtapaMaxima para o valor de numero de etapa maxima do produto passado
		SELECT TOP 1 @EtapaMaxima = Id
			FROM [dbo].[EtapaProducao] WITH(NOLOCK)
			WHERE IdProduto = @IdProduto
			ORDER BY Id DESC;

		-- 	-- Calcular a quantidade que está sendo produzida e atribuir o valor a variavel declarada
		SELECT @EstoqueVirtual = ISNULL(SUM(CASE WHEN x.rank = 1 THEN x.Quantidade END), 0)
			FROM	(
						SELECT 	p.Quantidade,
								DENSE_RANK() OVER (PARTITION BY p.IdPedidoProduto ORDER BY p.Id DESC) AS rank
							FROM [dbo].[Producao] p WITH(NOLOCK)
								LEFT JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
									ON ep.Id = p.IdEtapaProducao
							WHERE ep.IdProduto = @IdProduto
								AND p.IdPedidoProduto NOT IN	(
																	SELECT IdPedidoProduto
																		FROM [dbo].[Producao] WITH(NOLOCK)
																		WHERE IdEtapaProducao = @EtapaMaxima
																			AND DataTermino IS NOT NULL
																)
					) AS x

		-- Retornar o valor da variavel
		RETURN @EstoqueVirtual;
	END;