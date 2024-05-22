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

								EXEC @Ret = [dbo].[SP_ListarPedidos] @IdCliente = 1, @Id = 1

								SELECT	@Ret AS Retorno,
										DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo
		Autor Alteração......:	João Victor Maia
		Data Alteração.......:	22/05/2024
		Objetivo Alteração...:	Validação de parâmetros e indentação do código
		Retornos.............:	0 - Sucesso
								1 - Erro: Nenhum parâmetro foi passado
	*/
	BEGIN
		--Declarar variáveis
		DECLARE @Comando NVARCHAR(MAX),
				@Parametros NVARCHAR(1000),
				@Where BIT
		
		--Montar comando
		SET @Comando = N'
							SELECT	Id,
									IdCliente,
									DataPedido,
									DataPromessa,
									DataEntrega
								FROM [dbo].[Pedido] WITH(NOLOCK)
								WHERE '
		SET @Where = 0

		--Montar cláusula WHERE
		IF @Id IS NOT NULL 
			BEGIN
				SET @Comando = @Comando + N'Id = @pId'
				SET @Where = 1 
			END

		IF @IdCliente IS NOT NULL 
			BEGIN
				SET @Comando = @Comando +	(CASE WHEN @Where = 1 THEN N'
												AND ' ELSE N''END
											)
											+ N'IdCliente = @pIdCliente'
				SET @Where = 1 
			END

		IF @DataPedido IS NOT NULL 
			BEGIN
				SET @Comando = @Comando +	(CASE WHEN @Where = 1 THEN N'
												AND ' ELSE N''END
											) 
											+ N'DataPedido = @pDataPedido'
				SET @Where = 1 
			END
		
		IF @DataPromessa IS NOT NULL 
			BEGIN
				SET @Comando = @Comando +	(CASE WHEN @Where = 1 THEN N'
												AND ' ELSE N''END
											) 
											+ N'DataPromessa = @pDataPromessa'
				SET @Where = 1 
			END
		
		IF @DataEntrega IS NOT NULL 
			BEGIN
				SET @Comando = @Comando +	(CASE WHEN @Where = 1 THEN N'
												AND ' ELSE N''END
											) 
											+ N'ISNULL(DataEntrega, ''1900-01-01'') = @pDataEntrega'
				SET @Where = 1 
			END
		
		--Criar parâmetros da execução do comando
		SET @Parametros = N'@pId INT, @pIdCliente INT, @pDataPedido DATE, @pDataPromessa DATE, @pDataEntrega DATE'
			
		--Checar se não há parâmetros
		IF RIGHT(@Comando, 1) = ' ' 
			BEGIN
				RETURN 1
			END

		--Executar Comando  
		EXEC sp_executesql @Comando, 
						   @Parametros,
						   @pId = @Id, 
						   @pIdCliente = @IdCliente,
						   @pDataPedido = @DataPedido,
						   @pDataPromessa = @DataPromessa,
						   @pDataEntrega = @DataEntrega

	END
GO

CREATE OR ALTER PROCEDURE [dbo].[Sp_ListarPedidosEmAtraso]
	AS 
	/*
		Documentação
		Arquivo Fonte.........:	FNC_VerificarMatPrimaProduto.sql
		Objetivo..............:	Lista os pedidos que estão em atraso e os pedidos que foram entregues em atraso 
		Autor.................:	Adriel Alexander de Sousa
		Data..................:	21/05/2024
		Ex....................:	DBCC FREEPROCCACHE
								DBCC DROPCLEANBUFFERS

								DECLARE @DataInicio DATETIME = GETDATE()

								EXEC [Sp_ListarPedidosEmAtraso]

								SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao
	*/
	BEGIN
		--Declaracao de variáveis 
		DECLARE @DataAtual DATE = GETDATE();


		--Consulta dos pedidos em atraso 
		SELECT p.Id,
			   c.Nome AS NomeCliente,
			   p.DataPedido,
			   p.DataPromessa,
			   p.DataEntrega,
			   STRING_AGG(pd.Nome + ', Qtd: ' 
								  + CAST(pp.Quantidade AS NVARCHAR), '/ ') AS DetalhesPedido
			FROM [dbo].[Pedido] p WITH(NOLOCK)
				INNER JOIN [dbo].[Cliente] c WITH(NOLOCK)
					ON c.Id = p.IdCliente
				INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
					ON pp.IdPedido = p.Id
				INNER JOIN [dbo].[Produto]pd WITH(NOLOCK)
					ON pd.Id = pp.IdProduto
			WHERE p.DataEntrega IS NULL 
				  AND @DataAtual > p.DataPromessa
			GROUP BY p.Id, c.Nome, p.DataPedido,
					 p.DataPromessa, p.DataEntrega
	END
GO