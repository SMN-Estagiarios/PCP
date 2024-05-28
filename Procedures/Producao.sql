CREATE OR ALTER PROCEDURE [dbo].[SP_IniciarProducaoDeEtapa]		
	@QuantidadeProducao INT = NULL,
	@IdEtapaProducao INT = NULL,
	@IdPedidoProduto INT = NULL
	AS
	/*
		Documentacao
			Arquivo fonte........: 	Producao.sql
			Objetivo.............: 	Inserir novo registro em Producao marcando inicio de nova etapa de producao
			Autor................: 	Gabriel Damiani Puccinelli
			Data.................: 	23/05/2024
			Ex...................:	BEGIN TRAN
										SELECT	*
											FROM Producao WITH(NOLOCK)

										DBCC DROPCLEANBUFFERS
										DBCC FREEPROCCACHE

										DECLARE	@Retorno INT,
												@DataInicio DATETIME = GETDATE()
										
										EXEC @Retorno = [dbo].[SP_IniciarProducaoDeEtapa] 5, 8
										
										SELECT 	@Retorno AS Retorno,
												DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

										SELECT	*
											FROM Producao WITH(NOLOCK)

									SELECT *
										FROM MovimentacaoEstoqueMateriaPrima WITH(NOLOCK)
									ROLLBACK TRAN

			Retornos.............:	00 - Sucesso.
									01 - Erro, etapada de producao inexistente.
									02 - Erro, pedido produto inexistente.
									03 - Erro, a etapa passada como parametro nao e equivalente as do produto.
									04 - Erro, nao foi possivel fazer o resgistro na tabela.
									05 - Ja existe produtos suficientes para atender ao pedido.
	*/
	BEGIN
		-- DECLARANDO VARIAVEIS NECESSARIAS
		DECLARE @IdProduto INT,
				@Quantidade INT = NULL,
				@QuantidadeMinima INT,
				@QuantidadeEstoqueReal INT;

		-- VERIFICANDO SE EXISTE A ETAPA DE PRODUCAO QUE FOI PASSADA COMO PARAMETRO
		IF NOT EXISTS	(
							SELECT TOP 1 1
								FROM [dbo].[EtapaProducao] WITH(NOLOCK)
								WHERE Id = @IdEtapaProducao
					 	)
			RETURN 1;

		-- VERIFICANDO SE EXISTE O PEDIDO PRODUTO QUE FOI PASSADO COMO PARAMETRO
		IF NOT EXISTS	(
							SELECT TOP 1 1
								FROM [dbo].[PedidoProduto] WITH(NOLOCK)
								WHERE Id = @IdPedidoProduto
					 	)
			RETURN 2;

		-- SETANDO VALOR PARA A VARIAVEL DE IdPedidoProduto
		SELECT	@IdProduto = IdProduto
			FROM [dbo].[PedidoProduto] WITH(NOLOCK)
			WHERE Id = @IdPedidoProduto;

		IF	( 
				SELECT ep.NumeroEtapa
					FROM EtapaProducao ep WITH(NOLOCK)
					WHERE ep.Id = @IdEtapaProducao 
			) = 1
				BEGIN
					-- SETANDO VALOR PARA A VARIAVEL DE QuantidadeMinima
					SELECT @QuantidadeMinima = QuantidadeMinima
							FROM [dbo].[EstoqueProduto] WITH(NOLOCK)
							WHERE IdProduto = @IdProduto;

					-- SETANDO VALOR PARA A VARIAVEL DE QuantidadeEstoqueReal
					SET @QuantidadeEstoqueReal = [dbo].[FNC_CalcularEstoqueReal](@IdProduto);

					-- VERIFICANDO SE E NECESSARIO PRODUZIR O PRODUTO
					IF  @QuantidadeEstoqueReal >= @QuantidadeMinima
						RETURN 5;

					-- VERIFICANDO SE O ESTOQUE REAL E NEGATIVO
					IF @QuantidadeEstoqueReal < 0
						SET @Quantidade = @QuantidadeMinima + ABS(@QuantidadeEstoqueReal);
					ELSE
						SET @Quantidade = @QuantidadeMinima - @QuantidadeEstoqueReal;
				END

		-- VERIFICANDO SE A ETAPA PASSADA E DO PRODUTO
		IF @IdEtapaProducao NOT IN 	(
										SELECT Id
											FROM [dbo].[EtapaProducao] WITH(NOLOCK)
											WHERE IdProduto = @IdProduto
									)
			RETURN 3;

		--INSERE NOVO REGISTRO EM PRODUCAO
		INSERT INTO [dbo].[Producao] (IdEtapaProducao, IdPedidoProduto, DataInicio, Quantidade)
			VALUES (@IdEtapaProducao, @IdPedidoProduto, GETDATE(), ISNULL(@Quantidade, @QuantidadeProducao));

		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			RETURN 4;

		RETURN 0;
	END
GO



CREATE OR ALTER PROCEDURE [dbo].[SP_EncerrarProducaoDeEtapa]
	@IdProducao INT = NULL,
	@Quantidade INT = NULL
	AS
	/*
		Documentacao
			Arquivo fonte........: Producao.sql
			Objetivo.............: Aplicar data de termino no registro em Producao marcando termino de etapa de producao e 
								   marcar quantidade produzida no termino da etapa.
			Autor................: Gabriel Damiani Puccinelli
			Data.................: 23/05/2024
			Ex...................:	BEGIN TRAN
										SELECT	ep.Duracao,
												pd.DataInicio,
												pd.DataTermino,
												pd.Quantidade
											FROM Producao pd WITH(NOLOCK)
												INNER JOIN EtapaProducao ep WITH(NOLOCK)
													ON ep.Id = pd.IdEtapaProducao

										DBCC DROPCLEANBUFFERS
										DBCC FREEPROCCACHE

										DECLARE	@Retorno INT,
												@DataInicio DATETIME = GETDATE()

										EXEC @Retorno = [dbo].[SP_EncerrarProducaoDeEtapa] 12, NULL
	
										SELECT * FROM Producao

										SELECT 	@Retorno AS Retorno,
												DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

										SELECT	ep.Duracao,
												pd.DataInicio,
												pd.DataTermino,
												pd.Quantidade
											FROM Producao pd WITH(NOLOCK)
												INNER JOIN EtapaProducao ep WITH(NOLOCK)
													ON ep.Id = pd.IdEtapaProducao
									ROLLBACK TRAN

			Retornos.............:	00 - Sucesso.
									01 - Erro, a producao nao existe.
									02 - Erro, nao ha tempo habil para ter finalizado.
									03 - Erro, nenhum registro foi atualizado.
	*/
	BEGIN
		--DECLARA VARIAVEIS
		DECLARE @DataAtual DATETIME = GETDATE(),
				@DataInicioProducao DATETIME,
				@TempoProducao INT;

		--VERIFICANDO SE A PRODUCAO PASSADA COMO PARAMETRO EXISTE
		IF NOT EXISTS	(
							SELECT TOP 1 1
								FROM [dbo].[Producao] WITH(NOLOCK)
								WHERE Id = @IdProducao
					 	)
			RETURN 1;

		--ATRIBUI VALOR DE DURACAO DA ETAPA DE PRODUCAO A TEMPO EXECUCAO
		SELECT	@TempoProducao = ep.Duracao,
				@DataInicioProducao = pd.DataInicio
			FROM [dbo].[Producao] pd WITH(NOLOCK)
				INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
					ON ep.Id = pd.IdEtapaProducao
			WHERE pd.Id = @IdProducao

		--VERIFICA SE HOUVE TEMPO HABIL PARA TERMINAR A PRODUCAO
		IF (DATEDIFF(MINUTE, @DataInicioProducao, @DataAtual) < @TempoProducao)
			RETURN 2;

		--INSERE NOVO REGISTRO EM PRODUCAO
		UPDATE [dbo].[Producao]
			SET	DataTermino = @DataAtual,
				Quantidade = ISNULL(@Quantidade, Quantidade)
			WHERE Id = @IdProducao;

		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			RETURN 3;

		RETURN 0
	END
GO