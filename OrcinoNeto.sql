CREATE OR ALTER PROCEDURE [dbo].[ExtratoMovimentacaoMateriaPrima]
    @Id INT = NULL,
    @NomeMateriaPrima VARCHAR(150) = NULL,
    @DataInicial DATE,
    @DataFinal DATE
    AS
    /*
    DOCUMENTACAO
    Arquivo Fonte....: OrcinoNeto.sql
    Objetivo.........: Apresentar saldo medio em estoque materia prima.
                       Sao 3 formas de retornos pelo Id da materia prima, pelo nome da materia prima ou por tudo que estiver entre a data incial e data final.
    Autor............: OrcinoNeto
    Data.............: 06/06/2024
    EX...............:
                        BEGIN TRAN
                            DBCC DROPCLEANBUFFERS
                            DBCC FREEPROCCACHE
                            DBCC FREESYSTEMCACHE('ALL')                           
                           
                            DECLARE @DataInicio DATETIME = GETDATE();

                            EXEC [dbo].[ExtratoMovimentacaoMateriaPrima] null,null,'2020/01/01' , '2020/01/31'

                            SELECT DATEDIFF(MILLISECOND,@DataInicio,GETDATE()) AS Tempo;  
                        ROLLBACK TRAN
    
    */
    BEGIN         
        SELECT  mp.Id AS CodMateriaPrima,
                mp.Nome AS NomeMateriaPrima,                
                memp.DataMovimentacao,
                tm.Nome AS HistoricoMovimentacao,
                memp.Quantidade,
                sed.SaldoMovimentacao,               
                sed.Media AS SaldoMedioMensal 
            FROM [dbo].[MovimentacaoEstoqueMateriaPrima] memp WITH(NOLOCK)
                INNER JOIN [dbo].[TipoMovimentacao] tm WITH(NOLOCK)
                    ON tm.Id = memp.IdTipoMovimentacao
                INNER JOIN [dbo].[EstoqueMateriaPrima] emp WITH(NOLOCK)
                    ON emp.IdMateriaPrima = memp.IdEstoqueMateriaPrima
                INNER JOIN [dbo].[MateriaPrima] mp WITH(NOLOCK)
                    ON mp.Id = emp.IdMateriaPrima
                --Sub Consulta para puxar a media de entrada e saida do mês.
                INNER JOIN  (
                                SELECT  mp.Id,
                                        AVG (                                              
                                                CASE    WHEN tm.Nome = 'Entrada' THEN memp.Quantidade 
                                                        WHEN tm.Nome = 'Saída' THEN -memp.Quantidade
                                                        ELSE 0 END
                                            ) Media, 
                                         SUM(
                                                CASE    WHEN tm.Nome = 'Entrada' THEN memp.Quantidade 
                                                        WHEN tm.Nome = 'Saída' THEN -memp.Quantidade
                                                        ELSE 0 END
                                            ) SaldoMovimentacao                                                                      
                                    FROM [dbo].[MovimentacaoEstoqueMateriaPrima] memp WITH(NOLOCK) 
                                        INNER JOIN [dbo].[TipoMovimentacao] tm WITH(NOLOCK)
                                            ON tm.Id = memp.IdTipoMovimentacao                                                   
                                        INNER JOIN [dbo].[EstoqueMateriaPrima] emp WITH(NOLOCK)
                                            ON emp.IdMateriaPrima = memp.IdEstoqueMateriaPrima
                                        INNER JOIN [dbo].[MateriaPrima] mp WITH(NOLOCK)
                                            ON mp.Id = emp.IdMateriaPrima
                                    WHERE memp.DataMovimentacao >= @DataInicial AND memp.DataMovimentacao <= @DataFinal 
                                    GROUP BY mp.Id
                            ) sed 
                    ON sed.Id = mp.Id 
            --Condição para que so exiba as datas de movimentação de acordo com a data de extrato digitada no parametro.                               
            WHERE memp.DataMovimentacao >= @DataInicial 
                AND memp.DataMovimentacao <= @DataFinal 
                AND mp.Id = ISNULL(@Id,mp.id)
                AND mp.Nome = ISNULL(@NomeMateriaPrima,mp.Nome)                  
            ORDER BY memp.DataMovimentacao
    END
GO