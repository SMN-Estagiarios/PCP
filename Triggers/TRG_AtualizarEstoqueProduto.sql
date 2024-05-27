CREATE OR ALTER TRIGGER [dbo].[TRG_AtualizarEstoqueProduto]
ON [dbo].[MovimentacaoEstoqueProduto]
FOR INSERT 
	AS
	/*
		DOCUMENTACAO
		Arquivo Fonte........:	TRG_AtualizarEstoqueProduto.sql
		Objetivo.............:	Atualiza quantidade fisica do estoque de produto apos insert gerado na tabela MovimentacaoEstoqueProduto, que pode ocorrer quando um pedido e entregue
								ou quando ocorre a finalizacao de todas as etapas de producao para a composicao de um produto
								@IdTipoMovimentacao travado em 1 para entregue e os ids acima de um representam saida ou perca 
		Autor................:	Adriel Alexander
		Data.................:	22/05/2024
		Autores Alteracao....:  Adriel Alexander
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
										FROM [dbo].[estoqueprodutoduto] 

									INSERT INTO [dbo].[MovimentacaoEstoqueProduto](
																							IdTipoMovimentacao,
																							IdEstoqueProduto,
																							DataMovimentacao,
																							Quantidade
																					   )
										VALUES (2 , 1, GETDATE(), 100 )

									SELECT DATEDIFF(MILLISECOND, @DATA_INI,GETDATE()) AS TempoExecucao

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
		
		--realiza atualização do estoque físico mediante as movimentações do estoque 
		UPDATE [dbo].[EstoqueProduto]
			SET QuantidadeFisica = QuantidadeFisica + (CASE WHEN i.idTipoMovimentacao  = 1  
															THEN i.Quantidade 
														    ELSE i.Quantidade * (-1)
													    END)
			FROM [dbo].[EstoqueProduto] ep
				INNER JOIN inserted i 
					ON i.IdEstoqueProduto = ep.IdProduto
		IF @@ERROR <> 0 
			BEGIN
				RAISERROR('Não foi possivel atualizar o estoque do produto', 16,1);
			END
	END