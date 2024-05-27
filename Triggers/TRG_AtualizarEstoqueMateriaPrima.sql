CREATE OR ALTER TRIGGER [dbo].[TRG_AtualizarEstoqueMateriaPrima]
ON [dbo].[MovimentacaoEstoqueMateriaPrima]
FOR INSERT
	AS
	/*
		
		DOCUMENTACAO
		Arquivo Fonte........:	TRG_AtualizarEstoqueMatPrima.sql
		Objetivo.............:	Atualiza estoque da materia prima com base nas movimentacoes
		Autor................:	Adriel Alexander
		Data.................:	22/05/2024
		Autores Alteracao....:  Adriel Alexander
		Ex...................:  BEGIN TRAN
									DBCC DROPCLEANBUFFERS;
									DBCC FREEPROCCACHE;

									DECLARE @DataInicio DATETIME = GETDATE();

									SELECT 	IdMateriaPrima,
											QuantidadeFisica,
											QuantidadeMinima
									FROM [dbo].[EstoqueMateriaPrima]

									INSERT INTO [dbo].[MovimentacaoEstoqueMateriaPrima](
																							idTipoMovimentacao,
																							IdEstoqueMateriaPrima,
																							DataMovimentacao,
																							Quantidade
																					   )
										VALUES (3 , 1, GETDATE(), 20000)

									SELECT DATEDIFF(MILLISECOND, @DataInicio,GETDATE()) AS TempoExecucao

									SELECT 	IdMateriaPrima,
											QuantidadeFisica,
											QuantidadeMinima
										FROM [dbo].[EstoqueMateriaPrima]

								ROLLBACK TRAN					
	*/
	BEGIN
		--realiza atualizacao do estoque fisico mediante as movimentacoes do estoque 
		UPDATE emp
			SET QuantidadeFisica = QuantidadeFisica + (CASE WHEN i.idTipoMovimentacao  = 1  
															THEN i.Quantidade 
															ELSE i.Quantidade * (-1)
														END)
			FROM [dbo].[EstoqueMateriaPrima] emp
				INNER JOIN inserted i 
					ON i.IdEstoqueMateriaPrima = emp.IdMateriaPrima

			--Verificacao de erros
		IF @@ERROR <> 0 
			BEGIN
				RAISERROR('Não foi possivel atualizar o estoque da materia prima', 16,1);
			END
	END