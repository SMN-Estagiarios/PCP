CREATE OR ALTER TRIGGER [dbo].[TRG_GerarMovimentacaoPorEntregaDePedido]
	ON [dbo].[Pedido]
	FOR UPDATE
	AS
	/*
		DOCUMENTACAO
		Arquivo Fonte........:	TRG_GerarMovimentacaoPorEntregaDePedido.sql
		Objetivo.............:	Gere inserts automaticamente na tabela de movimentacao do estoque de todos os produtos de um pedido IdTipoMovimentacao travado em 2 
								para categorizar saida de produtos do estoque mediante entrega do pedido 
								quando o mesmo é entregue ao cliente
		Autor................:	Adriel Alexander
		Data.................:	23/05/2024
		Autores Alteracao....:  Adriel Alexander
		Ex...................:  BEGIN TRAN
									DBCC DROPCLEANBUFFERS;
									DBCC FREEPROCCACHE;

									DECLARE @DATA_INI DATETIME = GETDATE();

									SELECT * FROM [dbo].[EstoqueProduto]
									SELECT * FROM [dbo].[MovimentacaoEstoqueProduto]

									UPDATE [dbo].[Pedido]
										SET DataEntrega = GETDATE()
										WHERE Id = 7
									select * from pedidoProduto
									SELECT DATEDIFF(MILLISECOND, @DATA_INI,GETDATE()) AS TempoExecucao


									SELECT * FROM [dbo].[EstoqueProduto]
									SELECT * FROM [dbo].[MovimentacaoEstoqueProduto]
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
			
		-- atribuicoes de valores para as variaveis 
		SELECT @DataEntregaInserted = DataEntrega,
			   @IdPedido = Id
			FROM Inserted
		
		SELECT @DataEntregaDeleted = DataEntrega
			FROM deleted


		--verifica se o motivo do update foi a realizacao da entrega dos produtos aos clientes
		IF @DataEntregaInserted IS NOT NULL AND @DataEntregaDeleted IS NULL
			BEGIN 
			
				INSERT INTO [dbo].[MovimentacaoEstoqueProduto] 
					  SELECT   pp.IdProduto,
							   2,
							   @DataAtual,
							   pp.Quantidade
							FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
							WHERE pp.IdPedido = @IdPedido
				
			END
	END	
