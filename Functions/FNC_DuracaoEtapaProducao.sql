CREATE OR ALTER FUNCTION [dbo].[FNC_DuracaoEtapaProducao](@Id INT)
	 RETURNS SMALLINT
	 AS 
	 /*
		Documentação
		Arquivo Fonte.........:	FNC_DuracaoEtapaProducao.sql
		Objetivo..............:	Função para retornar a duração de uma etapa de produção
		Autor.................:	OrcinoNeto
 		Data..................:	21/05/2024
		Ex....................:	DBCC DROPCLEANBUFFERS
								DBCC FREEPROCCACHE
								
								DECLARE @DataInicio DATETIME = GETDATE()

								SELECT	[dbo].[FNC_DuracaoEtapaProducao](2) AS Resultado,
										DATEDIFF(millisecond, @DataInicio, GETDATE()) AS Tempo
	*/
	BEGIN
		--Declarar variáveis
		DECLARE	@Duracao SMALLINT

		--Atribuir valor à duração
		SELECT	@Duracao = SUM(ep.Duracao)
			FROM [dbo].[EtapaProducao] ep WITH(NOLOCK)
				INNER JOIN [dbo].[Produto] p WITH(NOLOCK)
					ON ep.IdProduto = p.Id
				INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
					ON pp.IdProduto = p.Id
			WHERE @Id = pp.IdPedido

		--Retornar duração
		RETURN @Duracao
	END
GO