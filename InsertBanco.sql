USE pcp

GO

INSERT INTO [dbo].[Cliente] (Nome) 
VALUES 
							('Jo�o Silva'),
							('Maria Oliveira'),
							('Carlos Souza'),
							('Pedro Avelino'),
							('Orcino Neto'),
							('Gabriel Damiani'),
							('Odlavir Florentino'),
							('Thays Carvalho'),
							('Danyel Targino'),
							('Rafael Maur�cio'),
							('Gustavo Targino'),
							('Ol�vio Freitas'),
							('Jo�o Victor'),
							('Adriel Alexander'),
							('Andr� Victor'),
							('Gustavo Brand�o'),
							('Rafael Valentim'),
							('Thomaz Falbo'),
							('Marcus Mandara'),
							('Isabella Tragante');
GO

INSERT INTO [dbo].[Pedido] (IdCliente, DataPedido, DataPromessa, DataEntrega)
VALUES
    (1, '2024-01-20', '2024-01-28', '2024-01-30'), -- Primeiro Pedido do cliente jo�o silva m�s de janeiro conclu�do
    (2, '2024-02-21', '2024-02-27', '2024-02-28'), -- Primeiro Pedido do cliente Maria Eduarda m�s de Fevereiro conclu�do
    (3, '2024-01-22', '2024-01-30', '2024-01-30'), -- Primeiro Pedido do cliente Carlos Souza m�s de janeiro conclu�do
    (1, '2024-04-01', '2024-04-14', '2024-04-20'), -- Segundo Pedido do cliente jo�o silva m�s de abril conclu�do
    (2, '2024-03-21', '2024-03-27', '2024-03-27'), -- Segundo Pedido do cliente Maria Eduarda m�s de mar�o conclu�do
    (3, '2024-03-22', '2024-03-30', '2024-04-01'), -- Segundo Pedido do cliente Carlos Souza m�s de mar�o conclu�do
    (1, '2024-05-25', '2024-05-30', NULL),         -- Terceiro Pedido do cliente jo�o silva m�s de maio
    (2, '2024-05-21', '2024-05-27', NULL),         -- Terceiro Pedido do cliente Maria Eduarda m�s de maio
    (3, '2024-05-22', '2024-05-30', NULL),         -- Terceiro Pedido do cliente Carlos Souza m�s de maio
    (4, '2024-05-23', '2024-06-12', NULL),         -- Primeiro Pedido do cliente Pedro Avelino m�s de maio
    (5, '2024-05-12', '2024-07-02', NULL),         -- Primeiro Pedido do cliente Orcino Neto m�s de maio
    (6, '2024-03-02', '2024-05-02', '2024-03-31'), -- Primeiro Pedido do cliente Gabriel Damiani m�s de mar�o
    (7, '2024-04-24', '2024-05-10', '2024-05-12'), -- Primeiro Pedido do cliente Odlavir Florentino m�s de abril
    (8, '2024-04-25', '2024-05-15', '2024-05-12'), -- Primeiro Pedido do cliente Thays Carvalho m�s de abril
    (9, '2024-04-26', '2024-05-20', '2024-05-23'), -- Primeiro Pedido do cliente Danyel Targino m�s de abril
    (10, '2024-04-27', '2024-05-25', '2024-05-21'), -- Primeiro Pedido do cliente Rafael Maur�cio m�s de abril
    (11, '2024-04-28', '2024-05-30', NULL),         -- Primeiro Pedido do cliente Gustavo Targino m�s de abril
    (12, '2024-04-29', '2024-06-05', NULL),         -- Primeiro Pedido do cliente Ol�vio Freitas m�s de abril
    (13, '2024-04-30', '2024-06-10', NULL),         -- Primeiro Pedido do cliente Jo�o Victor m�s de abril
    (14, '2024-05-01', '2024-06-15', NULL),         -- Primeiro Pedido do cliente Adriel Alexander m�s de maio
    (15, '2024-05-02', '2024-06-20', NULL),         -- Primeiro Pedido do cliente Andr� Victor m�s de maio
    (16, '2024-05-03', '2024-06-25', NULL),         -- Primeiro Pedido do cliente Gustavo Brand�o m�s de maio
    (17, '2024-05-04', '2024-06-30', NULL),         -- Primeiro Pedido do cliente Rafael Valentim m�s de maio
    (18, '2024-05-05', '2024-07-05', NULL),         -- Primeiro Pedido do cliente Thomaz Falbo m�s de maio
    (19, '2024-05-06', '2024-07-10', NULL),         -- Primeiro Pedido do cliente Marcus Mandara m�s de maio
    (20, '2024-05-07', '2024-07-15', NULL);         -- Primeiro Pedido do cliente Isabella Tragante m�s de maio


GO 

-- Insert �nico para os produtos
INSERT INTO [dbo].[Produto] (Nome) 
VALUES 
							('Caixa de papel�o laminado super resistente'),
							('Sacola de papel kraft reciclado'),
							('Embalagem pl�stica para alimentos'),
							('Pote de vidro para conservas'),
							('Envelope de papel para correspond�ncia'),
							('Garrafa PET para bebidas'),
							('Caixa de papel�o ondulado'),
							('Sacola biodegrad�vel'),
							('Embalagem pl�stica com tampa'),
							('Pote de vidro para doces'),
							('Envelope almofadado'),
							('Garrafa de vidro para sucos'),
							('Caixa de papel�o para mudan�as'),
							('Sacola de papel com al�a'),
							('Embalagem pl�stica para l�quidos'),
							('Pote de vidro para temperos'),
							('Envelope de seguran�a'),
							('Garrafa de alum�nio'),
							('Caixa de papel�o personalizada'),
							('Sacola de tecido reutiliz�vel'),
							('Embalagem de papel�o para alimentos'),
							('Pote de vidro decorativo'),
							('Envelope para documentos'),
							('Garrafa de vidro com tampa de rosca'),
							('Caixa de papel�o dupla face'),
							('Sacola de papel com refor�o'),
							('Embalagem de pl�stico biodegrad�vel'),
							('Pote de vidro com tampa herm�tica'),
							('Envelope de papel kraft'),
							('Garrafa PET reciclada');
GO 

-- Insert �nico para as mat�rias-primas
INSERT INTO [dbo].[MateriaPrima]	(Nome) 
VALUES 
									('Papel�o'),
									('Cola'),
									('Lamina��o'),
									('Papel kraft reciclado'),
									('Al�a de papel torcido'),
									('Pl�stico (polietileno de alta densidade)'),
									('Selagem t�rmica'),
									('Vidro'),
									('Tampa met�lica'),
									('Vedante de borracha'),
									('Papel sulfite'),
									('Adesivo para selagem'),
									('Pl�stico PET (polietileno tereftalato)'),
									('Tampa de rosca'),
									('Cart�o duplex'),
									('Pigmento para pl�stico'),
									('Papel reciclado'),
									('Fio de polipropileno'),
									('Silicone para veda��o'),
									('Papel�o ondulado'),
									('Tintas ecol�gicas'),
									('Alum�nio'),
									('Revestimento de pol�mero'),
									('Cera para selagem'),
									('Fita adesiva'),
									('Polietileno de baixa densidade'),
									('Pl�stico biodegrad�vel'),
									('Tecido n�o tecido'),
									('Espuma de poliestireno'),
									('Adesivo de alta resist�ncia'),
									('Policarbonato'),
									('Filme stretch'),
									('Resina ep�xi'),
									('Lacre de seguran�a'),
									('Poliuretano'),
									('PVC (policloreto de vinila)'),
									('Pigmento para papel'),
									('Polipropileno reciclado'),
									('Tinta UV');
GO 

-- Composi��o do produto 'Caixa de papel�o laminado super resistente' 
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(1, 1, 1000), -- Papel�o
								(1, 2, 50),  -- Cola
								(1, 3, 310);  -- Lamina��o
GO

-- Composi��o do produto 'Sacola de papel kraft reciclado' 
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(2, 4, 200), -- Papel kraft reciclado
								(2, 5, 100); -- Al�a de papel torcido
GO 

-- Composi��o do produto 'Embalagem pl�stica para alimentos' (IdProduto = 3)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(3, 6, 500), -- Pl�stico (polietileno de alta densidade)
								(3, 7, 200); -- Selagem t�rmica
GO

-- Composi��o do produto 'Pote de vidro para conservas' (IdProduto = 4)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(4, 8, 1000), -- Vidro
								(4, 9, 300), -- Tampa met�lica
								(4, 10, 50); -- Vedante de borracha
GO

-- Composi��o do produto 'Envelope de papel para correspond�ncia' (IdProduto = 5)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(5, 11, 300), -- Papel sulfite
								(5, 12, 10); -- Adesivo para selagem
GO

-- Composi��o do produto 'Garrafa PET para bebidas' (IdProduto = 6)
INSERT INTO [dbo].[Composicao]	(IdProduto, IdMateriaPrima, Quantidade) 
VALUES 
								(6, 13, 1500), -- Pl�stico PET (polietileno tereftalato)
								(6, 14, 100); -- Tampa de rosca
GO

-- Composi��o do produto 'Caixa de papel�o ondulado' (IdProduto = 7)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (7, 1, 1000),  -- Papel�o
    (7, 20, 500);  -- Papel�o ondulado
GO

-- Composi��o do produto 'Sacola biodegrad�vel' (IdProduto = 8)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (8, 27, 800),  -- Pl�stico biodegrad�vel
    (8, 16, 50);   -- Pigmento para pl�stico
GO

-- Composi��o do produto 'Embalagem pl�stica com tampa' (IdProduto = 9)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (9, 6, 500),   -- Pl�stico (polietileno de alta densidade)
    (9, 14, 100);  -- Tampa de rosca
GO

-- Composi��o do produto 'Pote de vidro para doces' (IdProduto = 10)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (10, 8, 1000),  -- Vidro
    (10, 9, 200);   -- Tampa met�lica
GO

-- Composi��o do produto 'Envelope almofadado' (IdProduto = 11)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (11, 11, 300),  -- Papel sulfite
    (11, 29, 100);  -- Espuma de poliestireno
GO

-- Composi��o do produto 'Garrafa de vidro para sucos' (IdProduto = 12)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (12, 8, 1200),  -- Vidro
    (12, 14, 100);  -- Tampa de rosca
GO

-- Composi��o do produto 'Caixa de papel�o para mudan�as' (IdProduto = 13)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (13, 1, 1500),  -- Papel�o
    (13, 2, 50);    -- Cola
GO

-- Composi��o do produto 'Sacola de papel com al�a' (IdProduto = 14)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (14, 4, 200),  -- Papel kraft reciclado
    (14, 5, 100);  -- Al�a de papel torcido
GO

-- Composi��o do produto 'Embalagem pl�stica para l�quidos' (IdProduto = 15)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (15, 6, 500),   -- Pl�stico (polietileno de alta densidade)
    (15, 33, 50);   -- Resina ep�xi
GO

-- Composi��o do produto 'Pote de vidro para temperos' (IdProduto = 16)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (16, 8, 800),   -- Vidro
    (16, 9, 150),   -- Tampa met�lica
    (16, 10, 20);   -- Vedante de borracha
GO

-- Composi��o do produto 'Envelope de seguran�a' (IdProduto = 17)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (17, 11, 200),  -- Papel sulfite
    (17, 34, 10);   -- Lacre de seguran�a
GO

-- Composi��o do produto 'Garrafa de alum�nio' (IdProduto = 18)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (18, 22, 1200), -- Alum�nio
    (18, 9, 100);   -- Tampa met�lica
GO

-- Composi��o do produto 'Caixa de papel�o personalizada' (IdProduto = 19)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (19, 1, 1000),  -- Papel�o
    (19, 37, 50);   -- Pigmento para papel
GO

-- Composi��o do produto 'Sacola de tecido reutiliz�vel' (IdProduto = 20)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (20, 28, 500),  -- Tecido n�o tecido
    (20, 19, 30);   -- Silicone para veda��o
GO

-- Composi��o do produto 'Embalagem de papel�o para alimentos' (IdProduto = 21)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (21, 20, 600),  -- Papel�o ondulado
    (21, 1, 400),   -- Papel�o
    (21, 2, 30);    -- Cola
GO

-- Composi��o do produto 'Pote de vidro decorativo' (IdProduto = 22)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (22, 8, 800),   -- Vidro
    (22, 18, 50),   -- Pigmento para pl�stico
    (22, 9, 100);   -- Tampa met�lica
GO

-- Composi��o do produto 'Envelope para documentos' (IdProduto = 23)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (23, 11, 300),  -- Papel sulfite
    (23, 12, 10);   -- Adesivo para selagem
GO

-- Composi��o do produto 'Garrafa de vidro com tampa de rosca' (IdProduto = 24)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (24, 8, 1000),  -- Vidro
    (24, 14, 100);  -- Tampa de rosca
GO

-- Composi��o do produto 'Caixa de papel�o dupla face' (IdProduto = 25)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (25, 1, 1200),  -- Papel�o
    (25, 3, 50),    -- Lamina��o
    (25, 20, 600);  -- Papel�o ondulado
GO

-- Composi��o do produto 'Sacola de papel com refor�o' (IdProduto = 26)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (26, 4, 300),  -- Papel kraft reciclado
    (26, 5, 50),   -- Al�a de papel torcido
    (26, 19, 20);  -- Silicone para veda��o
GO

-- Composi��o do produto 'Embalagem de pl�stico biodegrad�vel' (IdProduto = 27)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (27, 27, 500),  -- Pl�stico biodegrad�vel
    (27, 16, 20);   -- Pigmento para pl�stico
GO

-- Composi��o do produto 'Pote de vidro com tampa herm�tica' (IdProduto = 28)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (28, 8, 800),   -- Vidro
    (28, 14, 50),   -- Tampa de rosca
    (28, 19, 10);   -- Silicone para veda��o
GO

-- Composi��o do produto 'Envelope de papel kraft' (IdProduto = 29)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (29, 4, 200),  -- Papel kraft reciclado
    (29, 12, 10);  -- Adesivo para selagem
GO

-- Composi��o do produto 'Garrafa PET reciclada' (IdProduto = 30)
INSERT INTO [dbo].[Composicao] (IdProduto, IdMateriaPrima, Quantidade)
VALUES 
    (30, 13, 1200), -- Pl�stico PET (polietileno tereftalato)
    (30, 14, 100);  -- Tampa de rosca
GO



-- Inserts de mock de estoque para cada produto
INSERT INTO [dbo].[EstoqueProduto]	(IdProduto, QuantidadeFisica, QuantidadeMinima) 
VALUES 
									(1, 150, 100), -- Caixa de papel�o laminado super resistente
									(2, 300, 150), -- Sacola de papel kraft reciclado
									(3, 300, 200), -- Embalagem pl�stica para alimentos
									(4, 200, 100), -- Pote de vidro para conservas
									(5, 350, 250), -- Envelope de papel para correspond�ncia
									(6, 300, 300), -- Garrafa PET para bebidas
									(7, 250, 150),   -- Caixa de papel�o ondulado
									(8, 400, 200),   -- Sacola biodegrad�vel
									(9, 350, 250),   -- Embalagem pl�stica com tampa
									(10, 300, 150),  -- Pote de vidro para doces
									(11, 200, 100),  -- Envelope almofadado
									(12, 350, 200),  -- Garrafa de vidro para sucos
									(13, 150, 100),  -- Caixa de papel�o para mudan�as
									(14, 300, 200),  -- Sacola de papel com al�a
									(15, 250, 150),  -- Embalagem pl�stica para l�quidos
									(16, 200, 100),  -- Pote de vidro para temperos
									(17, 250, 200),  -- Envelope de seguran�a
									(18, 300, 200),  -- Garrafa de alum�nio
									(19, 200, 100),  -- Caixa de papel�o personalizada
									(20, 150, 100),  -- Sacola de tecido reutiliz�vel
									(21, 300, 150),  -- Embalagem de papel�o para alimentos
									(22, 250, 150),  -- Pote de vidro decorativo
									(23, 200, 100),  -- Envelope para documentos
									(24, 300, 200),  -- Garrafa de vidro com tampa de rosca
									(25, 250, 150),  -- Caixa de papel�o dupla face
									(26, 300, 200),  -- Sacola de papel com refor�o
									(27, 250, 150),  -- Embalagem de pl�stico biodegrad�vel
									(28, 200, 100),  -- Pote de vidro com tampa herm�tica
									(29, 300, 200),  -- Envelope de papel kraft
									(30, 250, 150);  -- Garrafa PET reciclada
GO

-- Insert �nico para o estoque de todas as mat�rias-primas
INSERT INTO [dbo].[EstoqueMateriaPrima] (IdMateriaPrima, QuantidadeFisica, QuantidadeMinima) 
VALUES
										(1, 5000, 1000), -- Papel�o
										(2, 300, 50), -- Cola
										(3, 200, 50), -- Lamina��o
										(4, 6000, 1500), -- Papel kraft reciclado
										(5, 1000, 200), -- Al�a de papel torcido
										(6, 8000, 2000), -- Pl�stico (polietileno de alta densidade)
										(7, 500, 100), -- Selagem t�rmica
										(8, 4000, 800), -- Vidro
										(9, 2000, 400), -- Tampa met�lica
										(10, 1000, 200), -- Vedante de borracha
										(11, 7000, 1500), -- Papel sulfite
										(12, 400, 100), -- Adesivo para selagem
										(13, 9000, 2500), -- Pl�stico PET (polietileno tereftalato)
										(14, 3000, 600), -- Tampa de rosca
										(15, 5000, 1000),  -- Cart�o duplex
										(16, 200, 50),     -- Pigmento para pl�stico
										(17, 8000, 1500),  -- Papel reciclado
										(18, 1000, 200),   -- Fio de polipropileno
										(19, 500, 100),    -- Silicone para veda��o
										(20, 3000, 500),   -- Papel�o ondulado
										(21, 200, 50),     -- Tintas ecol�gicas
										(22, 400, 100),    -- Alum�nio
										(23, 3000, 600),   -- Revestimento de pol�mero
										(24, 100, 20),     -- Cera para selagem
										(25, 500, 100),    -- Fita adesiva
										(26, 6000, 1500),  -- Polietileno de baixa densidade
										(27, 3000, 600),   -- Pl�stico biodegrad�vel
										(28, 2000, 500),   -- Tecido n�o tecido
										(29, 1000, 200),   -- Espuma de poliestireno
										(30, 400, 100),    -- Adesivo de alta resist�ncia
										(31, 1500, 300),   -- Policarbonato
										(32, 600, 150),    -- Filme stretch
										(33, 200, 50),     -- Resina ep�xi
										(34, 1000, 200),   -- Lacre de seguran�a
										(35, 300, 100),    -- Poliuretano
										(36, 800, 200),    -- PVC (policloreto de vinila)
										(37, 500, 100),    -- Pigmento para papel
										(38, 2000, 500),   -- Polipropileno reciclado
										(39, 400, 100);    -- Tinta UV
GO

-- Inserts para a tabela TipoMovimentacao
INSERT INTO [dbo].[TipoMovimentacao]	(Id, Nome) 
VALUES
										(1, 'Entrada'),          -- Movimenta��o de entrada de estoque
										(2, 'Sa�da'),            -- Movimenta��o de sa�da de estoque
										(3, 'Perda');            -- Perda de estoque (por exemplo, devido a acidentes de trabalho)
GO

-- Inserts para a tabela PedidoProduto
INSERT INTO [dbo].[PedidoProduto]	(IdPedido, IdProduto, Quantidade) 
VALUES
									(1, 1, 50),  -- Primeiro Pedido do cliente Jo�o Silva - Caixa de papel�o laminado super resistente
									(2, 2, 100), -- Primeiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
									(3, 3, 200), -- Primeiro Pedido do cliente Carlos Souza - Embalagem pl�stica para alimentos
									(4, 4, 150), -- Segundo Pedido do cliente Jo�o Silva - Pote de vidro para conservas
									(5, 5, 300), -- Segundo Pedido do cliente Maria Eduarda - Envelope de papel para correspond�ncia
									(6, 6, 400), -- Segundo Pedido do cliente Carlos Souza - Garrafa PET para bebidas
									(7, 1, 75),  -- Terceiro Pedido do cliente Jo�o Silva - Caixa de papel�o laminado super resistente
									(8, 2, 120), -- Terceiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
									(9, 3, 250), -- Terceiro Pedido do cliente Carlos Souza - Embalagem pl�stica para alimentos
									(13, 13, 50),   -- Terceiro Pedido do cliente Jo�o Victor - Caixa de papel�o para mudan�as
									(14, 14, 100),  -- Terceiro Pedido do cliente Adriel Alexander - Sacola de papel com al�a
									(15, 15, 150),  -- Terceiro Pedido do cliente Andr� Victor - Embalagem pl�stica para l�quidos
									(10, 7, 150),   -- Quarto Pedido do cliente Pedro Avelino - Caixa de papel�o ondulado
									(11, 8, 200),   -- Quarto Pedido do cliente Orcino Neto - Sacola biodegrad�vel
									(12, 9, 100),   -- Quarto Pedido do cliente Gabriel Damiani - Embalagem pl�stica com tampa
									(13, 10, 50),   -- Quarto Pedido do cliente Odlavir Florentino - Pote de vidro para doces
									(14, 11, 300),  -- Quarto Pedido do cliente Thays Carvalho - Envelope almofadado
									(15, 12, 250),  -- Quarto Pedido do cliente Danyel Targino - Garrafa de vidro para sucos
									(10, 10, 80),   -- Terceiro Pedido do cliente Rafael Maur�cio - Pote de vidro para doces
									(16, 13, 200),  -- Quarto Pedido do cliente Rafael Maur�cio - Caixa de papel�o para mudan�as
									(11, 11, 120),  -- Terceiro Pedido do cliente Gustavo Targino - Envelope almofadado
									(17, 14, 100),  -- Quarto Pedido do cliente Gustavo Targino - Sacola de papel com al�a
									(12, 12, 200),  -- Terceiro Pedido do cliente Ol�vio Freitas - Garrafa de vidro para sucos
									(18, 15, 300);  -- Quarto Pedido do cliente Ol�vio Freitas - Embalagem pl�stica para l�quidos
GO 

-- Inserts para a tabela EtapaProducao

-- Etapas de produ��o para 'Caixa de papel�o laminado super resistente' (IdProduto = 1)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(1, 'Corte do papel�o', 60, 1),
									(1, 'Aplica��o de cola e montagem', 120, 2),
									(1, 'Lamina��o e acabamento', 90, 3);
GO

-- Etapas de produ��o para 'Sacola de papel kraft reciclado' (IdProduto = 2)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(2, 'Corte do papel kraft', 45, 1),
									(2, 'Montagem e colagem das al�as', 60, 2),
									(2, 'Refor�o e finaliza��o', 30, 3);
GO

-- Etapas de produ��o para 'Embalagem pl�stica para alimentos' (IdProduto = 3)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(3, 'Extrus�o do pl�stico', 120, 1),
									(3, 'Corte e moldagem', 90, 2),
									(3, 'Selagem t�rmica', 60, 3);
GO

-- Etapas de produ��o para 'Pote de vidro para conservas' (IdProduto = 4)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa)
VALUES
									(4, 'Fabrica��o do vidro', 180, 1),
									(4, 'Moldagem e resfriamento', 120, 2),
									(4, 'Aplica��o da tampa e vedante', 45, 3);
GO

-- Etapas de produ��o para 'Envelope de papel para correspond�ncia' (IdProduto = 5)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(5, 'Corte do papel sulfite', 30, 1),
									(5, 'Dobra e montagem', 45, 2),
									(5, 'Aplica��o do adesivo de selagem', 15, 3);
GO

-- Etapas de produ��o para 'Garrafa PET para bebidas' (IdProduto = 6)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
									(6, 'Fabrica��o do pl�stico PET', 150, 1),
									(6, 'Sopro e moldagem da garrafa', 105, 2),
									(6, 'Aplica��o da tampa de rosca', 30, 3);
GO 

-- Etapas de produ��o para 'Caixa de papel�o ondulado' (IdProduto = 7)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (7, 'Corte do papel�o ondulado', 75, 1),
    (7, 'Dobra e montagem', 90, 2),
    (7, 'Aplica��o de cola e acabamento', 60, 3);
	GO


-- Etapas de produ��o para 'Sacola biodegrad�vel' (IdProduto = 8)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (8, 'Corte do material biodegrad�vel', 60, 1),
    (8, 'Costura e montagem', 90, 2),
    (8, 'Acabamento final', 45, 3);

	GO

-- Etapas de produ��o para 'Embalagem pl�stica com tampa' (IdProduto = 9)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (9, 'Extrus�o do pl�stico', 120, 1),
    (9, 'Moldagem e corte', 90, 2),
    (9, 'Aplica��o da tampa', 45, 3);

	GO

-- Etapas de produ��o para 'Pote de vidro para doces' (IdProduto = 10)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (10, 'Fabrica��o do vidro', 180, 1),
    (10, 'Moldagem e resfriamento', 120, 2),
    (10, 'Acabamento e rotulagem', 60, 3);

	GO

-- Etapas de produ��o para 'Envelope almofadado' (IdProduto = 11)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (11, 'Corte do papel kraft e papel�o', 90, 1),
    (11, 'Montagem e preenchimento com almofadas', 120, 2),
    (11, 'Fechamento e selagem', 30, 3);

	GO

-- Etapas de produ��o para 'Garrafa de vidro para sucos' (IdProduto = 12)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (12, 'Fabrica��o do vidro', 180, 1),
    (12, 'Sopro e moldagem da garrafa', 105, 2),
    (12, 'Lavagem, secagem e rotulagem', 90, 3);

	GO

	-- Etapas de produ��o para 'Caixa de papel�o para mudan�as' (IdProduto = 13)
	INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (13, 'Corte e dobra do papel�o', 90, 1),
    (13, 'Montagem e colagem', 120, 2),
    (13, 'Aplica��o de refor�os e acabamento', 60, 3),
    (13, 'Rotulagem e embalagem', 30, 4);

	GO

-- Etapas de produ��o para 'Sacola de papel com al�a' (IdProduto = 14)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (14, 'Corte do papel e da al�a', 60, 1),
    (14, 'Montagem e colagem', 90, 2),
    (14, 'Refor�o e acabamento', 45, 3);

	GO

-- Etapas de produ��o para 'Embalagem pl�stica para l�quidos' (IdProduto = 15)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (15, 'Extrus�o do pl�stico', 120, 1),
    (15, 'Moldagem e corte', 90, 2),
    (15, 'Inje��o da tampa', 45, 3),
    (15, 'Rotulagem e embalagem', 30, 4);

	GO

-- Etapas de produ��o para 'Pote de vidro para temperos' (IdProduto = 16)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (16, 'Fabrica��o do vidro', 180, 1),
    (16, 'Moldagem e resfriamento', 120, 2),
    (16, 'Acabamento e rotulagem', 60, 3);

	GO

-- Etapas de produ��o para 'Envelope de seguran�a' (IdProduto = 17)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (17, 'Corte e dobra do papel kraft especial', 75, 1),
    (17, 'Aplica��o de adesivo especial', 60, 2),
    (17, 'Secagem e acabamento', 45, 3);

	GO

-- Etapas de produ��o para 'Garrafa de alum�nio' (IdProduto = 18)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (18, 'Moldagem e prensagem do alum�nio', 180, 1),
    (18, 'Corte e acabamento', 120, 2),
    (18, 'Rotulagem e embalagem', 60, 3);

	GO

-- Etapas de produ��o para 'Caixa de papel�o personalizada' (IdProduto = 19)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (19, 'Corte e dobra do papel�o especial', 90, 1),
    (19, 'Montagem e colagem', 120, 2),
    (19, 'Acabamento personalizado', 60, 3),
    (19, 'Rotulagem e embalagem', 30, 4);

	GO

-- Etapas de produ��o para 'Sacola de tecido reutiliz�vel' (IdProduto = 20)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (20, 'Corte e costura do tecido', 90, 1),
    (20, 'Acabamento e refor�o', 60, 2),
    (20, 'Aplica��o de al�a', 45, 3),
    (20, 'Embalagem final', 30, 4);

	GO

	-- Etapas de produ��o para 'Embalagem de papel�o para alimentos' (IdProduto = 21)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (21, 'Corte e dobra do papel�o especial', 90, 1),
    (21, 'Montagem e colagem', 120, 2),
    (21, 'Refor�o e acabamento', 60, 3),
    (21, 'Rotulagem e embalagem', 30, 4);

	GO

-- Etapas de produ��o para 'Pote de vidro decorativo' (IdProduto = 22)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (22, 'Fabrica��o do vidro decorativo', 180, 1),
    (22, 'Moldagem e resfriamento', 120, 2),
    (22, 'Acabamento e rotulagem', 60, 3);

	GO

-- Etapas de produ��o para 'Envelope para documentos' (IdProduto = 23)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (23, 'Corte e dobra do papel kraft', 75, 1),
    (23, 'Aplica��o de adesivo especial', 60, 2),
    (23, 'Secagem e acabamento', 45, 3),
    (23, 'Embalagem final', 30, 4);

	GO

-- Etapas de produ��o para 'Garrafa de vidro com tampa de rosca' (IdProduto = 24)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (24, 'Fabrica��o do vidro', 180, 1),
    (24, 'Moldagem e resfriamento', 120, 2),
    (24, 'Aplica��o da tampa de rosca', 60, 3),
    (24, 'Rotulagem e embalagem', 45, 4);

	GO

-- Etapas de produ��o para 'Caixa de papel�o dupla face' (IdProduto = 25)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (25, 'Corte e dobra do papel�o especial', 90, 1),
    (25, 'Montagem e colagem', 120, 2),
    (25, 'Refor�o e acabamento', 60, 3),
    (25, 'Rotulagem e embalagem', 30, 4),
    (25, 'Embalagem final', 15, 5);

	GO

-- Etapas de produ��o para 'Sacola de papel com refor�o' (IdProduto = 26)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (26, 'Corte e dobra do papel', 60, 1),
    (26, 'Montagem e colagem', 90, 2),
    (26, 'Aplica��o do refor�o', 45, 3),
    (26, 'Acabamento final', 30, 4);

	GO

-- Etapas de produ��o para 'Embalagem de pl�stico biodegrad�vel' (IdProduto = 27)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (27, 'Extrus�o do pl�stico biodegrad�vel', 120, 1),
    (27, 'Moldagem e corte', 90, 2),
    (27, 'Inje��o da tampa biodegrad�vel', 45, 3),
    (27, 'Rotulagem e embalagem', 30, 4),
    (27, 'Embalagem final', 15, 5);

	GO

-- Etapas de produ��o para 'Pote de vidro com tampa herm�tica' (IdProduto = 28)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (28, 'Fabrica��o do vidro', 180, 1),
    (28, 'Moldagem e resfriamento', 120, 2),
    (28, 'Aplica��o da tampa herm�tica', 60, 3),
    (28, 'Acabamento e rotulagem', 45, 4);

	GO

-- Etapas de produ��o para 'Envelope de papel kraft' (IdProduto = 29)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (29, 'Corte e dobra do papel kraft', 75, 1),
    (29, 'Aplica��o de adesivo especial', 60, 2),
    (29, 'Secagem e acabamento', 45, 3),
    (29, 'Embalagem final', 30, 4);

	GO

-- Etapas de produ��o para 'Garrafa PET reciclada' (IdProduto = 30)
INSERT INTO [dbo].[EtapaProducao]	(IdProduto, Descricao, Duracao, NumeroEtapa) 
VALUES
    (30, 'Reciclagem do pl�stico PET', 120, 1),
    (30, 'Extrus�o e moldagem da garrafa', 90, 2),
    (30, 'Revestimento e rotulagem', 60, 3),
    (30, 'Embalagem final', 30, 4);

	GO


-- Primeiro Pedido do cliente Jo�o Silva - Caixa de papel�o laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES 
												(1, 2, '2024-01-30', 50); -- Sa�da de produto

												GO

-- Primeiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(2, 2, '2024-02-28', 100); -- Sa�da de produto

												GO

-- Primeiro Pedido do cliente Carlos Souza - Embalagem pl�stica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(3, 2, '2024-01-30', 200); -- Sa�da de produto

												GO

-- Segundo Pedido do cliente Jo�o Silva - Pote de vidro para conservas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES 
												(4, 2, '2024-04-20', 150); -- Sa�da de produto

												GO

-- Segundo Pedido do cliente Maria Eduarda - Envelope de papel para correspond�ncia
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES
												(5, 2, '2024-03-27', 300); -- Sa�da de produto

												GO

-- Segundo Pedido do cliente Carlos Souza - Garrafa PET para bebidas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(6, 2, '2024-03-27', 400); -- Sa�da de produto

												GO

-- Terceiro Pedido do cliente Jo�o Silva - Caixa de papel�o laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES 
												(1, 2, '2024-05-30', 75); -- Sa�da de produto

												GO

-- Terceiro Pedido do cliente Maria Eduarda - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(2, 2, '2024-05-27', 120); -- Sa�da de produto

												GO

-- Terceiro Pedido do cliente Carlos Souza - Embalagem pl�stica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto]	(IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade) 
VALUES 
												(3, 2, '2024-05-30', 250); -- Sa�da de produto

												GO

-- Primeiro Pedido do cliente Pedro Avelino - Caixa de papel�o laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (1, 2, '2024-01-30', 50); 

GO

-- Primeiro Pedido do cliente Orcino Neto - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (2, 2, '2024-02-28', 100); 

GO

-- Primeiro Pedido do cliente Gabriel Damiani - Embalagem pl�stica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (3, 2, '2024-01-30', 200); 

GO

-- Segundo Pedido do cliente Odlavir Florentino - Pote de vidro para conservas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (4, 2, '2024-04-20', 150);

GO

-- Segundo Pedido do cliente Thays Carvalho - Envelope de papel para correspond�ncia
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (5, 2, '2024-03-27', 300); 

GO

-- Segundo Pedido do cliente Danyel Targino - Garrafa PET para bebidas
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (6, 2, '2024-03-27', 400); 

GO

-- Terceiro Pedido do cliente Rafael Maur�cio - Caixa de papel�o laminado super resistente
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (1, 2, '2024-05-30', 75); 

GO

-- Terceiro Pedido do cliente Gustavo Targino - Sacola de papel kraft reciclado
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (2, 2, '2024-05-27', 120); 

GO

-- Terceiro Pedido do cliente Ol�vio Freitas - Embalagem pl�stica para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (3, 2, '2024-05-30', 250); 

GO

-- Primeiro Pedido do cliente Rafael Maur�cio - Pote de vidro para temperos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (16, 2, '2024-06-15', 50); 

GO

-- Primeiro Pedido do cliente Gustavo Targino - Envelope de seguran�a
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (17, 2, '2024-06-20', 80); 

GO

-- Primeiro Pedido do cliente Ol�vio Freitas - Garrafa de alum�nio
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (18, 2, '2024-06-25', 90); 

GO

-- Segundo Pedido do cliente Jo�o Victor - Caixa de papel�o personalizada
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (19, 2, '2024-07-01', 120); 

GO

-- Segundo Pedido do cliente Adriel Alexander - Sacola de tecido reutiliz�vel
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (20, 2, '2024-07-10', 150); 

GO

-- Segundo Pedido do cliente Andr� Victor - Embalagem de papel�o para alimentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (21, 2, '2024-07-15', 180); 

GO

-- Terceiro Pedido do cliente Gustavo Brand�o - Pote de vidro decorativo
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (22, 2, '2024-07-20', 200); 

GO

-- Terceiro Pedido do cliente Rafael Valentim - Envelope para documentos
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (23, 2, '2024-07-25', 100); 

GO

-- Terceiro Pedido do cliente Thomaz Falbo - Garrafa de vidro com tampa de rosca
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (24, 2, '2024-07-30', 150); 

GO

-- Quarto Pedido do cliente Marcus Mandara - Caixa de papel�o dupla face
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (25, 2, '2024-08-05', 200); 

GO

-- Quarto Pedido do cliente Isabella Tragante - Sacola de papel com refor�o
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (26, 2, '2024-08-10', 100); 

GO

-- Quarto Pedido do cliente [Nome do Cliente] - Embalagem de pl�stico biodegrad�vel
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (27, 2, '2024-08-15', 250); 

GO

-- Quarto Pedido do cliente [Nome do Cliente] - Pote de vidro com tampa herm�tica
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (28, 2, '2024-08-20', 120); 

GO

-- Quarto Pedido do cliente [Nome do Cliente] - Envelope de papel kraft
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (29, 2, '2024-08-25', 180); 

GO

-- Quarto Pedido do cliente [Nome do Cliente] - Garrafa PET reciclada
INSERT INTO [dbo].[MovimentacaoEstoqueProduto] (IdEstoqueProduto, idTipoMovimentacao, DataMovimentacao, Quantidade)
VALUES (30, 2, '2024-08-30', 200); 

GO



