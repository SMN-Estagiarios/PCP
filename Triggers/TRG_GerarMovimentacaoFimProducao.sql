CREATE OR ALTER TRIGGER [dbo].[TRG_GerarMovimentacaoFimProducao]
	ON [dbo].[Producao]
	FOR UPDATE
	AS
	/*
		Documentação
		Arquivo Fonte..........: TRG_GerarMovimentacaoFimProducao.sql
		Objetivo...............: Gerar inserts na tabela MovimentacaoEstoqueProduto ao detectar fim da produção IdTipoMovimentacao travado em 1 para entrada de produto no estoque
		Autores................: Thays Carvalho, Adriel Alexander, Gustavo Targino
		Data...................: 23/05/2024
		Ex.....................: BEGIN TRAN
										DBCC DROPCLEANBUFFERS;
										DBCC FREEPROCCACHE;

									    SELECT TOP 5 Id,
													 IdTipoMovimentacao,
													 IdEstoqueProduto,
													 DataMovimentacao,
													 Quantidade
												FROM [dbo].[movimentacaoestoqueproduto]	WITH(NOLOCK)
												ORDER BY Id DESC 

									   SELECT TOP 5	IdEtapaProducao,
													IdPedidoProduto,
													DataInicio,
													DataTermino,
													Quantidade
											FROM [dbo].[Producao] WITH(NOLOCK)
											ORDER BY DataTermino DESC 
							
										UPDATE Producao
												SET DataTermino = GETDATE()
													WHERE id = (
																	SELECT MAX(p.id)
																		FROM [dbo].[Producao] p
																			INNER JOIN PedidoProduto pp
																				ON p.IdPedidoProduto = pp.Id
																		WHERE pp.idPedido = 37 
														        )
								
										SELECT		 Id,
													 IdTipoMovimentacao,
													 IdEstoqueProduto,
													 DataMovimentacao,
													 Quantidade
												FROM [dbo].[movimentacaoestoqueproduto]	WITH(NOLOCK)
												ORDER BY Id DESC 

								    	SELECT TOP 5 IdEtapaProducao,
													 IdPedidoProduto,
													 DataInicio,
													 DataTermino,
													 Quantidade
											FROM [dbo].[Producao] WITH(NOLOCK)
											ORDER BY DataTermino DESC 
								 ROLLBACK TRAN
	*/
	BEGIN
		--Declaracao de variáveis 
		DECLARE @DataAtual DATETIME = GETDATE();

		-- Insercao na tabela de MovimentacaoEstoqueProduto para os produtos que foram entregues 
		WITH EtapaMaxima AS  (
			-- Capturar o valor máximo do número de etapa para o produto passado como parãmetro
			SELECT  IdProduto,
					MAX(NumeroEtapa) AS EtapaFinal
				FROM [dbo].[EtapaProducao] WITH(NOLOCK)
				GROUP BY IdProduto
							 )  
        INSERT INTO MovimentacaoEstoqueProduto(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
            SELECT  ep.IdProduto,
                    1, --id travado em 1 = entrada para produtos que acabaram de ser produzidos
                    GETDATE(),
                    I.Quantidade
                FROM INSERTED I
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        ON I.IdEtapaProducao = ep.Id
                    INNER JOIN EtapaMaxima em
                        ON ep.IdProduto = em.IdProduto
					INNER JOIN DELETED d
						ON d.Id = i.Id
                WHERE ep.NumeroEtapa = em.EtapaFinal 
						  AND I.DataTermino IS NOT NULL
						  AND d.DataTermino IS NULL
		--validacao de erros 
		IF @@ERROR <> 0
			BEGIN
				RAISERROR('Erro ao inserir o registro', 16, 1);
				RETURN;
			END
	END
