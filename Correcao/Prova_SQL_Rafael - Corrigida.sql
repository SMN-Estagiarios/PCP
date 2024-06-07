CREATE OR ALTER PROCEDURE [dbo].[SP_CalcularSaldoMedioMateriaPrima]
    @Ano INT = NULL
    AS
        /*
            Documentacao
            Arquivo Fonte.....: Prova_SQL_Rafael.sql
            Objetivo..........: Criar um demonstrativo com base no saldo medio em estoque do peso que o estoque de materia prima representa em quilos
            Autor.............: Rafael Mauricio
            Data..............: 06/06/2024
            Ex................: BEGIN TRAN
                                    DBCC FREEPROCCACHE
                                    DBCC DROPCLEANBUFFERS
                                    DBCC FREESYSTEMCACHE('ALL')

                                    DECLARE @DataInicio DATETIME = GETDATE(),
                                            @Retorno INT;

                                    EXEC @Retorno = [dbo].[SP_CalcularSaldoMedioMateriaPrima] 2022

                                    SELECT  @Retorno AS Retorno,
                                            DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao;
                                ROLLBACK TRAN
            Retornos.........:  00 - Sucesso
                                01 - Erro: Valor para ano inválido
                                02 - Nao existe registros para o ano passado como parametro
        */  
    BEGIN
    
        -- Validacao do parametro de entrada
        IF @Ano IS NULL
            RETURN 1;

        IF NOT EXISTS   (
                            SELECT TOP 1 1
                                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                                WHERE YEAR(DataMovimentacao) = @Ano
                        )
            RETURN 2;

        -- Criacao de tabela temporaria para evitar reutilizacao de codigo
        CREATE TABLE #Tabela (
            CodigoMateriaPrima INT,
            NomeMateriaPrima VARCHAR(100),
            JaneiroEntrada DECIMAL(15,2),
            JaneiroSaida DECIMAL(15,2),
            FevereiroEntrada DECIMAL(15,2),
            FevereiroSaida DECIMAL(15,2),
            MarcoEntrada DECIMAL(15,2),
            MarcoSaida DECIMAL(15,2),
            AbrilEntrada DECIMAL(15,2),
            AbrilSaida DECIMAL(15,2),
            MaioEntrada DECIMAL(15,2),
            MaioSaida DECIMAL(15,2),
            JunhoEntrada DECIMAL(15,2),
            JunhoSaida DECIMAL(15,2),
            JulhoEntrada DECIMAL(15,2),
            JulhoSaida DECIMAL(15,2),
            AgostoEntrada DECIMAL(15,2),
            AgostoSaida DECIMAL(15,2),
            SetembroEntrada DECIMAL(15,2),
            SetembroSaida DECIMAL(15,2),
            OutubroEntrada DECIMAL(15,2),
            OutubroSaida DECIMAL(15,2),
            NovembroEntrada DECIMAL(15,2),
            NovembroSaida DECIMAL(15,2),
            DezembroEntrada DECIMAL(15,2),
            DezembroSaida DECIMAL(15,2)
        )

        -- Insercao de dados na tabela temporaria
        INSERT INTO #Tabela (CodigoMateriaPrima, NomeMateriaPrima, JaneiroEntrada, JaneiroSaida, FevereiroEntrada, FevereiroSaida, MarcoEntrada,
                                MarcoSaida, AbrilEntrada, AbrilSaida, MaioEntrada, MaioSaida, JunhoEntrada, JunhoSaida, JulhoEntrada, JulhoSaida,
                                AgostoEntrada, AgostoSaida, SetembroEntrada, SetembroSaida, OutubroEntrada, OutubroSaida, NovembroEntrada,
                                NovembroSaida, DezembroEntrada, DezembroSaida)
            SELECT  mp.Id AS CodigoMateriaPrima,
                mp.Nome AS NomeMateriaPrima,
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 1 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 1 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 2 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 2 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 3 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 3 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 4 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 4 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 5 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 5 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 6 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 6 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 7 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 7 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 8 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 8 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 9 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 9 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 10 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 10 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 11 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 11 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 12 AND memp.IdTipoMovimentacao = 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2)),
                CAST(AVG(CASE WHEN MONTH(DataMovimentacao) = 12 AND memp.IdTipoMovimentacao <> 1 THEN (memp.Quantidade / 1000.00) END) AS DECIMAL(15,2))
            FROM [dbo].[MovimentacaoEstoqueMateriaPrima] memp WITH(NOLOCK)
                INNER JOIN [dbo].[EstoqueMateriaPrima] em WITH(NOLOCK)
                    ON em.IdMateriaPrima = memp.IdEstoqueMateriaPrima
                INNER JOIN [dbo].[MateriaPrima] mp WITH(NOLOCK)
                    ON mp.Id = em.IdMateriaPrima
            WHERE YEAR(DataMovimentacao) = @Ano
            GROUP BY    mp.Id,
                        mp.Nome
            ORDER BY mp.Id;

        -- Relatorio de entrada e saida por materia prima
        SELECT  CodigoMateriaPrima,
                NomeMateriaPrima,
                JaneiroEntrada,
                JaneiroSaida,
                FevereiroEntrada,
                FevereiroSaida,
                MarcoEntrada,
                MarcoSaida,
                AbrilEntrada,
                AbrilSaida,
                MaioEntrada,
                MaioSaida,
                JunhoEntrada,
                JunhoSaida,
                JulhoEntrada,
                JulhoSaida,
                AgostoEntrada,
                AgostoSaida,
                SetembroEntrada,
                SetembroSaida,
                OutubroEntrada,
                OutubroSaida,
                NovembroEntrada,
                NovembroSaida,
                DezembroEntrada,
                DezembroSaida
            FROM #Tabela

    -- Gerando relatorio do peso total
    SELECT  SUM(JaneiroEntrada) AS TotalEntradaJaneiro,
            SUM(JaneiroSaida) AS TotalSaidadaJaneiro,
            SUM(FevereiroEntrada) AS TotalEntradaFevereiro,
            SUM(FevereiroSaida) AS TotalSaidadaFevereiro,
            SUM(MarcoEntrada) AS TotalEntradaMarco,
            SUM(MarcoSaida) AS TotalSaidadaMarco,
            SUM(AbrilEntrada) AS TotalEntradaAbril,
            SUM(AbrilSaida) AS TotalSaidadaAbril,
            SUM(MaioEntrada) AS TotalEntradaMaio,
            SUM(MaioSaida) AS TotalSaidadaMaio,
            SUM(JunhoEntrada) AS TotalEntradaJunho,
            SUM(JunhoSaida) AS TotalSaidadaJunho,
            SUM(JulhoEntrada) AS TotalEntradaJulho,
            SUM(JulhoSaida) AS TotalSaidadaJulho,
            SUM(AgostoEntrada) AS TotalEntradaAgosto,
            SUM(AgostoSaida) AS TotalSaidadaAgosto,
            SUM(SetembroEntrada) AS TotalEntradaSetembro,
            SUM(SetembroSaida) AS TotalSaidadaSetembro,
            SUM(OutubroEntrada) AS TotalEntradaOutubro,
            SUM(OutubroSaida) AS TotalSaidadaOutubro,
            SUM(NovembroEntrada) AS TotalEntradaNovembro,
            SUM(NovembroSaida) AS TotalSaidadaNovembro,
            SUM(DezembroEntrada) AS TotalEntradaDezembro,
            SUM(DezembroSaida) AS TotalSaidadaDezembro
        FROM #Tabela

        -- Excluindo tabela temporaria
        DROP TABLE #Tabela
        RETURN 0
    END;
GO
