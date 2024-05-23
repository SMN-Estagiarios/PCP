CREATE OR ALTER PROCEDURE [dbo].[SP_ListarEtapaProducao]
	@Id INT
	AS
	/*
	Documentação
	Arquivo Fonte..: EtapasProducao.sql
	Autor..............: Orcino Neto
	Objetivo..........: Listar etapas de produção do produtos de um pedido.
	Data...............: 21/05/2024
	Ex..................:	
							BEGIN TRAN
								DBCC DROPCLEANBUFFERS; 
								DBCC FREEPROCCACHE;
	
								DECLARE	@Dat_init DATETIME = GETDATE(),
												@RET INT

								EXEC @RET = [dbo].[SP_ListarEtapaProducao] 1
	
								SELECT @RET AS RETORNO
	
								SELECT DATEDIFF(MILLISECOND, @Dat_init, GETDATE()) AS TempoExecucao
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
			WHERE @Id = pp.IdPedido

	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_CriarEtapaProducao]
	@IdProduto INT,
	@Descricao VARCHAR(150),
	@Duracao SMALLINT,
	@NumEtapa TINYINT
	AS
	/*
	Documentação
	Arquivo Fonte..: EtapasProducao.sql
	Autor..............: Orcino Neto
	Objetivo..........: Criar etapas de produção para um produto.
	Data...............: 23/05/2024
	Ex..................:	
							BEGIN TRAN
								DBCC DROPCLEANBUFFERS; 
								DBCC FREEPROCCACHE;
	
								DECLARE	@Dat_init DATETIME = GETDATE(),
												@RET INT
								SELECT * FROM [dbo].[EtapaProducao]
								
								EXEC @RET = [dbo].[SP_CriarEtapaProducao] 6, "Batendo bolo", 50,1
								
								SELECT * FROM [dbo].[EtapaProducao]
								SELECT @RET AS RETORNO
	
								SELECT DATEDIFF(MILLISECOND, @Dat_init, GETDATE()) AS TempoExecucao
							ROLLBACK TRAN
	*/
	BEGIN
		--Verificação se existe produto
		IF EXISTS	(
							SELECT	TOP 1 1
								FROM [dbo].[Produto] WITH(NOLOCK)	
								WHERE @IdProduto = Id
						)
			--Inserindo etapa de produção
			INSERT INTO [dbo].[EtapaProducao](IdProduto,Descricao,Duracao, NumeroEtapa)
				VALUES(@IdProduto,@Descricao,@Duracao,@NumEtapa)

		IF @@ROWCOUNT = 0
			RETURN 1
		RETURN 0

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
	Documentação
	Arquivo Fonte..: EtapasProducao.sql
	Autor..............: Orcino Neto
	Objetivo..........: Atualizar etapas de produção para um produto.
	Data...............: 23/05/2024
	Ex..................:	
							BEGIN TRAN
								DBCC DROPCLEANBUFFERS; 
								DBCC FREEPROCCACHE;
	
								DECLARE	@Dat_init DATETIME = GETDATE(),
												@RET INT
								SELECT * FROM [dbo].[EtapaProducao]
								
								EXEC @RET = [dbo].[SP_AtualizarEtapaProducao] 6, "Batendo bolo", 50,1,2
								
								SELECT * FROM [dbo].[EtapaProducao]
								SELECT @RET AS RETORNO
	
								SELECT DATEDIFF(MILLISECOND, @Dat_init, GETDATE()) AS TempoExecucao
							ROLLBACK TRAN
	*/
	BEGIN
		--Verificação se existe produto
		IF EXISTS	(
							SELECT	TOP 1 1
								FROM [dbo].[Produto] WITH(NOLOCK)	
								WHERE @IdProduto = Id
						)

			--Inserindo etapa de produção
			UPDATE  [dbo].[EtapaProducao]
				SET	Descricao = @Descricao,
						Duracao = @Duracao,
						NumeroEtapa = @NumEtapaNovo
				WHERE IdProduto = @IdProduto AND NumeroEtapa = @NumEtapaAntigo

		IF @@ROWCOUNT = 0
			RETURN 1
		RETURN 0

	END
GO