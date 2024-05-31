CREATE OR ALTER TRIGGER [dbo].[TRG_GerarMovimentacaoFimProducao]
	ON [dbo].[Producao]
	FOR INSERT
	AS
	/*
		Documentação
		Arquivo Fonte..........: TRG_GerarMovimentacaoFimProducao.sql
		Objetivo...............: Gerar inserts na tabela MovimentacaoEstoqueProduto ao detectar fim da produção IdTipoMovimentacao travado em 1 para entrada de produto no estoque
		Autores................: Thays Carvalho, Adriel Alexander, Gustavo Targino
		Data...................: 23/05/2024
		Ex.....................: BEGIN TRAN
										
										SELECT Id,
											   IdTipoMovimentacao,
											   IdEstoqueProduto,
											   DataMovimentacao,
											   Quantidade
											FROM [dbo].[movimentacaoestoqueproduto]	where idestoqueproduto = 1

										SELECT *
											FROM [dbo].[AuditoriaMovimetacaoEstoqueProduto] WITH(NOLOCK);
										
										-- SELECT IdProduto,
										-- 	   QuantidadeFisica,
										-- 	   QuantidadeMinima 
										-- 	FROM [dbo].[estoqueproduto] where idproduto = 1
										
										UPDATE Producao
											SET DataTermino = GETDATE()
												WHERE Id IN(8) 

										-- UPDATE Producao
										-- 	SET DataTermino = GETDATE()
										-- 		WHERE Id IN(8)
										

										INSERT INTO Producao   ( 	IdEtapaProducao,
																	IdPedidoProduto,
																	DataInicio,
																	DataTermino,
																	Quantidade
																)
											VALUES 	(4,	28,	'2024-05-29 11:16:11.680',	'2024-05-29 11:21:36.033',	125),
													(5,	28,	'2024-05-29 11:26:16.810',	'2024-05-29 11:27:04.380',	125),
													(6,	28,	'2024-05-29 11:28:27.553', '2024-05-29 11:39:41.127',	120);
									

										SELECT Id,
											   IdTipoMovimentacao,
											   IdEstoqueProduto,
											   DataMovimentacao,
											   Quantidade
											FROM [dbo].[movimentacaoestoqueproduto]	

										SELECT *
											FROM [dbo].[AuditoriaMovimetacaoEstoqueProduto] WITH(NOLOCK);
										
										SELECT IdProduto,
											   QuantidadeFisica,
											   QuantidadeMinima 
											FROM [dbo].[estoqueproduto] 

								 ROLLBACK TRAN
	*/
	BEGIN
		DECLARE @IdMovimentacao INT,
				@IdPedido INT,
				@Erro INT,
				@Linha INT;

		CREATE TABLE #Tabela (
			IdPedidoProduto INT,
			IdProduto INT,
			Quantidade INT,
			DataTermino DATETIME
		);

		WITH EtapaMaxima AS (
			-- Capturar o valor máximo do número de etapa para o produto passado como parãmetro
			SELECT	IdProduto,
					MAX(NumeroEtapa) AS EtapaFinal
				FROM [dbo].[EtapaProducao] WITH(NOLOCK)
				GROUP BY IdProduto
		)  
		INSERT INTO #Tabela (IdPedidoProduto, IdProduto, Quantidade, DataTermino)
			--Realiza a inserção das etapas que foram finalizadas na tabela temporaria 
			SELECT  I.IdPedidoProduto,
					ep.IdProduto,
					I.Quantidade,
					i.DataTermino
				FROM INSERTED I
					INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
						ON I.IdEtapaProducao = ep.Id
					INNER JOIN EtapaMaxima em
						ON ep.IdProduto = em.IdProduto
				WHERE ep.NumeroEtapa = em.EtapaFinal 
							AND I.DataTermino IS NOT NULL;

		WHILE EXISTS	(
							SELECT	IdProduto,
									Quantidade,
									DataTermino
								FROM #Tabela
						)
			BEGIN
				INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdTipoMovimentacao, IdEstoqueProduto, 
																	DataMovimentacao, Quantidade)
					SELECT	1, --id travado em 1 = entrada para produtos que acabaram de ser produzidos
							IdProduto,
							DataTermino,
							Quantidade
						FROM #Tabela;

				SELECT 	@Erro = @@ERROR,
						@Linha = @@ROWCOUNT,
						@IdMovimentacao = SCOPE_IDENTITY(),
						@IdPedido = pp.IdPedido
					FROM #Tabela t
						INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
							ON t.IdPedidoProduto = pp.Id;


				--Validacao de erros 
				IF @Erro <> 0 OR @Linha <> 1
					BEGIN
						RAISERROR('Erro ao inserir o registro na tabela de movimentacao estoque produto', 16, 1);
						RETURN;
					END

				INSERT INTO [dbo].[AuditoriaMovimetacaoEstoqueProduto] (IdPedido, IdMovimentacaoEstoqueProduto)
					VALUES (@IdPedido, @IdMovimentacao);

				--validacao de erros 
				IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
					BEGIN
						RAISERROR('Erro ao inserir o registro na tabela de auditoria estoque produto', 16, 1);
						RETURN;
					END

				DELETE TOP (1)
					FROM #Tabela;
			END

			DROP TABLE #Tabela
		-- -- Insercao na tabela de MovimentacaoEstoqueProduto para os produtos que foram entregues 
		-- WITH EtapaMaxima AS  (
		-- 						 -- Capturar o valor máximo do número de etapa para o produto passado como parãmetro
		-- 					  SELECT    IdProduto,
		-- 								MAX(NumeroEtapa) AS EtapaFinal
		-- 							FROM [dbo].[EtapaProducao] WITH(NOLOCK)
		-- 							GROUP BY IdProduto
		-- 				     )  
		-- 	--realiza a inserção das etapas que foram finalizadas 
        -- INSERT INTO MovimentacaoEstoqueProduto(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
        --     SELECT  ep.IdProduto,
        --             1, --id travado em 1 = entrada para produtos que acabaram de ser produzidos
        --             i.DataTermino,
        --             I.Quantidade
        --         FROM INSERTED I
        --             INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
        --                 ON I.IdEtapaProducao = ep.Id
        --             INNER JOIN EtapaMaxima em
        --                 ON ep.IdProduto = em.IdProduto
		-- 			-- INNER JOIN DELETED d
		-- 			-- 	ON d.Id = i.Id
        --         WHERE ep.NumeroEtapa = em.EtapaFinal 
		-- 				  AND I.DataTermino IS NOT NULL
		-- 				--   AND d.DataTermino IS NULL 

		-- 	SELECT 	@Erro = @@ERROR,
		-- 			@IdMovimentacao = SCOPE_IDENTITY()

		-- --validacao de erros 
		-- IF @Erro <> 0
		-- 	BEGIN
		-- 		RAISERROR('Erro ao inserir o registro', 16, 1);
		-- 		RETURN;
		-- 	END
	END
