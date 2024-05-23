CREATE OR ALTER PROCEDURE [dbo].[SP_InserirPedido]
	@IdCliente INT,
	@DataPromessa DATE,
	@JSON NVARCHAR(MAX)
	AS
	/*
		Documentação
		Arquivo Fonte........:	Pedido.sql
		Objetivo.............:	Procedure para inserir um novo registro de pedido e os seus produtos
		Autor................:	João Victor Maia
		Data.................:	21/05/2024
		Exemplo..............:	BEGIN TRAN
									DBCC FREEPROCCACHE
									DBCC DROPCLEANBUFFERS

									DECLARE @Ret INT,
											@DataInicio DATETIME = GETDATE(),
											@DataPromessa DATE =  DATEADD(DAY, 10, GETDATE())

									EXEC @Ret = [dbo].[SP_InserirPedido] 1, @DataPromessa, N'	[	{"IdProduto": 1, "Quantidade": 2},
																									{"IdProduto": 2, "Quantidade": 5}
																								]
																							'

									SELECT	@Ret AS Retorno,
											DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

									SELECT	IdCliente,
											DataPedido,
											DataPromessa,
											DataEntrega
										FROM [dbo].[Pedido] WITH(NOLOCK)
										WHERE Id = IDENT_CURRENT('Pedido')

									SELECT	IdPedido,
											IdProduto,
											Quantidade
										FROM [dbo].[PedidoProduto]
										WHERE IdPedido = IDENT_CURRENT('Pedido')
								ROLLBACK TRAN
		Retornos.............:	0 - Sucesso
								1 - Erro: o cliente não existe
								2 - Erro: a data da promessa é menor que a data atual
								3 - Erro: um Id de produto inexistente foi passado
	*/
	BEGIN
		--Declarar variáveis
		DECLARE @IdProduto INT,
				@Quantidade SMALLINT,
				@IdPedido INT,
				@DataAtual DATE = GETDATE()

		--Checar se o cliente existe
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

		--Criar tabela temporária
		CREATE TABLE #ProdutoDoPedido	(
											IdProduto INT,
											Quantidade SMALLINT
										)
		
		--Inserir dados na tabela temporária
		INSERT INTO #ProdutoDoPedido
			SELECT	IdProduto,
					Quantidade
				FROM OPENJSON(@JSON)
				WITH(	IdProduto INT,
						Quantidade SMALLINT
					)

	--Checar se algum Id do produto não existe
	IF EXISTS	(SELECT TOP 1 1
						FROM [dbo].[Produto] p WITH(NOLOCK)
							RIGHT JOIN #ProdutoDoPedido pdp
								ON pdp.IdProduto = p.Id
						WHERE p.Id IS NULL
				)
		BEGIN
			RETURN 3
		END

	--Inserir novo pedido
	INSERT INTO [dbo].[Pedido]	(IdCliente, DataPedido, DataPromessa, DataEntrega) VALUES
								(@IdCliente, @DataAtual, @DataPromessa, NULL)
	
	--Atribuir valor à IdPedido
	SET @IdPedido = SCOPE_IDENTITY()

	--Inserir a lista dos produtos do pedido
	INSERT INTO [dbo].[PedidoProduto](IdPedido, IdProduto, Quantidade)
		SELECT	@IdPedido,
				IdProduto,
				Quantidade
			FROM #ProdutoDoPedido

	--Dropar tabela temporária
	DROP TABLE #ProdutoDoPedido

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
		Exemplo..............:	DBCC FREEPROCCACHE
								DBCC DROPCLEANBUFFERS

								DECLARE @Ret INT,
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

CREATE OR ALTER PROCEDURE [dbo].[SP_ListarPedidosEmProducao]
	AS
		/*
			Documentação
			Arquivo fonte.........: Pedido.sql
			Objetivo..............: Listar pedidos que estão em produção
			Autor.................: Gustavo Targino
			Data..................: 22/05/2024
			Ex....................: DBCC FREEPROCCACHE
									DBCC DROPCLEANBUFFERS

									DECLARE @DataInicio DATETIME = GETDATE()

									EXEC [dbo].[SP_ListarPedidosEmProducao]

									SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) Tempo
		*/
	BEGIN
		-- Selecionando os pedidos em produção
		SELECT p.Id,
			   p.IdCliente,
			   p.DataPedido,
			   p.DataPromessa,
			   p.DataEntrega
			FROM [dbo].[Pedido] p WITH(NOLOCK)
				WHERE p.DataEntrega IS NULL
	END
GO