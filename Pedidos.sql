USE pcp;

CREATE OR ALTER PROCEDURE [dbo].[SP_ListarPedidosCompletos]

	/*
	Documentação
		Arquivo Fonte........:	Pedido.sql
		Objetivo.............:	Procedure para listar todos os pedidos completos
		Autor................:	Thays Carvalho
		Data.................:	22/05/2024
		Exemplo..............:	
								DECLARE @Ret INT,
										@DataInicio DATETIME = GETDATE()

								EXEC @Ret = [dbo].[SP_ListarPedidosCompletos] 

								SELECT	@Ret AS Retorno,
										DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) AS Tempo
								
		Retornos.............:	0 - Sucesso
	*/
	AS
	BEGIN
			SELECT	p.Id,
					p.IdCliente,
					p.DataPedido,
					p.DataPromessa,
					p.DataEntrega	
				FROM [dbo].[Pedido] p WITH(NOLOCK) 
				WHERE p.DataEntrega IS NOT NULL

			RETURN 0
	END

	