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
GO
DROP TABLE [dbo].[Composicao]
GO
DROP TABLE [dbo].[EstoqueProduto]
GO
DROP TABLE [dbo].[EstoqueMateriaPrima]
GO
DROP TABLE [dbo].[EtapaProducao]
GO
DROP TABLE [dbo].[MateriaPrima]
GO
DROP TABLE [dbo].[MovimentacaoEstoqueMateriaPrima]
GO
DROP TABLE [dbo].[MovimentacaoEstoqueProduto]
GO
DROP TABLE [dbo].[Pedido]
GO
DROP TABLE [dbo].[PedidoProduto]
GO
DROP TABLE [dbo].[Producao]
GO
DROP TABLE [dbo].[Produto]
GO
DROP TABLE [dbo].[TipoMovimentacao]
GO

-- Drop de procedures Pedido
DROP PROCEDURE [dbo].[SP_InserirPedido]
GO
DROP PROCEDURE [dbo].[SP_ListarPedidos]
GO
DROP PROCEDURE [dbo].[Sp_ListarPedidosEmAtraso]
GO

-- Drop Proc Cliente
DROP PROCEDURE [dbo].[SP_ListarClientes]
GO
DROP PROCEDURE [dbo].[SP_InserirCliente]
GO
DROP PROCEDURE [dbo].[SP_AtualizarCliente]
GO

-- Drop Proc Composicao
DROP PROCEDURE [dbo].[SP_InserirNovaComposicao]
GO
DROP PROCEDURE [dbo].[SP_ListarComposicao]
GO

-- Drop Proc EstoqueProduto
DROP PROCEDURE [dbo].[SP_AtualizarEstoqueProduto]
GO
DROP PROCEDURE [dbo].[FNC_ChecagemEstoqueProduto]
GO
DROP PROCEDURE [dbo].[FNC_DuracaoEstapaProducao]
GO

-- Drop Proc EtapaProducao
DROP PROCEDURE [dbo].[SP_ListarEtapaProducao]
GO
DROP PROCEDURE [dbo].[SP_InserirEtapaProducao]
GO
DROP PROCEDURE [dbo].[SP_AtualizarEtapaProducao]
GO
DROP PROCEDURE [dbo].[SP_IniciarProducaoEtapa]
GO

-- Drop Proc MateriaPrima
DROP PROCEDURE [dbo].[SP_InserirMateriaPrima]
GO
DROP PROCEDURE [dbo].[SP_ListarMateriaPrima]
GO

-- Drop Proc MovimentacaoEstoqueMateriaPrima
DROP PROCEDURE [dbo].[SP_InserirMovimentacaoEstoqueMateriaPrima]
GO
DROP PROCEDURE [dbo].[SP_ListarMovimentacaoEstoqueMateriaPrima]
GO


-- Drop Proc MovimentacaoEstoqueProduto
DROP PROCEDURE [dbo].[SP_InserirMovimentacaoEstoqueProduto]
GO
DROP PROCEDURE [dbo].[SP_ListarMovimentacaoEstoqueProduto]
GO

-- Drop Proc MovimentacaoEstoquePedido
DROP PROCEDURE [dbo].[SP_InserirPedido]
GO
DROP PROCEDURE [dbo].[SP_ListarPedidos]
GO
DROP PROCEDURE [dbo].[Sp_ListarPedidosEmAtraso]
GO
DROP PROCEDURE [dbo].[SP_ListarPedidosEmProducao]
GO
DROP PROCEDURE [dbo].[SP_ListarPedidosCompletos]
GO
DROP PROCEDURE [dbo].[SP_RealizarBaixaPedido]
GO

-- Drop Proc Producao
DROP PROCEDURE [dbo].[SP_IniciarProducaoDeEtapa]
GO
DROP PROCEDURE [dbo].[SP_EncerrarProducaoDeEtapa]
GO

-- Drop Proc Produto
DROP PROCEDURE [dbo].[SP_InserirProduto]
GO
DROP PROCEDURE [dbo].[SP_ListarProduto]
GO

-- Drop Functions
DROP FUNCTION [dbo].[FNC_CalcularEstoqueReal]
GO
DROP FUNCTION [dbo].[FNC_CalcularEstoqueVirtual]
GO
DROP FUNCTION [dbo].[FNC_CalcularTempoProducaoProduto]
GO
DROP FUNCTION [dbo].[FNC_ChecarEstoqueProduto]
GO
DROP FUNCTION [dbo].[FNC_VerificarDuracaoEtapaProducao]
GO
DROP FUNCTION [dbo].[FNC_DuracaoEtapaProducao]
GO
DROP FUNCTION [dbo].[FNC_ChecagemEstoqueProduto]
GO


-- Drop Trigger
DROP TRIGGER [dbo].[TRG_AtualizarEstoqueMateriaPrima]
GO
DROP TRIGGER [dbo].[TRG_AtualizarEstoqueProduto]
GO
DROP TRIGGER [dbo].[TRG_ChecarPerdaProducao]
GO
DROP TRIGGER [dbo].[TRG_CompararEstoqueProdutoReal]
GO
DROP TRIGGER [dbo].[TRG_GerarEstoqueMateriaPrima]
GO
DROP TRIGGER [dbo].[TRG_GerarMovimentacaoFimProducao]
GO
DROP TRIGGER [dbo].[TRG_GerarMovimentacaoPorEntregaDePedido]
GO