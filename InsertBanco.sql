-- Insert para cliente
INSERT INTO [dbo].[Cliente] (Nome) 
VALUES 
							('JoÃ£o Silva'),
							('Maria Oliveira'),
							('Carlos Souza');
GO

-- Insert para os pedido
INSERT INTO [dbo].[Pedido]	(IdCliente, DataPedido, DataPromessa, DataEntrega)
VALUES
							(1, '2024-01-20', '2024-01-28', '2024-01-30'), -- Primeiro Pedido do cliente joÃ£o silva mÃªs de janeiro concluido
							(2, '2024-02-21', '2024-02-27', '2024-02-28'), -- Primeiro Pedido do cliente Maria Eduarda mï¿½s de Fevereiro concluido
							(3, '2024-01-22', '2024-01-30', '2024-01-30'), -- Primeiro Pedido do cliente Carlos Souza mï¿½s de janeiro concluido 
							(1, '2024-04-01', '2024-04-14', '2024-04-20'), -- Segundo Pedido do cliente joï¿½o silva mï¿½s de abril concluido
							(2, '2024-03-21', '2024-03-27', '2024-03-27'),
							(3, '2024-03-22', '2024-03-30', '2024-04-01'),
							(1, '2024-05-25', '2024-05-30', NULL),
							(2, '2024-05-21', '2024-05-27', NULL),
							(3, '2024-05-22', '2024-05-30', NULL);
GO 

-- Insert único para os produtos
INSERT INTO [dbo].[Produto] (Nome) 
VALUES 
							('Caixa de papelÃ£o laminado super resistente'),
							('Sacola de papel kraft reciclado'),
							('Embalagem plÃ¡stica para alimentos'),
							('Pote de vidro para conservas'),
							('Envelope de papel para correspondÃªncia'),
							('Garrafa PET para bebidas');
GO 

-- Insert único para as matérias-primas
INSERT INTO [dbo].[MateriaPrima]	(Nome) 
VALUES 
									('Papelão'),
									('Cola'),
									('Laminação'),
									('Papel kraft reciclado'),
									('AlÃ§a de papel torcido'),
									('Plástico (polietileno de alta densidade)'),
									('Selagem térmica'),
									('Vidro'),
									('Tampa metálica'),
									('Vedante de borracha'),
									('Papel sulfite'),
									('Adesivo para selagem'),
									('Plástico PET (polietileno tereftalato)'),
									('Tampa de rosca');
GO 

-- Composição do produto 'Caixa de papelão laminado super resistente' 
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(1, 1, 1000), -- PapelÃ£o
								(1, 2, 50),  -- Cola
								(1, 3, 310);  -- LaminaÃ§Ã£o
GO

-- Composição do produto 'Sacola de papel kraft reciclado' 
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(2, 4, 200), -- Papel kraft reciclado
								(2, 5, 100); -- AlÃ§a de papel torcido
GO 

-- Composição do produto 'Embalagem plástica para alimentos' (IdProduto = 3)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(3, 6, 500), -- PlÃ¡stico (polietileno de alta densidade)
								(3, 7, 200); -- Selagem tÃ©rmica
GO

-- Composição do produto 'Pote de vidro para conservas' (IdProduto = 4)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(4, 8, 1000), -- Vidro
								(4, 9, 300), -- Tampa metÃ¡lica
								(4, 10, 50); -- Vedante de borracha
GO

-- Composição do produto 'Envelope de papel para correspondência' (IdProduto = 5)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(5, 11, 300), -- Papel sulfite
								(5, 12, 10); -- Adesivo para selagem
GO

-- Composição do produto 'Garrafa PET para bebidas' (IdProduto = 6)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(6, 13, 1500), -- PlÃ¡stico PET (polietileno tereftalato)
								(6, 14, 100); -- Tampa de rosca
GO


-- Inserts de mock de estoque para cada produto
INSERT INTO [dbo].[EstoqueProduto]	(IdProduto, QuantidadeFisica, QuantidadeMinima, QuantidadeVirtual) 
VALUES 
									(1, 150, 100, 0), -- Caixa de papelÃ£o laminado super resistente
									(2, 300, 150, 0), -- Sacola de papel kraft reciclado
									(3, 300, 200, 0), -- Embalagem plÃ¡stica para alimentos
									(4, 200, 100, 0), -- Pote de vidro para conservas
									(5, 350, 250, 0), -- Envelope de papel para correspondÃªncia
									(6, 300, 300, 0); -- Garrafa PET para bebidas
GO

-- Insert único para o estoque de todas as matérias-primas
INSERT INTO [dbo].[EstoqueMateriaPrima] (IdMateriaPrima, QuantidadeFisica, QuantidadeMinima) 
VALUES
										(1, 5000, 1000), -- PapelÃ£o
										(2, 300, 50), -- Cola
										(3, 200, 50), -- LaminaÃ§Ã£o
										(4, 6000, 1500), -- Papel kraft reciclado
										(5, 1000, 200), -- AlÃ§a de papel torcido
										(6, 8000, 2000), -- PlÃ¡stico (polietileno de alta densidade)
										(7, 500, 100), -- Selagem tÃ©rmica
										(8, 4000, 800), -- Vidro
										(9, 2000, 400), -- Tampa metÃ¡lica
										(10, 1000, 200), -- Vedante de borracha
										(11, 7000, 1500), -- Papel sulfite
										(12, 400, 100), -- Adesivo para selagem
										(13, 9000, 2500), -- PlÃ¡stico PET (polietileno tereftalato)
										(14, 3000, 600); -- Tampa de rosca
GO

-- Inserts para a tabela TipoMovimentacao
INSERT INTO [dbo].[TipoMovimentacao]	(Id, Nome) 
VALUES
										(1, 'Entrada'),          -- Movimentação de entrada de estoque
										(2, 'Saída'),            -- Movimentação de saída de estoque
										(3, 'Perda');            -- Perda de estoque (por exemplo, devido a acidentes de trabalho)
GO

-- Inserts para a tabela PedidoProduto
INSERT INTO [dbo].[PedidoProduto]	(IdPedido, IdProduto, Quantidade) 
VALUES
									(1, 1, 50),  -- Primeiro Pedido do cliente JoÃ£o Silva - Caixa de papelÃ£o laminado super resistente
									(2, 2, 100), -- Primeiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
									(3, 3, 200), -- Primeiro Pedido do cliente Carlos Souza - Embalagem plÃ¡stica para alimentos
									(4, 4, 150), -- Segundo Pedido do cliente JoÃ£o Silva - Pote de vidro para conservas
									(5, 5, 300), -- Segundo Pedido do cliente Maria Eduarda - Envelope de papel para correspondï¿½ncia
									(6, 6, 400), -- Segundo Pedido do cliente Carlos Souza - Garrafa PET para bebidas
									(7, 1, 75),  -- Terceiro Pedido do cliente JoÃ£o Silva - Caixa de papelÃ£o laminado super resistente
									(8, 2, 120), -- Terceiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
									(9, 3, 250); -- Terceiro Pedido do cliente Carlos Souza - Embalagem plï¿½stica para alimentos
GO 

-- Inserts para a tabela EtapaProducao

-- Etapas de produção para 'Caixa de papelão laminado super resistente' (IdProduto = 1)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao) 
VALUES
									(1, 'Corte do papelÃ£o', 60),
									(1, 'AplicaÃ§Ã£o de cola e montagem', 120),
									(1, 'LaminaÃ§Ã£o e acabamento', 90);
GO

-- Etapas de produção para 'Sacola de papel kraft reciclado' (IdProduto = 2)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao) 
VALUES
									(2, 'Corte do papel kraft', 45),
									(2, 'Montagem e colagem das alÃ§as', 60),
									(2, 'ReforÃ§o e finalizaÃ§Ã£o', 30);
GO

-- Etapas de produção para 'Embalagem plástica para alimentos' (IdProduto = 3)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao) 
VALUES
									(3, 'Extrusão do plástico', 120),
									(3, 'Corte e moldagem', 90),
									(3, 'Selagem térmica', 60);
GO

-- Etapas de produção para 'Pote de vidro para conservas' (IdProduto = 4)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao)
VALUES
									(4, 'Fabricação do vidro', 180),
									(4, 'Moldagem e resfriamento', 120),
									(4, 'Aplicação da tampa e vedante', 45);
GO

-- Etapas de produção para 'Envelope de papel para correspondência' (IdProduto = 5)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao) 
VALUES
									(5, 'Corte do papel sulfite', 30),
									(5, 'Dobra e montagem', 45),
									(5, 'AplicaÃ§Ã£o do adesivo de selagem', 15);
GO

-- Etapas de produção para 'Garrafa PET para bebidas' (IdProduto = 6)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao) 
VALUES
									(6, 'Fabricação do plástico PET', 150),
									(6, 'Sopro e moldagem da garrafa', 105),
									(6, 'Aplicação da tampa de rosca', 30);
GO 

-- Primeiro Pedido do cliente João Silva - Caixa de papelão laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES 
												(1, 2, '30/01/2024', 50); -- Saída de produto
                        
-- Primeiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(2, 2, '28/02/2024', 100); -- Saída de produto
                        
-- Primeiro Pedido do cliente Carlos Souza - Embalagem plástica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(3, 2, '30/01/2024', 200); -- Saída de produto

-- Segundo Pedido do cliente Maria Eduarda - Envelope de papel para correspondÃªncia
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES
												(2, 2, '28/02/2024', 100); -- Saída de produto

-- Segundo Pedido do cliente João Silva - Pote de vidro para conservas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES 
												(4, 2, '20/04/2024', 150); -- Saída de produto
                        
-- Segundo Pedido do cliente Carlos Souza - Garrafa PET para bebidas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(6, 2, '27/03-2024', 400); -- Saída de produto

-- Terceiro Pedido do cliente João Silva - Caixa de papelão laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES 
												(1, 2, '30/05/2024', 75); -- Saída de produto

-- Terceiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(2, 2, '27/05/2024', 120); -- Saída de produto

-- Terceiro Pedido do cliente Carlos Souza - Embalagem plÃ¡stica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(2, 2, '27/05/2024', 120); -- Saída de produto