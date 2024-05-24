CREATE OR ALTER FUNCTION [dbo].[FNC_CalcularTempoProducaoProduto](@Id INT)
	RETURNS	SMALLINT
	AS 
	/*
	Documentação
	Arquivo Fonte....: FNC_CalcularTempoProducaoProduto.sql
	Objetivo.........: Função para calcular o tempo de produção do produto selecionado.
	Autor............: OrcinoNeto
	Data.............: 21/05/2024
	Ex...............: 
						DBCC DROPCLEANBUFFERS;
						DBCC FREEPROCCACHE;
						
						DECLARE @Dat_ini DATETIME = GETDATE()
						SELECT	[dbo].[FNC_DuracaoEtapaProducao](2) AS Resultado,
								DATEDIFF(millisecond, @Dat_ini, GETDATE()) AS Tempo_Execucao	
	*/
	BEGIN	
		DECLARE	@Duracao SMALLINT

		SELECT	@Duracao	= SUM(ep.Duracao)
			FROM [dbo].[EtapaProducao] ep WITH(NOLOCK)
				INNER JOIN [dbo].[Produto] p WITH(NOLOCK)
					ON ep.IdProduto = p.Id
				INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
					ON pp.IdProduto = p.Id
			WHERE @Id = pp.IdPedido

		RETURN @Duracao
	END
GO