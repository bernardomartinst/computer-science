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