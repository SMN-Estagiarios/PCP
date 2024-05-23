CREATE OR ALTER PROCEDURE [dbo].[SP_AtualizarEstoqueProduto]
	@IdProduto INT,
	@QuantidadeFisica INT, 
	@QuantidadeMinima INT
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

								EXEC @Retorno = [dbo].[SP_AtualizarEstoqueProduto] 2, 200, 250
									
								SELECT	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo;

								SELECT *
									FROM [dbo].[EstoqueProduto] WITH(NOLOCK) 
							ROLLBACK TRAN
							
	*/

	BEGIN
		UPDATE [dbo].[EstoqueProduto]
			SET QuantidadeFisica = ISNULL(@QuantidadeFisica, QuantidadeFisica),
				QuantidadeMinima = ISNULL(@QuantidadeMinima, QuantidadeMinima)
			WHERE IdProduto = @IdProduto;
	END