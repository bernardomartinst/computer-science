//Questão 1:
SELECT pokemon.id_pokemon, pokemon.apelido, especie.nome, treinador.nome, pokemon.nivel
FROM pokemon, treinador, especie
WHERE pokemon.id_treinador = treinador.id_treinador
AND pokemon.id_especie = especie.id_especie
AND pokemon.nivel >= 50
ORDER BY pokemon.nivel DESC, treinador.nome;

//Questão 2:
SELECT DISTINCT regiao.nome, tipo.nome
FROM regiao, tipo, especie_tipo, especie, treinador, pokemon
WHERE treinador.id_regiao = regiao.id_regiao
AND pokemon.id_treinador = treinador.id_treinador
AND pokemon.id_especie = especie.id_especie
AND especie.id_especie = especie_tipo.id_especie
AND especie_tipo.id_tipo = tipo.id_tipo
ORDER BY regiao.nome, tipo.nome;

//Questão 3:
SELECT treinador.nome, COUNT(pokemon.id_pokemon) AS quantidade_pokemons, COUNT(pokemon.id_pokemon) FILTER (WHERE pokemon.nivel >= 40) AS quantidade_pokemons_nivel_40
FROM treinador LEFT JOIN pokemon ON treinador.id_treinador = pokemon.id_treinador
GROUP BY treinador.nome, treinador.id_treinador
ORDER BY COUNT(pokemon.id_pokemon) DESC;

//Questão 4:
SELECT treinador.nome, pokemon.apelido, especie.nome, captura.metodo, regiao.nome, captura.data_captura
FROM captura
INNER JOIN pokemon ON captura.id_pokemon = pokemon.id_pokemon
INNER JOIN especie ON pokemon.id_especie = especie.id_especie
INNER JOIN treinador ON treinador.id_treinador = captura.id_treinador
INNER JOIN regiao ON captura.id_regiao = regiao.id_regiao
WHERE captura.data_captura >= '2025-01-01' AND captura.data_captura < '2026-01-01';

//Questão 5:
SELECT treinador.nome,
COUNT(pokemon.id_pokemon) AS quantidade_pokemons, 
COUNT(DISTINCT pokemon.id_especie) AS quantidade_especies,
AVG(pokemon.nivel) AS media_nivel
FROM treinador JOIN pokemon ON pokemon.id_treinador = treinador.id_treinador
GROUP BY treinador.id_treinador, treinador.nome
HAVING COUNT(DISTINCT pokemon.id_especie) >= 5
AND AVG(pokemon.nivel) > 30;

//Questão 6:
SELECT torneio.nome,
COUNT(DISTINCT CASE WHEN batalha.situacao = 'CONCLUIDA' THEN batalha.id_batalha END) AS total_concluidas,
COUNT(DISTINCT CASE WHEN batalha.situacao = 'CONCLUIDA' AND participacao_batalha.resultado = 'EMPATE' 
THEN participacao_batalha.id_batalha END) AS quantidade_empates,
ROUND(COUNT(DISTINCT CASE WHEN batalha.situacao = 'CONCLUIDA' AND participacao_batalha.resultado = 'EMPATE' 
THEN batalha.id_batalha END) * 100.0 / COUNT(DISTINCT CASE WHEN batalha.situacao = 'CONCLUIDA' THEN batalha.id_batalha END), 2) AS percentual_empates
FROM torneio
JOIN batalha ON torneio.id_torneio = batalha.id_torneio
JOIN participacao_batalha ON batalha.id_batalha = participacao_batalha.id_batalha
GROUP BY torneio.id_torneio, torneio.nome
HAVING COUNT(DISTINCT CASE WHEN batalha.situacao = 'CONCLUIDA' THEN batalha.id_batalha END) >= 10;

//QUestão 7:
SELECT p1.nivel, 
    (SELECT AVG(p2.nivel) 
    FROM pokemon p2 
    WHERE p2.id_especie = p1.id_especie) AS media_nivel
FROM pokemon p1 
WHERE p1.nivel > 
    (SELECT AVG(p2.nivel)
    FROM pokemon p2 
    WHERE p2.id_especie = p1.id_especie HAVING COUNT(p2.id_pokemon) >= 3);

//Questão 8:
SELECT treinador.nome, treinador.id_treinador
FROM treinador
WHERE EXISTS (
    SELECT 1
    FROM pokemon
    WHERE pokemon.id_treinador = treinador.id_treinador)
AND NOT EXISTS (
    SELECT 1
    FROM inscricao
    WHERE inscricao.id_treinador = treinador.id_treinador);

//Questão 9:
SELECT g1.nome, g1.categoria, g1.poder
FROM golpe g1
WHERE g1.poder > ALL(
    SELECT g2.poder
    FROM golpe g2
    WHERE g2.categoria = g1.categoria
    AND g2.id_golpe != g1.id_golpe
);

//Questão 10:
SELECT origem.nome AS nome_origem, 
destino.nome AS nome_destino, 
CASE WHEN nivel_minimo IS NULL THEN item_necessario ELSE CAST(nivel_minimo AS VARCHAR) END AS condicao_evolucao
FROM evolucao 
JOIN especie AS origem ON evolucao.id_origem = origem.id_especie
JOIN especie AS destino ON evolucao.id_destino = destino.id_especie
ORDER BY origem.nome;

//Questão 11:
SELECT treinador.id_treinador,
       treinador.nome,
       placar.vitorias,
       placar.total,
       ROUND(placar.vitorias * 100.0 / placar.total, 2) AS percentual_vitorias
FROM treinador
JOIN (SELECT inscricao.id_treinador,
             COUNT(*) AS total,
             COUNT(*) FILTER (WHERE participacao_batalha.resultado = 'VITORIA') AS vitorias
        FROM participacao_batalha
        JOIN inscricao ON inscricao.id_inscricao = participacao_batalha.id_inscricao
        JOIN batalha   ON batalha.id_batalha     = participacao_batalha.id_batalha
       WHERE batalha.situacao = 'CONCLUIDA'
       GROUP BY inscricao.id_treinador
      HAVING COUNT(*) >= 10) AS placar
  ON placar.id_treinador = treinador.id_treinador
WHERE placar.vitorias * 100.0 / placar.total > 70;

//Questão 12:
SELECT especie.nome, especie.id_especie
FROM especie
WHERE EXISTS (
    SELECT 1
    FROM pokemon
    WHERE pokemon.id_especie = especie.id_especie)
AND NOT EXISTS (
    SELECT 1
    FROM pokemon
    JOIN uso_pokemon ON pokemon.id_pokemon = uso_pokemon.id_pokemon
    WHERE pokemon.id_especie = especie.id_especie);

//Questão 13:
SELECT pokemon.id_pokemon, pokemon.apelido, especie.nome, pokemon.nivel, ROUND((SELECT AVG(pokemon.nivel) FROM POKEMON), 2) AS media_nivel
FROM pokemon 
JOIN especie ON pokemon.id_especie = especie.id_especie
WHERE pokemon.nivel > (SELECT AVG(pokemon.nivel) FROM pokemon)
ORDER BY pokemon.nivel DESC;

//Questão 14:
SELECT treinador.nome, treinador.id_treinador
FROM treinador
WHERE treinador.id_treinador 
IN (SELECT captura.id_treinador
    FROM captura
    JOIN regiao ON captura.id_regiao = regiao.id_regiao
    WHERE regiao.nome = 'Kanto'
);

//Questão 15:
SELECT treinador.nome, treinador.id_treinador
FROM treinador
WHERE NOT EXISTS (
    SELECT 1
    FROM tipo
    WHERE tipo.id_tipo IN (
        SELECT especie_tipo.id_tipo
        FROM especie_tipo
        JOIN especie ON especie_tipo.id_especie = especie.id_especie
        JOIN regiao ON especie.id_regiao = regiao.id_regiao
        WHERE regiao.nome = 'Kanto'   
    )
    AND NOT EXISTS (
        SELECT 1
        FROM pokemon
        JOIN especie ON pokemon.id_especie = especie.id_especie
        JOIN especie_tipo ON especie.id_especie = especie_tipo.id_especie
        WHERE pokemon.id_treinador = treinador.id_treinador
        AND especie_tipo.id_tipo = tipo.id_tipo
    )
);

//Questão 16:
SELECT origem.nome  AS especie_origem, destino.nome AS especie_final, 1 AS etapas
FROM evolucao e1
JOIN especie origem  ON origem.id_especie = e1.id_origem
JOIN especie destino ON destino.id_especie = e1.id_destino
WHERE origem.nome = 'Charmander'

UNION

SELECT origem.nome AS especie_origem, destino.nome AS especie_final, 2 AS etapas
FROM evolucao e1
JOIN evolucao e2 ON e2.id_origem = e1.id_destino
JOIN especie origem  ON origem.id_especie = e1.id_origem
JOIN especie destino ON destino.id_especie = e2.id_destino
WHERE origem.nome = 'Charmander'

ORDER BY etapas, especie_final;

//Questão 17:
SELECT treinador.nome AS treinador, pokemon.apelido, especie.nome AS especie, pokemon.nivel
FROM pokemon 
JOIN treinador ON pokemon.id_treinador = treinador.id_treinador
JOIN especie ON pokemon.id_especie = especie.id_especie
WHERE pokemon.nivel = (SELECT MAX(pokemon.nivel) FROM pokemon);

//Questão 18:
SELECT regiao.nome AS regiao, totais.quantidade, 
totais.ultima_captura
FROM regiao
JOIN (SELECT captura.id_regiao,
                COUNT(*) AS quantidade,
                MAX(captura.data_captura) AS ultima_captura
        FROM captura
        GROUP BY captura.id_regiao
        HAVING COUNT(*) >= 20) AS totais
ON regiao.id_regiao = totais.id_regiao;

//Questão 19: 
SELECT regiao.nome AS regiao,
       especie.raridade,
       COUNT(pokemon.id_pokemon) AS quantidade,
       CASE WHEN GROUPING (regiao.nome) = 1 THEN 'TOTAL GERAl' 
        WHEN GROUPING(especie.raridade) = 1 THEN 'SUBTOTAL REGIAO' ELSE 'DETALHE' END AS tipo_linha
FROM pokemon
JOIN treinador ON treinador.id_treinador = pokemon.id_treinador
JOIN regiao ON treinador.id_regiao = regiao.id_regiao
JOIN especie ON pokemon.id_especie = especie.id_especie
GROUP BY ROLLUP (regiao.nome, especie.raridade);

//Questão 20:
SELECT treinador.id_treinador, treinador.nome, COUNT (pokemon.id_pokemon) AS quantidade
FROM treinador
JOIN pokemon ON pokemon.id_treinador = treinador.id_treinador
GROUP BY treinador.id_treinador, treinador.nome
HAVING COUNT(pokemon.id_pokemon) > (SELECT COUNT(pokemon.id_treinador) FROM pokemon) * 1.0/ (SELECT COUNT(*) FROM treinador);
