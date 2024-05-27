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

-- Drop de procedures Pedido
DROP PROCEDURE [dbo].[SP_InserirPedido]
DROP PROCEDURE [dbo].[SP_ListarPedidos]
DROP PROCEDURE [dbo].[Sp_ListarPedidosEmAtraso]

-- Drop Proc Cliente
DROP PROCEDURE [dbo].[SP_ListarClientes]
DROP PROCEDURE [dbo].[SP_InserirCliente]
DROP PROCEDURE [dbo].[SP_AtualizarCliente]

-- Drop Proc Composicao
DROP PROCEDURE [dbo].[SP_InserirNovaComposicao]
DROP PROCEDURE [dbo].[SP_ListarComposicao]

-- Drop Proc EstoqueProduto
DROP PROCEDURE [dbo].[SP_AtualizarEstoqueProduto]

-- Drop Proc EtapaProducao
DROP PROCEDURE [dbo].[SP_ListarEtapaProducao]
DROP PROCEDURE [dbo].[SP_InserirEtapaProducao]
DROP PROCEDURE [dbo].[SP_AtualizarEtapaProducao]

-- Drop Proc MateriaPrima
DROP PROCEDURE [dbo].[SP_InserirMateriaPrima]
DROP PROCEDURE [dbo].[SP_ListarMateriaPrima]

-- Drop Proc MovimentacaoEstoqueMateriaPrima
DROP PROCEDURE [dbo].[SP_InserirMovimentacaoEstoqueMateriaPrima]
DROP PROCEDURE [dbo].[SP_ListarMovimentacaoEstoqueMateriaPrima]

-- Drop Proc MovimentacaoEstoqueProduto
DROP PROCEDURE [dbo].[SP_InserirMovimentacaoEstoqueProduto]
DROP PROCEDURE [dbo].[SP_ListarMovimentacaoEstoqueProduto]

-- Drop Proc MovimentacaoEstoquePedido
DROP PROCEDURE [dbo].[SP_InserirPedido]
DROP PROCEDURE [dbo].[SP_ListarPedidos]
DROP PROCEDURE [dbo].[Sp_ListarPedidosEmAtraso]
DROP PROCEDURE [dbo].[SP_ListarPedidosEmProducao]
DROP PROCEDURE [dbo].[SP_ListarPedidosCompletos]
DROP PROCEDURE [dbo].[SP_RealizarBaixaPedido]

-- Drop Proc Producao
DROP PROCEDURE [dbo].[SP_IniciarProducaoDeEtapa]
DROP PROCEDURE [dbo].[SP_EncerrarProducaoDeEtapa]

-- Drop Proc Produto
DROP PROCEDURE [dbo].[SP_InserirProduto]
DROP PROCEDURE [dbo].[SP_ListarProduto]

-- Drop Functions
DROP FUNCTION [dbo].[FNC_CalcularEstoqueReal]
DROP FUNCTION [dbo].[FNC_CalcularEstoqueVirtual]
DROP FUNCTION [dbo].[FNC_CalcularTempoProducaoProduto]
DROP FUNCTION [dbo].[FNC_ChecarEstoqueProduto]
DROP FUNCTION [dbo].[FNC_VerificarDuracaoEtapaProducao]

-- Drop Trigger
DROP TRIGGER [dbo].[TRG_AtualizarEstoqueMateriaPrima]
DROP TRIGGER [dbo].[TRG_AtualizarEstoqueProduto]
DROP TRIGGER [dbo].[TRG_ChecarPerdaProducao]
DROP TRIGGER [dbo].[TRG_CompararEstoqueProdutoReal]
DROP TRIGGER [dbo].[TRG_GerarEstoqueMateriaPrima]
DROP TRIGGER [dbo].[TRG_GerarMovimentacaoFimProducao]
DROP TRIGGER [dbo].[TRG_GerarMovimentacaoPorEntregaDePedido]