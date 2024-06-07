CREATE OR ALTER PROCEDURE [dbo].[SP_ListarProdutosMaisVendidos]
	@Ano INT = NULL,
	@Mes INT = NULL
	AS 
	/*
		Documentacao
		Arquivo Fonte......: ProvaSQL_Thays.sql
		Objetivo...........: Listar produtos mais vendidos dentro de um periodo
		Autor..............: Thays Carvalho
		Data...............: 06/06/2024
		Objetivo Alteração.: Correção de indentação do código e paginação do resultado
		Autor Alteração....: João Victor Maia
		Data Alteração.....: 07/06/2024
		Ex.................: DBCC FREEPROCCACHE
							 DBCC DROPCLEANBUFFERS

							 DECLARE @DataInicio DATETIME = GETDATE(),
							 		 @Ret INT

							 EXEC @Ret = [dbo].[SP_ListarProdutosMaisVendidos] 2022, 2
							
							 SELECT @Ret AS Retorno,
							 		DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao
		Retornos...........: 0 - Sucesso
							 1 - Erro: o ano passado como parâmetro é superior ao ano atual
							 2 - Erro: o mês passado como parâmetro não existe
	*/
	BEGIN

		--Checar se o ano passado é válido
		IF @Ano > YEAR(GETDATE())
			BEGIN
				RETURN 1
			END

		--Checar se o mês passado é válido
		IF @Mes < 1 AND @Mes > 12
			BEGIN
				RETURN 2
			END

		-- Criar CTE com a soma da quantidade total vendida de cada produto dentro do periodo
			;WITH QuantidadeTotal AS (
				SELECT  IdProduto,
						SUM(Quantidade) AS QuantidadeVendida
					FROM[dbo].[PedidoProduto] pp WITH(NOLOCK)
						INNER JOIN [dbo].[Pedido] p WITH(NOLOCK) 
							ON p.Id = pp.IdPedido
					WHERE 	YEAR(p.DataEntrega) = ISNULL(@Ano, YEAR(p.DataEntrega)) 
							AND MONTH(p.DataEntrega) = ISNULL(@Mes, MONTH(p.DataEntrega))
					GROUP BY IdProduto
			)
				-- Selecionar e ordenar os produtos do 11° ao 20°
				SELECT
					@Ano AS Ano,
					@Mes AS Mes,
					pt.Id AS CodigoProduto,
					pt.Nome AS NomeProduto,
					qt.QuantidadeVendida
					FROM QuantidadeTotal qt
						INNER JOIN [dbo].[Produto] pt WITH(NOLOCK)
							ON qt.IdProduto = pt.Id
					ORDER BY qt.QuantidadeVendida DESC
					OFFSET 10 ROWS
					FETCH NEXT 10 ROWS ONLY
	END
GO