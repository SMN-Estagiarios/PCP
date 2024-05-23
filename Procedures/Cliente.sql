CREATE OR ALTER PROCEDURE [dbo].[SP_ListarClientes]
	@IdCliente INT = NULL
AS
		/*
			Documentacaoo
			Arquivo fonte........: Cliente.sql
			Objetivo.............: Listar um ou todos os clientes
			Autor................: Gustavo Targino
			Data.................: 21/05/2024
			Ex...................: BEGIN TRAN
										DBCC DROPCLEANBUFFERS
										DBCC FREEPROCCACHE
										DBCC FREESYSTEMCACHE('ALL')
										
										DECLARE @DataInicio DATETIME = GETDATE()

										EXEC [dbo].[SP_ListarClientes] 1

										SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) Tempo
								   ROLLBACK
		*/
	BEGIN
		-- Selecionando as informacoes de um ou todos os clientes
		SELECT  c.Id,
				c.Nome
			FROM [dbo].[Cliente] c WITH(NOLOCK)
				WHERE c.Id = ISNULL(@IdCliente, c.Id)

	END

GO
CREATE OR ALTER PROCEDURE [dbo].[SP_InserirCliente]
	@Nome VARCHAR(100)
	AS
	/*
		Documentacao
		Arquivo fonte.....: Cliente.sql
		Objetivo..........: Inserir um cliente
		Autor.............: Gustavo Targino
		Data..............: 21/05/2024
		Ex................: BEGIN TRAN
								SELECT *
									FROM [dbo].[Cliente] WITH(NOLOCK);
								
								DBCC DROPCLEANBUFFERS
								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')

								DECLARE @Data_Inicio DATETIME = GETDATE(),
										@Retorno INT;

								EXEC @Retorno = [dbo].[SP_InserirCliente] 'Gustavo'

								SELECT 	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo;
								
								SELECT *
									FROM [dbo].[Cliente] WITH(NOLOCK);
							ROLLBACK

		Retornos..........: 00 - Cliente inserido com sucesso
							01 - Houve um erro ao inserir o cliente
	*/
	BEGIN
		-- Inserindo um novo cliente
		INSERT INTO [dbo].[Cliente](c.Nome)
			VALUES (@Nome)

		-- Checagem de erro
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			RETURN 1;

		RETURN 0
	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_AtualizarCliente]	
	@IdCliente INT,
	@Nome VARCHAR(100)
	AS
	/*
		Documentacao
		Arquivo fonte.....: Cliente.sql
		Objetivo..........: Atualizar um cliente
		Autor.............: Gustavo Targino
		Data..............: 21/05/2024
		Ex................: BEGIN TRAN
								SELECT *
									FROM [dbo].[Cliente] WITH(NOLOCK);

								DBCC DROPCLEANBUFFERS
								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')
								
								DECLARE @Data_Inicio DATETIME = GETDATE(),
										@Retorno INT;

								EXEC @Retorno = [dbo].[SP_AtualizarCliente] 2, 'Joao'

								SELECT 	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo;

								SELECT *
									FROM [dbo].[Cliente] WITH(NOLOCK);
							ROLLBACK TRAN

		Retornos..........: 00 - Cliente atualizado com sucesso
							01 - Houve um erro atualizar o cliente
	*/
	BEGIN
		-- Inserindo um novo cliente
		UPDATE [dbo].[Cliente] 
			SET Nome = @Nome
				WHERE Id = @IdCliente

		-- Checagem de erro
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			RETURN 1

		RETURN 0
	END