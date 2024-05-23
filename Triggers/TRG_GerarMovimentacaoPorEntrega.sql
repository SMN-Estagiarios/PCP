CREATE OR ALTER TRIGGER [dbo].[TRG_GerarMovimentacaoPorEntrega]
	ON [dbo].[Pedido]
	FOR UPDATE
	AS
	/*
		DOCUMENTA��O
		Arquivo Fonte........:	TRG_GerarMovimentacaoPorEntrega.sql
		Objetivo.............:	Gere inserts automaticamente na tabela de movimenta��es do estoque de todos os produtos de um pedido
								quando o mesmo � entregue ao cliente
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
										WHERE Id = 3

									SELECT DATEDIFF(MILLISECOND, @DATA_INI,GETDATE()) AS TempoExecu��o

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
				@DataEntregaInserted DATE,
				@DataEntregaDeleted DATE
			
		-- atribui��o de valores para as vari�veis 
		SELECT @DataEntregaInserted = DataEntrega,
			   @IdPedido = Id
			FROM Inserted
		
		SELECT @DataEntregaDeleted = DataEntrega
			FROM deleted


		--verifica se o motivo do update foi a realiza��o da entrega dos produtos aos clientes
		IF @DataEntregaInserted IS NOT NULL AND @DataEntregaDeleted IS NULL
			BEGIN 
				--criando tabela tempor�ria para receber a rela��o dos produtos que foram entregues 	
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
						--atribuindo as vari�veis 
						SELECT TOP 1 @IdPedido = tp.IdPedido,
									 @IdEstoqueProduto = tp.IdProduto,
									 @Quantidade = tp.Quantidade
								FROM #TabelaProdutos tp
						
						--fazendo insert na tabela de movimenta��o de produtos 
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
					   --deletando informa��es do registro da tabela temporaria 
					   DELETE FROM #TabelaProdutos
							  WHERE IdProduto = @IdEstoqueProduto

					  --resetando as vari�veis 
					  SET @IdPedido = NULL
					  SET @IdEstoqueProduto = NULL
					  SET @Quantidade = NULL

					END
				--delecao da tabela temporaria
				DROP TABLE #TabelaProdutos
			END
	END	
	