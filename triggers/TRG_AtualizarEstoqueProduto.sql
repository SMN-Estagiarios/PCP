CREATE OR ALTER TRIGGER [dbo].[TRG_AtualizarEstoqueProduto]
ON [dbo].[MovimentacaoEstoqueProduto]
FOR INSERT 
	AS
	/*
		DOCUMENTA��O
		Arquivo Fonte........:	TRG_AtualizarEstoqueProduto.sql
		Objetivo.............:	Atualiza quantidade f�sica do estoque de produto apos insert gerado na tabela MovimentacaoEstoqueProduto, que pode ocorrer quando um pedido � entregue
								ou quando ocorre a finaliza��o de todas as etapas de produ��o para a composi��o de um produto
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

									SELECT DATEDIFF(MILLISECOND, @DATA_INI,GETDATE()) AS TempoExecu��o

									SELECT * FROM [dbo].[MovimentacaoEstoqueProduto]

									SELECT * FROM [dbo].[EstoqueProduto]

								ROLLBACK TRAN					
	*/
	BEGIN
		--declarando vari�veis para realizar atualiza��o do registro de EstoqueMateriaPrima
		DECLARE @IdMovimentacao INT,
				@IdTipoMovimentacao INT,
				@QtdMovimentada INT,
				@IdEstoqueProduto INT
	    
		-- Atribui��o de Valores 
		SELECT @IdMovimentacao = Id,
			   @IdTipoMovimentacao = idTipoMovimentacao,
			   @QtdMovimentada = Quantidade,
			   @IdEstoqueProduto = IdEstoqueProduto
			FROM inserted
		
		--realiza atualiza��o do estoque f�sico mediante as movimenta��es do estoque 
		UPDATE [dbo].[EstoqueProduto]
			SET QuantidadeFisica = QuantidadeFisica + (CASE WHEN @IdTipoMovimentacao  = 1  
															THEN @QtdMovimentada 
														    ELSE @QtdMovimentada * (-1)
													    END)
			WHERE IdProduto = @IdEstoqueProduto
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			BEGIN
				RAISERROR('N�o foi possivel atualizar o estoque do produto', 16,1);
			END
	END