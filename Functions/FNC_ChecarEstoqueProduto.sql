CREATE OR ALTER FUNCTION [dbo].[FNC_ChecarEstoqueProduto]	(
																@IdProduto INT,
																@Quantidade INT
															)
	RETURNS BIT
	AS
	/*
	Documentacao
	Arquivo Fonte.....: FNC_ChecarEstoqueProduto.sql
	Objetivo..........: Verifica o estoque do produto passado por parametro e retorna TRUE(1) ou FALSE(0)
	Autor.............: Olivio Freitas
	Data..............: 22/05/2024
	EX................: DBCC FREEPROCCACHE
						DBCC DROPCLEANBUFFERS

						DECLARE @IdProduto INT = 1, --------------------> Alterar o Id do produto por aqui
								@DataInicio DATETIME = GETDATE()

						SELECT [dbo].[FNC_ChecarEstoqueProduto] (@IdProduto, 1);

						SELECT *
							FROM [dbo].[Produto] pr WITH(NOLOCK)
								INNER JOIN [dbo].[EstoqueProduto] ep
									ON ep.IdProduto = pr.Id
							WHERE pr.Id = @IdProduto

						SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo
						
	Retorno.........:	0 - FALSE: Produto nao encontrado ou nao tem estoque suficiente
						1 - TRUE: Temos estoque do produto
	*/
	BEGIN
		-- Declarar as variaveis que preciso
		DECLARE @EstoqueFisico INT

		-- Atribuir a quantidade fisica a variavel
		SELECT @EstoqueFisico = ep.QuantidadeFisica
				FROM [dbo].[Produto] pr WITH(NOLOCK)
					INNER JOIN [dbo].[EstoqueProduto] ep
						ON ep.IdProduto = pr.Id
				WHERE pr.Id = @IdProduto

		-- Verificar se eu tenho estoque maior do que a quantidade pedida
		IF @Quantidade < @EstoqueFisico
				RETURN 1;

		RETURN 0;
	END
GO