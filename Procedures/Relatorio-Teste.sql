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

CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioPedidoPorPagina]
    @Pagina INT = NULL,
    @TamanhoPagina INT

AS

/*
    Documentação
    Arquivo Fonte: Relatorio.sql
    Objetivo: Listar os pedidos dividindo-os por página
    Autor: Pedro Avelino
    Data: 31/04
    Ex:
        BEGIN TRAN

            DBCC DROPCLEANBUFFERS
            DBCC FREEPROCCACHE

            DECLARE @DataInicio DATETIME = GETDATE();

            EXEC [dbo].[SP_RelatorioPedidoPorPagina] 3, 10;

            SELECT DATEDIFF (MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

        ROLLBACK TRAN
*/

BEGIN


    DECLARE @Inicio INT;
    SET @Inicio = (@Pagina - 1) * @TamanhoPagina;

    IF @Pagina IS NULL
        BEGIN   
            SET @Inicio = 0;
        END;

    SELECT  Id,
            IdCliente,
            DataPedido,
            DataPromessa,
            DataEntrega
        FROM [dbo].[Pedido] 
        ORDER BY Id
            OFFSET @Inicio ROWS
            FETCH NEXT @TamanhoPagina ROWS ONLY;
END;


GO


CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioProdutoMaisVendido]
    @Ano INT = NULL,
    @Mes INT = NULL,
    @Dia INT = NULL

AS

/*
    Documentação
    Arquivo Fonte: Relatorio.sql
    Objetivo: Listar o produto mais vendido em um período de tempo específico;
    Autor: Pedro Avelino;
    Data: 31/05/24
    Ex: 
        BEGIN TRAN

            DBCC DROPCLEANBUFFERS
            DBCC FREEPROCCACHE

            DECLARE @DataIncio DATETIME = GETDATE();

            EXEC [dbo].[SP_RelatorioProdutoMaisVendido] @Ano = 2024, @Mes = 2;

            SELECT DATEDIFF (MILLISECOND, @DataIncio, GETDATE()) AS Tempo;

        ROLLBACK TRAN
*/

BEGIN

    BEGIN TRY
        SELECT  TOP 1
                pr.Id,
                pr.Nome,
                SUM(pp.Quantidade) AS QuantidadeVendida
            FROM [dbo].[PedidoProduto] pp
            INNER JOIN [dbo].[Pedido] p 
                ON pp.IdPedido = p.Id
            INNER JOIN [dbo].[Produto] pr 
                ON pp.IdProduto = pr.Id 
            WHERE (@Ano IS NULL OR YEAR(p.DataPedido) = @Ano)
                AND(@Mes IS NULL OR MONTH(p.DataPedido) = @Mes)
                AND(@Dia IS NULL OR DAY(p.DataPedido) = @Dia)
            GROUP BY pr.Id, pr.Nome
            ORDER BY QuantidadeVendida DESC;
    END TRY

    BEGIN CATCH

        SELECT  ERROR_NUMBER() AS ErrorNumber,
                ERROR_MESSAGE() AS ErrorMessage;

    END CATCH

END;

GO

CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioPedidosDeUmClienteEmAtraso]
    @Nome VARCHAR(255)
AS

/*
    Documentação
    Arquivo Fonte: Relatorio.sql
    Objetivo: Listar todos os pedidos de um cliente específico entregues em atraso;
    Autor: Pedro Avelino;
    Data: 31/05/2024
    Ex: 
        BEGIN TRAN 
            
            DBCC DROPCLEANBUFFERS
            DBCC FREEPROCCACHE

            DECLARE @DataInicio DATETIME = GETDATE();

            EXEC [dbo].[SP_RelatorioPedidosDeUmClienteEmAtraso] 'João Silva';

            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE() AS Tempo);

        ROLLBACK TRAN
*/

BEGIN

    SELECT  p.Id,
            c.Nome,
            p.DataPedido,
            p.DataPromessa,
            p.DataEntrega 
        FROM [dbo].[Cliente] c
        INNER JOIN [dbo].[Pedido] p
            ON c.Id = p.IdCliente
        WHERE DataEntrega IS NOT NULL 
            AND DataEntrega > DataPromessa
            AND c.Nome = @Nome;
END;


GO


CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioPedidosDeUmClienteEntregueNoPrazo]
    @Nome VARCHAR (255)

AS
/*
    Documentação
    Arquivo Fonte: Relatorio.sql
    Objetivo: Listar todos os pedidos de um cliente específico entregues dentro do prazo;
    Autor: Pedro Avelino;
    Data: 31/05/2024
    Ex: 
        BEGIN TRAN 
            
            DBCC DROPCLEANBUFFERS
            DBCC FREEPROCCACHE

            DECLARE @DataInicio DATETIME = GETDATE();

            EXEC [dbo].[SP_RelatorioPedidosDeUmClienteEntregueNoPrazo] 'João Silva';

            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

        ROLLBACK TRAN
*/

BEGIN

    SELECT  p.Id,
            c.Nome,
            p.DataPedido,
            p.DataPromessa,
            p.DataEntrega 
        FROM [dbo].[Cliente] c
        INNER JOIN [dbo].[Pedido] p
            ON c.Id = p.IdCliente
        WHERE DataEntrega IS NOT NULL 
            AND DataEntrega <= DataPromessa
            AND c.Nome = @Nome;
END;

GO

CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioPedidosDeUmClienteAindaNãoEntregues]
    @Nome VARCHAR (255)

AS
/*
    Documentação
    Arquivo Fonte: Relatorio.sql
    Objetivo: Listar todos os pedidos de um cliente específico ainda não entregues;
    Autor: Pedro Avelino;
    Data: 31/05/2024
    Ex: 
        BEGIN TRAN 
            
            DBCC DROPCLEANBUFFERS
            DBCC FREEPROCCACHE

            DECLARE @DataInicio DATETIME = GETDATE();

            EXEC [dbo].[SP_RelatorioPedidosDeUmClienteAindaNãoEntregues] 'Pedro Avelino';

            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

        ROLLBACK TRAN
*/

BEGIN

    SELECT  p.Id,
            c.Nome,
            p.DataPedido,
            p.DataPromessa
        FROM [dbo].[Cliente] c
        INNER JOIN [dbo].[Pedido] p
            ON c.Id = p.IdCliente
        WHERE DataEntrega IS NOT NULL 
            AND DataEntrega IS NULL
            AND c.Nome = @Nome;
END;






