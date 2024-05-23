CREATE OR ALTER TRIGGER [dbo].[TRG_AtualizarEstoqueFisico]
	ON [dbo].[Pedido]
	AFTER UPDATE
	AS
	/*
	Documentacao: 
	Arquivo Fonte..: TRG_AtualizarEstoqueFisico.sql
	Objetivo.......: Atualizar estoque fisico quando for entregue o pedido.
	Autor..........: OrcinoNeto
	Data...........: 23/05/2024
	Ex.............: 
                    BEGIN TRAN
                        DECLARE @DATA_INI DATETIME = GETDATE();

                        DBCC DROPCLEANBUFFERS
                        DBCC FREEPROCCACHE
                        DBCC FREESYSTEMCACHE ('ALL')
                        --SELECT * FROM Pedido
                        --SELECT * FROM PedidoProduto
                        --SELECT * FROM EstoqueProduto
                        SELECT * FROM MovimentacaoEstoqueProduto

                        UPDATE Pedido
                            SET DataEntrega = GETDATE()
                        WHERE Id = 7

                        --SELECT * FROM Pedido
                        --SELECT * FROM PedidoProduto
                        --SELECT * FROM EstoqueProduto
                        SELECT * FROM MovimentacaoEstoqueProduto
                        SELECT	DATEDIFF(MILLISECOND, @DATA_INI, GETDATE()) AS ResultadoExecucao

                    ROLLBACK TRAN
	*/
	BEGIN
        --Declaração das Variaveis.
		DECLARE	@Quantidade INT,
                @IdProduto INT,
                @IdPedido INT,
                @DataEntrega DATE,
                @DataEntregaD DATE =    (
                                            SELECT DataEntrega
                                                FROM deleted
                                        )

        --Setando as variaveis , verificando se é um update para entrega de pedido.
        SELECT  @IdPedido = i.Id,
                @IdProduto = p.Id,
                @Quantidade = pp.Quantidade,
                @DataEntrega = i.DataEntrega
            FROM inserted i
                INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                    ON @IdPedido = pp.IdPedido
                INNER JOIN [dbo].[Produto] p WITH(NOLOCK)
                    ON p.Id = @IdProduto
            WHERE i.DataEntrega IS NOT NULL AND @DataEntregaD IS NULL
        
        --Executa a procedure de inserir movimentação de estoque com a quantidade de saida dos produtos daquele pedido.
        EXEC [dbo].[SP_InserirMovimentacaoEstoqueProduto] @IdProduto, 2, NULL, @Quantidade

	END
GO