USE vendaCarro;

INSERT INTO montadora (idmontadora, nomeMontadora, cidade) VALUES (1, 'Fiat', 'Betim');

INSERT INTO carro (idmontadora, modelo, versao, cor, combustivel, cilindrada, ano_modelo) VALUES
(1, 'Palio', 'Fire', 'Prata', 'Flex', 1000, 2015),
(1, 'Palio', '1.8R', 'Prata', 'Flex', 1800, 2015),
(1, 'Punto', 'Sporting', 'Branca', 'Flex', 1800, 2015),
(1, 'Punto', 'T-JET', 'Branca', 'Gasolina', 1400, 2015);

INSERT INTO montadora (idmontadora, nomeMontadora, cidade) VALUES (2, 'Volkswagen', 'São Paulo');

INSERT INTO carro (idmontadora, modelo, versao, cor, combustivel, cilindrada, ano_modelo) VALUES
(2, 'Gol', 'Trend', 'Preta', 'Flex', 1000, 2014),
(2, 'Gol', 'Power', 'Preta', 'Flex', 1600, 2014),
(2, 'Polo', 'Confortline', 'Grafite', 'Flex', 1600, 2012),
(2, 'Polo', 'GT', 'Grafite', 'Flex', 2000, 2012);

INSERT INTO montadora (idmontadora, nomeMontadora, cidade) VALUES (3, 'Chevrolet', 'Rio de Janeiro');

INSERT INTO carro (idmontadora, modelo, versao, cor, combustivel, cilindrada, ano_modelo) VALUES
(3, 'Vectra', 'Elegance', 'Cinza', 'Flex', 2000, 2013),
(3, 'Vectra', 'Elite', 'Cinza', 'Flex', 2000, 2013);

INSERT INTO montadora (idmontadora, nomeMontadora, cidade) VALUES (4, 'Ford', 'Porto Alegre');

INSERT INTO carro (idmontadora, modelo, versao, cor, combustivel, cilindrada, ano_modelo) VALUES
(4, 'Fusion', 'SEL2.5', 'Areia', 'Gasolina', 2500, 2015),
(4, 'Fusion', 'SELV6', 'Areia', 'Gasolina', 3000, 2015);

ALTER TABLE carro ADD COLUMN numerodevalvulas INT;

UPDATE carro SET numerodevalvulas = 8;
UPDATE carro SET numerodevalvulas = 16 WHERE modelo = 'Punto' AND versao = 'T-JET';
UPDATE carro SET numerodevalvulas = 16 WHERE modelo = 'Fusion' AND versao = 'SEL2.5';
UPDATE carro SET numerodevalvulas = 24 WHERE modelo = 'Fusion' AND versao = 'SELV6';

SELECT DISTINCT modelo FROM carro WHERE numerodevalvulas >= 16;

UPDATE carro SET cilindrada = 2400, numerodevalvulas = 16 WHERE modelo = 'Vectra' AND versao = 'Elite';

SELECT modelo, versao, idmontadora FROM carro ORDER BY cilindrada ASC;

SELECT modelo, versao, idmontadora FROM carro ORDER BY cilindrada DESC;

SELECT MAX(cilindrada) AS Maior_Cilindrada FROM carro;

SELECT AVG(cilindrada) AS Media_Cilindradas FROM carro;

SELECT COUNT(*) AS Qtd_Carros FROM carro WHERE cilindrada BETWEEN 1500 AND 2100;