CREATE OR ALTER PROCEDURE [dbo].[SP_ListarPedidosEmProducao]
	AS
		/*
			Documenta��o
			Arquivo fonte.........: Pedido.sql
			Objetivo..............: Listar pedidos que est�o em produ��o
			Autor.................: Gustavo Targino
			Data..................: 22/05/2024
			Ex....................: 
									DECLARE @DataInicio DATETIME = GETDATE()
									EXEC [dbo].[SP_ListarPedidosEmProducao]
									SELECT DATEDIFF(MILLISECOND, @DataInicio, GETDATE()) Tempo
		*/
	BEGIN
		-- Selecionando os pedidos em produ��o
		SELECT p.Id,
			   p.IdCliente,
			   p.DataPedido,
			   p.DataPromessa,
			   p.DataEntrega
			FROM [dbo].[Pedido] p WITH(NOLOCK)
				WHERE p.DataEntrega IS NULL
	END