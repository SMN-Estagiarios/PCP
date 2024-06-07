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

								EXEC @Retorno = [dbo].[SP_ConsumoMateriaPrima2] NULL
									
								SELECT	@Retorno AS Retorno,
										DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo;
							ROLLBACK TRAN
    */
    BEGIN
        DECLARE @DataProcessamento DATE, 
                @DataAtual DATE = GETDATE()

        --Trata o nulo na variável, caso for, assume ano atual
       IF @AnoProcessamento IS NULL
           SET @AnoProcessamento = YEAR(@DataAtual);

        --Fazendo o select que retornara a tabela solicitada
        SELECT      mp.Id,
                    mp.Nome,
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 1) 
                                THEN memp.Quantidade / 1000
                                ELSE 0 
                        END ) AS DECIMAL(15,3)) AS 'Mes1',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 2) 
                                THEN memp.Quantidade / 1000
                                ELSE 0
                        END) AS DECIMAL(15,3)) AS 'Mes2',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 3) 
                                THEN memp.Quantidade / 1000
                                ELSE 0 
                        END ) AS DECIMAL(15,3)) AS 'Mes3',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 4) 
                                THEN memp.Quantidade /1000 
                                ELSE 0
                            END) AS DECIMAL(15,3)) AS 'Mes4',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 5) 
                                THEN memp.Quantidade /1000
                                ELSE 0 
                        END ) AS DECIMAL(15,3))AS 'Mes5',
                    CAST(SUM( CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 6) 
                                THEN memp.Quantidade /1000
                                ELSE 0 
                        END) AS DECIMAL(15,3)) AS 'Mes6',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 7) 
                                THEN memp.Quantidade /1000
                                ELSE 0
                        END) AS DECIMAL(15,3)) AS 'Mes7',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 8) 
                                THEN memp.Quantidade /1000
                                ELSE 0 
                        END ) AS DECIMAL(15,3))AS 'Mes8',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 9) 
                                THEN memp.Quantidade /1000
                                ELSE 0
                            END )/1000 AS DECIMAL(15,3))AS 'Mes9',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 10) 
                                THEN memp.Quantidade /1000
                                ELSE 0 
                        END) AS DECIMAL(15,3))AS 'Mes10',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 11) 
                                THEN memp.Quantidade /1000
                                ELSE 0
                            END) AS DECIMAL(15,3))AS 'Mes11',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento AND MONTH(DataMovimentacao) = 12 ) 
                                THEN memp.Quantidade /1000
                                ELSE 0 
                        END) AS DECIMAL(15,3) )AS 'Mes12',
                    CAST(SUM(CASE WHEN (YEAR(DataMovimentacao) = @AnoProcessamento) 
                                THEN memp.Quantidade /1000
                                ELSE 0 
                        END) /12 AS DECIMAL(15,3) ) AS 'MediaAno'
            FROM [dbo].[MateriaPrima] mp WITH(NOLOCK)
                INNER JOIN [dbo].[MovimentacaoEstoqueMateriaPrima] memp WITH(NOLOCK)
                    ON memp.IdEstoqueMateriaPrima = mp.Id
            WHERE memp.IdTipoMovimentacao = 2
                AND YEAR(DataMovimentacao) = @AnoProcessamento 
            GROUP BY mp.Id,
                     mp.Nome
    END
GO

/*
select * from TipoMovimentacao

SELECT CAST(SUM(mp.Quantidade /1000) AS DECIMAL(15,3))AS 'Mes 12' ,
       IdEstoqueMateriaPrima
    FROM MovimentacaoEstoqueMateriaPrima mp
        WHERE IdTipoMovimentacao = 2
        AND YEAR(DataMovimentacao) = 2022
        AND MONTH(DataMovimentacao) = 1
        AND IdEstoqueMateriaPrima = 29
    GROUP BY IdEstoqueMateriaPrima
*/
