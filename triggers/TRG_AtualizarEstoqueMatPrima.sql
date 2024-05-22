CREATE OR ALTER TRIGGER [dbo].[TRG_AtualizarEstoqueMatPrima]
ON [dbo].[MovimentacaoEstoqueMateriaPrima]
FOR INSERT
	AS
	/*
		DOCUMENTA��O
		Arquivo Fonte........:	TRG_AtualizarEstoqueMatPrima.sql
		Objetivo.............:	Atualiza estoque da materia prima com base nas movimenta��es
		Autor................:	Adriel Alexander
		Data.................:	22/05/2024
		Autores Alteracao....:  Adriel Alexander
		Ex...................:  BEGIN TRAN
									DBCC DROPCLEANBUFFERS;
									DBCC FREEPROCCACHE;

									DECLARE @DATA_INI DATETIME = GETDATE();

									SELECT * FROM [dbo].[EstoqueMateriaPrima]

									INSERT INTO [dbo].[MovimentacaoEstoqueMateriaPrima](
																							idTipoMovimentacao,
																							IdEstoqueMateriaPrima,
																							DataMovimentacao,
																							Quantidade
																					   )
										VALUES (1 , 1, GETDATE(), 20000 )

									SELECT DATEDIFF(MILLISECOND, @DATA_INI,GETDATE()) AS TempoExecu��o

									SELECT * FROM [dbo].[EstoqueMateriaPrima]

								ROLLBACK TRAN					
	*/
	BEGIN
		--declarando vari�veis para realizar atualiza��o do registro de EstoqueMateriaPrima
		DECLARE @IdMovimentacao INT,
				@IdTipoMovimentacao INT,
				@QtdMovimentada INT,
				@IdEstoqueMateriaPrima INT
	    
		-- Atribui��o de Valores 
		SELECT @IdMovimentacao = Id,
			   @IdTipoMovimentacao = idTipoMovimentacao,
			   @QtdMovimentada = Quantidade,
			   @IdEstoqueMateriaPrima = IdEstoqueMateriaPrima
			FROM inserted
		
		--realiza atualiza��o do estoque f�sico mediante as movimenta��es do estoque 
		UPDATE [dbo].[EstoqueMateriaPrima]
			SET QuantidadeFisica = QuantidadeFisica + (CASE WHEN @IdTipoMovimentacao  = 1  
														    THEN @QtdMovimentada 
														    WHEN @IdTipoMovimentacao > 1 AND QuantidadeFisica - @QtdMovimentada >= QuantidadeMinima
															THEN @QtdMovimentada * (-1)
														    ELSE 0
													    END)
			WHERE IdMateriaPrima = @IdEstoqueMateriaPrima 
		IF @@ERROR <> 0 
			BEGIN
				RAISERROR('N�o foi possivel atualizar o estoque do produto', 16,1);
			END
	END