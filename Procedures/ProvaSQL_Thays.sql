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
	Ex.................: DBCC FREEPROCCACHE
						 DBCC DROPCLEANBUFFERS

						 DECLARE @DataInicio DATETIME = GETDATE()

						 EXEC [dbo].[SP_ListarProdutosMaisVendidos] 2022, 2
						 
						 SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS TempoExecucao
*/
	BEGIN

	-- Criar CTE com a soma da quantidade total vendida de cada produto dentro do periodo
		WITH QuantidadeTotal AS (
			SELECT  IdProduto,
                    SUM(Quantidade) AS QuantidadeVendida
				FROM[dbo].[PedidoProduto] pp WITH(NOLOCK)
					INNER JOIN [dbo].[Pedido] p WITH(NOLOCK) 
						ON p.Id = pp.IdPedido
				WHERE YEAR(p.DataEntrega) = ISNULL(@Ano, YEAR(p.DataEntrega)) AND MONTH(p.DataEntrega) = ISNULL(@Mes, MONTH(p.DataEntrega))
				GROUP BY IdProduto
		)
	-- Selecionar e ordenar os produtos
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
	END
GO