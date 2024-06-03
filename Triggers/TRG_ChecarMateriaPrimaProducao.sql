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
                                            emp.QuantidadeFisica,
                                            emp.QuantidadeMinima
                                        FROM [dbo].[Composicao] c WITH(NOLOCK)
                                            INNER JOIN [dbo].[EstoqueMateriaPrima] emp WITH(NOLOCK)
                                                ON c.IdMateriaPrima = emp.IdMateriaPrima
                                        WHERE IdProduto IN (1,2)

                                    SELECT *
                                        FROM [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima] WITH(NOLOCK)

                                    INSERT INTO [dbo].[Producao] (IdEtapaProducao, IdPedidoProduto, Quantidade, DataInicio, DataTermino)
                                        VALUES (1, 1, 10, GETDATE() - 2, NULL),
                                               (4, 2, 200, GETDATE() -2, NULL)
 
                                     SELECT  c.IdProduto,
                                            c.Quantidade AS QuantidadeNecessaria,
                                            c.IdMateriaPrima,
                                            emp.QuantidadeFisica
                                        FROM [dbo].[Composicao] c WITH(NOLOCK)
                                            INNER JOIN [dbo].[EstoqueMateriaPrima] emp WITH(NOLOCK)
                                                ON c.IdMateriaPrima = emp.IdMateriaPrima
                                        WHERE IdProduto IN (1,2)

                                    SELECT *
                                        FROM [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima] WITH(NOLOCK)

                                    SELECT  IdEstoqueMateriaPrima,
                                            Quantidade,
                                            IdTipoMovimentacao
                                        FROM [dbo].[MovimentacaoEstoqueMateriaPrima] WITH(NOLOCK)
                                        WHERE IdEstoqueMateriaPrima IN (1, 2, 3, 4, 5, 6)
                                ROLLBACK TRAN
    */
    BEGIN

        --Declarar variáveis
        DECLARE @IdMateriaPrima INT,
                @QuantidadeFaltante INT,
                @QuantidadeNecessaria INT,
                @IdPedido INT,
                @IdMovimentacao INT,
                @DataMovimentacao DATETIME;


        --Checar se a produção será iniciada agora
        IF NOT EXISTS   (SELECT TOP 1 1
                            FROM Inserted i
                                INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                                    ON i.IdEtapaProducao = ep.Id
                            WHERE ep.NumeroEtapa = 1
                        )
            BEGIN
                RETURN
            END

        --Criar tabela temporária
        CREATE TABLE #MateriaPrima  (   
                                        IdPedido INT,
                                        IdMateriaPrima INT,
                                        QuantidadeNecessaria INT,
                                        QuantidadeFaltante INT,
                                        DataTermino DATETIME
                                    )

        --Inserir registro das matérias primas da produção na tabela temporária
        INSERT INTO #MateriaPrima
            SELECT  pp.IdPedido,
                    c.IdMateriaPrima,
                    i.Quantidade * c.Quantidade AS QuantidadeNecessaria,
                    i.Quantidade * c.Quantidade - emp.QuantidadeFisica AS QuantidadeFaltante, --Calcular o que será usado menos o que ja tem no estoque
                    i.DataInicio 
                FROM Inserted i
                    INNER JOIN [dbo].[EtapaProducao] ep WITH(NOLOCK)
                        ON i.IdEtapaProducao = ep.Id
                    INNER JOIN [dbo].[Composicao] c WITH(NOLOCK)
                        ON ep.IdProduto = c.IdProduto
                    INNER JOIN [dbo].[EstoqueMateriaPrima] emp WITH(NOLOCK)
                        ON c.IdMateriaPrima = emp.IdMateriaPrima
                    INNER JOIN [dbo].[PedidoProduto] pp WITH(NOLOCK)
                        ON i.IdPedidoProduto = pp.Id;

        --Loopar registros da tabela temporária
        WHILE EXISTS(
                        SELECT TOP 1 1
                            FROM #MateriaPrima
                    )
            BEGIN
                --Atribuir valor às variáveis
                SELECT TOP 1    @IdPedido = IdPedido,
                                @IdMateriaPrima = IdMateriaPrima,
                                @QuantidadeFaltante = QuantidadeFaltante,
                                @QuantidadeNecessaria = QuantidadeNecessaria,
                                @DataMovimentacao = DataTermino
                    FROM #MateriaPrima


                IF @QuantidadeFaltante > 0
                    BEGIN
                        --Inserir movimentação de adição da matéria prima do faltante somado ao estoque mínimo
                        INSERT INTO [dbo].[MovimentacaoEstoqueMateriaPrima] (IdTipoMovimentacao, IdEstoqueMateriaPrima,
                                                                                DataMovimentacao, Quantidade)
                            VALUES (1, @IdMateriaPrima, @DataMovimentacao, @QuantidadeFaltante)

                        SET @IdMovimentacao = SCOPE_IDENTITY();

                        INSERT INTO [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima] (IdPedido, IdMovimentacaoEstoqueMateriaPrima)
                            VALUES (@IdPedido, @IdMovimentacao);
                    END

                --Inserir movimentação de subtração da matéria prima necessária para a produção
                INSERT INTO [dbo].[MovimentacaoEstoqueMateriaPrima] (IdTipoMovimentacao, IdEstoqueMateriaPrima,
                                                                                DataMovimentacao, Quantidade)
                            VALUES (2, @IdMateriaPrima, @DataMovimentacao, @QuantidadeNecessaria)

                SET @IdMovimentacao = SCOPE_IDENTITY();

                INSERT INTO [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima] (IdPedido, IdMovimentacaoEstoqueMateriaPrima)
                    VALUES (@IdPedido, @IdMovimentacao);

                --Remover a matéria prima sensibilizada da tabela temporária
                DELETE TOP(1)
                    FROM #MateriaPrima

                SELECT  @IdMateriaPrima = NULL,
                        @QuantidadeFaltante = NULL,
                        @QuantidadeNecessaria = NULL,
                        @IdPedido = NULL,
                        @IdMovimentacao = NULL;
            END

            DROP TABLE #MateriaPrima;
    END
GO