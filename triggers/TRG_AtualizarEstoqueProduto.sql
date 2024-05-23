CREATE OR ALTER TRIGGER [dbo].[TRG_AtualizarEstoqueProduto]
ON [dbo].[MovimentacaoEstoqueProduto]
FOR INSERT 
	AS
	/*
		DOCUMENTAÇÃO
		Arquivo Fonte........:	TRG_AtualizarEstoqueProduto.sql
		Objetivo.............:	Atualiza quantidade física do estoque de produto apos insert gerado na tabela MovimentacaoEstoqueProduto, que pode ocorrer quando um pedido é entregue
								ou quando ocorre a finalização de todas as etapas de produção para a composição de um produto
								@IdTipoMovimentacao travado em 1 para entregue e os ids acima de um representam saida ou perca 
		Autor................:	Adriel Alexander
		Data.................:	22/05/2024
		Autores Alteracao....:  Adriel Alexander
		Ex...................:  BEGIN TRAN
									DBCC DROPCLEANBUFFERS;
									DBCC FREEPROCCACHE;

									DECLARE @DATA_INI DATETIME = GETDATE();

									SELECT * FROM [dbo].[EstoqueProduto]

									SELECT * FROM [dbo].[MovimentacaoEstoqueProduto]

									INSERT INTO [dbo].[MovimentacaoEstoqueProduto](
																							IdTipoMovimentacao,
																							IdEstoqueProduto,
																							DataMovimentacao,
																							Quantidade
																					   )
										VALUES (2 , 1, GETDATE(), 100 )

									SELECT DATEDIFF(MILLISECOND, @DATA_INI,GETDATE()) AS TempoExecução

									SELECT * FROM [dbo].[MovimentacaoEstoqueProduto]

									SELECT * FROM [dbo].[EstoqueProduto]

								ROLLBACK TRAN					
	*/
	BEGIN
		--declarando variáveis para realizar atualização do registro de EstoqueMateriaPrima
		DECLARE @IdMovimentacao INT,
				@IdTipoMovimentacao INT,
				@QtdMovimentada INT,
				@IdEstoqueProduto INT
	    
		-- Atribuição de Valores 
		SELECT @IdMovimentacao = Id,
			   @IdTipoMovimentacao = idTipoMovimentacao,
			   @QtdMovimentada = Quantidade,
			   @IdEstoqueProduto = IdEstoqueProduto
			FROM inserted
		
		--realiza atualização do estoque físico mediante as movimentações do estoque 
		UPDATE [dbo].[EstoqueProduto]
			SET QuantidadeFisica = QuantidadeFisica + (CASE WHEN @IdTipoMovimentacao  = 1  
															THEN @QtdMovimentada 
														    ELSE @QtdMovimentada * (-1)
													    END)
			WHERE IdProduto = @IdEstoqueProduto
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			BEGIN
				RAISERROR('Não foi possivel atualizar o estoque do produto', 16,1);
			END
	END