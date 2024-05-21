CREATE OR ALTER PROCEDURE [dbo].[SP_InserirPedido]
	@IdCliente INT,
	@DataPromessa DATE
	AS
	/*
		Documentação
		Arquivo Fonte........:	Pedido.sql
		Objetivo.............:	Procedure para inserir um novo registro de pedido
		Autor................:	João Victor Maia
		Data.................:	21/05/2024
		Exemplo..............:	BEGIN TRAN
									DECLARE @Ret INT,
											@DataInicio DATETIME = GETDATE(),
											@DataPromessa DATE =  DATEADD(DAY, 10, GETDATE())

									EXEC @Ret = [dbo].[SP_InserirPedido] 1, @DataPromessa

									SELECT	@Ret AS Retorno,
											DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

									SELECT	IdCliente,
											DataPedido,
											DataPromessa,
											DataEntrega
										FROM [dbo].[Pedido] WITH(NOLOCK)
										WHERE Id = SCOPE_IDENTITY()
								ROLLBACK TRAN
		Retornos.............:	0 - Sucesso
								1 - Erro: Id do cliente não existe
								2 - Erro: A data da promessa é inferior à hoje
	*/
	BEGIN
		--Declarar variáveis
		DECLARE @DataAtual DATE = GETDATE()

		--Checar se o Id do cliente existe
		IF NOT EXISTS	(SELECT TOP 1 1
							FROM [dbo].[Cliente] WITH(NOLOCK)
							WHERE Id = @IdCliente
						)
			BEGIN
				RETURN 1
			END

		--Checar se a data da promessa é maior que hoje
		IF @DataPromessa < @DataAtual
			BEGIN
				RETURN 2
			END

		--Inserir um pedido
		INSERT INTO [dbo].[Pedido]	(IdCliente, DataPedido, DataPromessa, DataEntrega) VALUES
									(@IdCliente, @DataAtual, @DataPromessa, NULL)
	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_ListarPedidos]
	@Id INT = NULL,
	@IdCliente INT = NULL,
	@DataPedido DATE = NULL,
	@DataPromessa DATE = NULL,
	@DataEntrega DATE = NULL
	AS
	/*
		Documentação
		Arquivo Fonte........:	Pedido.sql
		Objetivo.............:	Procedure para listar todos os pedidos registrados ou todos os pedidos filtrados por um ou mais campos
		Autor................:	João Victor Maia
		Data.................:	21/05/2024
		Exemplo..............:	DECLARE @Ret INT,
										@DataInicio DATETIME = GETDATE()

								EXEC @Ret = [dbo].[SP_ListarPedidos] @IdCliente = 1

								SELECT	@Ret AS Retorno,
										DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo
		Retornos.............:	0 - Sucesso
	*/
	BEGIN
		--Listar todos os pedidos ou filtra-los através dos parâmetros
		SELECT	Id,
				IdCliente,
				DataPedido,
				DataPromessa,
				DataEntrega
			FROM [dbo].[Pedido] WITH(NOLOCK)
			WHERE	Id = ISNULL(@Id, Id)
					AND IdCliente = ISNULL(@IdCliente, IdCliente)
					AND DataPedido = ISNULL(@DataPedido, DataPedido)
					AND DataPromessa = ISNULL(@DataPromessa, DataPromessa)
					AND ISNULL(DataEntrega, '1900-01-01') = COALESCE(NULL, DataEntrega, '1900-01-01')
	END
GO