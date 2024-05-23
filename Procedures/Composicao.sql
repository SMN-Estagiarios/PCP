CREATE OR ALTER PROCEDURE [dbo].[SP_InserirNovaComposicao]
	@IdProduto INT,
	@IdMateriaPrima INT,
	@Quantidade INT
	AS
	/*
	Documentacao
	Arquivo fonte............:	Composicao.sql
	Objetivo.................:	Inserir uma composicao do produto
	Autor....................:	Danyel Targino
	Data.....................:	21/05/2024
	Ex.......................:	BEGIN TRAN
									DBCC DROPCLEANBUFFERS;
									DBCC FREEPROCCACHE;

									DECLARE	@Retorno INT,
											@DataInicio DATETIME = GETDATE()

									SELECT	IdProduto,
											IdMateriaPrima,
											Quantidade
										FROM [dbo].[Composicao]

									EXEC @Retorno = [dbo].[SP_InserirNovaComposicao] 2, 12, 10

									SELECT	@Retorno AS Retorno,
											DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

									SELECT	IdProduto,
											IdMateriaPrima,
											Quantidade
										FROM [dbo].[Composicao]

								ROLLBACK TRAN
	
	Retornos.................:	
								0 - Sucesso
								1 - Erro ao inserir a composicao do Produto
								2 - Erro Materia-Prima não existe
								3 - Erro Produto não existe
	*/
	BEGIN
		-- Verificar se produto existe
		IF NOT EXISTS	(
						SELECT TOP 1 1
							FROM [dbo].[Produto] p WITH (NOLOCK)
							WHERE p.Id = @IdProduto
					)
			RETURN 3

		-- Verificar se materia-prima existe
		IF NOT EXISTS	(
						SELECT TOP 1 1
							FROM [dbo].[MateriaPrima] mp WITH (NOLOCK)
							WHERE mp.Id = @IdMateriaPrima
					)
			RETURN 2
			
		-- Inserir uma nova Composicao do produto
		INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
			VALUES	(@IdProduto, @IdMateriaPrima, @Quantidade)
		
		IF @@ROWCOUNT = 1
			RETURN 0
		ELSE
			RETURN 1;

	END
GO

------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE [dbo].[SP_ListarComposicao]
	@IdProduto INT = NULL
	AS
	/*
	Documentacao
	Arquivo fonte............:	Composicao.sql
	Objetivo.................:	Listar a composicao do produto
	Autor....................:	Danyel Targino
	Data.....................:	21/05/2024
	Ex.......................:	BEGIN TRAN
									DBCC DROPCLEANBUFFERS;
									DBCC FREEPROCCACHE;

									DECLARE	@Retorno INT,
											@DataInicio DATETIME = GETDATE()
									
									EXEC @Retorno = [dbo].[SP_ListarComposicao] 1
									
									SELECT	@Retorno AS Retorno,
											DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

								ROLLBACK TRAN
	
	Retornos.................:	
								0 - Sucesso
								1 - Erro Materia-Prima não existe
								2 - Erro Produto não existe
	*/
	BEGIN
		-- Declarando variavel
		DECLARE @IdMateriaPrima INT = NULL

		-- Verificar se produto existe
		IF NOT EXISTS	(
							SELECT @IdProduto 
								FROM [dbo].[Produto] p WITH (NOLOCK)
								WHERE @IdProduto = p.Id
						)
			RETURN 2

		-- Verificar se materia-prima existe
		IF EXISTS	(
							SELECT @IdMateriaPrima
								FROM [dbo].[MateriaPrima] mp WITH (NOLOCK)
								WHERE @IdMateriaPrima = mp.Id
						)
			RETURN 1
			
		-- Informacoes da Composicao
		SELECT	IdProduto,
				IdMateriaPrima,
				Quantidade
			FROM [dbo].[Composicao] WITH (NOLOCK)
			WHERE IdProduto = ISNULL(@IdProduto, IdProduto);

		RETURN 0;
	END
GO