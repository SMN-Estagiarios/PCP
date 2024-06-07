CREATE OR ALTER FUNCTION [dbo].[FNC_CalcularTempoProducaoProduto](@Id INT)
	RETURNS	SMALLINT
	AS 
	/*
	Documentação
	Arquivo Fonte....: FNC_CalcularTempoProducaoProduto.sql
	Objetivo.........: Funcao para calcular o tempo de produção do produto selecionado.
	Autor............: OrcinoNeto
	Data.............: 21/05/2024
	Ex...............: 
						DBCC DROPCLEANBUFFERS;
						DBCC FREEPROCCACHE;
						
						DECLARE @DataInicio DATETIME = GETDATE()
						SELECT	[dbo].[FNC_CalcularTempoProducaoProduto](1) AS Resultado,
								DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao	
	*/
	BEGIN	
		--Criando variavel.
		DECLARE	@Duracao SMALLINT

		--Setando variável para receber o tempo somado das etapas de produção do produto escolhido.
		SELECT	@Duracao = SUM(ep.Duracao)
			FROM [dbo].[EtapaProducao] ep WITH(NOLOCK)							
			WHERE @Id = ep.IdProduto

		--Retorno da variavel.
		RETURN @Duracao
	END
GO