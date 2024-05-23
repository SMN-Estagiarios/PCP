CREATE OR ALTER FUNCTION [dbo].[FNC_DuracaoEtapaProducao](@Id INT)
	 RETURNS SMALLINT
	 AS 
	 /*
		Documenta��o
		Arquivo Fonte.........:	FNC_DuracaoEtapaProducao.sql
		Objetivo..............:	Fun��o para retornar a dura��o de uma etapa de produ��o
		Autor.................:	OrcinoNeto
 		Data..................:	21/05/2024
		Ex....................:	DBCC DROPCLEANBUFFERS
								DBCC FREEPROCCACHE
								
								DECLARE @DataInicio DATETIME = GETDATE()

								SELECT	[dbo].[FNC_DuracaoEtapaProducao](2) AS Resultado,
										DATEDIFF(millisecond, @DataInicio, GETDATE()) AS Tempo
	*/
	BEGIN
		--Declarar vari�veis
		DECLARE	@Duracao SMALLINT

		--Atribuir valor � dura��o
		SELECT	@Duracao = SUM(ep.Duracao)
			FROM [dbo].[EtapaProducao] ep WITH(NOLOCK)
				INNER JOIN [dbo].[Produto] p WITH(NOLOCK)
					ON ep.IdProduto = p.Id
				INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
					ON pp.IdProduto = p.Id
			WHERE @Id = pp.IdPedido

		--Retornar dura��o
		RETURN @Duracao
	END
GO