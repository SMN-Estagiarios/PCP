CREATE OR ALTER PROCEDURE [dbo].[SP_ListarEtapaProducao]
	@Id INT
	AS
	/*
	Documentacao
	Arquivo Fonte.....: EtapasProducao.sql
	Autor.............: Orcino Neto
	Objetivo..........: Listar etapas de producao do produtos de um pedido.
	Data..............: 21/05/2024
	Ex................:	BEGIN TRAN
							DBCC DROPCLEANBUFFERS; 
							DBCC FREEPROCCACHE;

							DECLARE	@Data_Inicial DATETIME = GETDATE(),
									@Retorno INT

							EXEC @Retorno = [dbo].[SP_ListarEtapaProducao] 1

							SELECT 	@Retorno AS Retorno,
									DATEDIFF(MILLISECOND, @Data_Inicial, GETDATE()) AS Tempo
						ROLLBACK TRAN
	*/
	BEGIN
		SELECT	ep.IdProduto,
				p.Nome,
				ep.Descricao,
				ep.Duracao,
				ep.NumeroEtapa
			FROM [dbo].[EtapaProducao] ep WITH(NOLOCK)
				INNER JOIN [dbo].[Produto] p WITH(NOLOCK)
					ON ep.IdProduto = p.Id
				INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
					ON pp.IdProduto = p.Id
			WHERE pp.IdPedido = @Id
	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_InserirEtapaProducao]
	@IdProduto INT,
	@Descricao VARCHAR(150),
	@Duracao SMALLINT,
	@NumEtapa TINYINT
	AS
	/*
	Documentacao
	Arquivo Fonte.....: EtapasProducao.sql
	Autor.............: Orcino Neto
	Objetivo..........: Criar etapas de producao para um produto.
	Data..............: 23/05/2024
	Ex................:	BEGIN TRAN
							SELECT * FROM
								[dbo].[EtapaProducao] WITH(NOLOCK);

							DBCC DROPCLEANBUFFERS; 
							DBCC FREEPROCCACHE;

							DECLARE	@Data_Inicial DATETIME = GETDATE(),
									@Retorno INT
							
							EXEC @Retorno = [dbo].[SP_InserirEtapaProducao] 6, "Batendo bolo", 50, 1;

							SELECT 	@Retorno AS Retorno,
									DATEDIFF(MILLISECOND, @Data_Inicial, GETDATE()) AS TempoExecucao;

							SELECT *
								FROM [dbo].[EtapaProducao] WITH(NOLOCK);
						ROLLBACK TRAN

	Retornos..........: 00 - Sucesso.
						01 - Erro, produto inexistente.
						02 - Erro, nao foi possivel inserir um registro na tabela.
	*/
	BEGIN
		--Verificacao se o produto existe
		IF NOT EXISTS	(
							SELECT TOP 1 1
								FROM [dbo].[Produto] WITH(NOLOCK)	
								WHERE Id = @IdProduto
						)
			RETURN 1;

		--Inserindo etapa de producao
		INSERT INTO [dbo].[EtapaProducao](IdProduto,Descricao,Duracao, NumeroEtapa)
			VALUES(@IdProduto,@Descricao,@Duracao,@NumEtapa)

		IF @@ROWCOUNT <> 1 OR @@ERROR <> 0
			RETURN 2;

		RETURN 0;

	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_AtualizarEtapaProducao]
	@IdProduto INT,
	@Descricao VARCHAR(150),
	@Duracao SMALLINT,
	@NumEtapaAntigo TINYINT,
	@NumEtapaNovo TINYINT
	AS
	/*
	Documentacao
	Arquivo Fonte.....: EtapasProducao.sql
	Autor.............: Orcino Neto
	Objetivo..........: Atualizar etapas de producao para um produto.
	Data..............: 23/05/2024
	Ex................:	BEGIN TRAN
							SELECT *
								FROM [dbo].[EtapaProducao] WITH(NOLOCK);
							
							DBCC DROPCLEANBUFFERS; 
							DBCC FREEPROCCACHE;

							DECLARE	@Data_Inicio DATETIME = GETDATE(),
									@Retorno INT

							EXEC @Retorno = [dbo].[SP_AtualizarEtapaProducao] 6, "Batendo bolo", 50, 1, 2;

							SELECT 	@Retorno AS Retorno, 
									DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo;
							
							SELECT *
								FROM [dbo].[EtapaProducao] WITH(NOLOCK);
						ROLLBACK TRAN
		Retornos..........: 00 - Sucesso.
							01 - Erro, produto inexistente.
							02 - Erro, nao foi possivel inserir um registro na tabela.						
	*/
	BEGIN
		-- Verificando se existe produto
		IF NOT EXISTS	(
							SELECT	TOP 1 1
								FROM [dbo].[Produto] WITH(NOLOCK)	
								WHERE @IdProduto = Id
						)
			RETURN 1;

		--Inserindo etapa de producao
		UPDATE  [dbo].[EtapaProducao]
			SET	Descricao = ISNULL(@Descricao, Descricao),
				Duracao = ISNULL(@Duracao, Duracao),
				NumeroEtapa = ISNULL(@NumEtapaNovo, NumeroEtapa)
			WHERE IdProduto = @IdProduto
				AND NumeroEtapa = @NumEtapaAntigo;

		IF @@ROWCOUNT <> 1 OR @@ERROR <> 0
			RETURN 2;

		RETURN 0;
	END
GO