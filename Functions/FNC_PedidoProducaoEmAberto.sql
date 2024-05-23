CREATE OR ALTER FUNCTION [dbo].[FNC_PedidoProducaoEmAberto](@IdPedido INT)
	RETURNS @Tabela TABLE (
							IdPedido INT, 
							IdEtapaProducao INT,
							DataInicioProducao DATETIME,
							QuantidadeProducao INT
						  )
AS
	BEGIN
		--insere na tabela da funcao os pedidos que possuem producao em aberto 
		INSERT INTO @Tabela
			SELECT p.Id,
					pr.IdEtapaProducao,
					pr.DataInicio,
					pr.Quantidade
				FROM Pedido p WITH(NOLOCK)
					INNER JOIN PedidoProduto pp WITH(NOLOCK)
						ON pp.IdPedido = p.Id
					INNER JOIN Producao pr WITH(NOLOCK)
						ON pr.IdPedidoProduto = pp.Id
					WHERE p.DataEntrega IS NULL
						  AND pr.DataTermino IS NULL
						  AND p.Id = @IdPedido
		RETURN
	END
