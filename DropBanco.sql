-- Drop das CONSTRAINT FK
ALTER TABLE Pedido
DROP CONSTRAINT fk_IdCliente_Pedido;
GO

ALTER TABLE EstoqueProduto
DROP CONSTRAINT fk_IdProduto_EstoqueProduto;
GO

ALTER TABLE MovimentacaoEstoqueProduto
DROP CONSTRAINT fk_IdTipoMovimentacao_MovimentacaoEstoqueProduto;
GO

ALTER TABLE MovimentacaoEstoqueProduto
DROP CONSTRAINT fk_IdEstoqueProduto_MovimentacaoEstoqueProduto;
GO

ALTER TABLE EstoqueMateriaPrima
DROP CONSTRAINT fk_IdMateriaPrima_EstoqueMateriaPrima;
GO

ALTER TABLE MovimentacaoEstoqueMateriaPrima
DROP CONSTRAINT fk_IdTipoMovimentacao_MovimentacaoEstoqueMateriaPrima;
GO

ALTER TABLE MovimentacaoEstoqueMateriaPrima
DROP CONSTRAINT fk_IdEstoqueMateriaPrima_MovimentacaoEstoqueMateriaPrima;
GO

ALTER TABLE PedidoProduto
DROP CONSTRAINT fk_IdPedido_PedidoProduto;
GO

ALTER TABLE PedidoProduto
DROP CONSTRAINT fk_IdProduto_PedidoProduto;
GO

ALTER TABLE EtapaProducao
DROP CONSTRAINT fk_IdProduto_EtapaProducao;
GO

ALTER TABLE Composicao
DROP CONSTRAINT fk_IdProduto_Composicao;
GO

ALTER TABLE Composicao
DROP CONSTRAINT fk_IdMateriaPrima_Composicao;
GO

ALTER TABLE Producao
DROP CONSTRAINT fk_IdEtapaProducao_Producao;
GO

ALTER TABLE Producao
DROP CONSTRAINT fk_IdPedidoProduto_Producao;
GO

-- Drop de tabelas

DROP TABLE [dbo].[Cliente]
DROP TABLE [dbo].[Composicao]
DROP TABLE [dbo].[EstoqueProduto]
DROP TABLE [dbo].[EstoqueMateriaPrima]
DROP TABLE [dbo].[EtapaProducao]
DROP TABLE [dbo].[MateriaPrima]
DROP TABLE [dbo].[MovimentacaoEstoqueMateriaPrima]
DROP TABLE [dbo].[MovimentacaoEstoqueProduto]
DROP TABLE [dbo].[Pedido]
DROP TABLE [dbo].[PedidoProduto]
DROP TABLE [dbo].[Producao]
DROP TABLE [dbo].[Produto]
DROP TABLE [dbo].[TipoMovimentacao]

-- Drop de procedures

DROP PROCEDURE [dbo].[SP_InserirPedido]
DROP PROCEDURE [dbo].[SP_ListarPedidos]
DROP PROCEDURE [dbo].[Sp_ListarPedidosEmAtraso]
