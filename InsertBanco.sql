-- Insert para cliente

INSERT INTO [dbo].[Cliente] (Nome) 
VALUES 
							('João Silva'),
							('Maria Oliveira'),
							('Carlos Souza'),
							('Pedro Avelino'),
							('Orcino Neto'),
							('Gabriel Damiani'),
							('Odlavir Florentino'),
							('Thays Carvalho'),
							('Danyel Targino'),
							('Rafael Maurício'),
							('Gustavo Targino'),
							('Olívio Freitas'),
							('João Victor'),
							('Adriel Alexander'),
							('André Victor'),
							('Gustavo Brandão'),
							('Rafael Valentim'),
							('Thomaz Falbo'),
							('Marcus Mandara'),
							('Isabella Tragante');
GO

-- Insert para os pedido
INSERT INTO [dbo].[Pedido]	(IdCliente, DataPedido, DataPromessa, DataEntrega)
VALUES
							(1, '2024-01-20', '2024-01-28', '2024-01-30'), -- Primeiro Pedido do cliente João Silva mês de janeiro concluido
							(2, '2024-02-21', '2024-02-27', '2024-02-28'), -- Primeiro Pedido do cliente Maria Eduarda mês de Fevereiro concluido
							(3, '2024-01-22', '2024-01-30', '2024-01-30'), -- Primeiro Pedido do cliente Carlos Souza mês de janeiro concluido 
							(1, '2024-04-01', '2024-04-14', '2024-04-20'), -- Segundo Pedido do cliente João Silva mês de abril concluido
							(2, '2024-03-21', '2024-03-27', '2024-03-27'),
							(3, '2024-03-22', '2024-03-30', '2024-04-01'),
							(1, '2024-05-25', '2024-05-30', NULL),
							(2, '2024-05-21', '2024-05-27', NULL),
							(3, '2024-05-22', '2024-05-30', NULL);

INSERT INTO [dbo].[Pedido] (IdCliente, DataPedido, DataPromessa, DataEntrega)
VALUES
    (1, '2024-01-20', '2024-01-28', '2024-01-30'), -- Primeiro Pedido do cliente joão silva mês de janeiro concluído
    (2, '2024-02-21', '2024-02-27', '2024-02-28'), -- Primeiro Pedido do cliente Maria Eduarda mês de Fevereiro concluído
    (3, '2024-01-22', '2024-01-30', '2024-01-30'), -- Primeiro Pedido do cliente Carlos Souza mês de janeiro concluído
    (1, '2024-04-01', '2024-04-14', '2024-04-20'), -- Segundo Pedido do cliente joão silva mês de abril concluído
    (2, '2024-03-21', '2024-03-27', '2024-03-27'), -- Segundo Pedido do cliente Maria Eduarda mês de março concluído
    (3, '2024-03-22', '2024-03-30', '2024-04-01'), -- Segundo Pedido do cliente Carlos Souza mês de março concluído
    (1, '2024-05-25', '2024-05-30', NULL),         -- Terceiro Pedido do cliente joão silva mês de maio
    (2, '2024-05-21', '2024-05-27', NULL),         -- Terceiro Pedido do cliente Maria Eduarda mês de maio
    (3, '2024-05-22', '2024-05-30', NULL),         -- Terceiro Pedido do cliente Carlos Souza mês de maio
    (4, '2024-05-23', '2024-06-12', NULL),         -- Primeiro Pedido do cliente Pedro Avelino mês de maio
    (5, '2024-05-12', '2024-07-02', NULL),         -- Primeiro Pedido do cliente Orcino Neto mês de maio
    (6, '2024-03-02', '2024-05-02', '2024-03-31'), -- Primeiro Pedido do cliente Gabriel Damiani mês de março
    (7, '2024-04-24', '2024-05-10', '2024-05-12'), -- Primeiro Pedido do cliente Odlavir Florentino mês de abril
    (8, '2024-04-25', '2024-05-15', '2024-05-12'), -- Primeiro Pedido do cliente Thays Carvalho mês de abril
    (9, '2024-04-26', '2024-05-20', '2024-05-23'), -- Primeiro Pedido do cliente Danyel Targino mês de abril
    (10, '2024-04-27', '2024-05-25', '2024-05-21'), -- Primeiro Pedido do cliente Rafael Maurício mês de abril
    (11, '2024-04-28', '2024-05-30', NULL),         -- Primeiro Pedido do cliente Gustavo Targino mês de abril
    (12, '2024-04-29', '2024-06-05', NULL),         -- Primeiro Pedido do cliente Olívio Freitas mês de abril
    (13, '2024-04-30', '2024-06-10', NULL),         -- Primeiro Pedido do cliente João Victor mês de abril
    (14, '2024-05-01', '2024-06-15', NULL),         -- Primeiro Pedido do cliente Adriel Alexander mês de maio
    (15, '2024-05-02', '2024-06-20', NULL),         -- Primeiro Pedido do cliente André Victor mês de maio
    (16, '2024-05-03', '2024-06-25', NULL),         -- Primeiro Pedido do cliente Gustavo Brandão mês de maio
    (17, '2024-05-04', '2024-06-30', NULL),         -- Primeiro Pedido do cliente Rafael Valentim mês de maio
    (18, '2024-05-05', '2024-07-05', NULL),         -- Primeiro Pedido do cliente Thomaz Falbo mês de maio
    (19, '2024-05-06', '2024-07-10', NULL),         -- Primeiro Pedido do cliente Marcus Mandara mês de maio
    (20, '2024-05-07', '2024-07-15', NULL);         -- Primeiro Pedido do cliente Isabella Tragante mês de maio
GO 

-- Insert Único para os produtos
INSERT INTO [dbo].[Produto] (Nome) 
VALUES 
							('Caixa de papelão laminado super resistente'),
							('Sacola de papel kraft reciclado'),
							('Embalagem plástica para alimentos'),
							('Pote de vidro para conservas'),
							('Envelope de papel para correspondência'),
							('Garrafa PET para bebidas'),
							('Caixa de papelão ondulado'),
							('Sacola biodegradável'),
							('Embalagem plástica com tampa'),
							('Pote de vidro para doces'),
							('Envelope almofadado'),
							('Garrafa de vidro para sucos'),
							('Caixa de papelão para mudanças'),
							('Sacola de papel com alça'),
							('Embalagem plástica para líquidos'),
							('Pote de vidro para temperos'),
							('Envelope de segurança'),
							('Garrafa de alumínio'),
							('Caixa de papelão personalizada'),
							('Sacola de tecido reutilizável'),
							('Embalagem de papelão para alimentos'),
							('Pote de vidro decorativo'),
							('Envelope para documentos'),
							('Garrafa de vidro com tampa de rosca'),
							('Caixa de papelão dupla face'),
							('Sacola de papel com reforço'),
							('Embalagem de plástico biodegradável'),
							('Pote de vidro com tampa hermética'),
							('Envelope de papel kraft'),
							('Garrafa PET reciclada');
GO 

-- Insert único para as matérias-primas
INSERT INTO [dbo].[MateriaPrima]	(Nome) 
VALUES 
									('Papelão'),
									('Cola'),
									('Laminação'),
									('Papel kraft reciclado'),
									('Alça de papel torcido'),
									('Plástico (polietileno de alta densidade)'),
									('Selagem térmica'),
									('Vidro'),
									('Tampa metálica'),
									('Vedante de borracha'),
									('Papel sulfite'),
									('Adesivo para selagem'),
									('Plástico PET (polietileno tereftalato)'),
									('Tampa de rosca'),
									('Cartão duplex'),
									('Pigmento para plástico'),
									('Papel reciclado'),
									('Fio de polipropileno'),
									('Silicone para vedação'),
									('Papelão ondulado'),
									('Tintas ecológicas'),
									('Alumínio'),
									('Revestimento de polímero'),
									('Cera para selagem'),
									('Fita adesiva'),
									('Polietileno de baixa densidade'),
									('Plástico biodegradável'),
									('Tecido não tecido'),
									('Espuma de poliestireno'),
									('Adesivo de alta resistência'),
									('Policarbonato'),
									('Filme stretch'),
									('Resina epóxi'),
									('Lacre de segurança'),
									('Poliuretano'),
									('PVC (policloreto de vinila)'),
									('Pigmento para papel'),
									('Polipropileno reciclado'),
									('Tinta UV');
GO 

-- Composição do produto 'Caixa de papelãoo laminado super resistente' 
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(1, 1, 1000), -- Papelão
								(1, 2, 50),  -- Cola
								(1, 3, 310);  -- Laminação
GO

-- Composição do produto 'Sacola de papel kraft reciclado' 
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(2, 4, 200), -- Papel kraft reciclado
								(2, 5, 100); -- Alçaa de papel torcido
GO 

-- Composição do produto 'Embalagem plÃ¡stica para alimentos' (IdProduto = 3)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(3, 6, 500), -- Plástico (polietileno de alta densidade)
								(3, 7, 200); -- Selagem térmica
GO

-- Composição do produto 'Pote de vidro para conservas' (IdProduto = 4)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(4, 8, 1000), -- Vidro
								(4, 9, 300), -- Tampa metálica
								(4, 10, 50); -- Vedante de borracha
GO

-- Composição do produto 'Envelope de papel para correspondÃªncia' (IdProduto = 5)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(5, 11, 300), -- Papel sulfite
								(5, 12, 10); -- Adesivo para selagem
GO

-- Composição do produto 'Garrafa PET para bebidas' (IdProduto = 6)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(6, 13, 1500), -- Plástico PET (polietileno tereftalato)
								(6, 14, 100); -- Tampa de rosca
GO

-- Composição do produto 'Caixa de papelão ondulado' (IdProduto = 7)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (7, 1, 1000),  -- Papelão
    (7, 20, 500);  -- Papelão ondulado
GO

-- Composição do produto 'Sacola biodegradável' (IdProduto = 8)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (8, 27, 800),  -- Plástico biodegradável
    (8, 16, 50);   -- Pigmento para plástico
GO

-- Composição do produto 'Embalagem plástica com tampa' (IdProduto = 9)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (9, 6, 500),   -- Plástico (polietileno de alta densidade)
    (9, 14, 100);  -- Tampa de rosca
GO

-- Composição do produto 'Pote de vidro para doces' (IdProduto = 10)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (10, 8, 1000),  -- Vidro
    (10, 9, 200);   -- Tampa metálica
GO

-- Composição do produto 'Envelope almofadado' (IdProduto = 11)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (11, 11, 300),  -- Papel sulfite
    (11, 29, 100);  -- Espuma de poliestireno
GO

-- Composição do produto 'Garrafa de vidro para sucos' (IdProduto = 12)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (12, 8, 1200),  -- Vidro
    (12, 14, 100);  -- Tampa de rosca
GO

-- Composição do produto 'Caixa de papelão para mudanças' (IdProduto = 13)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (13, 1, 1500),  -- Papelão
    (13, 2, 50);    -- Cola
GO

-- Composição do produto 'Sacola de papel com alça' (IdProduto = 14)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (14, 4, 200),  -- Papel kraft reciclado
    (14, 5, 100);  -- Alça de papel torcido
GO

-- Composição do produto 'Embalagem plástica para líquidos' (IdProduto = 15)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (15, 6, 500),   -- Plástico (polietileno de alta densidade)
    (15, 33, 50);   -- Resina epóxi
GO

-- Composição do produto 'Pote de vidro para temperos' (IdProduto = 16)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (16, 8, 800),   -- Vidro
    (16, 9, 150),   -- Tampa metálica
    (16, 10, 20);   -- Vedante de borracha
GO

-- Composição do produto 'Envelope de segurança' (IdProduto = 17)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (17, 11, 200),  -- Papel sulfite
    (17, 34, 10);   -- Lacre de segurança
GO

-- Composição do produto 'Garrafa de alumínio' (IdProduto = 18)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (18, 22, 1200), -- Alumínio
    (18, 9, 100);   -- Tampa metálica
GO

-- Composição do produto 'Caixa de papelão personalizada' (IdProduto = 19)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (19, 1, 1000),  -- Papelão
    (19, 37, 50);   -- Pigmento para papel
GO

-- Composição do produto 'Sacola de tecido reutilizável' (IdProduto = 20)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (20, 28, 500),  -- Tecido não tecido
    (20, 19, 30);   -- Silicone para vedação
GO

-- Composição do produto 'Embalagem de papelão para alimentos' (IdProduto = 21)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (21, 20, 600),  -- Papelão ondulado
    (21, 1, 400),   -- Papelão
    (21, 2, 30);    -- Cola
GO

-- Composição do produto 'Pote de vidro decorativo' (IdProduto = 22)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (22, 8, 800),   -- Vidro
    (22, 18, 50),   -- Pigmento para plástico
    (22, 9, 100);   -- Tampa metálica
GO

-- Composição do produto 'Envelope para documentos' (IdProduto = 23)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (23, 11, 300),  -- Papel sulfite
    (23, 12, 10);   -- Adesivo para selagem
GO

-- Composição do produto 'Garrafa de vidro com tampa de rosca' (IdProduto = 24)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (24, 8, 1000),  -- Vidro
    (24, 14, 100);  -- Tampa de rosca
GO

-- Composição do produto 'Caixa de papelão dupla face' (IdProduto = 25)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (25, 1, 1200),  -- Papelão
    (25, 3, 50),    -- Laminação
    (25, 20, 600);  -- Papelão ondulado
GO

-- Composição do produto 'Sacola de papel com reforço' (IdProduto = 26)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (26, 4, 300),  -- Papel kraft reciclado
    (26, 5, 50),   -- Alça de papel torcido
    (26, 19, 20);  -- Silicone para vedação
GO

-- Composição do produto 'Embalagem de plástico biodegradável' (IdProduto = 27)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (27, 27, 500),  -- Plástico biodegradável
    (27, 16, 20);   -- Pigmento para plástico
GO

-- Composição do produto 'Pote de vidro com tampa hermética' (IdProduto = 28)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (28, 8, 800),   -- Vidro
    (28, 14, 50),   -- Tampa de rosca
    (28, 19, 10);   -- Silicone para vedação
GO

-- Composição do produto 'Envelope de papel kraft' (IdProduto = 29)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (29, 4, 200),  -- Papel kraft reciclado
    (29, 12, 10);  -- Adesivo para selagem
GO

-- Composição do produto 'Garrafa PET reciclada' (IdProduto = 30)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (30, 13, 1200), -- Plástico PET (polietileno tereftalato)
    (30, 14, 100);  -- Tampa de rosca
GO



-- Inserts de mock de estoque para cada produto
INSERT INTO [dbo].[EstoqueProduto]	(IdProduto, QuantidadeFisica, QuantidadeMinima) 
VALUES 
									(1, 150, 100), -- Caixa de papelão laminado super resistente
									(2, 300, 150), -- Sacola de papel kraft reciclado
									(3, 300, 200), -- Embalagem plástica para alimentos
									(4, 200, 100), -- Pote de vidro para conservas
									(5, 350, 250), -- Envelope de papel para correspondência
									(6, 300, 300), -- Garrafa PET para bebidas
									(7, 250, 150),   -- Caixa de papelão ondulado
									(8, 400, 200),   -- Sacola biodegradável
									(9, 350, 250),   -- Embalagem plástica com tampa
									(10, 300, 150),  -- Pote de vidro para doces
									(11, 200, 100),  -- Envelope almofadado
									(12, 350, 200),  -- Garrafa de vidro para sucos
									(13, 150, 100),  -- Caixa de papelão para mudanças
									(14, 300, 200),  -- Sacola de papel com alça
									(15, 250, 150),  -- Embalagem plástica para líquidos
									(16, 200, 100),  -- Pote de vidro para temperos
									(17, 250, 200),  -- Envelope de segurança
									(18, 300, 200),  -- Garrafa de alumínio
									(19, 200, 100),  -- Caixa de papelão personalizada
									(20, 150, 100),  -- Sacola de tecido reutilizável
									(21, 300, 150),  -- Embalagem de papelão para alimentos
									(22, 250, 150),  -- Pote de vidro decorativo
									(23, 200, 100),  -- Envelope para documentos
									(24, 300, 200),  -- Garrafa de vidro com tampa de rosca
									(25, 250, 150),  -- Caixa de papelão dupla face
									(26, 300, 200),  -- Sacola de papel com reforço
									(27, 250, 150),  -- Embalagem de plástico biodegradável
									(28, 200, 100),  -- Pote de vidro com tampa hermética
									(29, 300, 200),  -- Envelope de papel kraft
									(30, 250, 150);  -- Garrafa PET reciclada
GO

-- Insert único para o estoque de todas as matérias-primas
INSERT INTO [dbo].[EstoqueMateriaPrima] (IdMateriaPrima, QuantidadeFisica, QuantidadeMinima) 
VALUES
										(1, 5000, 1000), -- Papelão
										(2, 300, 50), -- Cola
										(3, 200, 50), -- Laminação
										(4, 6000, 1500), -- Papel kraft reciclado
										(5, 1000, 200), -- Alça de papel torcido
										(6, 8000, 2000), -- Plástico (polietileno de alta densidade)
										(7, 500, 100), -- Selagem térmica
										(8, 4000, 800), -- Vidro
										(9, 2000, 400), -- Tampa metálica
										(10, 1000, 200), -- Vedante de borracha
										(11, 7000, 1500), -- Papel sulfite
										(12, 400, 100), -- Adesivo para selagem
										(13, 9000, 2500), -- Plástico PET (polietileno tereftalato)
										(14, 3000, 600), -- Tampa de rosca
										(15, 5000, 1000),  -- Cartão duplex
										(16, 200, 50),     -- Pigmento para plástico
										(17, 8000, 1500),  -- Papel reciclado
										(18, 1000, 200),   -- Fio de polipropileno
										(19, 500, 100),    -- Silicone para vedação
										(20, 3000, 500),   -- Papelão ondulado
										(21, 200, 50),     -- Tintas ecológicas
										(22, 400, 100),    -- Alumínio
										(23, 3000, 600),   -- Revestimento de polímero
										(24, 100, 20),     -- Cera para selagem
										(25, 500, 100),    -- Fita adesiva
										(26, 6000, 1500),  -- Polietileno de baixa densidade
										(27, 3000, 600),   -- Plástico biodegradável
										(28, 2000, 500),   -- Tecido não tecido
										(29, 1000, 200),   -- Espuma de poliestireno
										(30, 400, 100),    -- Adesivo de alta resistência
										(31, 1500, 300),   -- Policarbonato
										(32, 600, 150),    -- Filme stretch
										(33, 200, 50),     -- Resina epóxi
										(34, 1000, 200),   -- Lacre de segurança
										(35, 300, 100),    -- Poliuretano
										(36, 800, 200),    -- PVC (policloreto de vinila)
										(37, 500, 100),    -- Pigmento para papel
										(38, 2000, 500),   -- Polipropileno reciclado
										(39, 400, 100);    -- Tinta UV
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
									(1, 1, 50),  -- Primeiro Pedido do cliente João Silva - Caixa de papelão laminado super resistente
									(2, 2, 100), -- Primeiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
									(3, 3, 200), -- Primeiro Pedido do cliente Carlos Souza - Embalagem plástica para alimentos
									(4, 4, 150), -- Segundo Pedido do cliente João Silva - Pote de vidro para conservas
									(5, 5, 300), -- Segundo Pedido do cliente Maria Eduarda - Envelope de papel para correspondência
									(6, 6, 400), -- Segundo Pedido do cliente Carlos Souza - Garrafa PET para bebidas
									(7, 1, 75),  -- Terceiro Pedido do cliente João Silva - Caixa de papelão laminado super resistente
									(8, 2, 120), -- Terceiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
									(9, 3, 250), -- Terceiro Pedido do cliente Carlos Souza - Embalagem plástica para alimentos
									(13, 13, 50),   -- Terceiro Pedido do cliente João Victor - Caixa de papelão para mudanças
									(14, 14, 100),  -- Terceiro Pedido do cliente Adriel Alexander - Sacola de papel com alça
									(15, 15, 150),  -- Terceiro Pedido do cliente André Victor - Embalagem plástica para líquidos
									(10, 7, 150),   -- Quarto Pedido do cliente Pedro Avelino - Caixa de papelão ondulado
									(11, 8, 200),   -- Quarto Pedido do cliente Orcino Neto - Sacola biodegradável
									(12, 9, 100),   -- Quarto Pedido do cliente Gabriel Damiani - Embalagem plástica com tampa
									(13, 10, 50),   -- Quarto Pedido do cliente Odlavir Florentino - Pote de vidro para doces
									(14, 11, 300),  -- Quarto Pedido do cliente Thays Carvalho - Envelope almofadado
									(15, 12, 250),  -- Quarto Pedido do cliente Danyel Targino - Garrafa de vidro para sucos
									(10, 10, 80),   -- Terceiro Pedido do cliente Rafael Maurício - Pote de vidro para doces
									(16, 13, 200),  -- Quarto Pedido do cliente Rafael Maurício - Caixa de papelão para mudanças
									(11, 11, 120),  -- Terceiro Pedido do cliente Gustavo Targino - Envelope almofadado
									(17, 14, 100),  -- Quarto Pedido do cliente Gustavo Targino - Sacola de papel com alça
									(12, 12, 200),  -- Terceiro Pedido do cliente Olívio Freitas - Garrafa de vidro para sucos
									(18, 15, 300);  -- Quarto Pedido do cliente Olívio Freitas - Embalagem plástica para líquidos
GO 

-- Inserts para a tabela EtapaProducao

-- Etapas de produção para 'Caixa de papelão laminado super resistente' (IdProduto = 1)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao) 
VALUES
									(1, 'Corte do papelão', 60),
									(1, 'Aplicação de cola e montagem', 120),
									(1, 'Laminação e acabamento', 90);
GO

-- Etapas de produção para 'Sacola de papel kraft reciclado' (IdProduto = 2)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao) 
VALUES
									(2, 'Corte do papel kraft', 45),
									(2, 'Montagem e colagem das alçaas', 60),
									(2, 'Reforço e finalização', 30);
GO

-- Etapas de produção para 'Embalagem plástica para alimentos' (IdProduto = 3)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao) 
VALUES
									(3, 'Extrusão do plásstico', 120),
									(3, 'Corte e moldagem', 90),
									(3, 'Selagem térrmica', 60);
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
									(5, 'Aplicação do adesivo de selagem', 15);
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

-- Etapas de produção para 'Caixa de papelão laminado super resistente' (IdProduto = 1)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(1, 'Corte do papelão', 60, 1),
									(1, 'Aplicação de cola e montagem', 120, 2),
									(1, 'Laminação e acabamento', 90, 3);
GO

-- Etapas de produção para 'Sacola de papel kraft reciclado' (IdProduto = 2)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(2, 'Corte do papel kraft', 45, 1),
									(2, 'Montagem e colagem das alças', 60, 2),
									(2, 'Reforço e finalização', 30, 3);
GO

-- Etapas de produção para 'Embalagem plástica para alimentos' (IdProduto = 3)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(3, 'Extrusão do plástico', 120, 1),
									(3, 'Corte e moldagem', 90, 2),
									(3, 'Selagem térmica', 60, 3);
GO

-- Etapas de produção para 'Pote de vidro para conservas' (IdProduto = 4)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa)
VALUES
									(4, 'Fabricação do vidro', 180, 1),
									(4, 'Moldagem e resfriamento', 120, 2),
									(4, 'Aplicação da tampa e vedante', 45, 3);
GO

-- Etapas de produção para 'Envelope de papel para correspondência' (IdProduto = 5)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(5, 'Corte do papel sulfite', 30, 1),
									(5, 'Dobra e montagem', 45, 2),
									(5, 'Aplicação do adesivo de selagem', 15, 3);
GO

-- Etapas de produção para 'Garrafa PET para bebidas' (IdProduto = 6)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(6, 'Fabricação do plástico PET', 150, 1),
									(6, 'Sopro e moldagem da garrafa', 105, 2),
									(6, 'Aplicação da tampa de rosca', 30, 3);
GO 

-- Etapas de produção para 'Caixa de papelão ondulado' (IdProduto = 7)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (7, 'Corte do papelão ondulado', 75, 1),
    (7, 'Dobra e montagem', 90, 2),
    (7, 'Aplicação de cola e acabamento', 60, 3);
	GO


-- Etapas de produção para 'Sacola biodegradável' (IdProduto = 8)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (8, 'Corte do material biodegradável', 60, 1),
    (8, 'Costura e montagem', 90, 2),
    (8, 'Acabamento final', 45, 3);

	GO

-- Etapas de produção para 'Embalagem plástica com tampa' (IdProduto = 9)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (9, 'Extrusão do plástico', 120, 1),
    (9, 'Moldagem e corte', 90, 2),
    (9, 'Aplicação da tampa', 45, 3);

	GO

-- Etapas de produção para 'Pote de vidro para doces' (IdProduto = 10)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (10, 'Fabricação do vidro', 180, 1),
    (10, 'Moldagem e resfriamento', 120, 2),
    (10, 'Acabamento e rotulagem', 60, 3);

	GO

-- Etapas de produção para 'Envelope almofadado' (IdProduto = 11)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (11, 'Corte do papel kraft e papelão', 90, 1),
    (11, 'Montagem e preenchimento com almofadas', 120, 2),
    (11, 'Fechamento e selagem', 30, 3);

	GO

-- Etapas de produção para 'Garrafa de vidro para sucos' (IdProduto = 12)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (12, 'Fabricação do vidro', 180, 1),
    (12, 'Sopro e moldagem da garrafa', 105, 2),
    (12, 'Lavagem, secagem e rotulagem', 90, 3);

	GO

	-- Etapas de produção para 'Caixa de papelão para mudanças' (IdProduto = 13)
	INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (13, 'Corte e dobra do papelão', 90, 1),
    (13, 'Montagem e colagem', 120, 2),
    (13, 'Aplicação de reforços e acabamento', 60, 3),
    (13, 'Rotulagem e embalagem', 30, 4);

	GO

-- Etapas de produção para 'Sacola de papel com alça' (IdProduto = 14)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (14, 'Corte do papel e da alça', 60, 1),
    (14, 'Montagem e colagem', 90, 2),
    (14, 'Reforço e acabamento', 45, 3);

	GO

-- Etapas de produção para 'Embalagem plástica para líquidos' (IdProduto = 15)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (15, 'Extrusão do plástico', 120, 1),
    (15, 'Moldagem e corte', 90, 2),
    (15, 'Injeção da tampa', 45, 3),
    (15, 'Rotulagem e embalagem', 30, 4);

	GO

-- Etapas de produção para 'Pote de vidro para temperos' (IdProduto = 16)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (16, 'Fabricação do vidro', 180, 1),
    (16, 'Moldagem e resfriamento', 120, 2),
    (16, 'Acabamento e rotulagem', 60, 3);

	GO

-- Etapas de produção para 'Envelope de segurança' (IdProduto = 17)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (17, 'Corte e dobra do papel kraft especial', 75, 1),
    (17, 'Aplicação de adesivo especial', 60, 2),
    (17, 'Secagem e acabamento', 45, 3);

	GO

-- Etapas de produção para 'Garrafa de alumínio' (IdProduto = 18)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (18, 'Moldagem e prensagem do alumínio', 180, 1),
    (18, 'Corte e acabamento', 120, 2),
    (18, 'Rotulagem e embalagem', 60, 3);

	GO

-- Etapas de produção para 'Caixa de papelão personalizada' (IdProduto = 19)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (19, 'Corte e dobra do papelão especial', 90, 1),
    (19, 'Montagem e colagem', 120, 2),
    (19, 'Acabamento personalizado', 60, 3),
    (19, 'Rotulagem e embalagem', 30, 4);

	GO

-- Etapas de produção para 'Sacola de tecido reutilizável' (IdProduto = 20)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (20, 'Corte e costura do tecido', 90, 1),
    (20, 'Acabamento e reforço', 60, 2),
    (20, 'Aplicação de alça', 45, 3),
    (20, 'Embalagem final', 30, 4);

	GO

	-- Etapas de produção para 'Embalagem de papelão para alimentos' (IdProduto = 21)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (21, 'Corte e dobra do papelão especial', 90, 1),
    (21, 'Montagem e colagem', 120, 2),
    (21, 'Reforço e acabamento', 60, 3),
    (21, 'Rotulagem e embalagem', 30, 4);

	GO

-- Etapas de produção para 'Pote de vidro decorativo' (IdProduto = 22)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (22, 'Fabricação do vidro decorativo', 180, 1),
    (22, 'Moldagem e resfriamento', 120, 2),
    (22, 'Acabamento e rotulagem', 60, 3);

	GO

-- Etapas de produção para 'Envelope para documentos' (IdProduto = 23)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (23, 'Corte e dobra do papel kraft', 75, 1),
    (23, 'Aplicação de adesivo especial', 60, 2),
    (23, 'Secagem e acabamento', 45, 3),
    (23, 'Embalagem final', 30, 4);

	GO

-- Etapas de produção para 'Garrafa de vidro com tampa de rosca' (IdProduto = 24)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (24, 'Fabricação do vidro', 180, 1),
    (24, 'Moldagem e resfriamento', 120, 2),
    (24, 'Aplicação da tampa de rosca', 60, 3),
    (24, 'Rotulagem e embalagem', 45, 4);

	GO

-- Etapas de produção para 'Caixa de papelão dupla face' (IdProduto = 25)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (25, 'Corte e dobra do papelão especial', 90, 1),
    (25, 'Montagem e colagem', 120, 2),
    (25, 'Reforço e acabamento', 60, 3),
    (25, 'Rotulagem e embalagem', 30, 4),
    (25, 'Embalagem final', 15, 5);

	GO

-- Etapas de produção para 'Sacola de papel com reforço' (IdProduto = 26)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (26, 'Corte e dobra do papel', 60, 1),
    (26, 'Montagem e colagem', 90, 2),
    (26, 'Aplicação do reforço', 45, 3),
    (26, 'Acabamento final', 30, 4);

	GO

-- Etapas de produção para 'Embalagem de plástico biodegradável' (IdProduto = 27)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (27, 'Extrusão do plástico biodegradável', 120, 1),
    (27, 'Moldagem e corte', 90, 2),
    (27, 'Injeção da tampa biodegradável', 45, 3),
    (27, 'Rotulagem e embalagem', 30, 4),
    (27, 'Embalagem final', 15, 5);

	GO

-- Etapas de produção para 'Pote de vidro com tampa hermética' (IdProduto = 28)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (28, 'Fabricação do vidro', 180, 1),
    (28, 'Moldagem e resfriamento', 120, 2),
    (28, 'Aplicação da tampa hermética', 60, 3),
    (28, 'Acabamento e rotulagem', 45, 4);

	GO

-- Etapas de produção para 'Envelope de papel kraft' (IdProduto = 29)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (29, 'Corte e dobra do papel kraft', 75, 1),
    (29, 'Aplicação de adesivo especial', 60, 2),
    (29, 'Secagem e acabamento', 45, 3),
    (29, 'Embalagem final', 30, 4);

	GO

-- Etapas de produção para 'Garrafa PET reciclada' (IdProduto = 30)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (30, 'Reciclagem do plástico PET', 120, 1),
    (30, 'Extrusão e moldagem da garrafa', 90, 2),
    (30, 'Revestimento e rotulagem', 60, 3),
    (30, 'Embalagem final', 30, 4);

	GO


-- Primeiro Pedido do cliente João Silva - Caixa de papelão laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES 
												(1, 2, '2024-01-30', 50); -- Saída de produto

												GO


-- Primeiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(2, 2, '28/02/2024', 100); -- Saída de produto

-- Primeiro Pedido do cliente Carlos Souza - Embalagem plástica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(3, 2, '2024-01-30', 200); -- Saída de produto

GO

-- Segundo Pedido do cliente João Silva - Pote de vidro para conservas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES 
												(4, 2, '2024-04-20', 150); -- Saída de produto

GO

-- Segundo Pedido do cliente Maria Eduarda - Envelope de papel para correspondência
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES
												(5, 2, '2024-03-27', 300); -- Saída de produto

GO              

-- Segundo Pedido do cliente Carlos Souza - Garrafa PET para bebidas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(6, 2, '27/03-2024', 400); -- Saída de produto
GO

-- Terceiro Pedido do cliente João Silva - Caixa de papelão laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES 
												(1, 2, '2024-05-30', 75); -- Saída de produto

GO

-- Terceiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 

												(2, 2, '27/05/2024', 120); -- Saída de produto
GO

-- Terceiro Pedido do cliente Carlos Souza - Embalagem plástica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(2, 2, '27/05/2024', 120); -- Saída de produto
GO

-- Primeiro Pedido do cliente Pedro Avelino - Caixa de papelão laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (1, 2, '2024-01-30', 50); 

GO

-- Primeiro Pedido do cliente Orcino Neto - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (2, 2, '2024-02-28', 100); 

GO

-- Primeiro Pedido do cliente Gabriel Damiani - Embalagem plástica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (3, 2, '2024-01-30', 200); 

GO

-- Segundo Pedido do cliente Odlavir Florentino - Pote de vidro para conservas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (4, 2, '2024-04-20', 150);

GO

-- Segundo Pedido do cliente Thays Carvalho - Envelope de papel para correspondência
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (5, 2, '2024-03-27', 300); 

GO

-- Segundo Pedido do cliente Danyel Targino - Garrafa PET para bebidas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (6, 2, '2024-03-27', 400); 

GO

-- Terceiro Pedido do cliente Rafael Maurício - Caixa de papelão laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (1, 2, '2024-05-30', 75); 

GO

-- Terceiro Pedido do cliente Gustavo Targino - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (2, 2, '2024-05-27', 120); 

GO

-- Terceiro Pedido do cliente Olívio Freitas - Embalagem plástica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (3, 2, '2024-05-30', 250); 

GO

-- Primeiro Pedido do cliente Rafael Maurício - Pote de vidro para temperos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (16, 2, '2024-06-15', 50); 

GO

-- Primeiro Pedido do cliente Gustavo Targino - Envelope de segurança
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (17, 2, '2024-06-20', 80); 

GO

-- Primeiro Pedido do cliente Olívio Freitas - Garrafa de alumínio
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (18, 2, '2024-06-25', 90); 

GO

-- Segundo Pedido do cliente João Victor - Caixa de papelão personalizada
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (19, 2, '2024-07-01', 120); 

GO

-- Segundo Pedido do cliente Adriel Alexander - Sacola de tecido reutilizável
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (20, 2, '2024-07-10', 150); 

GO

-- Segundo Pedido do cliente André Victor - Embalagem de papelão para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (21, 2, '2024-07-15', 180); 

GO

-- Terceiro Pedido do cliente Gustavo Brandão - Pote de vidro decorativo
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (22, 2, '2024-07-20', 200); 

GO

-- Terceiro Pedido do cliente Rafael Valentim - Envelope para documentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (23, 2, '2024-07-25', 100); 

GO

-- Terceiro Pedido do cliente Thomaz Falbo - Garrafa de vidro com tampa de rosca
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (24, 2, '2024-07-30', 150); 

GO

-- Quarto Pedido do cliente Marcus Mandara - Caixa de papelão dupla face
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (25, 2, '2024-08-05', 200); 

GO

-- Quarto Pedido do cliente Isabella Tragante - Sacola de papel com reforço
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (26, 2, '2024-08-10', 100); 

GO

-- Quarto Pedido do cliente [Nome do Cliente] - Embalagem de plástico biodegradável
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (27, 2, '2024-08-15', 250); 

GO

-- Quarto Pedido do cliente [Nome do Cliente] - Pote de vidro com tampa hermética
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (28, 2, '2024-08-20', 120); 

GO

-- Quarto Pedido do cliente [Nome do Cliente] - Envelope de papel kraft
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (29, 2, '2024-08-25', 180); 

GO

-- Quarto Pedido do cliente [Nome do Cliente] - Garrafa PET reciclada
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, IdTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (30, 2, '2024-08-30', 200); 

GO