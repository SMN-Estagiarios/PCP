-- Tabela Pedido
CREATE NONCLUSTERED INDEX IX_Pedido_DataEntrega ON Pedido (DataEntrega);
CREATE NONCLUSTERED INDEX IX_Pedido_DataPedido ON Pedido (DataPedido);

-- Tabela PedidoProduto
CREATE NONCLUSTERED INDEX IX_PedidoProduto_IdPedido ON PedidoProduto (IdPedido);
CREATE NONCLUSTERED INDEX IX_PedidoProduto_IdProduto ON PedidoProduto (IdProduto);

-- Tabela Producao
CREATE NONCLUSTERED INDEX IX_Producao_IdPedidoProduto ON Producao (IdPedidoProduto);
CREATE NONCLUSTERED INDEX IX_Producao_IdEtapaProducao ON Producao (IdEtapaProducao);
CREATE NONCLUSTERED INDEX IX_Producao_DataInicio ON Producao (DataInicio);
CREATE NONCLUSTERED INDEX IX_Producao_DataTermino ON Producao (DataTermino);

-- Tabela EtapaProducao
CREATE NONCLUSTERED INDEX IX_EtapaProducao_IdProduto ON EtapaProducao (IdProduto);

-- Tabela MovimentacaoEstoqueProduto
CREATE NONCLUSTERED INDEX IX_MovimentacaoEstoqueProduto_IdEstoqueProduto ON MovimentacaoEstoqueProduto (IdEstoqueProduto);
CREATE NONCLUSTERED INDEX IX_MovimentacaoEstoqueProduto_DataMovimentacao ON MovimentacaoEstoqueProduto (DataMovimentacao);
CREATE NONCLUSTERED INDEX IX_MovimentacaoEstoqueProduto_IdTipoMovimentacao ON MovimentacaoEstoqueProduto (IdTipoMovimentacao);

-- Tabela MovimentacaoEstoqueMateriaPrima
CREATE NONCLUSTERED INDEX IX_MovimentacaoEstoqueMateriaPrima_IdEstoqueProduto ON MovimentacaoEstoqueMateriaPrima (IdEstoqueMateriaPrima);
CREATE NONCLUSTERED INDEX IX_MovimentacaoEstoqueMateriaPrima_DataMovimentacao ON MovimentacaoEstoqueMateriaPrima (DataMovimentacao);
CREATE NONCLUSTERED INDEX IX_MovimentacaoEstoqueMateriaPrima_IdTipoMovimentacao ON MovimentacaoEstoqueMateriaPrima (IdTipoMovimentacao);