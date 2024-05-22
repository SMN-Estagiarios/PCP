CREATE OR ALTER TRIGGER [dbo].[TRG_SubtrairDoEstoqueMateriaPrima]
	ON [dbo].[PedidoProduto]
	AFTER INSERT
	AS
	/*
		Documentacao
		Arquivo Fonte.....: TRG_SubtrairDoEstoqueMateriaPrima.sql
		Objetivo..........: Subtrair materia prima do estoque sempre que um produto aparecer na tabela PedidoProduto
		Autor.............: Odlavir Florentino
		Data..............: 22/05/2024
		Ex................: BEGIN TRAN
									SELECT * FROM [dbo].[PedidoProduto]
									select * from MovimentacaoEstoqueMateriaPrima
									SELECT * from EstoqueMateriaPrima

									INSERT INTO PedidoProduto 
										VALUES  (3,)
									

										

							ROLLBACK TRAN
	*/
	BEGIN
		DECLARE @IdProdutoInserted INT,
				@QuantidadeInserted INT,
				@VerificarQuantidadeProdutoEstoque BIT,
				@IdMateriaPrima INT,
				@Quantidade INT,
				@QuantidadeEstoqueMateriaPrima INT,
				@QuantidadePedido INT,
				@QuantidadeSaida INT;

		SELECT	@IdProdutoInserted = IdProduto,
				@QuantidadeInserted = Quantidade
			FROM inserted

		SET @VerificarQuantidadeProdutoEstoque = [dbo].[FNC_ChecagemEstoqueProduto](@IdProdutoInserted, @QuantidadeInserted) 

		IF @VerificarQuantidadeProdutoEstoque = 1
			BEGIN
					
				SELECT	IIF((ep.QuantidadeFisica - @Quantidade) < ep.QuantidadeMinima , 1, 0)
					FROM [dbo].[Produto] AS p WITH(NOLOCK)
						INNER JOIN [dbo].[EstoqueProduto] AS ep WITH(NOLOCK)
							ON p.Id = ep.IdProduto
					WHERE p.Id = @IdProdutoInserted
					

			END

		CREATE TABLE #Tabela	(
									IdProduto INT,
									IdMateriaPrima INT,
									Quantidade INT
								);

		INSERT INTO #Tabela	(IdProduto,IdMateriaPrima, Quantidade)
			SELECT	IdProduto,
					IdMateriaPrima,
					Quantidade
				FROM [dbo].[Composicao] WITH(NOLOCK)
				WHERE IdProduto = @IdProdutoInserted

		WHILE EXISTS	(
							SELECT IdProduto,
									IdMateriaPrima,
									Quantidade
								FROM #Tabela
						)
			BEGIN
				SELECT TOP 1
							@IdMateriaPrima = IdMateriaPrima,
							@Quantidade = Quantidade
					FROM #Tabela

				SET @Quantidade *= @QuantidadeInserted;

				SELECT	@QuantidadeEstoqueMateriaPrima = QuantidadeFisica - QuantidadeMinima 
					FROM [dbo].[EstoqueMateriaPrima] WITH(NOLOCK)
					WHERE IdMateriaPrima = @IdMateriaPrima;

				IF @Quantidade > @QuantidadeEstoqueMateriaPrima
					BEGIN
						SET @QuantidadePedido = @Quantidade - @QuantidadeEstoqueMateriaPrima;

						EXEC [dbo].[SP_InsertMovimentacaoEstoqueMateriaPrima] @IdMateriaPrima, 1, @QuantidadePedido;
					END

				SET @QuantidadeSaida = @Quantidade - @QuantidadeEstoqueMateriaPrima;

				EXEC [dbo].[SP_InsertMovimentacaoEstoqueMateriaPrima] @IdMateriaPrima, 2, @QuantidadeSaida;

				DELETE FROM #Tabela
					WHERE IdMateriaPrima =	(
												SELECT TOP 1 IdMateriaPrima
													FROM #Tabela
											)

				SET @IdMateriaPrima = 0
				SET @Quantidade = 0
				SET @QuantidadeEstoqueMateriaPrima = 0
				SET @QuantidadePedido = 0;
				SET @QuantidadeSaida = 0
			END
		DROP TABLE #Tabela;
	END



