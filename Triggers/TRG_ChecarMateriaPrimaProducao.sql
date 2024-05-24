CREATE OR ALTER TRIGGER [dbo].[TRG_ChecarMateriaPrimaProducao]
    ON [dbo].[Producao]
    FOR INSERT
    AS
    /*
        Documentação
        Arquivo Fonte.........: TRG_ChecarMateriaPrimaProducao.sql
        Objetivo..............: Trigger para checar no início da produção se há materia-prima suficiente para finalizar o produto.
                                Caso não haja, será feita a requisição da matéria-prima
        Autor.................: João Victor Maia
        Data..................: 24/05/2024
        Exemplo...............: BEGIN TRAN
                                    INSERT INTO [dbo].[Producao] (IdEtapaProducao, IdPedidoProduto, Quantidade, DataInicio, DataTermino)
                                        VALUES (1, 1, 5, GETDATE() - 2, NULL)
                                ROLLBACK TRAN            
    */
    BEGIN
        SELECT *
            FROM Inserted i
                INNER JOIN [dbo].[PedidoProduto] pp
                    ON i.IdPedidoProduto = pp.Id
                INNER JOIN [dbo].[Composicao] c
                    ON pp.IdProduto = c.IdProduto
    END
GO