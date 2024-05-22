CREATE OR ALTER PROCEDURE [dbo].[AtualizarEstoqueProduto]
	@IdProduto INT,
	@QuantidadeFisica INT, 
	@QuantidadeMinima INT, 
	@QuantidadeVirtual INT

AS
	/*
		Documentacao
		Arquivo Fonte.....: EstoqueProduto.sql
		Objetivo..........: Inserir um registro de estoque de produto
		Autor.............: Rafael Mauricio
		Data..............: 21/05/2024
		Ex................: BEGIN TRAN
								SELECT *
									FROM [dbo].[EstoqueProduto] WITH(NOLOCK)

								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')
								DBCC DROPCLEANBUFFERS

								DECLARE @Data_Inicio DATETIME = GETDATE(),
										@Retorno INT;

								EXEC @Retorno = [dbo].[AtualizarEstoqueProduto] 2, 200, 250, 50
									
								SELECT	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo;

								SELECT *
									FROM [dbo].[EstoqueProduto] WITH(NOLOCK) 
							ROLLBACK TRAN
							
	*/

	BEGIN
		UPDATE [dbo].[EstoqueProduto]
			SET QuantidadeFisica = @QuantidadeFisica, QuantidadeMinima = @QuantidadeMinima, QuantidadeVirtual = @QuantidadeVirtual
				WHERE IdProduto = @IdProduto
	END