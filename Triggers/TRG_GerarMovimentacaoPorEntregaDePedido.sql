CREATE OR ALTER TRIGGER [dbo].[TRG_GerarMovimentacaoPorEntregaDePedido]
	ON [dbo].[PedidoProduto]
	FOR INSERT
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
									
									SELECT  Id,
                                            IdTipoMovimentacao,
                                            IdEstoqueProduto,
                                            DataMovimentacao,
                                            Quantidade
										FROM [dbo].[movimentacaoestoqueproduto]	
									
									SELECT IdProduto,
											QuantidadeFisica,
											QuantidadeMinima 
										FROM [dbo].[estoqueproduto]

								INSERT INTO PedidoProduto (IdPedido, IdProduto, Quantidade)																					
											VALUES 	(1,	1,	125),
                                                    (1,	2,	125),
                                                    (2,	1,	120),
                                                    (2,	1,	120);
								-- INSERT INTO PedidoProduto (IdPedido, IdProduto, Quantidade)																					
								-- 			VALUES 	(1,	2,	125);
                                -- INSERT INTO PedidoProduto (IdPedido, IdProduto, Quantidade)																					
								-- 			VALUES 	(2,	1,	120);
                                -- INSERT INTO PedidoProduto (IdPedido, IdProduto, Quantidade)																					
								-- 			VALUES 	(2,	1,	120);
								
									SELECT Id,
										   IdTipoMovimentacao,
										   IdEstoqueProduto,
										   DataMovimentacao,
										   Quantidade
										FROM [dbo].[movimentacaoestoqueproduto]	
										
									SELECT IdProduto,
										   QuantidadeFisica,
										   QuantidadeMinima 
										FROM [dbo].[estoqueproduto]

                                    SELECT * FROM AuditoriaMovimetacaoSaidaEstoqueProduto
								ROLLBACK TRAN					
	*/
	BEGIN
		--Declarando Variaveis 
		DECLARE @DataAtual DATETIME = GETDATE(),
				@IdPedido INT,
				@IdMovimentacao INT;
			
		-- atribuicoes de valores para as variaveis 
		-- SELECT @DataEntregaInserted = DataEntrega
		-- 	FROM INSERTED
		
		-- SELECT @DataEntregaDeleted = DataEntrega
		-- 	FROM DELETED
		
		CREATE TABLE #Tabela (
                                IdPedidoProduto INT,
								IdPedido INT, 
								IdProduto INT,
								Quantidade INT,
								DataEntrega DATE
							 );

		INSERT INTO #Tabela (IdPedidoProduto, IdProduto, IdPedido, Quantidade, DataEntrega)
            --Faz a inserção relacionada com o que vem na inserted 
            SELECT  i.Id,
                    i.IdProduto,
                    i.IdPedido,
                    i.Quantidade,
                    p.DataEntrega
                FROM INSERTED i
                    INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
                        ON p.Id = i.IdPedido
                WHERE p.DataEntrega IS NOT NULL

		--faz um looping para fazer os inserts em movimentacao em lote 
		WHILE EXISTS (
						SELECT TOP 1 1 
							FROM #Tabela
					 )
            BEGIN
                SELECT TOP 1 @IdPedido = t.IdPedido
                    FROM #Tabela t;

                -- Inserir movimenta;áo em etoque produto com retirada de estoque
                INSERT INTO [dbo].[MovimentacaoEstoqueProduto]( 
                                                                IdTipoMovimentacao,
                                                                IdEstoqueProduto,
                                                                DataMovimentacao,
                                                                Quantidade
                                                            )
                    SELECT TOP 1    2,
                                    IdProduto,
                                    DataEntrega,
                                    Quantidade
                        FROM #Tabela

                SELECT @IdMovimentacao = SCOPE_IDENTITY()

                INSERT INTO [dbo].[AuditoriaMovimetacaoSaidaEstoqueProduto] (IdPedido, IdMovimentacaoEstoqueProduto)
                    VALUES (@IdPedido, @IdMovimentacao)
                
                DELETE TOP (1)
                    FROM #Tabela

                SELECT  @IdMovimentacao = NULL,
						@IdPedido = NULL;
            END
	    DROP TABLE #tabela
		-- --verifica se o motivo do update foi a realizacao da entrega dos produtos aos clientes
		-- IF @DataEntregaInserted IS NOT NULL AND @DataEntregaDeleted IS NULL
		-- 	BEGIN 
			


			--END
	END	