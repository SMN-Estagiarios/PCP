CREATE OR ALTER TRIGGER [dbo].[TRG_GerarMovimentacaoPorEntregaDePedido]
	ON [dbo].[Pedido]
	FOR UPDATE
	AS
	/*
		DOCUMENTACAO
		Arquivo Fonte........:	TRG_GerarMovimentacaoPorEntregaDePedido.sql
		Objetivo.............:	Gere inserts automaticamente na tabela de movimentação do estoque de todos os produtos de um pedido 
								IdTipoMovimentacao travado em 2 para categorizar saida de produtos do estoque mediante entrega do pedido 
								quando o mesmo é entregue ao cliente
		Autor................:	Adriel Alexander
		Data.................:	24/05/2024
		Autores Alteracao....:  Gustavo Targino
		Ex...................:  BEGIN TRAN
									DBCC DROPCLEANBUFFERS;
									DBCC FREEPROCCACHE;

									DECLARE @DATA_INI DATETIME = GETDATE();
									
									SELECT * FROM [dbo].[Pedido] WITH(NOLOCK)

									 SELECT Id,
									 		IdTipoMovimentacao,
									 		IdEstoqueProduto,
									 		DataMovimentacao,
									 		Quantidade
									 	FROM [dbo].[MovimentacaoEstoqueProduto]
									 	WHERE IdEstoqueProduto = 1

									SElECT *
										FROM EstoqueProduto
										WHERE IdProduto IN (1,2)
									
									SELECT IdProduto,
										   QuantidadeFisica,
										   QuantidadeMinima 
										FROM [dbo].[Estoqueproduto] 
										WHERE IdProduto = 1

									UPDATE [dbo].[Pedido]
										SET DataEntrega = GETDATE()+1
										WHERE Id = 37
								
									SELECT Id,
										   IdTipoMovimentacao,
										   IdEstoqueProduto,
										   DataMovimentacao,
										   Quantidade
										FROM [dbo].[MovimentacaoEstoqueProduto]	
										WHERE IdEstoqueProduto = 1
										
									SELECT IdProduto,
										   QuantidadeFisica,
										   QuantidadeMinima 
										FROM [dbo].[Estoqueproduto] 
										WHERE IdProduto IN (1,2)

									SELECT * FROM [dbo].[Pedido] WITH(NOLOCK)
								
								ROLLBACK TRAN					
	*/
	BEGIN
		--Declarando Variaveis 
		DECLARE @DataAtual DATETIME = GETDATE(),
				@IdEstoqueProduto INT,
				@Quantidade INT,
				@IdPedido INT,
				@IdProduto INT,
				@DataEntregaInserted DATE,
				@DataEntregaDeleted DATE,
				@IdTipoMovimentacao INT = 1,
				@RET INT
			
		-- atribuicoes de valores para as variaveis 
		SELECT @DataEntregaInserted = DataEntrega
			FROM INSERTED
		
		SELECT @DataEntregaDeleted = DataEntrega
			FROM DELETED

			CREATE TABLE #ProdutosDoPedido (
					IdPedido INT,
					IdProduto INT,
					Quantidade INT,
					DataEntregaInserted DATETIME
			)

		--verifica se o motivo do update foi a realizacao da entrega dos produtos aos clientes
		IF @DataEntregaInserted IS NOT NULL AND @DataEntregaDeleted IS NULL
			BEGIN 
				SET @IdTipoMovimentacao = 2

				INSERT INTO #ProdutosDoPedido (IdPedido, IdProduto, Quantidade, DataEntregaInserted)
					SELECT  pp.Id,
							pp.IdProduto,
							pp.Quantidade,
							i.DataEntrega
						FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
							INNER JOIN INSERTED i
								ON i.Id = pp.IdPedido
						WHERE i.DataEntrega IS NOT NULL 
			END

		--Caso mude de nao nulo para nulo
		ELSE IF @DataEntregaInserted IS NULL AND @DataEntregaDeleted IS NOT NULL
			BEGIN
				INSERT INTO #ProdutosDoPedido (IdPedido, IdProduto, Quantidade, DataEntregaInserted)
					SELECT  pp.Id,
							pp.IdProduto,
							pp.Quantidade,
							i.DataEntrega
						FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
							INNER JOIN INSERTED i
								ON i.Id = pp.IdPedido
						WHERE i.DataEntrega IS NULL
			END
		
		--Caso seja somente mudanca de data de entrega, nao ha mudanca no estoque
		ELSE
			BEGIN
				DROP TABLE #ProdutosDoPedido
		 		RETURN;
			END
			
			-- Inserir movimentacao em etoque produto com retirada de estoque
			WHILE EXISTS ( SELECT TOP 1 1 
							FROM #ProdutosDoPedido )
				BEGIN
					SELECT TOP 1 @IdPedido = IdPedido,
								@IdProduto = IdProduto,
								@Quantidade = Quantidade,
								@DataEntregaInserted = DataEntregaInserted
						FROM #ProdutosDoPedido

					EXEC @RET = [dbo].[SP_InserirMovimentacaoEstoqueProduto] @IdProduto, @IdTipoMovimentacao, @DataAtual, @Quantidade
					PRINT @RET

					DELETE TOP (1) FROM #ProdutosDoPedido
				END

				DROP TABLE #ProdutosDoPedido

	END	