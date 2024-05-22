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
					ep.Duracao
			FROM [dbo].[EtapaProducao] ep WITH(NOLOCK)
				INNER JOIN [dbo].[Produto] p WITH(NOLOCK)
					ON ep.IdProduto = p.Id
				INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
					ON pp.IdProduto = p.Id
			WHERE @Id = pp.IdPedido

	END
GO