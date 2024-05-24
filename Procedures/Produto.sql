CREATE OR ALTER PROCEDURE [dbo].[SP_InserirProduto]	@Nome VARCHAR(45)
	AS
	/*
		Documentacao
		Arquivo Fonte.....: Produto.sql
		Objetivo..........: Inserir registro em [dbo].[Produto]
		Autor.............: Gabriel Damiani Puccinelli
 		Data..............: 10/05/2024
		Ex................: BEGIN TRAN

								EXEC [dbo].[SP_ListarProduto]

								DBCC DROPCLEANBUFFERS
								DBCC FREEPROCCACHE

								DECLARE	@Ret INT,
										@DataInicio DATETIME = GETDATE()

								EXEC @Ret = [dbo].[SP_InserirProduto] 'Dorflex'

								SELECT @Ret AS Retorno, DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

								EXEC [dbo].[SP_ListarProduto]

							ROLLBACK TRAN

		RETORNOS: ........: 0 - SUCESSO.
							1 - JA HA NO BANCO DE DADOS PRODUTO COM ESSE NOME.
	*/
	BEGIN
		--INSERE NA TABELA PRODUTO O REGISTRO DO NOVO PRODUTO EM QUESTAO
		INSERT INTO Produto (Nome)
			VALUES	(@Nome)

		IF @@ROWCOUNT = 1
			RETURN 0

		RETURN 1
	END
GO


CREATE OR ALTER PROCEDURE [dbo].[SP_ListarProduto]
	AS
	/*
		BEGIN TRAN

		Documentacao
		Arquivo Fonte.....: Produto.sql
		Objetivo..........: Listar itens do [dbo].[Produto]
		Autor.............: Gabriel Damiani Puccinelli
 		Data..............: 10/05/2024
		Ex................: BEGIN TRAN

								DBCC DROPCLEANBUFFERS
								DBCC FREEPROCCACHE

								DECLARE	@Ret INT,
										@DataInicio DATETIME = GETDATE()

								EXEC @Ret = [dbo].[SP_ListarProduto]

								SELECT @Ret AS Retorno, DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo

								EXEC [dbo].[SP_ListarProduto]

							ROLLBACK TRAN

		RETORNOS: ........: 0 - SUCESSO.
							1 - JA HA NO BANCO DE DADOS PRODUTO COM ESSE NOME.
	*/
	BEGIN
		--LISTA TODOS OS PRODUTOS CADASTRADOS NO BANCO
		SELECT	Nome
			FROM Produto WITH(NOLOCK)
	END
GO