-- QUESTÃO 1.1
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

--QUESTÃO 1.2
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

-- QUESTÃO 2
CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioPedidosProducaoPausada] 
    
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
                            DBCC FREESYSTEMCACHE('ALL')

                            DECLARE @DataInicio DATETIME = GETDATE();

                            EXEC [dbo].[SP_RelatorioPedidosProducaoPausada];


                            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;
                        
                        ROLLBACK TRAN
*/

BEGIN

    WITH EtapaMaxima AS (
        SELECT  IdProduto,
                MAX(NumeroEtapa) AS MaxEtapa
            FROM [dbo].[EtapaProducao] WITH (NOLOCK)
            GROUP BY IdProduto
    ), ContagemPedidoProduto AS (
        SELECT  IdPedidoProduto,
                COUNT(IdPedidoProduto) AS Contagem
            FROM [dbo].[Producao] WITH (NOLOCK)
            GROUP BY IdPedidoProduto
    )
        SELECT p.Id
            FROM [dbo].[Pedido] p WITH (NOLOCK)
                INNER JOIN [dbo].[PedidoProduto] pp WITH (NOLOCK)
                    ON p.Id = pp.IdPedido
                INNER JOIN [dbo].[Producao] pr WITH (NOLOCK)
                    ON pr.IdPedidoProduto = pp.Id
                INNER JOIN ContagemPedidoProduto cpp
                    ON pp.Id = cpp.IdPedidoProduto
                INNER JOIN EtapaMaxima em
                    ON pp.IdProduto = em.IdProduto
            WHERE cpp.Contagem < em.MaxEtapa
                AND pr.DataTermino IS NOT NULL
                AND p.DataEntrega IS NULL;
 END;

GO

-- QUESTÃO 3
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
                                    DBCC FREESYSTEMCACHE('ALL')

                                    DECLARE @DataIncio DATETIME = GETDATE();

                                    EXEC [dbo].[SP_RelatorioProducaoConcluidaComEtapaEmAtraso];

                                    SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

                                ROLLBACK TRAN
*/

BEGIN

    SELECT  p.Id AS IdProducao,
            p.DataInicio AS IncioProducao,
            p.DataTermino AS TerminoProducao,
            (DATEDIFF(MINUTE, p.DataInicio, p.DataTermino) - ep.Duracao) AS Atraso
        FROM [dbo].[Producao] p WITH (NOLOCK)
            LEFT JOIN [dbo].[EtapaProducao] ep WITH (NOLOCK)
                ON p.IdEtapaProducao = ep.Id 
        WHERE p.DataTermino IS NOT NULL
            AND DATEDIFF(MINUTE, p.DataInicio, p.DataTermino) > ep.Duracao;
END;


GO

-- QUESTÃO 4
CREATE OR ALTER PROCEDURE[dbo].[SP_RankingDeProdutosMaisPedidos]

AS

/*
    Documentação
    Arquivo Fonte: Relatorio.sql
    Objetivo: Ranquear os produtos mais vendidos
    Autor: Pedro Avelino
    Data: 05/06/24
    Ex: 
        BEGIN TRAN

            DBCC DROPCLEANBUFFERS
            DBCC FREEPROCCACHE

            DECLARE @DataInicio DATETIME = GETDATE();

            EXEC [dbo].[SP_RankingDeProdutosMaisPedidos];

            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

        ROLLBACK TRAN
*/

BEGIN
    SELECT  p.Id,
            p.Nome,
            SUM(pp.Quantidade) AS SomaQuantidade,
            DENSE_RANK() OVER (ORDER BY SUM(pp.Quantidade) DESC) AS Ranking
        FROM [dbo].[PedidoProduto] pp WITH (NOLOCK)
            INNER JOIN [dbo].[Produto] p WITH (NOLOCK)
                ON pp.IdProduto = p.Id
            GROUP BY p.Id, p.Nome
END;

GO


-- QUESTÃO 5
CREATE PROCEDURE [dbo].[SP_RelatoriosPedidosEntreguesNãoConcluidos]

AS

/*
    Documentação
    Arquivo Fonte.....: Relatorio.sql
    Objetivo..........: Listar todos os pedidos entregues, porém com produções não concluídas;
    Autor.............: Pedro Avelino;
    Data..............: 05/06/24
    Ex................: 
                        BEGIN TRAN
                            
                            DBCC DROPCLEANBUFFERS
                            DBCC FREEPROCCACHE
                            DBCC FREESYSTEMCACHE('ALL')

                            DECLARE @DataInicio DATETIME = GETDATE();

                            UPDATE [dbo].[Pedido]
                                SET DataEntrega = DATEADD(DAY, 10, GETDATE())
                                WHERE DataEntrega IS NULL
                                    AND DataPedido BETWEEN '2024-05-22'
                                        AND GETDATE();
                            
                            EXEC [dbo].[SP_RelatoriosPedidosEntreguesNãoConcluidos];

                            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

                        ROLLBACK TRAN 
*/

BEGIN

    WITH EtapaMaxima AS 
    (
        SELECT  IdProduto,
                MAX(NumeroEtapa) AS MaiorEtapa
            FROM [dbo].[EtapaProducao]
            GROUP BY IdProduto
    ), 
    ContagemPedidoProdutoProducao AS 
    (
        SELECT  IdPedidoProduto,
                COUNT(IdPedidoProduto) AS ContagemDePedidoProduto
            FROM Producao
            GROUP BY IdPedidoProduto
    )

    SELECT  p.Id,
            pp.IdProduto,
            pt.Nome,
            pp.Quantidade
        FROM [dbo].[Pedido] p
            INNER JOIN [dbo].[PedidoProduto] pp
                ON p.Id = pp.IdPedido
            INNER JOIN [dbo].[Producao] pr
                ON pp.Id = pr.IdPedidoProduto
            INNER JOIN [EtapaMaxima] em
                ON pp.IdProduto = em.IdProduto
            INNER JOIN [ContagemPedidoProdutoProducao] cppp
                ON pp.Id = cppp.IdPedidoProduto
            INNER JOIN [dbo].[Produto] pt
                ON pt.Id = pp.IdProduto
        WHERE p.DataEntrega IS NOT NULL
            AND (
                cppp.ContagemDePedidoProduto < em.MaiorEtapa 
                    OR (cppp.ContagemDePedidoProduto = em.MaiorEtapa 
                            AND pr.DataTermino IS NULL)
            );
END;


GO


--QUESTÃO 6
CREATE OR ALTER PROCEDURE [dbo].[SP_RankingEtapasMaisEMenosAtrasadas]

AS

/*
    Documentação
    Arquivo Fonte.....: Relatorio.sql
    Objetivo..........: Ranquear as etapas mais e as menos atrasadas;
    Autor.............: Pedro Avelino;
    Data..............: 05/06/24
    Ex................: 
                        DBCC DROPCLEANBUFFERS
                        DBCC FREEPROCCACHE

                        DECLARE @DataInicio DATETIME = GETDATE();

                        EXEC [dbo].[SP_RankingEtapasMaisEMenosAtrasadas]

                        SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;
*/

BEGIN

    WITH AtrasoEtapa AS (
                        SELECT  ep.Id AS IdEtapa,
                                ep.NumeroEtapa,
                                SUM(ep.Duracao) AS DuracaoEstimadaTotal,
                                SUM(DATEDIFF(MINUTE, p.DataInicio, p.DataTermino)) AS TempoReal,
                                SUM(DATEDIFF(MINUTE, p.DataInicio, p.DataTermino) - ep.Duracao) AS Atraso
                            FROM [dbo].[Producao] p WITH (NOLOCK)
                                INNER JOIN [dbo].[EtapaProducao] ep WITH (NOLOCK)
                                    ON p.IdEtapaProducao = ep.Id
                            WHERE p.DataTermino IS NOT NULL 
                                AND DATEDIFF(MINUTE, p.DataInicio, p.DataTermino) > ep.Duracao
                            GROUP BY ep.Id, ep.NumeroEtapa 
                        )
    SELECT  IdEtapa,
            NumeroEtapa,
            DuracaoEstimadaTotal,
            TempoReal,
            Atraso,
            DENSE_RANK() OVER (ORDER BY Atraso DESC) AS RankingMaisAtrasadas
        FROM AtrasoEtapa
        WHERE Atraso > 0
        ORDER BY RankingMaisAtrasadas;
END;

GO

--QUESTÃO 7
CREATE PROCEDURE [dbo].[SP_RankingProdutosMaisAtrasados]

AS

BEGIN

    SELECT * FROM Produto

END;

GO

-- QUESTÃO 8
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

-- QUESTÃO 9
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

--QUESTÃO 10
CREATE OR ALTER PROCEDURE [dbo].[SP_RelatorioNumeroDePedidosTrimestraisAoLongoDeTresAnos]

AS

/*
    Documentação
    Arquivo Fonte.....: Relatorio.sql
    Objetivo..........: Listar os clientes com seus números de pedidos trimestrais ao longo de três anos;
    Autor.............: Pedro Avelino;
    Data..............: 06/06/24
    Ex................:
                        BEGIN TRAN

                            DBCC DROPCLEANBUFFERS
                            DBCC FREEPROCCACHE
                            DBCC FREESYSTEMCACHE('ALL')

                            DECLARE @DataInicio DATETIME = GETDATE();

                            EXEC [dbo].[SP_RelatorioNumeroDePedidosTrimestraisAoLongoDeTresAnos]

                            SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;

                        ROLLBACK TRAN 
*/

BEGIN

    DECLARE @DataAtual DATE = GETDATE(); 

    SELECT  x.IdCliente,
            x.Trimestre,
            x.Ano,
            COUNT(x.IdCliente) AS TotalPedidos,
            DENSE_RANK() OVER (PARTITION BY x.Trimestre, x.Ano ORDER BY COUNT(x.IdCliente) DESC)
        AS Ranking   
        FROM (
            SELECT  p.IdCliente AS IdCliente,
                    YEAR(p.DataPedido) AS Ano,
                    DATEPART(QUARTER, p.DataPedido) AS Trimestre
                FROM [dbo].[Pedido] p WITH (NOLOCK)
                WHERE YEAR(p.DataPedido) BETWEEN YEAR(@DataAtual) - 2
                                            AND YEAR(@DataAtual) 
            ) x
        GROUP BY    x.IdCliente,  
                    x.Trimestre,
                    x.Ano;
END;

GO

--QUESTÃO 11
CREATE PROCEDURE [dbo].[SP_StatusDeProducoes]

AS

/*
    Documentação
    Arquivo Fonte.....: Relatorio.sql
    Objetivo..........: Dashboard com status momentâneo de todas as produções;
    Autor.............: Pedro Avelino;
    Data..............: 05/06/24
    Ex................:
*/

BEGIN

    DECLARE @DataAtual DATETIME =  GETDATE();

    WITH MaximoNumeroEtapas AS 
        (
            SELECT  IdProduto,
                    MAX(NumeroEtapa) AS EtapaMaxima 
                FROM [dbo].[EtapaProducao] 
                GROUP BY IdProduto
        ), 
        ContagemPedidoProduto AS 
        (
            SELECT  IdPedidoProduto,
                    COUNT(IdPedidoProduto) AS MaximaEtapaProducao
                FROM [dbo].[Producao]
               GROUP BY IdPedidoProduto
        ),
        ContagemProducoesAtrasadas AS 
        (
            SELECT  IdPedidoProduto,
                    COUNT(IdPedidoProduto) AS ProducoesAtrasadas
                FROM [dbo].[Producao] p
                    INNER JOIN [dbo].[EtapaProducao] ep
                        ON ep.Id = p.IdEtapaProducao
                    WHERE DATEDIFF(MINUTE, p.DataInicio, ISNULL(p.DataTermino, @DataAtual)) > ep.Duracao
                    GROUP BY IdPedidoProduto
        )
        SELECT  IdPedido,
                pp.IdProduto,
                pp.Quantidade,
                Descricao
            FROM [dbo].[PedidoProduto] pp
                INNER JOIN [dbo].[Producao] p
                    ON pp.Id = p.IdPedidoProduto
                INNER JOIN [dbo].[EtapaProducao] ep
                    ON ep.Id = p.IdEtapaProducao
                INNER JOIN [MaximoNumeroEtapas] mne
                    ON pp.IdProduto = mne.IdProduto
                INNER JOIN [ContagemPedidoProduto] cpp
                    ON pp.Id = cpp.IdPedidoProduto
                RIGHT JOIN [ContagemProducoesAtrasadas] cpa
                    ON pp.Id = cpa.IdPedidoProduto

END;

GO

--RELATÓRIO DE PAGINAÇÃO COM OLÍVIO FREITAS
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
