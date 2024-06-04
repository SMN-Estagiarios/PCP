--1.1
CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioPedidoEmAtraso]

AS

/*
    Documentação
    Arquivo Fonte: Relatiorio.sql;
    Objetivo: Listar todos os pedido concluídos e entregues, porém em atraso;
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

--1.2
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

--2
CREATE PROCEDURE [dbo].[SP_RelatorioPedidosProducaoPausada]

AS

/*
    Documentação
    Arquivo Fonte:......Relatorio.sql
    Objetivo:...........Listar todos os pedidos em que a produção está pausada;
    Autor:..............Pedro Avelino;
    Data:...............04/06/2024
    Ex:.................
                        BEGIN TRAN

                            DBCC DROPCLEANBUFFERS
                            DBCC FREEPROCCACHE

                            DECLARE @DataInicio DATETIME = GETDATE();

                            EXEC [dbo].[SP_RelatorioPedidosProducaoPausada];

                            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;
                        
                        ROLLBACK TRAN
*/

BEGIN

    SELECT * FROM Pedido
    SELECT * FROM PedidoProduto
    SELECT * FROM Producao 

    SELECT p.Id AS 'Id do Pedido'
        FROM [dbo].[Pedido] p
        INNER JOIN [dbo].[PedidoProduto] pp
            ON p.Id = pp.IdPedido
        INNER JOIN [dbo].[Producao] pr
            ON pp.Id = pr.IdPedidoProduto
        WHERE DataTermino IS NULL;

END;

GO

--3
CREATE PROCEDURE [dbo].[SP_RelatorioProducaoConcluidaComEtapaEmAtraso]

AS

/*
    Documentação
    Arquivo Fonte:.............Relatorio.sql
    Objetivo:..................Listar as produções concluídas com etapas atrasadas;
    Autor:.....................Pedro Avelino;
    Data:......................04/06/24;
    Ex:........................
                                BEGIN TRAN

                                    DBCC DROPCLEANBUFFERS
                                    DBCC FREEPROCCACHE

                                    DECLARE @DataIncio DATETIME = GETDATE();

                                    EXEC [dbo].[SP_RelatorioProducaoConcluidaComEtapaEmAtraso];

                                    SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

                                ROLLBACK TRAN
*/

BEGIN

    SELECT  *
        FROM [dbo].[Producao] p
        INNER JOIN EtapaProducao ep
            ON p.IdEtapaProducao = ep.Id
END;


GO

--4
CREATE PROCEDURE[dbo].[SP_RelatorioRankingDeProdutosMaisPedidos]

AS

BEGIN
    SELECT COUNT(DISTINCT(IdProduto)) 
        FROM PedidoProduto
END;

GO

CREATE PROCEDURE [dbo].[SP_RelatorioDePedidosEntreguesNãoConcluidos]

AS

BEGIN

END;

GO

--8
CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioProdutoMaisVendido]
    @Ano INT = NULL,
    @Mes INT = NULL,
    @Dia INT = NULL

AS

/*
    Documentação
    Arquivo Fonte:.............Relatorio.sql
    Objetivo:..... ............Listar o produto mais vendido em um período de tempo específico;
    Autor:.....................Pedro Avelino;
    Data:......................31/05/24
    Ex:........................ BEGIN TRAN

                                    DBCC DROPCLEANBUFFERS
                                    DBCC FREEPROCCACHE

                                    DECLARE @DataIncio DATETIME = GETDATE();

                                    EXEC [dbo].[SP_RelatorioProdutoMaisVendido] @Ano = 2021, @Mes = 12;

                                    SELECT DATEDIFF (MILLISECOND, @DataIncio, GETDATE()) AS Tempo;

                                ROLLBACK TRAN

                                Retornos:...4 - Ano inválido
                                            3 - Mês inválido
                                            2 - Dia inválido
                                            1 - Período especificado sem pedidos
                                            0 - Sucesso
       
*/

BEGIN 

    BEGIN TRY
        --Verificação da validade do ano 
        IF @Ano IS NOT NULL AND (@Ano < 2020 OR @Ano > YEAR(GETDATE()))
            BEGIN 
                RAISERROR('Ano inválido. Por favor, insira um ano entre 2020 e o ano atual', 16, 1);
                RETURN 4;
            END
        
        -- Verificação da validade do mês
        IF @Mes IS NOT NULL AND (@Mes < 1 OR @Mes > 12)
            BEGIN 
                RAISERROR('Mês inválido. Por favor, insira um mês entre 1 e 12', 16, 1);
                RETURN 3;
            END
        
        --Verificação da validade do dia
        IF @Dia IS NOT NULL AND (@Dia < 1 OR @Dia > 31)
            BEGIN
                RAISERROR('Dia inválido. Por favor, insira um dia entre 1 e 31', 16, 1);
                RETURN 2;
            END
        
        --Verificação se existem pedidos naquele período especificado
        IF NOT EXISTS (
                        SELECT TOP 1 1
                            FROM [dbo].[Pedido] p
                            WHERE (@Ano IS NULL OR YEAR(p.DataPedido) = @Ano)
                AND(@Mes IS NULL OR MONTH(p.DataPedido) = @Mes)
                AND(@Dia IS NULL OR DAY(p.DataPedido) = @Dia)
        )
            BEGIN 
                RAISERROR('Não existem pedidos nesse período especificado', 16, 1);
                RETURN 1;
            END

        -- Consulta dos produto mais vendidos
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

            RETURN 0;
    END TRY

    BEGIN CATCH

        SELECT  ERROR_NUMBER() AS ErrorNumber,
                ERROR_MESSAGE() AS ErrorMessage;

    END CATCH

END;

GO

--9
CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioPedidoDeUmCliente] 
    @Nome VARCHAR(255),
    @StatusPedido CHAR(1)

AS

/*
    Documentação
    Arquivo Fonte: Relatorio.sql
    Objetivo: Listar os pedidos de um cliente específico de acordo com o status do pedido (entregue em atraso, entregue no prazo ou não entregue)
    Autor: Pedro Avelino;
    Data: 01/06/2024
    Ex: 
        BEGIN TRAN

            DBCC DROPCLEANBUFFERS 
            DBCC FREEPROCCACHE 

            DECLARE @DataInicio DATETIME = GETDATE();

            EXEC [dbo].[SP_RelatorioPedidoDeUmCliente] 'João Silva', 'A';

            EXEC [dbo].[SP_RelatorioPedidoDeUmCliente] 'Thomaz Falbo', 'N';

            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

        ROLLBACK TRAN
*/

BEGIN

    IF @StatusPedido NOT IN ('A', 'P', 'N')
        BEGIN
            RAISERROR('Status do pedido inválido. Use as letras "A" para "atrasado", "P" para "no prazo" ou "N" para "não entreguee".', 16, 1);
            RETURN;
        END;

    SELECT  p.Id,
            c.Nome,
            p.DataPedido,
            p.DataPromessa,
            p.DataEntrega
        FROM [dbo].[Cliente] c 
        INNER JOIN [dbo].[Pedido] p
            ON c.Id = p.IdCliente
        WHERE c.Nome = @Nome
        AND (
            (@StatusPedido = 'A' AND p.DataEntrega IS NOT NULL AND p.DataEntrega > p.DataPromessa)
            OR (@StatusPedido = 'P' AND p.DataEntrega IS NOT NULL AND p.DataEntrega <= p.DataPromessa)
            OR (@StatusPedido = 'N' AND p.DataEntrega IS NULL)
        );
END;

GO

--João disse
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
