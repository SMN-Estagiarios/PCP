CREATE OR ALTER PROCEDURE [dbo].[SPJOB_RealizarEntregaPedido]
    AS
    /*
        Documentacao
        Arquivo Fonte.....: SPJOB_RealizarEntregaPedido.sql
        Objetivo..........: Verificar e realizar entrega de pedidos que possuam estoque suficiente dos itens a cada 5 minutos
        Autor.............: Odlavir Florentino
        Data..............: 29/05/2024
        Ex................: BEGIN TRAN
                                DBCC FREEPROCCACHE
                                DBCC FREESYSTEMCACHE('ALL')
                                DBCC DROPCLEANBUFFERS

                                DECLARE @DataInicio DATETIME = GETDATE();

                                TRUNCATE TABLE [dbo].[MovimentacaoEstoqueProduto];

                                 SELECT p.Id,
                                        p.DataEntrega
                                    FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                                        INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
                                                ON pp.IdPedido = p.Id
                                    WHERE p.DataEntrega IS NULL
                                    ORDER BY p.DataPromessa ASC;

                                SELECT  Id,
                                        IdTipoMovimentacao,
                                        IdEstoqueProduto,
                                        DataMovimentacao,
                                        Quantidade
                                    FROM [dbo].[MovimentacaoEstoqueProduto] WITH(NOLOCK);

                                EXEC [dbo].[SPJOB_RealizarEntregaPedido]

                                SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) Tempo;

                                SELECT p.Id,
                                        p.DataEntrega
                                    FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                                        INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
                                                ON pp.IdPedido = p.Id
                                    WHERE p.DataEntrega IS NULL
                                    ORDER BY p.DataPromessa ASC;

                                SELECT  Id,
                                        IdTipoMovimentacao,
                                        IdEstoqueProduto,
                                        DataMovimentacao,
                                        Quantidade
                                    FROM [dbo].[MovimentacaoEstoqueProduto] WITH(NOLOCK);

                            ROLLBACK TRAN
    */
    BEGIN
        -- Declarando variaveis necessarias
        DECLARE @IdPedido INT

        -- Criando tabela temporaria
        CREATE TABLE #Tabela    (
                                    IdPedido INT
                                )
        
        -- Inserir na tabela todos os ids de pedidos que ainda estao para entrega 
        INSERT INTO #Tabela (IdPedido)
            SELECT  p.Id
                FROM [dbo].[PedidoProduto] pp WITH(NOLOCK)
                    INNER JOIN [dbo].[Pedido] p WITH(NOLOCK)
                        ON pp.IdPedido = p.Id
                WHERE p.DataEntrega IS NULL
                ORDER BY p.DataPromessa ASC;

        -- Loop que ira rodar enquanto existir registro na tabela
        WHILE EXISTS (
                        SELECT TOP 1 1
                            FROM #Tabela
                    )
            BEGIN
                -- Setando variavel para o primeiro registro da tabela
                SELECT TOP 1 @IdPedido = IdPedido
                    FROM #Tabela;

                -- Executando procedure de realizar a baixa do pedido
                EXEC [dbo].[SP_RealizarBaixaPedido] @IdPedido

                -- Deletando o primeiro registro na tabela
                DELETE TOP (1)
                    FROM #Tabela;
                
                -- Limpando variavel
                SET @IdPedido = NULL;
            END

        -- Dropando tabela
        DROP TABLE #Tabela
    END