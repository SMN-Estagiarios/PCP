CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioPedidoEmAtraso]

AS

/*
    Documentação
    Arquivo Fonte: Relatiorio.sql;
    Objetivo: Listar todos os pedido concluídos e entregue, porém em atraso;
    Autor: Pedro Avelino;
    Data: 30/05/2024
    Ex: 
        BEGIN TRAN

            SELECT * 
                FROM [dbo].[Pedido] WITH (NOLOCK)

            DBCC DROPCLEANBUFFERS
            DBCC FREEPROCCACHE

            DECLARE @Data_Inicio DATETIME = GETDATE(),
                    @Retorno INT;
            
            EXEC [dbo].[SP_RelatorioPedidoEmAtraso] 

            SELECT 	@Retorno AS Retorno,
					DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo;
								
			SELECT *
				FROM [dbo].[Pedido] WITH(NOLOCK);

        ROLLBACK TRAN
*/

BEGIN 

    SELECT  Id,
            IdCliente,
            DataPedido,
            DataPromessa,
            DataEntrega
        FROM [dbo].[Pedido] 
        WHERE DataEntrega > DataPromessa
            AND DataEntrega IS NOT NULL;
END;

GO

CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioPedidoEntregueNoPrazo]

AS

/*
    Documentação
    Arquivo Fonte: Relatorio.sql
    Objetivo: Listar todos os pedidos concluídos e entregues dentro do prazo;
    Autor: Pedro Avelino;
    Data: 30/05/2024
    Ex:
        BEGIN TRAN

        SELECT *
            FROM [dbo].[Pedido] WITH (NOLOCK) 

            DBCC DROPCLEANBUFFERS
            DBCC FREEPROCCACHE

            DECLARE @Data_Inicio DATETIME = GETDATE(),
                    @Retorno AS INT;

            EXEC [dbo].[SP_RelatorioPedidoEntregueNoPrazo];

            SELECT @Retorno AS Retorno,
                DATEDIFF(MILLISECOND, @Data_Inicio, GETDATE()) AS Tempo;
            
        SELECT *
            FROM [dbo].[Pedido] WITH (NOLOCK) 
        
        ROLLBACK TRAN
*/

BEGIN

    SELECT Id,
            IdCliente,
            DataPedido,
            DataPromessa,
            DataEntrega
        FROM [dbo].[Pedido]
        WHERE DataEntrega IS NOT NULL
            AND DataEntrega <= DataPromessa;

END;

GO

SELECT * FROM Producao