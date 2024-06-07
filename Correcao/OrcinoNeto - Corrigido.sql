CREATE OR ALTER PROCEDURE [dbo].[ExtratoMovimentacaoMateriaPrima]
    @Id INT = NULL,
    @NomeMateriaPrima VARCHAR(150) = NULL,
    @DataInicial DATE,
    @DataFinal DATE
    AS
    /*
    DOCUMENTACAO
    Arquivo Fonte....: OrcinoNeto - Corrigido.sql
    Objetivo.........: Apresentar saldo medio em estoque materia prima.
                       Sao 3 formas de retornos pelo Id da materia prima, pelo nome da materia prima ou por tudo que estiver entre a data incial e data final.
    Autor............: Orcino Neto e Pedro Avelino
    Data.............: 06/06/2024
    EX...............:
                        BEGIN TRAN
                            DBCC DROPCLEANBUFFERS
                            DBCC FREEPROCCACHE
                            DBCC FREESYSTEMCACHE('ALL')                           
                           
                            DECLARE @DataInicio DATETIME = GETDATE(),
                                    @Retorno INT;

                            EXEC @Retorno = [dbo].[ExtratoMovimentacaoMateriaPrima] null, null, '2024/04/02' , '2024/05/01'

                            SELECT  @Retorno AS Retorno,
                                    DATEDIFF(MILLISECOND,@DataInicio,GETDATE()) AS Tempo;  
                        ROLLBACK TRAN

    Retornos:.........: 0 - Sucesso!
                        1 - Período sem registros de movimentação de matéria-prima
                        2 - Data final inválida
                        3 - Data inicial inválida
    
    */
    BEGIN 

        --Verificação da data de incial de entrada 
        IF @DataInicial < (
                            SELECT MIN(DataMovimentacao)
                                FROM [dbo].[MovimentacaoEstoqueMateriaPrima]
                        )
                OR @DataInicial > GETDATE()
            BEGIN
                RETURN 3;
            END
        
        --Verificação da validade da data
        IF @DataFinal < (
                            SELECT MIN(DataMovimentacao)
                                FROM [dbo].[MovimentacaoEstoqueMateriaPrima]
                        ) 
                OR @DataFinal > GETDATE()
            BEGIN
                RETURN 2;
            END

              IF NOT EXISTS (
                        SELECT TOP 1 1
                            FROM MovimentacaoEstoqueMateriaPrima
                            WHERE DataMovimentacao >= @DataInicial
                                AND DataMovimentacao <= @DataFinal
        )
            BEGIN
                RETURN 1;
            END

        --Consulta de extrato de matéria-prima        
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
                --SubConsulta que retorna a média de entrada e saída do mês.
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
            --Condição para que só exiba as datas de movimentação de acordo com a data de extrato digitada no paramêtro.                               
            WHERE memp.DataMovimentacao >= @DataInicial 
                AND memp.DataMovimentacao <= @DataFinal 
                AND mp.Id = ISNULL(@Id,mp.id)
                AND mp.Nome = ISNULL(@NomeMateriaPrima,mp.Nome)                  
            ORDER BY memp.DataMovimentacao

        RETURN 0;
    END;
GO

