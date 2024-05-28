CREATE OR ALTER PROCEDURE [dbo].[SP_InserirMovimentacaoEstoqueMateriaPrima]
	@IdMateriaPrima INT = NULL,
	@IdTipoMovimentacao INT = NULL,
	@Quantidade INT = NULL,
	@DataAtual DATETIME = NULL
	AS
	/*
		Documentacao
		Arquivo Fonte.....: MovimentacaoEstoqueMateriaPrima.sql
		Objetivo..........: Gerar um insert para a tabela de movimentacao no estoque da materia prima.
		Autor.............: Odlavir Florentino
		Data..............: 22/05/2024
		Ex................: BEGIN TRAN
								SELECT	*
									FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK);

								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')
								DBCC DROPCLEANBUFFERS

								DECLARE @Data_Inicio DATETIME = GETDATE(),
										@Retorno INT;

								EXEC @Retorno = [dbo].[SP_InserirMovimentacaoEstoqueMateriaPrima] 38, 1, 1

								SELECT	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE());

								SELECT	*
									FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK);
							ROLLBACK TRAN

		Retornos..........: 00 - Sucesso.
							01 - Erro, verifique corretamente os parametros passados
							02 - Erro, materia prima inexistente.
							03 - Erro, tipo de movimentacao inexistente.
							04 - Erro ao inserir um registro na tabela.
	*/
	BEGIN
		-- Se nao for passado como parametro a data, utilizar a data atual.
		IF @DataAtual IS NULL
			SET @DataAtual = GETDATE();

		-- Verificando se algum dos parametros obrigatorios nao foi passado.
		IF @IdTipoMovimentacao IS NULL OR @IdMateriaPrima IS NULL OR @Quantidade IS NULL
			RETURN 1;

		-- Verificando se a materia prima passada como parametro existe.
		IF NOT EXISTS	(
							SELECT TOP 1 1
								FROM [dbo].[MateriaPrima] WITH(NOLOCK)
								WHERE Id = @IdMateriaPrima
						)
			RETURN 2;

		-- Verificando se o tipo movimentacao passado como parametro existe.
		IF NOT EXISTS	(
							SELECT TOP 1 1
								FROM [dbo].[TipoMovimentacao] WITH(NOLOCK)
								WHERE Id = @IdTipoMovimentacao
						)
			RETURN 3;

		-- Caso a quantidade passada for menor que 0, devera ser aplicado o modulo para que fique positiva.
		IF @Quantidade < 0
			SET @Quantidade = ABS(@Quantidade);

		-- Inserir registro na tabela.
		INSERT INTO [dbo].[MovimentacaoEstoqueMateriaPrima]	(idTipoMovimentacao, IdEstoqueMateriaPrima, Quantidade, DataMovimentacao)
			VALUES											(@IdTipoMovimentacao, @IdMateriaPrima, @Quantidade, @DataAtual);

		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			RETURN 4;

		RETURN 0;
	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_ListarMovimentacaoEstoqueMateriaPrima]
	@Id INT = NULL
	AS
	/*
		Documentacao
		Arquivo Fonte.....: MovimentacaoEstoqueMateriaPrima.sql
		Objetivo..........: Listar um ou varios registros da tabela de movimentacao estoque de materia prima.
		Autor.............: Odlavir Florentino
		Data..............: 22/05/2024
		Ex................: BEGIN TRAN
								DECLARE @Data_Inicio DATETIME = GETDATE(),
										@Retorno INT;

								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')
								DBCC DROPCLEANBUFFERS

								EXEC @Retorno = [dbo].[SP_ListarMateriaPrima] 38
									
								SELECT	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo;
							ROLLBACK TRAN

		Retornos..........: 00 - Sucesso.
							01 - Erro, materia prima inexistente.
	*/
	BEGIN
		-- Verificando se existe o registro com o id passado
		IF @Id IS NOT NULL AND NOT EXISTS	(
												SELECT TOP 1 1
													FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
													WHERE Id = @Id
											)
			RETURN 1;

		SELECT	Id,
				idTipoMovimentacao,
				IdEstoqueMateriaPrima,
				Quantidade,
				DataMovimentacao
			FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
			WHERE Id = ISNULL(@Id, Id);

		RETURN 0;
	END
GO