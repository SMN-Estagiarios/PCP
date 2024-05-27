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
		-- Insercao na tabela de MovimentacaoEstoqueProduto para os produtos que foram entregues 
		INSERT INTO MovimentacaoEstoqueProduto(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
            SELECT ep.IdProduto,
				   1 IdTipoMovimentacao,
				   GETDATE() DataAtual,
				   i.Quantidade
				FROM inserted i WITH(NOLOCK)
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        ON i.IdEtapaProducao = ep.Id
				WHERE i.DataTermino IS NOT NULL
				AND ep.NumeroEtapa = (
										SELECT  MAX(ep.NumeroEtapa) AS EtapaFinal
										FROM [dbo].[EtapaProducao] ep WITH(NOLOCK)
										INNER JOIN inserted i
										ON i.IdEtapaProducao = ep.Id
									 )
		--validacao de erros 
		IF @@ERROR <> 0
			BEGIN
				RAISERROR('Erro ao inserir o registro', 16, 1);
				RETURN;
			END
	END
