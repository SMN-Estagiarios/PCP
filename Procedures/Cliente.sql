CREATE OR ALTER PROCEDURE [dbo].[SP_ListarClientes]
	@IdCliente INT = NULL
AS
		/*
			Documentação
			Arquivo fonte........: Cliente.sql
			Objetivo.............: Listar um ou todos os clientes
			Autor................: Gustavo Targino
			Data.................: 21/05/2024
			Ex...................: BEGIN TRAN
										
										DECLARE @DataInicio DATETIME = GETDATE()

										EXEC [dbo].[SP_ListarClientes] 1

										SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) Tempo

								   ROLLBACK
		*/
	BEGIN
		-- Selecionando as informações de um ou todos os clientes
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
			Documentação
			Arquivo fonte........: Cliente.sql
			Objetivo.............: Inserir um cliente
			Autor................: Gustavo Targino
			Data.................: 21/05/2024
			Ex...................: BEGIN TRAN
										
										DECLARE @DataInicio DATETIME = GETDATE()

										SELECT Id, Nome FROM [dbo].[Cliente]

										EXEC [dbo].[SP_InserirCliente] 'Gustavo'

										SELECT Id, Nome FROM [dbo].[Cliente]

										SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) Tempo

								   ROLLBACK
			Retornos.............: 0 - Cliente inserido com sucesso
								   1 - Houve um erro ao inserir o cliente
		*/
	BEGIN
		-- Inserindo um novo cliente
		INSERT INTO [dbo].[Cliente](c.Nome)
			VALUES (@Nome)

		-- Checagem de erro
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			RETURN 1

		RETURN 0
	END

GO
CREATE OR ALTER PROCEDURE [dbo].[SP_AtualizarCliente]	
	@IdCliente INT,
	@Nome VARCHAR(100)
AS
		/*
			Documentação
			Arquivo fonte........: Cliente.sql
			Objetivo.............: Atualizar um cliente
			Autor................: Gustavo Targino
			Data.................: 21/05/2024
			Ex...................: BEGIN TRAN
										
										DECLARE @DataInicio DATETIME = GETDATE(),
												@Ret INT

										SELECT Id, Nome FROM [dbo].[Cliente]

										EXEC @Ret = [dbo].[SP_AtualizarCliente] 2, 'João'
										SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) Tempo,
											   @Ret Retorno

								   ROLLBACK
			Retornos.............: 0 - Cliente atualizado com sucesso
								   1 - Houve um erro atualizar o cliente
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