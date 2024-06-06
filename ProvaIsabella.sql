CREATE OR ALTER PROCEDURE [dbo].[SP_ConsumoMateriaPrima2]
    @AnoProcessamento INT = NULL
    AS
    /*
    Documentacao
    Arquivo fonte........: ProvaIsabella.sql
    Objetivo.............: Procedure que lista o consumo mensal de todas as materias primas e a media anual passado o ano como parametro
    Autor................: Isabella Siqueira
    Data.................: 06/06/2024
    Ex...................: BEGIN TRAN
								DECLARE @DataInicio DATETIME = GETDATE(),
										@Retorno INT;

								DBCC FREEPROCCACHE
								DBCC FREESYSTEMCACHE('ALL')
								DBCC DROPCLEANBUFFERS

								EXEC @Retorno = [dbo].[SP_ConsumoMateriaPrima2] 2023
									
								SELECT	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;
							ROLLBACK TRAN
    */
    BEGIN
    --Capturando a soma da movimentacao mensal de cada mes
        WITH MovimentacaoMensal1 AS (    
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 1
                GROUP BY IdEstoqueMateriaPrima
        ), MovimentacaoMensal2 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 2
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal3 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 3
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal4 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 4
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal5 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 5
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal6 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 6
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal7 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 7
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal8 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 8
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal9 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 9
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal10 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 10
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal11 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 11
                GROUP BY IdEstoqueMateriaPrima
        ) , MovimentacaoMensal12 AS (
            SELECT  IdEstoqueMateriaPrima,  
                    SUM(CASE WHEN IdTipoMovimentacao = 1 THEN Quantidade*(-1) ELSE Quantidade END ) AS SomaMovimentacao
                FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                WHERE YEAR(DataMovimentacao) = @AnoProcessamento
                AND MONTH(DataMovimentacao) = 12
                GROUP BY IdEstoqueMateriaPrima
        )
        --Fazendo o select que retornara a tabela solicitada
        SELECT  mp.Id,
                mp.Nome,
                mm1.SomaMovimentacao AS 'Mes 1',
                mm2.SomaMovimentacao AS 'Mes 2',
                mm3.SomaMovimentacao AS 'Mes 3',
                mm4.SomaMovimentacao AS 'Mes 4',
                mm5.SomaMovimentacao AS 'Mes 5',
                mm6.SomaMovimentacao AS 'Mes 6',
                mm7.SomaMovimentacao AS 'Mes 7',
                mm8.SomaMovimentacao AS 'Mes 8',
                mm9.SomaMovimentacao AS 'Mes 9',
                mm10.SomaMovimentacao AS 'Mes 10',
                mm11.SomaMovimentacao AS 'Mes 11',
                mm12.SomaMovimentacao AS 'Mes 12',
                ( --A media anual de movimentacoes 
                    mm1.SomaMovimentacao +
                    mm2.SomaMovimentacao +
                    mm3.SomaMovimentacao +
                    mm4.SomaMovimentacao +
                    mm5.SomaMovimentacao +
                    mm6.SomaMovimentacao +
                    mm7.SomaMovimentacao +
                    mm8.SomaMovimentacao +
                    mm9.SomaMovimentacao +
                    mm10.SomaMovimentacao +
                    mm11.SomaMovimentacao +
                    mm12.SomaMovimentacao
                )/12 AS Media
            FROM [dbo].[MateriaPrima] mp WITH(NOLOCK)
                INNER JOIN MovimentacaoMensal1 mm1
                    ON mp.Id = mm1.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal2 mm2
                    ON mp.Id = mm2.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal3 mm3
                    ON mp.Id = mm3.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal4 mm4
                    ON mp.Id = mm4.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal5 mm5
                    ON mp.Id = mm5.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal6 mm6
                    ON mp.Id = mm6.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal7 mm7
                    ON mp.Id = mm7.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal8 mm8
                    ON mp.Id = mm8.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal9 mm9
                    ON mp.Id = mm9.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal10 mm10
                    ON mp.Id = mm10.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal11 mm11
                    ON mp.Id = mm11.IdEstoqueMateriaPrima
                INNER JOIN MovimentacaoMensal12 mm12
                    ON mp.Id = mm12.IdEstoqueMateriaPrima
                ORDER BY Media ASC
    END
GO