CREATE OR ALTER TRIGGER [dbo].[TRG_ChecarMateriaPrimaProducao]
    ON [dbo].[Producao]
    FOR INSERT
    AS
    /*
        Documentação
        Arquivo Fonte.........: TRG_ChecarMateriaPrimaProducao.sql
        Objetivo..............: Trigger para checar no início da produção se há materia-prima suficiente para finalizar o produto.
                                Caso não haja, será feita a requisição da matéria-prima faltante
                                //ep.NumeroEtapa fixado em 1 pois será sempre o início da produção
        Autor.................: João Victor Maia
        Data..................: 24/05/2024
        Exemplo...............: BEGIN TRAN
                                    SELECT  c.IdProduto,
                                            c.Quantidade AS QuantidadeNecessaria,
                                            c.IdMateriaPrima,
                                            emp.QuantidadeFisica
                                        FROM [dbo].[Composicao] c WITH(NOLOCK)
                                            INNER JOIN [dbo].[EstoqueMateriaPrima] emp WITH(NOLOCK)
                                                ON c.IdMateriaPrima = emp.IdMateriaPrima
                                        WHERE IdProduto = 1

                                    SELECT  IdEstoqueMateriaPrima,
                                            Quantidade
                                        FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                                        WHERE IdEstoqueMateriaPrima IN (1, 2, 3)

                                    INSERT INTO [dbo].[Producao] (IdEtapaProducao, IdPedidoProduto, Quantidade, DataInicio, DataTermino)
                                        VALUES (1, 1, 1, GETDATE() - 2, NULL)

                                     SELECT  c.IdProduto,
                                            c.Quantidade AS QuantidadeNecessaria,
                                            c.IdMateriaPrima,
                                            emp.QuantidadeFisica
                                        FROM [dbo].[Composicao] c WITH(NOLOCK)
                                            INNER JOIN [dbo].[EstoqueMateriaPrima] emp WITH(NOLOCK)
                                                ON c.IdMateriaPrima = emp.IdMateriaPrima
                                        WHERE IdProduto = 1

                                    SELECT  IdEstoqueMateriaPrima,
                                            Quantidade,
                                            IdTipoMovimentacao
                                        FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                                        WHERE IdEstoqueMateriaPrima IN (1, 2, 3)
                                ROLLBACK TRAN
    */
    BEGIN

        --Declarar variáveis
        DECLARE @IdMateriaPrima INT,
                @QuantidadeFaltante INT,
                @QuantidadeNecessaria INT

        --Checar se a produção será iniciada agora
        IF NOT EXISTS   (SELECT TOP 1 1
                            FROM Inserted i
                                INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                                    ON i.EtapaProducao = ep.Id
                            WHERE ep.NumeroEtapa = 1
                        )
            BEGIN
                RETURN
            END

        --Criar tabela temporária
        CREATE TABLE #MateriaPrima  (
                                        IdMateriaPrima INT,
                                        QuantidadeNecessaria INT,
                                        QuantidadeFaltante INT
                                    )

        --Inserir registro das matérias primas da produção na tabela temporária
        INSERT INTO #MateriaPrima
            SELECT  c.IdMateriaPrima,
                    c.Quantidade AS QuantidadeNecessaria,
                    i.Quantidade * c.Quantidade - emp.QuantidadeFisica AS QuantidadeFaltante --Calcular o que será usado menos o que ja tem no estoque
                FROM Inserted i
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        ON i.IdEtapaProducao = ep.Id
                    INNER JOIN [dbo].[Composicao] c WITH(NOLOCK)
                        ON ep.IdProduto = c.IdProduto
                    INNER JOIN [dbo].[EstoqueMateriaPrima] emp WITH(NOLOCK)
                        ON c.IdMateriaPrima = emp.IdMateriaPrima

        --Loopar registros da tabela temporária
        WHILE EXISTS(SELECT TOP 1 1
                        FROM #MateriaPrima
                    )
            BEGIN
                
                --Atribuir valor às variáveis
                SELECT TOP 1    @IdMateriaPrima = IdMateriaPrima,
                                @QuantidadeFaltante = QuantidadeFaltante,
                                @QuantidadeNecessaria = QuantidadeNecessaria
                    FROM #MateriaPrima


                --Inserir movimentação de subtração da matéria prima necessária para a produção
                EXEC [dbo].[SP_InserirMovimentacaoEstoqueMateriaPrima]  @IdMateriaPrima,
                                                                        2,
                                                                        @QuantidadeNecessaria,
                                                                        NULL

                --Remover a matéria prima sensibilizada da tabela temporária
                DELETE TOP(1)
                    FROM #MateriaPrima
            END
    END
GO
