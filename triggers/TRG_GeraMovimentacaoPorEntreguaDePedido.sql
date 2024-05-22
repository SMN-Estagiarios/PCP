CREATE OR ALTER TRIGGER [dbo].[TRG_GeraMovimentacaoPorEntreguaDePedido]
	ON [dbo].[Pedido]
	FOR UPDATE
	AS
	/*
		DOCUMENTAÇÃO
		Arquivo Fonte........:	TRG_AtualizarEstoqueProduto.sql
		Objetivo.............:	Gere inserts automaticamente na tabela de movimentações do estoque de todos os produtos de um pedido
								quando o mesmo é entregue ao cliente
		Autor................:	Adriel Alexander
		Data.................:	22/05/2024
		Autores Alteracao....:  Adriel Alexander
		Ex...................:  BEGIN TRAN
									DBCC DROPCLEANBUFFERS;
									DBCC FREEPROCCACHE;

									DECLARE @DATA_INI DATETIME = GETDATE();

									SELECT * FROM [dbo].[EstoqueProduto]

									SELECT * FROM [dbo].[MovimentacaoEstoqueProduto]

									UPDATE [dbo].[Pedido]
										SET DataEntrega = GETDATE()
										WHERE Id = 9 

									SELECT DATEDIFF(MILLISECOND, @DATA_INI,GETDATE()) AS TempoExecução

									SELECT * FROM [dbo].[MovimentacaoEstoqueProduto]

									SELECT * FROM [dbo].[EstoqueProduto]

								ROLLBACK TRAN					
	*/
	BEGIN
		--Declarando Variaveis 
		DECLARE @DataAtual DATETIME = GETDATE(),
				@IdEstoqueProduto INT,
				@Quantidade INT,
				@IdPedido INT,
				@DataEntrega DATE
			
		-- atribuição de valores para as variáveis 
		SELECT @DataEntrega = DataEntrega,
			   @IdPedido = Id
			FROM Inserted

		--verifica se o motivo do update foi a realização da entrega dos produtos aos clientes
		IF @DataEntrega IS NOT NULL
			BEGIN 
				--criando tabela temporária para receber a relação dos produtos que foram entregues 	
				CREATE TABLE #TabelaProdutos (
												IdPedido INT,
												IdProduto INT,
												Quantidade INT
												)
				--inserindo relacao dentro da tabela 
				INSERT INTO #TabelaProdutos
					SELECT pp.IdPedido,
						   pp.IdProduto,
						   pp.Quantidade
						FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
						WHERE pp.IdPedido = @IdPedido
				
				-- iterando entre os pedidos de um produto 
				WHILE EXISTS (
								SELECT tp.IdPedido,
									   tp.IdProduto,
									   tp.Quantidade
									FROM #TabelaProdutos tp
							 )
					BEGIN
						--atribuindo as variáveis 
						SELECT TOP 1 @IdPedido = tp.IdPedido,
									 @IdEstoqueProduto = tp.IdProduto,
									 @Quantidade = tp.Quantidade
								FROM #TabelaProdutos tp
						
						--fazendo insert na tabela de movimentação de produtos 
						INSERT INTO [dbo].[MovimentacaoEstoqueProduto](
																		IdTipoMovimentacao,
																		IdEstoqueProduto,
																		DataMovimentacao,
																		Quantidade
																	  )
						   VALUES									  (
																		2,
																		@IdEstoqueProduto,
																		@DataAtual,
																		@Quantidade
																	  )
					   --deletando informações do registro da tabela temporaria 
					   DELETE FROM #TabelaProdutos
							  WHERE IdProduto = @IdEstoqueProduto

					  --resetando as variáveis 
					  SET @IdPedido = NULL
					  SET @IdEstoqueProduto = NULL
					  SET @Quantidade = NULL

					END
				DROP TABLE #TabelaProdutos
			END
	END	
	