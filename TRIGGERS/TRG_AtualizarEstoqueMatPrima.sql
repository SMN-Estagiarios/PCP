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
									SELECT	*
										FROM [dbo].[EstoqueMateriaPrima];

									SELECT	*
										FROM [dbo].[MovimentacaoEstoqueMateriaPrima];

									DBCC FREEPROCCACHE
									DBCC FREESYSTEMCACHE('ALL')
									DBCC DROPCLEANBUFFERS

									DECLARE @Data_Inicio DATETIME = GETDATE(),
											@Retorno INT;

									EXEC @Retorno = [dbo].[SP_InsertMovimentacaoEstoqueMateriaPrima] 38, 2, 50

									SELECT	@Retorno AS Retorno,
											DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE());

									SELECT	*
										FROM [dbo].[EstoqueMateriaPrima];

									SELECT	*
										FROM [dbo].[MovimentacaoEstoqueMateriaPrima];
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
														    ELSE @QtdMovimentada * (-1)
													    END)
			WHERE IdMateriaPrima = @IdEstoqueMateriaPrima 
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			BEGIN
				RAISERROR('N�o foi possivel atualizar o estoque do produto', 16,1);
			END
	END