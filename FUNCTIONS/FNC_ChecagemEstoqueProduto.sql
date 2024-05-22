USE pcp;
GO

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
	Data............: 22/05/2024
	EX..............: 
						DBCC FREEPROCCACHE
						DBCC FREESYSTEMCACHE('ALL')
						DBCC DROPCLEANBUFFERS

						DECLARE @Data_Inicio DATETIME = GETDATE();

						SELECT [dbo].[FNC_CalcularEstoqueReal](1);

						SELECT DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS TempoExecucao;
	*/
	BEGIN
		DECLARE @EstoqueFisico INT,
				@EstoqueVirtual INT,
				@EstoqueComprometido INT,
				@Resultado INT;

		SELECT	@EstoqueComprometido = ISNULL(SUM(pp.Quantidade), 0)
			FROM [dbo].[PedidoProduto] AS pp WITH(NOLOCK)
				INNER JOIN [dbo].[Pedido] AS p WITH(NOLOCK)
					ON pp.IdPedido = p.Id
			WHERE pp.IdProduto = @IdProduto
				AND p.DataEntrega IS NULL;

		SELECT	@EstoqueVirtual = ISNULL(SUM(p.Quantidade), 0)
			FROM [dbo].[Producao] AS p WITH(NOLOCK)
				INNER JOIN [dbo].[EtapaProducao] AS ep WITH(NOLOCK)
					ON p.IdEtapaProducao = ep.Id
			WHERE ep.IdProduto = @IdProduto
				

		SELECT	@EstoqueFisico = ISNULL(QuantidadeFisica, 0)
			FROM [dbo].[EstoqueProduto] WITH(NOLOCK)
			WHERE IdProduto = @IdProduto;

		SET @Resultado = @EstoqueFisico + @EstoqueVirtual - @EstoqueComprometido;

		RETURN @Resultado;
	END
GO

