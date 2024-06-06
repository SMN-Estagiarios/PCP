CREATE OR ALTER TRIGGER [dbo].[TRG_GerarMovimentacaoFimProducao]
	ON [dbo].[Producao]
	FOR UPDATE
	AS
	/*
		Documentação
		Arquivo Fonte.....: TRG_GerarMovimentacaoFimProducao.sql
		Objetivo..........: Gerar inserts na tabela MovimentacaoEstoqueProduto ao detectar fim da produção IdTipoMovimentacao
								travado em 1 para entrada de produto no estoque
		Autores...........: Thays Carvalho, Adriel Alexander, Gustavo Targino
		Data..............: 23/05/2024
		Autores Alteracao.: Odlavir, Adriel 
		Data Alteracao....:	03/06/2024
		Ex................: BEGIN TRAN
								SELECT TOP 1 *
									FROM [dbo].[MovimentacaoEstoqueProduto]
									ORDER BY Id DESC;	
								
								SELECT *
									FROM [dbo].[EstoqueProduto]
									WHERE IdProduto = 29;

								SELECT TOP 1  *
									FROM [dbo].[AuditoriaMovimetacaoEntradaEstoqueProduto]
									ORDER BY IdMovimentacaoEstoqueProduto DESC

								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')
								DBCC DROPCLEANBUFFERS

								DECLARE @DataInicio DATETIME = GETDATE();
								
								UPDATE [dbo].[Producao]
									SET DataTermino = GETDATE()
										WHERE Id = 104901

								SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao;

								SELECT TOP 1 *
									FROM [dbo].[MovimentacaoEstoqueProduto]
									ORDER BY Id DESC;
								
								SELECT *
									FROM [dbo].[EstoqueProduto]
									WHERE IdProduto = 29;

								SELECT TOP 1 *
									FROM [dbo].[AuditoriaMovimetacaoEntradaEstoqueProduto]
									ORDER BY IdMovimentacaoEstoqueProduto DESC
							ROLLBACK TRAN
	*/
	BEGIN
		-- Criando variaveis necessarias.
		DECLARE @IdProducao INT,
				@IdMovimentacao INT,
				@DataMovimentacao DATETIME,
				@IdProduto INT,
				@Quantidade INT;

		-- Criando tabela temporaria.
		CREATE TABLE #Tabela (
			IdPedidoProduto INT,
			IdProducao INT,
			Quantidade INT,
			DataMovimentacao DATETIME
		);

		WITH EtapaMaxima AS	(
			-- Capturar o valor máximo do número de etapa para o produto passado como parametro.
			SELECT	IdProduto,
					MAX(NumeroEtapa) AS EtapaFinal
				FROM [dbo].[EtapaProducao] WITH(NOLOCK)
				GROUP BY IdProduto
		)  
		-- Realiza a inserção das etapas que foram finalizadas 
        INSERT INTO [#Tabela](IdPedidoProduto, IdProducao, Quantidade, DataMovimentacao)
            SELECT  i.IdPedidoProduto,
					i.Id,
					i.Quantidade,
					i.DataTermino
                FROM inserted i
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        ON i.IdEtapaProducao = ep.Id
                    INNER JOIN EtapaMaxima em
                        ON ep.IdProduto = em.IdProduto
					INNER JOIN DELETED d
						ON d.Id = i.Id
                WHERE ep.NumeroEtapa = em.EtapaFinal 
					AND i.DataTermino IS NOT NULL
					AND d.DataTermino IS NULL

		-- Loop para inserir registros
		WHILE EXISTS	(
							SELECT TOP 1 1
								FROM #Tabela
						)
			BEGIN

				-- Atribuindo os valores as variaveis
				SELECT TOP 1	@IdProduto = pp.IdProduto,
								@DataMovimentacao = t.DataMovimentacao,
								@Quantidade = t.Quantidade,
								@IdProducao = t.IdProducao
					FROM #Tabela t
						INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
							ON t.IdPedidoProduto = pp.Id;

				-- Inserindo registro na tabela de movimentacao estoque produto.
				EXEC [dbo].[SP_InserirMovimentacaoEstoqueProduto] @IdProduto, '1', @DataMovimentacao, @Quantidade;

				-- Capturando o ultimo id gerado na tabela de movimentacao estoque produto.
				SET @IdMovimentacao = IDENT_CURRENT('MovimentacaoEstoqueProduto')

				-- Inserindo registro na tabela de auditoria.
				INSERT INTO [dbo].[AuditoriaMovimetacaoEntradaEstoqueProduto] (IdProducao, IdMovimentacaoEstoqueProduto)
					VALUES (@IdProducao, @IdMovimentacao);

				IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
					BEGIN
						ROLLBACK;
						RAISERROR('Erro ao inserir o registro na tabela de auditoria estoque produto.', 16, 1);
						RETURN;
					END

				-- Deletando o primeiro registro da tabela temporaria.
				DELETE TOP (1)
					FROM #Tabela;
			END

		-- Dropando tabela temporaria.
		DROP TABLE #Tabela;
	END
