CREATE OR ALTER PROCEDURE [dbo].[SP_InserirEstoqueProduto]
	@IdProduto INT,
	@QuantidadeFisica INT,
	@QuantidadeMinima INT,
	@QuantidadeVirtual INT
	AS
	/*
		Documentação
		Arquivo Fonte.........:	EstoqueProduto.sql
		Objetivo..............:	Procedure para inserir um novo registro em EstoqueProduto
		Autor.................:	João Victor Maia
		Data..................:	23/05/2024
		Exemplo...............:	BEGIN TRAN
									DBCC FREEPROCCACHE
									DBCC DROPCLEANBUFFERS

									DECLARE @Ret INT,
											@DataInicio DATETIME = GETDATE()

									EXEC @Ret = [dbo].[SP_InserirEstoqueProduto] 1, 100, 50, 0
									
									SELECT	@Ret AS Retorno,
											DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

									SELECT	IdProduto,
											QuantidadeFisica,
											QuantidadeMinima,
											QuantidadeVirtual
									FROM [dbo].[EstoqueProduto] WITH(NOLOCK) 
								ROLLBACK TRAN
		Retornos..............:	0 - Sucesso
								1 - Erro: o Id do produto não existe
	*/
	BEGIN
		
		--Checar se o Id do produto existe
		IF NOT EXISTS	(SELECT TOP 1 1
							FROM [dbo].[Produto]
							WHERE Id = @IdProduto
						)
			BEGIN
				RETURN 1
			END

		--Inserir registro
		INSERT INTO [dbo].[EstoqueProduto] (IdProduto, QuantidadeFisica, QuantidadeMinima, QuantidadeVirtual)
			VALUES (@IdProduto, @QuantidadeFisica, @QuantidadeMinima, @QuantidadeVirtual)

	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_AtualizarEstoqueProduto]
	@IdProduto INT,
	@QuantidadeFisica INT, 
	@QuantidadeMinima INT, 
	@QuantidadeVirtual INT
	AS
	/*
		Documentacao
		Arquivo Fonte.....: EstoqueProduto.sql
		Objetivo..........: Inserir um registro de estoque de produto
		Autor.............: Rafael Mauricio
		Data..............: 21/05/2024
		Ex................: BEGIN TRAN
								SELECT	IdProduto,
										QuantidadeFisica,
										QuantidadeMinima,
										QuantidadeVirtual
									FROM [dbo].[EstoqueProduto] WITH(NOLOCK)

								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')
								DBCC DROPCLEANBUFFERS

								DECLARE @DataInicio DATETIME = GETDATE(),
										@Retorno INT

								EXEC @Retorno = [dbo].[SP_AtualizarEstoqueProduto] 2, 200, 250, 50
									
								SELECT	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

								SELECT	IdProduto,
										QuantidadeFisica,
										QuantidadeMinima,
										QuantidadeVirtual
									FROM [dbo].[EstoqueProduto] WITH(NOLOCK) 
							ROLLBACK TRAN
		Retornos.........: 0 - Sucesso
						   1 - Erro: o Id do produto passado não existe
		Autor Alt........: João Victor Maia
		Objetivo Alt.....: Indentação do código e validação dos parâmetros
		Data Alt.........: 23/05/2024

							
	*/

	BEGIN
		--Checar se o IdProduto existe
		IF NOT EXISTS	(SELECT TOP 1 1
							FROM [dbo].[EstoqueProduto]
							WHERE IdProduto = @IdProduto
						)
			BEGIN
				RETURN 1
			END

		--Atualizar tabela
		UPDATE [dbo].[EstoqueProduto]
			SET QuantidadeFisica = @QuantidadeFisica, 
				QuantidadeMinima = @QuantidadeMinima, 
				QuantidadeVirtual = @QuantidadeVirtual
			WHERE IdProduto = @IdProduto
	END
GO