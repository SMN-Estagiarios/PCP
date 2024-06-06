
CREATE OR ALTER PROCEDURE [dbo].[SP_DemonstrativoPedidoCompraMateriaPrima]  @MesProcessamento INT,
                                                                            @AnoProcessamento INT
    AS
    /*
        Documentacao
            Arquivo fonte.....: MovimentacaoEstoqueMateriaPrima.sql
            Objetivo..........: Gerar demonstrativo acerca de pedidos que geraram compra de materia prima para sua producao em
                                determinado mes escolhido
            Autor.............: Gabriel Damiani Puccinelli
            Data..............: 06/06/2024
            EX................: BEGIN TRAN
                                    DBCC FREEPROCCACHE
						            DBCC FREESYSTEMCACHE('ALL')
						            DBCC DROPCLEANBUFFERS
                                    
                                    DECLARE @DataInicio DATETIME = GETDATE(),
                                            @Ret INt

                                    EXEC @Ret = [dbo].[SP_DemonstrativoPedidoCompraMateriaPrima]  10, 2023

                                    SELECT @Ret AS Retorno

                                    SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao

                                ROLLBACK TRAN
            Retornos..........: 0. SUCESSO
                                1. NÃO HOUVE PEDIDOS NESSA DATA

    */
    BEGIN
        --Verifica se há pedido nessa data
        IF NOT EXISTS   (
                            SELECT TOP 1 1
                                FROM [dbo].[Pedido]
                                WHERE   YEAR(DataPedido) = @AnoProcessamento
                                        	AND MONTH(DataPedido) = @MesProcessamento
                        )
            --Caso não haja pedidos na data selecionada
            RETURN 1
        
		--Busca de pedidos que demandaram materia prima com demais atributos
        SELECT  pe.Id AS CodigoPedido,
                pe.DataPedido AS DataPedido,
                pt.Id AS CodigoProduto,
                pt.Nome AS NomeProduto,
                mp.Id AS CodigoMateriaPrima,
                mp.Nome AS NomeMateriaPrima,
                mm.DataMovimentacao AS DataCompra
            FROM [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima] am WITH(NOLOCK)
                INNER JOIN [dbo].[Pedido] pe WITH(NOLOCK)
                    ON pe.Id = am.IdPedido
                INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                    ON pe.Id = pp.IdPedido
                INNER JOIN [dbo].[Produto] pt WITH(NOLOCK)
                    ON pt.Id = pp.IdProduto
                INNER JOIN [dbo].[MovimentacaoEstoqueMateriaPrima] mm WITH(NOLOCK)
                    ON mm.Id = am.IdMovimentacaoEstoqueMateriaPrima
                INNER JOIN [dbo].[MateriaPrima] mp WITH(NOLOCK)
                    ON mp.Id = mm.IdEstoqueMateriaPrima
            WHERE   YEAR(pe.DataPedido) = @AnoProcessamento
                    	AND MONTH(pe.DataPedido) = @MesProcessamento
                        AND mm.IdTipoMovimentacao = 1

        --Caso retorne dados como o esperado
        RETURN 0
    END
GO