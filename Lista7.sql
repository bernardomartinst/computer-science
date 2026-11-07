USE Loja;

INSERT INTO Fornecedor (FNUM, FNOME, CIDADE) VALUES
(1, 'VARGAS', 'RJ'), 
(2, 'MURILO', 'SP'), 
(3, 'IVO', 'BH'),
(4, 'WANDER', 'RJ'), 
(5, 'CARLOS', 'BH'), 
(6, 'LUIZ', 'ITAUNA');

INSERT INTO Peca (PNUM, COR, PESO, CIDADE) VALUES
(1, 'AZUL', 10, 'RJ'), 
(2, 'VERDE', 30, 'BETIM'),
(3, 'PRETA', 10, 'ITAUNA'), 
(4, 'MARROM', 30, 'RJ');

INSERT INTO Vende (FNUM, PNUM, QUANTIDADE) VALUES
(1, 1, 10), (1, 2, 20), (1, 3, 30), (1, 4, 10),
(2, 1, 20), (2, 3, 15),
(3, 1, 21), (3, 2, 40), (3, 3, 12), (3, 4, 23),
(5, 1, 54), (5, 3, 10);

SELECT DISTINCT CIDADE FROM Fornecedor;

SELECT DISTINCT CIDADE FROM Peca WHERE COR IN ('VERDE', 'AZUL');

SELECT COR FROM Peca WHERE PESO >= 20;

SELECT PNUM, SUM(QUANTIDADE) AS Total_Fornecido FROM Vende GROUP BY PNUM;

SELECT FNOME FROM Fornecedor WHERE CIDADE = 'BH';