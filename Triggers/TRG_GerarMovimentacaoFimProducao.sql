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
										SELECT Id,
											   IdTipoMovimentacao,
											   IdEstoqueProduto,
											   DataMovimentacao,
											   Quantidade
											FROM [dbo].[movimentacaoestoqueproduto]	
										
										SELECT IdProduto,
											   QuantidadeFisica,
											   QuantidadeMinima 
											FROM [dbo].[estoqueproduto]
										
										UPDATE Producao
											SET DataTermino = GETDATE()
												WHERE Id IN(17) 
										

										SELECT Id,
											   IdTipoMovimentacao,
											   IdEstoqueProduto,
											   DataMovimentacao,
											   Quantidade
											FROM [dbo].[movimentacaoestoqueproduto]	
										
										SELECT IdProduto,
											   QuantidadeFisica,
											   QuantidadeMinima 
											FROM [dbo].[estoqueproduto]

								 ROLLBACK TRAN
	*/
	BEGIN
		
		WITH EtapaMaxima AS (
            -- Capturar o valor máximo do número de etapa para o produto passado como parãmetro
            SELECT    IdProduto,
                    MAX(NumeroEtapa) AS EtapaFinal
                FROM [dbo].[EtapaProducao] WITH(NOLOCK)
                GROUP BY IdProduto
        )	-- Capturar os Ids de producoes finalizadas
            INSERT INTO MovimentacaoEstoqueProduto(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
                SELECT ep.IdProduto,
					   1,
					   GETDATE(),
					   I.Quantidade
					FROM INSERTED I
						INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
							ON I.IdEtapaProducao = ep.Id
						INNER JOIN EtapaMaxima em
							ON ep.IdProduto = em.IdProduto
					WHERE ep.NumeroEtapa = em.EtapaFinal AND I.DataTermino IS NOT NULL
       
		--validacao de erros 
		IF @@ERROR <> 0
			BEGIN
				RAISERROR('Erro ao inserir o registro', 16, 1);
				RETURN;
			END
	END
