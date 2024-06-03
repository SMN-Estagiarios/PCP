CREATE DATABASE pcp;  
GO

USE pcp;
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Cliente]
-- -----------------------------------------------------
CREATE TABLE [dbo].[Cliente](
								Id INT PRIMARY KEY IDENTITY,
								Nome VARCHAR(100) NOT NULL
							);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Produto]
-- -----------------------------------------------------
CREATE TABLE [dbo].[Produto]	(
									Id INT PRIMARY KEY IDENTITY,
									Nome VARCHAR(45) NOT NULL UNIQUE
								);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Pedido] 
-- -----------------------------------------------------
CREATE TABLE [dbo].[Pedido]	(
								Id INT PRIMARY KEY IDENTITY,
								IdCliente INT NOT NULL,
								DataPedido DATE NOT NULL,
								DataPromessa DATE NOT NULL,
								DataEntrega DATE

								CONSTRAINT fk_IdCliente_Pedido
									FOREIGN KEY (IdCliente)
									REFERENCES [dbo].[Cliente] (Id)
							);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[EstoqueProduto]
-- -----------------------------------------------------
CREATE TABLE [dbo].[EstoqueProduto](
										IdProduto INT PRIMARY KEY,
										QuantidadeFisica INT NOT NULL,
										QuantidadeMinima INT NOT NULL,

										CONSTRAINT fk_IdProduto_EstoqueProduto
											FOREIGN KEY (IdProduto)
											REFERENCES [dbo].[Produto] (Id)
									);


-- -----------------------------------------------------
-- Tabela [dbo].[TipoMovimentacao]
-- -----------------------------------------------------
CREATE TABLE [dbo].[TipoMovimentacao]	(
											Id TINYINT PRIMARY KEY,
											Nome VARCHAR(50) NOT NULL UNIQUE
										);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[MovimentacaoEstoqueProduto]
-- -----------------------------------------------------
CREATE TABLE [dbo].[MovimentacaoEstoqueProduto](
													Id INT PRIMARY KEY IDENTITY,
													IdTipoMovimentacao TINYINT NOT NULL,
													IdEstoqueProduto INT NOT NULL,
													DataMovimentacao DATETIME NOT NULL,
													Quantidade INT
													CONSTRAINT fk_IdTipoMovimentacao_MovimentacaoEstoqueProduto
														FOREIGN KEY (idTipoMovimentacao)
														REFERENCES [dbo].[TipoMovimentacao] (Id),
													CONSTRAINT fk_IdEstoqueProduto_MovimentacaoEstoqueProduto
														FOREIGN KEY (IdEstoqueProduto)
														REFERENCES [dbo].[EstoqueProduto] (IdProduto)
												);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[MateriaPrima]
-- -----------------------------------------------------
CREATE TABLE [dbo].[MateriaPrima]	(
										Id INT PRIMARY KEY IDENTITY,
										Nome VARCHAR(60) NOT NULL UNIQUE
									);


-- -----------------------------------------------------
-- Tabela [dbo].[EstoqueMateriaPrima]
-- -----------------------------------------------------
CREATE TABLE [dbo].[EstoqueMateriaPrima]	(
												IdMateriaPrima INT PRIMARY KEY,
												QuantidadeFisica INT NOT NULL,
												QuantidadeMinima INT NOT NULL

												CONSTRAINT fk_IdMateriaPrima_EstoqueMateriaPrima
													FOREIGN KEY (IdMateriaPrima)
													REFERENCES [dbo].[MateriaPrima] (Id)
											);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[MovimentacaoEstoqueMateriaPrima]
-- -----------------------------------------------------
CREATE TABLE [dbo].[MovimentacaoEstoqueMateriaPrima]	(
															Id INT PRIMARY KEY IDENTITY,
															IdTipoMovimentacao TINYINT NOT NULL,
															IdEstoqueMateriaPrima INT NOT NULL,
															DataMovimentacao DATETIME NOT NULL,
															Quantidade INT NOT NULL
															CONSTRAINT fk_IdTipoMovimentacao_MovimentacaoEstoqueMateriaPrima
																FOREIGN KEY (idTipoMovimentacao)
																REFERENCES [dbo].[TipoMovimentacao] (Id),
															CONSTRAINT fk_IdEstoqueMateriaPrima_MovimentacaoEstoqueMateriaPrima
																FOREIGN KEY (IdEstoqueMateriaPrima)
																REFERENCES [dbo].[EstoqueMateriaPrima] (IdMateriaPrima)
														);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[PedidoProduto]
-- -----------------------------------------------------
CREATE TABLE [dbo].[PedidoProduto]	(
										Id INT PRIMARY KEY  IDENTITY,
										IdPedido INT NOT NULL,
										IdProduto INT NOT NULL,
										Quantidade INT NOT NULL

										CONSTRAINT fk_IdPedido_PedidoProduto
											FOREIGN KEY (IdPedido)
											REFERENCES [dbo].[Pedido] (Id),
										CONSTRAINT fk_IdProduto_PedidoProduto
											FOREIGN KEY (IdProduto)
											REFERENCES [dbo].[Produto] (Id)
									);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[EtapaProducao]
-- -----------------------------------------------------
CREATE TABLE [dbo].[EtapaProducao]	(
										Id INT PRIMARY KEY IDENTITY,
										IdProduto INT NOT NULL,
										Descricao VARCHAR(150) NOT NULL,
										Duracao SMALLINT NOT NULL,
										NumeroEtapa TINYINT NOT NULL,

										CONSTRAINT fk_IdProduto_EtapaProducao
											FOREIGN KEY (IdProduto)
											REFERENCES [dbo].[Produto] (Id)
									);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Composicao]
-- -----------------------------------------------------
CREATE TABLE [dbo].[Composicao]	(
									IdProduto INT NOT NULL,
									IdMateriaPrima INT NOT NULL,
									Quantidade INT NOT NULL,

									CONSTRAINT fk_IdProduto_Composicao
										FOREIGN KEY (IdProduto)
										REFERENCES [dbo].[Produto] (Id),
									CONSTRAINT fk_IdMateriaPrima_Composicao
										FOREIGN KEY (IdMateriaPrima)
										REFERENCES [dbo].[MateriaPrima] (Id)
								);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Producao]
-- -----------------------------------------------------
CREATE TABLE [dbo].[Producao]	(
									Id INT PRIMARY KEY IDENTITY,
									IdEtapaProducao INT NOT NULL,
									IdPedidoProduto INT NOT NULL,
									DataInicio DATETIME NOT NULL,
									DataTermino DATETIME NULL,
									Quantidade  INT NOT NULL,

									CONSTRAINT fk_IdEtapaProducao_Producao
										FOREIGN KEY (IdEtapaProducao)
										REFERENCES [dbo].[EtapaProducao] (Id),
									CONSTRAINT fk_IdPedidoProduto_Producao
										FOREIGN KEY (IdPedidoProduto)
										REFERENCES [dbo].[PedidoProduto] (Id)
								);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[PedidoMovimetacaoEstoqueProduto]
-- -----------------------------------------------------
CREATE TABLE [dbo].[AuditoriaMovimetacaoSaidaEstoqueProduto](
														IdPedido INT NOT NULL,
														IdMovimentacaoEstoqueProduto INT NOT NULL UNIQUE
														CONSTRAINT fk_IdPedido_AuditoriaMovimetacaoSaidaEstoqueProduto
															FOREIGN KEY (IdPedido)
															REFERENCES [dbo].[Pedido] (Id),
														CONSTRAINT fk_IdMovimetacaoEstoqueProduto_AuditoriaMovimetacaoSaidaEstoqueProduto
															FOREIGN KEY (IdMovimentacaoEstoqueProduto)
															REFERENCES [dbo].[MovimentacaoEstoqueProduto] (Id)
													);
GO

CREATE TABLE [dbo].[AuditoriaMovimetacaoEntradaEstoqueProduto](
														IdProducao INT NOT NULL,
														IdMovimentacaoEstoqueProduto INT NOT NULL UNIQUE
														CONSTRAINT fk_IdPedido_AuditoriaMovimetacaoEntradaEstoqueProduto
															FOREIGN KEY (IdProducao)
															REFERENCES [dbo].[Producao] (Id),
														CONSTRAINT fk_IdMovimetacaoEstoqueProduto_AuditoriaMovimetacaoEntradaEstoqueProduto
															FOREIGN KEY (IdMovimentacaoEstoqueProduto)
															REFERENCES [dbo].[MovimentacaoEstoqueProduto] (Id)
													);
GO


-- -----------------------------------------------------
-- Tabela [dbo].[PedidoMovimetacaoEstoqueMateriaPrima]
-- -----------------------------------------------------
CREATE TABLE [dbo].[AuditoriaMovimetacaoEstoqueMateriaPrima](
														IdPedido INT NOT NULL,
														IdMovimentacaoEstoqueMateriaPrima INT NOT NULL UNIQUE
														CONSTRAINT fk_IdPedido_AuditoriaMovimetacaoEstoqueMateriaPrima
															FOREIGN KEY (IdPedido)
															REFERENCES [dbo].[Pedido] (Id),
														CONSTRAINT fk_IdMovimetacaoEstoqueMateriaPrima_AuditoriaMovimetacaoEstoqueMateriaPrima
															FOREIGN KEY (IdMovimentacaoEstoqueMateriaPrima)
															REFERENCES [dbo].[MovimentacaoEstoqueMateriaPrima] (Id)
													);
GO