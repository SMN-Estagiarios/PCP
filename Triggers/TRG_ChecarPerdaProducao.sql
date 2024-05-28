CREATE OR ALTER TRIGGER [dbo].[TRG_ChecarPerdaProducao]
    ON [dbo].[Producao]
    FOR UPDATE
    AS
    /*
        Documentação
        Arquivo Fonte.........: TRG_ChecarPerdaProducao.sql
        Objetivo..............: Trigger para verificar quando um produto em produção tem seu estoque virtual perdido em alguma das etapas, retornando um aviso
        Autores...............: Adriel Alexande de Sousa, Olívio Freitas, João Victor Maia 
        Data..................: 24/05/2024
        Exemplo...............: BEGIN TRAN
                                   DECLARE @IdProducao INT 

                                   INSERT INTO [dbo].[Producao] (IdEtapaProducao, IdPedidoProduto, DataInicio, DataTermino, Quantidade)
                                    VALUES (1, 7, GETDATE()-1, NULL, 75)

                                    SET @IdProducao = IDENT_CURRENT('Producao')

                                    SELECT  IdEtapaProducao, 
                                            IdPedidoProduto, 
                                            DataInicio, 
                                            DataTermino, 
                                            Quantidade
                                        FROM [dbo].[Producao] WITH(NOLOCK)

                                    UPDATE [dbo].[Producao]
                                        SET Quantidade = 50,
                                            DataTermino = GETDATE()
                                        WHERE Id = @IdProducao
                                ROLLBACK TRAN
        
    */
    BEGIN
        --Declarar variáveis 
        DECLARE @QuantidadeAtual INT,
                @QuantidadeAntiga INT,
                @QuantidadePerdida INT,
                @IdProduto INT,
                @Erro VARCHAR(120)

        --Atribuindo valor às variáveis
        SELECT @QuantidadeAtual = i.Quantidade,
               @IdProduto = ep.IdProduto
            FROM Inserted i   
                INNER JOIN [dbo].[EtapaProducao] ep
                    ON Ep.Id = i.IdEtapaProducao
        
        SELECT @QuantidadeAntiga = Quantidade
            FROM Deleted

        --Checar se a quantidade do fim da produção é menor que a do início dela
        IF @QuantidadeAtual < @QuantidadeAntiga
            BEGIN

                --Calcular a quantidade perdida e atribuir valor à mensagem de erro
                SET @QuantidadePerdida = @QuantidadePerdida - @QuantidadeAtual
                SET @Erro = CONCAT('Houve uma perda durante a produção referente a ', CAST(@QuantidadePerdida AS VARCHAR), ' unidades do produto de ID ' + CAST(@IdProduto AS VARCHAR))
                
                --Enviar erro
                RAISERROR(@Erro, 16, 1)
                RETURN;
            END
    END
GO