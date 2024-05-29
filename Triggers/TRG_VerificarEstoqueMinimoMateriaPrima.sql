CREATE OR ALTER TRIGGER [dbo].[TRG_VerificarEstoqueMinimoMateriaPrima]
    ON [dbo].[EstoqueMateriaPrima]
    FOR UPDATE
    AS
        /*  
            Documentação
            Arquivo fonte..........: TRG_VerificarEstoqueMinimoMateriaPrima.sql
            Objetivo...............: Verificar se o estoque da matéria prima está abaixo do mínimo
            Autor..................: Gustavo Targino
            Data...................: 27/05/2024
            Ex.....................: BEGIN TRAN
                                        
                                        DECLARE @DataInicio DATETIME = GETDATE()

                                        SELECT *
                                            FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                                            
                                            WHERE IdEstoqueMateriaPrima = 1
                                        
                                        SELECT *
                                            FROM [dbo].[EstoqueMateriaPrima] WITH(NOLOCK)
                                            WHERE IdMateriaPrima = 1


                                        EXEC [dbo].[SP_InserirMovimentacaoEstoqueMateriaPrima] 1, 2, 20000
                                        EXEC [dbo].[SP_InserirMovimentacaoEstoqueMateriaPrima] 1, 2, 20000

                                        SELECT *
                                            FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                                            WHERE IdEstoqueMateriaPrima = 1
                                        
                                        SELECT *
                                            FROM [dbo].[EstoqueMateriaPrima] WITH(NOLOCK)
                                             WHERE IdMateriaPrima = 1

                                     ROLLBACK TRAN
        */
    BEGIN
        DECLARE @DataAtual DATETIME = GETDATE()
        -- Verificar se o update que foi feito tornou a quantidade física menor que a quantidade mínima
        IF EXISTS (
                    SELECT TOP 1 1
                        FROM INSERTED i
                        WHERE i.QuantidadeFisica < i.QuantidadeMinima
                  )
            BEGIN
                --Caso o estoque real seja menor que o mínimo, gerar um insert em MovimentacaoEstoqueMateriaPrima
                INSERT INTO [dbo].[MovimentacaoEstoqueMateriaPrima] (
                                                                        IdTipoMovimentacao,
                                                                        IdEstoqueMateriaPrima,
                                                                        DataMovimentacao,
                                                                        Quantidade
                                                                    )
                    SELECT  1,
                            i.IdMateriaPrima,
                            @DataAtual,
                            i.QuantidadeMinima - i.QuantidadeFisica
                        FROM INSERTED i
                        WHERE i.QuantidadeFisica < i.QuantidadeMinima
            END
                
    END
GO