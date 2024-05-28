CREATE OR ALTER PROCEDURE [dbo].[SP_IniciarProducaoDeEtapa]		
	@Quantidade SMALLINT,
	@IdEtapaProducao INT,
	@IdPedidoProduto INT = NULL
	AS
	/*
		Documentacao
			Arquivo fonte........: Producao.sql
			Objetivo.............: Inserir novo registro em Producao marcando inicio de nova etapa de producao
			Autor................: Gabriel Damiani Puccinelli
			Data.................: 23/05/2024
			Ex...................:	BEGIN TRAN
										SELECT	IdEtapaProducao,
												IdPedidoProduto,
												DataInicio,
												DataTermino,
												Quantidade
											FROM Producao WITH(NOLOCK)

										DBCC DROPCLEANBUFFERS
										DBCC FREEPROCCACHE

										DECLARE	@Retorno INT,
												@DataInicio DATETIME = GETDATE()

										EXEC @Retorno = [dbo].[SP_IniciarProducaoDeEtapa] 500, 1

										SELECT 	@Retorno AS Retorno,
												DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

										SELECT	IdEtapaProducao,
												IdPedidoProduto,
												DataInicio,
												DataTermino,
												Quantidade
											FROM Producao WITH(NOLOCK)
									ROLLBACK TRAN

			Retornos.............:	00 - Sucesso.
									01 - Erro, a quantidade nao foi passada como parametro.
									02 - Erro, etapada de producao inexistente.
									03 - Erro, nao foi possivel fazer o resgistro na tabela.
	*/
	BEGIN
		-- VERIFICANDO SE A QUANTIDADE FOI PASSADA COMO PARAMETRO
		IF @Quantidade IS NULL
			RETURN 1;

		-- VERIFICANDO SE EXISTE A ETAPA DE PRODUCAO QUE FOI PASSADA COMO PARAMETRO
		IF NOT EXISTS(
						SELECT TOP 1 1
							FROM [dbo].[EtapaProducao] WITH(NOLOCK)
							WHERE Id = @IdEtapaProducao
					 )
			RETURN 2;

		--INSERE NOVO REGISTRO EM PRODUCAO
		INSERT INTO [dbo].[Producao] (IdEtapaProducao, IdPedidoProduto, DataInicio, Quantidade)
			VALUES (@IdEtapaProducao, @IdPedidoProduto, GETDATE(), @Quantidade);

		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
			RETURN 3;

		RETURN 0;
	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_EncerrarProducaoDeEtapa]
	@IdProducao INT = NULL,
	@Quantidade SMALLINT = NULL
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

										EXEC @Retorno = [dbo].[SP_EncerrarProducaoDeEtapa] 2, 500

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
		IF NOT EXISTS(
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