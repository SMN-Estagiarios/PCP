CREATE OR ALTER TRIGGER [dbo].[TRG_GerarEstoqueMateriaPrima]
	ON [dbo].[MateriaPrima]
	AFTER INSERT
	AS
	/*
		Documentacao
		Arquivo Fonte.....: TRG_GerarEstoqueMateriaPrima.sql
		Objetivo..........: Gerar um registro de estoque, sempre que uma materia prima for inserida.
		Autor.............: Odlavir Florentino
		Data..............: 21/05/2024
		Ex................: BEGIN TRAN
								SELECT *
									FROM [dbo].[MateriaPrima] WITH(NOLOCK)

								SELECT *
									FROM [dbo].[EstoqueMateriaPrima] WITH(NOLOCK)

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
									
								SELECT *
									FROM [dbo].[EstoqueMateriaPrima] WITH(NOLOCK)
							ROLLBACK TRAN
	*/
	BEGIN
		-- Declarando variavel de id necessaria para criar o registro de estoque.
		DECLARE @IdInserted INT;

		-- Atribuindo valor a variavel de id.
		SELECT	@IdInserted = Id
			FROM inserted;

		-- Inserindo registro para a tabela de estoque de materia prima.
		INSERT INTO [dbo].[EstoqueMateriaPrima]	(IdMateriaPrima, QuantidadeFisica, QuantidadeMinima)
			VALUES								(@IdInserted, 0, 0);

		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			BEGIN
				ROLLBACK TRAN;
				RAISERROR('Erro ao inserir registro no estoque.', 16, 1);
				RETURN;
			END
	END