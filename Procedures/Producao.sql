CREATE OR ALTER PROCEDURE [dbo].[SP_IniciarProducao]	@Quantidade SMALLINT,
														@IdEtapaProducao INT,
														@IdPedidoProduto INT

	AS
	/*
		Documentação
			Arquivo fonte........: Producao.sql
			Objetivo.............: Inserir novo registro em Producao marcando inicio de nova etapa de producao
			Autor................: Gabriel Damiani Puccinelli
			Data.................: 23/05/2024
			Ex...................:	BEGIN TRAN

										SELECT	*
											FROM Producao WITH(NOLOCK)

										DBCC DROPCLEANBUFFERS
										DBCC FREEPROCCACHE

										DECLARE	@Ret INT,
												@DataInicio DATETIME = GETDATE()

										EXEC @Ret = [dbo].[SP_IniciarProducao] 500, 1, 2

										SELECT @Ret AS Retorno, DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

										SELECT	*
											FROM Producao WITH(NOLOCK)

									ROLLBACK TRAN
	*/
	BEGIN
		--INSERE NOVO REGISTRO EM PRODUCAO
		INSERT INTO [dbo].[Producao] (IdEtapaProducao, IdPedidoProduto, DataInicio, Quantidade)
			VALUES (@IdEtapaProducao, @IdPedidoProduto, GETDATE(), @Quantidade)
	END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_EncerrarProducao]	@IdProducao INT

	AS
	/*
		Documentação
			Arquivo fonte........: Producao.sql
			Objetivo.............: Aplicar data de término no registro em Producao marcando termino de etapa de producao
			Autor................: Gabriel Damiani Puccinelli
			Data.................: 23/05/2024
			Ex...................:	BEGIN TRAN

										SELECT	ep.Duracao,
												pd.DataInicio,
												pd.DataTermino
											FROM Producao pd WITH(NOLOCK)
												INNER JOIN EtapaProducao ep WITH(NOLOCK)
													ON ep.Id = pd.IdEtapaProducao

										DBCC DROPCLEANBUFFERS
										DBCC FREEPROCCACHE

										DECLARE	@Ret INT,
												@DataInicio DATETIME = GETDATE()

										EXEC @Ret = [dbo].[SP_EncerrarProducao] 2

										SELECT @Ret AS Retorno, DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

										SELECT	ep.Duracao,
												pd.DataInicio,
												pd.DataTermino
											FROM Producao pd WITH(NOLOCK)
												INNER JOIN EtapaProducao ep WITH(NOLOCK)
													ON ep.Id = pd.IdEtapaProducao

									ROLLBACK TRAN
	*/
	BEGIN
		--DECLARA VARIAVEIS
		DECLARE @DataAtual DATETIME = GETDATE(),
				@DataInicioProducao DATETIME,
				@TempoProducao INT

		--ATRIBUI VALOR DE DURACAO DA ETAPA DE PRODUCAO A TEMPOEXECUCAO
		SELECT	@TempoProducao = Duracao,
				@DataInicioProducao = DataInicio
			FROM Producao pd
				INNER JOIN EtapaProducao ep
					ON ep.Id = pd.IdEtapaProducao
			WHERE pd.Id = @IdProducao

		--VERIFICA SE HOUVE TEMPO HÁBIL PARA TERMINAR A PRODUCAO
		IF (DATEDIFF(MINUTE, @DataInicioProducao, @DataAtual) < @TempoProducao)
			RETURN 1

		--INSERE NOVO REGISTRO EM PRODUCAO
		UPDATE Producao
			SET DataTermino = @DataAtual
			WHERE Id = @IdProducao

		RETURN 0
	END
GO
