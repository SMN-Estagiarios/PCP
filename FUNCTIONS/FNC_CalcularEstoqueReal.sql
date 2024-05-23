CREATE OR ALTER FUNCTION [dbo].[FNC_CalcularEstoqueReal]	(
																@IdProduto INT
															)
	RETURNS INT
	AS
	/*
	Documentacao
	Arquivo Fonte...: FNC_CalcularEstoqueReal.sql
	Objetivo........: Calcular o estoque real de um produto para aquele momento
	Autor...........: Odlavir Florentino
	Data............: 23/05/2024
	EX..............: 
						DBCC FREEPROCCACHE
						DBCC FREESYSTEMCACHE('ALL')
						DBCC DROPCLEANBUFFERS

						DECLARE @Data_Inicio DATETIME = GETDATE();

						SELECT [dbo].[FNC_CalcularEstoqueReal](1);

						SELECT DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS TempoExecucao;
	*/
	BEGIN
		-- Declarando variaveis necessarias para a solucao
		DECLARE @EstoqueFisico INT,
				@EstoqueVirtual INT,
				@EstoqueComprometido INT,
				@Resultado INT;

		-- Capturar a somatoria da quantidade do produto em pedidos que ainda estao em aberto
		SELECT	@EstoqueComprometido = ISNULL(SUM(pp.Quantidade), 0)
			FROM [dbo].[PedidoProduto] AS pp WITH(NOLOCK)
				INNER JOIN [dbo].[Pedido] AS p WITH(NOLOCK)
					ON pp.IdPedido = p.Id
			WHERE pp.IdProduto = @IdProduto
				AND p.DataEntrega IS NULL;

		-- Capturar a somatoria da quantidade do produto que estao em producao
		SELECT @EstoqueVirtual = [dbo].[FNC_CalcularEstoqueVirtual](@IdProduto);

		-- Capturar a somatoria da quantidade do produto que estao prontos
		SELECT	@EstoqueFisico = ISNULL(QuantidadeFisica, 0)
			FROM [dbo].[EstoqueProduto] WITH(NOLOCK)
			WHERE IdProduto = @IdProduto;

		-- Calcular o estoque real
		SET @Resultado = @EstoqueFisico + @EstoqueVirtual - @EstoqueComprometido;

		-- Retornar o valor do estoque real
		RETURN @Resultado;
	END
GO