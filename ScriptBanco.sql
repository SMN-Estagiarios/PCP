CREATE DATABASE pcp;
GO

USE pcp;
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Cliente]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[Cliente];

CREATE TABLE [dbo].[Cliente](
								Id INT PRIMARY KEY IDENTITY,
								Nome VARCHAR(100) NOT NULL
							);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Produto]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[Produto];

CREATE TABLE [dbo].[Produto]	(
									Id INT PRIMARY KEY IDENTITY,
									Nome VARCHAR(45) NOT NULL UNIQUE
								);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Pedido]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[Pedido];

CREATE TABLE [dbo].[Pedido]	(
								Id INT PRIMARY KEY IDENTITY,
								IdCliente INT NOT NULL,
								DataPedido DATE NOT NULL,
								DataPromessa DATE NOT NULL,
								DataEntrega DATE

								CONSTRAINT fk_Pedido_Cliente1
									FOREIGN KEY (IdCliente)
									REFERENCES [dbo].[Cliente] (Id)
							);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[EstoqueProduto]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[EstoqueProduto];

CREATE TABLE [dbo].[EstoqueProduto](
										IdProduto INT PRIMARY KEY,
										QuantidadeFisica INT NOT NULL,
										QuantidadeMinima INT NOT NULL,
										QuantidadeVirtual INT NOT NULL

										CONSTRAINT fk_EstoqueProduto_Produto1
											FOREIGN KEY (IdProduto)
											REFERENCES [dbo].[Produto] (Id)
									);


-- -----------------------------------------------------
-- Tabela [dbo].[TipoMovimentacao]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[TipoMovimentacao];

CREATE TABLE [dbo].[TipoMovimentacao]	(
											Id TINYINT PRIMARY KEY,
											Nome VARCHAR(50) NOT NULL UNIQUE
										);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[MovimentacaoEstoqueProduto]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[MovimentacaoEstoqueProduto];

CREATE TABLE [dbo].[MovimentacaoEstoqueProduto](
													Id INT PRIMARY KEY IDENTITY,
													IdEstoqueProduto INT NOT NULL,
													idTipoMovimentacao TINYINT NOT NULL

													CONSTRAINT fk_MovimentacaoEstoqueProduto_EstoqueProduto1
														FOREIGN KEY (IdEstoqueProduto)
														REFERENCES [dbo].[EstoqueProduto] (IdProduto),
													CONSTRAINT fk_MovimentacaoEstoqueProduto_TipoMovimentacao1
														FOREIGN KEY (idTipoMovimentacao)
														REFERENCES [dbo].[TipoMovimentacao] (Id)
												);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[MateriaPrima]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[MateriaPrima];

CREATE TABLE [dbo].[MateriaPrima]	(
										Id INT PRIMARY KEY IDENTITY,
										Nome VARCHAR(60) NOT NULL UNIQUE
									);


-- -----------------------------------------------------
-- Tabela [dbo].[EstoqueMateriaPrima]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[EstoqueMateriaPrima];

CREATE TABLE [dbo].[EstoqueMateriaPrima]	(
												IdMateriaPrima INT PRIMARY KEY,
												QuantidadeFisica INT NOT NULL,
												QuantidadeMinima INT NOT NULL

												CONSTRAINT fk_EstoqueMateriaPrima_MateriaPrima1
													FOREIGN KEY (IdMateriaPrima)
													REFERENCES [dbo].[MateriaPrima] (Id)
											);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[MovimentacaoEstoqueMateriaPrima]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[MovimentacaoEstoqueMateriaPrima];

CREATE TABLE [dbo].[MovimentacaoEstoqueMateriaPrima]	(
															Id INT PRIMARY KEY IDENTITY,
															idTipoMovimentacao TINYINT NOT NULL,
															IdEstoqueMateriaPrima INT NOT NULL,
															DataMovimentacao DATE NOT NULL,
															CONSTRAINT fk_MovimentacaoEstoqueMateriaPrima_EstoqueMateriaPrima1
																FOREIGN KEY (IdEstoqueMateriaPrima)
																REFERENCES [dbo].[EstoqueMateriaPrima] (IdMateriaPrima),
															CONSTRAINT fk_MovimentacaoEstoqueMateriaPrima_TipoMovimentacao1
																FOREIGN KEY (idTipoMovimentacao)
																REFERENCES [dbo].[TipoMovimentacao] (Id)
														);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[PedidoProduto]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[PedidoProduto];

CREATE TABLE [dbo].[PedidoProduto]	(
										Id INT PRIMARY KEY  IDENTITY,
										IdPedido INT NOT NULL,
										IdProduto INT NOT NULL,
										Quantidade SMALLINT NOT NULL

										CONSTRAINT fk_Pedido_has_Produto_Pedido
											FOREIGN KEY (IdPedido)
											REFERENCES [dbo].[Pedido] (Id),
										CONSTRAINT fk_Pedido_has_Produto_Produto1
											FOREIGN KEY (IdProduto)
											REFERENCES [dbo].[Produto] (Id)
									);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[EtapaProducao]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[EtapaProducao];

CREATE TABLE [dbo].[EtapaProducao]	(
										Id INT PRIMARY KEY IDENTITY,
										IdProduto INT NOT NULL,
										Descricao VARCHAR(150) NOT NULL,
										Duracao SMALLINT NOT NULL

										CONSTRAINT fk_Etapa_Produto1
											FOREIGN KEY (IdProduto)
											REFERENCES [dbo].[Produto] (Id)
									);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Composicao]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[Composicao];

CREATE TABLE [dbo].[Composicao]	(
									IdProduto INT NOT NULL,
									IdMateriaPrima INT NOT NULL,
									Quantidade INT NOT NULL,

									CONSTRAINT fk_Produto_has_MateriaPrima_Produto1
										FOREIGN KEY (IdProduto)
										REFERENCES [dbo].[Produto] (Id),
									CONSTRAINT fk_Produto_has_MateriaPrima_MateriaPrima1
										FOREIGN KEY (IdMateriaPrima)
										REFERENCES [dbo].[MateriaPrima] (Id)
								);
GO

-- -----------------------------------------------------
-- Tabela [dbo].[Producao]
-- -----------------------------------------------------
DROP TABLE IF EXISTS [dbo].[Producao];

CREATE TABLE [dbo].[Producao]	(
									Id INT PRIMARY KEY IDENTITY,
									IdEtapaProducao INT NOT NULL,
									IdPedidoProduto INT NOT NULL,
									DataInicio DATETIME NOT NULL,
									DataTermino DATETIME NULL,

									CONSTRAINT fk_Producao_Etapa1
										FOREIGN KEY (IdEtapaProducao)
										REFERENCES [dbo].[EtapaProducao] (Id),
									CONSTRAINT fk_Producao_PedidoProduto1
										FOREIGN KEY (IdPedidoProduto)
										REFERENCES [dbo].[PedidoProduto] (Id)
								);
GO