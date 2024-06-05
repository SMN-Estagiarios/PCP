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
		Autores Alteracao....:  Odlavir, Adriel 
		Data Alteracao.......:	03/06/2024
		Ex...................:  BEGIN TRAN
								
									SELECT * FROM [dbo].[Pedido] WITH(NOLOCK)
										WHERE Id = 37 

									 SELECT Id,
									 		IdTipoMovimentacao,
									 		IdEstoqueProduto,
									 		DataMovimentacao,
									 		Quantidade
									 	FROM [dbo].[MovimentacaoEstoqueProduto]
									 	WHERE IdEstoqueProduto IN (24, 14, 29)
										ORDER BY id DESC
									
									SELECT IdProduto,
										   QuantidadeFisica,
										   QuantidadeMinima 
										FROM [dbo].[Estoqueproduto] 
										WHERE IdProduto IN (24, 14, 29)
									
									SELECT TOP 1 * 
										FROM [AuditoriaMovimetacaoSaidaEstoqueProduto]
										ORDER BY idMovimentacaoEstoqueProduto DESC 
									
									DBCC DROPCLEANBUFFERS;
									DBCC FREEPROCCACHE;
									DBCC FREESYSTEMCACHE('ALL');

									DECLARE @DataInicio DATETIME = GETDATE();

									UPDATE [dbo].[Pedido]
										SET DataEntrega = GETDATE()
										WHERE Id = 37

									SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE())
									
								
									SELECT Id,
										   IdTipoMovimentacao,
										   IdEstoqueProduto,
										   DataMovimentacao,
										   Quantidade
										FROM [dbo].[MovimentacaoEstoqueProduto]	
										WHERE IdEstoqueProduto IN (24, 14, 29)
										ORDER BY id DESC

										
									SELECT IdProduto,
										   QuantidadeFisica,
										   QuantidadeMinima 
										FROM [dbo].[Estoqueproduto] 
										WHERE IdProduto IN (24, 14, 29)

									SELECT * FROM [dbo].[Pedido] WITH(NOLOCK)
										WHERE Id = 37

									SELECT TOP 1 * 
										FROM [AuditoriaMovimetacaoSaidaEstoqueProduto]
										ORDER BY idMovimentacaoEstoqueProduto DESC 
								
								ROLLBACK TRAN					
	*/
	BEGIN
		--Declarando Variaveis 
		DECLARE @DataMovimentacao DATETIME = GETDATE(),
				@Quantidade INT,
				@IdPedido INT,
				@IdProduto INT,
				@DataEntregaInserted DATE,
				@DataEntregaDeleted DATE,
				@IdTipoMovimentacao INT = 1,
				@IdMovimentacao INT 

		-- atribuicoes de valores para as variaveis de validacao 
		SELECT @DataEntregaInserted = DataEntrega
			FROM INSERTED
		
		SELECT @DataEntregaDeleted = DataEntrega
			FROM DELETED

			CREATE TABLE #ProdutosDoPedido (
					IdPedido INT,
					IdProduto INT,
					Quantidade INT,
					DataEntrega DATETIME
			)

		--verifica se o motivo do update foi a realizacao da entrega dos produtos aos clientes
		IF @DataEntregaInserted IS NOT NULL AND @DataEntregaDeleted IS NULL
			BEGIN 
				SET @IdTipoMovimentacao = 2

				INSERT INTO #ProdutosDoPedido (IdPedido, IdProduto, Quantidade, DataEntrega)
					SELECT  i.Id,
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
				INSERT INTO #ProdutosDoPedido (IdPedido, IdProduto, Quantidade, DataEntrega)
					SELECT  i.Id,
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
			WHILE EXISTS (
							 SELECT TOP 1 1 
								FROM #ProdutosDoPedido
						 )
				BEGIN
					SELECT TOP 1 @IdPedido = IdPedido,
								@IdProduto = IdProduto,
								@Quantidade = Quantidade,
								@DataMovimentacao = DataEntrega
						FROM #ProdutosDoPedido

					--Insere o registro de movimentacao 
					EXEC [dbo].[SP_InserirMovimentacaoEstoqueProduto] @IdProduto, @IdTipoMovimentacao, @DataMovimentacao, @Quantidade
					
					--setando o valor do id com base no ultimo registro de movimentacao 
					SET @IdMovimentacao = IDENT_CURRENT('MovimentacaoEstoqueProduto')

					--Registra a qual pedido se referen os registros de movimentacao 
					INSERT INTO [dbo].[AuditoriaMovimetacaoSaidaEstoqueProduto] (IdPedido, IdMovimentacaoEstoqueProduto)
						VALUES (@IdPedido, @IdMovimentacao) 
					
					--valição de error para insert de auditoria 
					IF @@ERROR <> 0 OR @@ROWCOUNT <> 1 
						BEGIN
							ROLLBACK TRAN
							RAISERROR('Impossivel inserir audtoria de movimentação ', 16,1);
							RETURN 
						END

					--faz o delete do registro que foi inserido anteriormente 
					DELETE TOP (1) 
						FROM #ProdutosDoPedido
				END

				DROP TABLE #ProdutosDoPedido

	END	