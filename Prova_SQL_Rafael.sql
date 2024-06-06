CREATE OR ALTER PROCEDURE [dbo].[SP_CalcularSaldoMedioMateriaPrima]
@Mes INT
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

                                DECLARE @DataInicio DATETIME = GETDATE();

                                EXEC [dbo].[SP_ListarPesoEstoqueMateriaPrima] 1, 1

                                SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao;
        Retornos.........:  0 - Sucesso
                            1 - Erro: Valor para mês inválido
                            ROLLBACK TRAN
    */  
    BEGIN
    
            -- Validação do parâmetro de entrada
            IF @Mes IS NULL OR @Mes < 1 OR @Mes > 12
            BEGIN
                RETURN 1;
            END
    
            -- Obtém o ano atual
            DECLARE @Ano INT = YEAR(GETDATE());
    
            -- Calcula o primeiro e último dia do mês informado
            DECLARE @DataInicio DATE = DATEFROMPARTS(@Ano, @Mes, 1);
            DECLARE @DataFim DATE = EOMONTH(@DataInicio);
    
            -- Calcula o saldo médio em estoque para cada matéria-prima no mês
            SELECT  mp.Id AS CodigoMateriaPrima,
                    mp.Nome AS NomeMateriaPrima,
                    AVG(emp.QuantidadeFisica / 1000.0) AS PesoEmQuilos -- Converte gramas para quilos
                FROM dbo.MateriaPrima mp
                    INNER JOIN dbo.EstoqueMateriaPrima emp 
                        ON mp.Id = emp.IdMateriaPrima
                    INNER JOIN dbo.MovimentacaoEstoqueMateriaPrima memp 
                        ON emp.IdMateriaPrima = memp.IdEstoqueMateriaPrima
                WHERE memp.DataMovimentacao < @DataFim  -- Considera apenas movimentações antes do fim do mês
                GROUP BY mp.Id, mp.Nome;
    
            -- Calcula e exibe o total em quilos de todas as matérias-primas no mês
            SELECT SUM(emp.QuantidadeFisica / 1000.0) AS TotalEmQuilos
                FROM dbo.EstoqueMateriaPrima emp
                    INNER JOIN dbo.MovimentacaoEstoqueMateriaPrima memp 
                        ON emp.IdMateriaPrima = memp.IdEstoqueMateriaPrima
                WHERE memp.DataMovimentacao < @DataFim; -- Considera apenas movimentações antes do fim do mês
        RETURN 0
    END;
