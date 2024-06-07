CREATE OR ALTER PROCEDURE [dbo].[SP_InserirMateriaPrima]
	@Nome VARCHAR(60) = NULL
	AS
	/*
		Documentacao
		Arquivo Fonte.....: MateriaPrima.sql
		Objetivo..........: Inserir um registro para a tabela de materia prima de acordo com os parametros passados
		Autor.............: Odlavir Florentino
		Data..............: 21/05/2024
		Ex................: BEGIN TRAN
								SELECT *
									FROM [dbo].[MateriaPrima] WITH(NOLOCK)

								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')
								DBCC DROPCLEANBUFFERS

								DECLARE @Data_Inicio DATETIME = GETDATE(),
										@Retorno INT;

								EXEC @Retorno = [dbo].[SP_InserirMateriaPrima] 'Teste 1'
									
								SELECT	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo;

								SELECT *
									FROM [dbo].[MateriaPrima] WITH(NOLOCK) 
							ROLLBACK TRAN

		Retornos..........: 00 - Sucesso.
							01 - Erro, o nome nao foi passado como parametro.
							02 - Erro, materia prima ja existente no banco de dados.
							03 - Erro, mao foi possivel inserir um registro na tabela.
	*/
	BEGIN
		--  Verificando se o parametro foi passado.
		IF @Nome IS NULL
			RETURN 1;

		-- Verificando se ja existe algum registro com o nome passado como parametro.
		IF EXISTS	(
						SELECT TOP 1 1
							FROM [dbo].[MateriaPrima] WITH(NOLOCK)
							WHERE Nome = @Nome
					)
			RETURN 2;

		-- Inserindo valor na tabela de materia prima.
		INSERT INTO [dbo].[MateriaPrima]	(Nome)
			VALUES							(@Nome);

		-- Verificando se ocorreu algum erro na insercao do registro.
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			BEGIN
				ROLLBACK TRAN;
				RETURN 3;
			END

		RETURN 0;
	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_ListarMateriaPrima]
	@Id INT = NULL
	AS
	/*
		Documentacao
		Arquivo Fonte.....: materiaprima.sql
		Objetivo..........: Listar um ou vários registros da tabela de materia prima.
		Autor.............: Odlavir Florentino
		Data..............: 21/05/2024
		Ex................: BEGIN TRAN
								DECLARE @Data_Inicio DATETIME = GETDATE(),
										@Retorno INT;

								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')
								DBCC DROPCLEANBUFFERS

								EXEC @Retorno = [dbo].[SP_ListarMateriaPrima] 99
									
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
													FROM [dbo].[MateriaPrima] WITH(NOLOCK)
													WHERE Id = @Id
											)
			RETURN 1;

		SELECT	Id,
				Nome
			FROM [dbo].[MateriaPrima] WITH(NOLOCK)
			WHERE Id = ISNULL(@Id, Id);

		RETURN 0;
	END
GO