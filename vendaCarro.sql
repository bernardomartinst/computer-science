CREATE DATABASE vendaCarro;

CREATE TABLE MONTADORA (

    IdMontadora INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(20) NOT NULL,
    Cidade VARCHAR(20) NOT NULL,
    PRIMARY KEY (IdMontadora)
);

CREATE TABLE CARRO (

    IdCarro INT NOT NULL AUTO_INCREMENT,
    IdMontadora INT,
    Modelo VARCHAR(15),
    Versao VARCHAR(15),
    Cor VARCHAR(15),
    Cilindrada INT,
    Combustivel VARCHAR(15),
    Ano_Fabricacao INT,
    PRIMARY KEY (IdCarro),
    FOREIGN KEY (IdMontadora) references MONTADORA (IdMontadora) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE MONTADORA CHANGE COLUMN Nome NomeMontadora VARCHAR(20);
ALTER TABLE CARRO ADD COLUMN Ano_Modelo YEAR;
ALTER TABLE CARRO DROP Ano_Fabricacao;

DROP TABLE CARRO;
DROP vendaCarro;