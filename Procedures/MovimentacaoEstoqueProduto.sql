CREATE OR ALTER PROCEDURE [dbo].[SP_InserirMovimentacaoEstoqueProduto]
	@IdProduto INT = NULL,
	@IdTipoMovimentacao TINYINT = NULL,
	@DataAtual DATE= NULL,
	@Quantidade INT = NULL
	AS
	/*
	Documentacao
	Arquivo Fonte.....: MovimentacaoEstoqueProduto.sql
	Objetivo..........: Gerar um insert para a tabela de movimentacao no estoque da materia prima.
	Autor.............: Olívio Freitas
	Data..............: 23/05/2024
	Ex................: BEGIN TRAN
							DBCC FREEPROCCACHE
							DBCC FREESYSTEMCACHE('ALL')
							DBCC DROPCLEANBUFFERS

							DECLARE @Data_Inicio DATETIME = GETDATE(),
									@Retorno INT;

							SELECT * FROM [dbo].[MovimentacaoEstoqueProduto]

							EXEC @Retorno = [dbo].[SP_InserirMovimentacaoEstoqueProduto] 1, 1, NULL, 1

							SELECT * FROM [dbo].[MovimentacaoEstoqueProduto]

							SELECT	@Retorno AS Retorno,
									DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE());
						ROLLBACK TRAN

	Retornos..........: 0 - Sucesso.
						1 - Erro, verifique corretamente os parametros passados
						2 - Erro, produto inexistente
						3 - Erro, tipo de movimentacao inexistente
						4 - Erro, Quantidade deve ser positiva
						5 - Erro ao inserir um registro na tabela
	*/
	BEGIN
		-- Verifico se a data foi passada por parametro
		IF @DataAtual IS NULL
			BEGIN
				SET @DataAtual = GETDATE()
			END

		-- Verificacao se algum dos parametros obrigatorios nao foi passado
		IF @IdTipoMovimentacao IS NULL OR @IdProduto IS NULL OR @Quantidade IS NULL
			BEGIN
				RETURN 1
			END
		-- Verificacao se o produto passado por parâmetro existe
		IF NOT EXISTS	(SELECT TOP 1 1
							FROM [dbo].[Produto] WITH(NOLOCK)
							WHERE Id = @IdProduto)
			BEGIN
				RETURN 2
			END

		-- Verificacao se o tipo de movimentacao existe
		IF NOT EXISTS	(SELECT TOP 1 1
							FROM [dbo].[TipoMovimentacao] WITH(NOLOCK)
							WHERE Id = @IdTipoMovimentacao)
			BEGIN
				RETURN 3
			END

		-- Verifico se a quantidade passada é positiva
		IF @Quantidade < 0
			BEGIN
				RETURN 4
			END
		
		--INSERE NA TABELA MOVIMENTACAO ESTOQUE PRODUTO OS VALORES SETADOS NAS VARIAVEIS
		INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
			VALUES										(@IdProduto, @IdTipoMovimentacao, @DataAtual, @Quantidade)

		-- Verificacao de erros
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			RETURN 5
	END
GO



CREATE OR ALTER PROCEDURE [dbo].[SP_ListarMovimentacaoEstoqueProduto]
	@IdMovimentacaoProduto INT = NULL
	AS
	/*
	Documentacao
	Arquivo Fonte.....: MovimentacaoEstoqueProduto.sql
	Objetivo..........: Gerar um insert para a tabela de movimentacao no estoque da materia prima.
	Autor.............: Olívio Freitas
	Data..............: 23/05/2024
	Ex................: BEGIN TRAN
							DBCC FREEPROCCACHE
							DBCC FREESYSTEMCACHE('ALL')
							DBCC DROPCLEANBUFFERS

							DECLARE @Data_Inicio DATETIME = GETDATE(),
									@Retorno INT;

							SELECT	Id,
									IdTipoMovimentacao,
									IdEstoqueProduto,
									DataMovimentacao,
									Quantidade
								FROM [dbo].[MovimentacaoEstoqueProduto]

							EXEC @Retorno = [dbo].[SP_ListarMovimentacaoEstoqueProduto]

							SELECT	Id,
									IdTipoMovimentacao,
									IdEstoqueProduto,
									DataMovimentacao,
									Quantidade
								FROM [dbo].[MovimentacaoEstoqueProduto]

							SELECT	@Retorno AS Retorno,
									DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE());
						ROLLBACK TRAN

	Retornos..........: 0 - Sucesso.
						1 - Erro, movimentacao inexistente
	*/
	BEGIN
		IF @IdMovimentacaoProduto IS NOT NULL AND NOT EXISTS	(SELECT TOP 1 1
																	FROM [dbo].[MovimentacaoEstoqueProduto] WITH(NOLOCK)
																	WHERE Id = @IdMovimentacaoProduto)
			BEGIN
				RETURN 1
			END

		SELECT	Id,
				IdTipoMovimentacao,
				IdEstoqueProduto,
				DataMovimentacao,
				Quantidade
			FROM [dbo].[MovimentacaoEstoqueProduto] WITH(NOLOCK)
			WHERE Id = COALESCE(@IdMovimentacaoProduto, Id)

		RETURN 0
	END
GO