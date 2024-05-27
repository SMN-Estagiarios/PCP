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

									UPDATE [dbo].[Pedido]
										SET DataEntrega = GETDATE()
										WHERE Id = 7
								
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
				@DataEntregaDeleted DATE
			
		-- atribuicoes de valores para as variaveis 
		SELECT @DataEntregaInserted = DataEntrega,
			   @IdPedido = Id
			FROM INSERTED
		
		SELECT @DataEntregaDeleted = DataEntrega
			FROM DELETED

		--verifica se o motivo do update foi a realizacao da entrega dos produtos aos clientes
		IF @DataEntregaInserted IS NOT NULL AND @DataEntregaDeleted IS NULL
			BEGIN 
			
				SELECT  @IdPedido = i.Id,
                		@IdProduto = pp.IdProduto,
                		@Quantidade = pp.Quantidade,
                		@DataEntregaInserted = i.DataEntrega
            FROM INSERTED i
                INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                    ON @IdPedido = pp.IdPedido
            WHERE i.DataEntrega IS NOT NULL AND @DataEntregaDeleted IS NULL

			-- Inserir movimenta;áo em etoque produto com retirada de estoque
			EXEC [dbo].[SP_InserirMovimentacaoEstoqueProduto] @IdProduto, 2, @DataAtual, @Quantidade

			END
	END	