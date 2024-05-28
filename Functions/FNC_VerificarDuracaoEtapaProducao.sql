CREATE OR ALTER FUNCTION [dbo].[FNC_VerificarDuracaoEtapaProducao](@Id INT)
	 RETURNS SMALLINT
	 AS 
	 /*
		Documentacao
		Arquivo Fonte.........:	FNC_VerificarDuracaoEtapaProducao.sql
		Objetivo..............:	Funcao para retornar a duracao de uma etapa de producao
		Autor.................:	OrcinoNeto
 		Data..................:	21/05/2024
		Ex....................:	DBCC DROPCLEANBUFFERS
								DBCC FREEPROCCACHE
								
								DECLARE @Data_Inicio DATETIME = GETDATE();

								SELECT	[dbo].[FNC_VerificarDuracaoEtapaProducao](2) AS Resultado,
										DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo
	*/
	BEGIN
		--Declarar variaveis
		DECLARE	@Duracao SMALLINT

		--Atribuir valor a duracao
		SELECT	@Duracao = SUM(ep.Duracao)
			FROM [dbo].[EtapaProducao] ep WITH(NOLOCK)
				INNER JOIN [dbo].[Produto] p WITH(NOLOCK)
					ON ep.IdProduto = p.Id
				INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
					ON pp.IdProduto = p.Id
			WHERE @Id = pp.IdPedido

		--Retornar duracao
		RETURN @Duracao
	END
GO