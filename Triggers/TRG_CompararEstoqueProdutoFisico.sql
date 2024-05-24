CREATE OR ALTER TRIGGER [dbo].[TRG_CompararEstoqueProdutoReal]
    ON [dbo].[EstoqueProduto]
    FOR UPDATE
    AS
    /*
        Documentação
        Arquivo Fonte.........: TRG_CompararEstoqueProdutoReal.sql
        Objetivo..............: Trigger para comparar se o estoque real está abaixo do estoque mínimo.
                                Caso o estoque real esteja menor, haverá um aviso para gerar mais estoque
        Autor.................: João Victor Maia, Adriel Alexsander, Olívio Freitas
        Data..................: 24/05/2024
        Exemplo...............: BEGIN TRAN
                                    UPDATE [dbo].[EstoqueProduto]
                                        SET QuantidadeFisica = 0
                                ROLLBACK TRAN
        Retorno...............:
    */
    BEGIN

        --Declarar variáveis
        DECLARE @IdProduto INT,
                @EstoqueReal INT,
                @QuantidadeMinima SMALLINT,
                @Erro VARCHAR(100)

        --Atribuir valor à IdProduto
        SELECT  @IdProduto = IdProduto,
                @QuantidadeMinima = QuantidadeMinima
            FROM Inserted

        --Atribuir valor ao EstoqueReal
        SELECT  @EstoqueReal = [dbo].[FNC_CalcularEstoqueReal] (@IdProduto)

        SET @Erro = CONCAT('O estoque real do produto de Id ', @IdProduto, ' está menor que o estoque mínimo.') 

        IF @EstoqueReal < @QuantidadeMinima
            BEGIN
                RAISERROR(@Erro, 16, 1)
            END
    END
GO