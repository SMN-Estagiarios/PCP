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
										SELECT * 
                                            FROM movimentacaoestoqueproduto	
										select * from estoqueproduto
										
										UPDATE Producao
											SET DataTermino = GETDATE()
												WHERE Id IN(3, 6)

										

										select * from estoqueproduto
										select * from movimentacaoestoqueproduto

								 ROLLBACK TRAN
	*/
	BEGIN
		--seleciona a maxima etapa do produto 
		WITH EtapaMaxima AS (
								SELECT  IdProduto,
										MAX(NumeroEtapa) AS EtapaFinal
									FROM [dbo].[EtapaProducao] WITH(NOLOCK)
									GROUP BY IdProduto
							) 
		-- Insercao na tabela de MovimentacaoEstoqueProduto para os produtos que foram entregues 
		INSERT INTO MovimentacaoEstoqueProduto(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
            SELECT ep.IdProduto,
				   1 IdTipoMovimentacao,
				   GETDATE() DataAtual,
				   p.Quantidade
                FROM [dbo].[Producao] p WITH(NOLOCK)
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        ON p.IdEtapaProducao = ep.Id
                    INNER JOIN EtapaMaxima em WITH(NOLOCK)
                        ON ep.IdProduto = em.IdProduto
					INNER JOIN PedidoProduto pp WITH(NOLOCK)
						ON pp.Id = p.IdPedidoProduto
					INNER JOIN Pedido pe WITH(NOLOCK)
						ON pe.Id = pp.IdPedido
                WHERE ep.NumeroEtapa = em.EtapaFinal 
					  AND p.DataTermino IS NOT NULL
					  AND pe.DataEntrega IS NULL
	END
