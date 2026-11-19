-- =====================================================================
-- LIGA POKEMON | CARGA DIDATICA PARA POSTGRESQL 14+
-- Compativel com 01_criacao_liga_pokemon.sql (19 tabelas)
-- Executar DEPOIS do DDL, no banco com schema liga_pokemon vazio.
-- Volume: 8 regioes; 250 especies; 18 tipos; 120 treinadores;
--         1500 Pokemon; 120 golpes; 200 equipes; 35 torneios;
--         700 inscricoes; 1000 batalhas; 2000 participacoes;
--         6000 usos de Pokemon; 30000 eventos de batalha.
-- Dados ficticios e reproduciveis; IDs explicitos.
-- Nao executar repetidamente sobre a mesma carga: IDs duplicados.
-- A carga nao exige extensoes e nao modifica o esquema/tabelas.
-- =====================================================================
BEGIN;
SET LOCAL search_path TO liga_pokemon, public;

-- 01. 8 regioes ----------------------------------------------------
INSERT INTO regiao (id_regiao, nome, clima) VALUES
 (1,'Kanto','Temperado'), (2,'Johto','Temperado'),
 (3,'Hoenn','Tropical'), (4,'Sinnoh','Frio'),
 (5,'Unova','Continental'), (6,'Kalos','Mediterraneo'),
 (7,'Alola','Tropical'), (8,'Galar','Oceanico');

-- 02. 18 tipos -----------------------------------------------------
INSERT INTO tipo (id_tipo, nome) VALUES
 (1,'Normal'),(2,'Fogo'),(3,'Agua'),(4,'Eletrico'),
 (5,'Grama'),(6,'Gelo'),(7,'Lutador'),(8,'Venenoso'),
 (9,'Terra'),(10,'Voador'),(11,'Psiquico'),(12,'Inseto'),
 (13,'Pedra'),(14,'Fantasma'),(15,'Dragao'),(16,'Sombrio'),
 (17,'Aco'),(18,'Fada');

-- 03. 250 especies: nomes conhecidos para casos didaticos,
--     demais nomes ficticios, sem repeticao.
INSERT INTO especie (id_especie, nome, raridade, id_regiao)
SELECT s,
       CASE s
         WHEN 1 THEN 'Charmander' WHEN 2 THEN 'Charmeleon'
         WHEN 3 THEN 'Charizard' WHEN 4 THEN 'Bulbasaur'
         WHEN 5 THEN 'Ivysaur' WHEN 6 THEN 'Venusaur'
         WHEN 7 THEN 'Squirtle' WHEN 8 THEN 'Wartortle'
         WHEN 9 THEN 'Blastoise' WHEN 10 THEN 'Pikachu'
         WHEN 11 THEN 'Raichu' WHEN 12 THEN 'Eevee'
         WHEN 13 THEN 'Pidgey' WHEN 14 THEN 'Pidgeotto'
         WHEN 15 THEN 'Pidgeot' WHEN 16 THEN 'Gastly'
         WHEN 17 THEN 'Haunter' WHEN 18 THEN 'Gengar'
         WHEN 19 THEN 'Dratini' WHEN 20 THEN 'Dragonair'
         WHEN 21 THEN 'Dragonite' WHEN 22 THEN 'Magikarp'
         WHEN 23 THEN 'Gyarados' WHEN 24 THEN 'Geodude'
         WHEN 25 THEN 'Graveler' WHEN 26 THEN 'Golem'
         WHEN 27 THEN 'Machop' WHEN 28 THEN 'Machoke'
         WHEN 29 THEN 'Machamp' WHEN 30 THEN 'Abra'
         WHEN 31 THEN 'Kadabra' WHEN 32 THEN 'Alakazam'
         ELSE 'Especie_' || LPAD(s::text,3,'0') END,
       CASE WHEN s % 29 = 0 THEN 'LENDARIA'
            WHEN s % 11 = 0 THEN 'RARA'
            WHEN s % 4 = 0 THEN 'INCOMUM' ELSE 'COMUM' END,
       CASE WHEN s <= 40 THEN 1 ELSE 2 + ((s - 41) % 7) END
FROM generate_series(1,250) AS s;

-- 04. Cada especie tem 1 ou 2 tipos.
-- As primeiras 15 especies recebem coletivamente os 18 tipos,
-- possibilitando resolver a atividade de divisao relacional.
INSERT INTO especie_tipo (id_especie, id_tipo)
SELECT s, 1 + ((s-1) % 18)
FROM generate_series(1,250) AS s;
INSERT INTO especie_tipo (id_especie, id_tipo)
SELECT s, CASE WHEN s <= 3 THEN 15+s
               ELSE 1 + ((s+7) % 18) END
FROM generate_series(1,250) AS s
WHERE s <= 3 OR (s > 3 AND s % 4 = 0);
-- Na segunda insercao, nunca ha duplicacao do tipo primario.

-- 05. Evolucoes diretas e algumas cadeias de duas etapas.
INSERT INTO evolucao (id_origem,id_destino,nivel_minimo,item_necessario) VALUES
 (1,2,16,NULL),(2,3,36,NULL),(4,5,16,NULL),(5,6,32,NULL),
 (7,8,16,NULL),(8,9,36,NULL),(10,11,NULL,'Pedra do Trovao'),
 (13,14,18,NULL),(14,15,36,NULL),(16,17,25,NULL),
 (17,18,NULL,'Troca'),(19,20,30,NULL),(20,21,55,NULL),
 (22,23,20,NULL),(24,25,25,NULL),(25,26,NULL,'Troca'),
 (27,28,28,NULL),(28,29,NULL,'Troca'),(30,31,16,NULL),
 (31,32,NULL,'Troca');

-- 06. 120 treinadores, sendo 20 sem Pokemon para LEFT JOIN.
INSERT INTO treinador (id_treinador,nome,cidade,data_cadastro,id_regiao)
SELECT s, 'Treinador ' || LPAD(s::text,3,'0'),
       'Cidade ' || (1 + (s%23)), DATE '2024-01-01' + (s%260),
       1 + ((s-1)%8)
FROM generate_series(1,120) AS s;

-- 07. 1500 Pokemon: 15 por treinador de 1 a 100.
-- Treinadores 101..120 ficam sem Pokemon.
-- 1..15 do treinador 1 correspondem as especies 1..15 (todos os
-- tipos de Kanto aparecem entre seus Pokemon).
-- Algumas especies 241..250 ficam exclusivas de treinadores
-- fora da liga e jamais sao utilizadas em batalha.
INSERT INTO pokemon (id_pokemon,apelido,nivel,experiencia,id_especie,id_treinador)
SELECT s,
       CASE WHEN s % 17 = 0 THEN NULL ELSE 'Parceiro '||LPAD(s::text,4,'0') END,
       CASE WHEN s % 61 = 0 THEN 100 ELSE 5 + ((s*13)%91) END,
       (s*173)%190000,
       CASE WHEN s <= 15 THEN s
            WHEN s > 1260 AND s % 3 = 0 THEN 241 + (s%10)
            ELSE 1 + ((s*37-1)%240) END,
       1 + ((s-1)/15)
FROM generate_series(1,1500) AS s;

-- 08. 1500 capturas, das quais 1260 acontecem em 2025.
-- Em 10% dos casos quem capturou difere do proprietario atual,
-- simulando transferencias posteriores. Captura na regiao Kanto
-- e deliberadamente frequente para exercicios com IN e datas.
INSERT INTO captura (id_captura,id_pokemon,id_treinador,data_captura,id_regiao,metodo)
SELECT s,s,
       CASE WHEN s%10 = 0 THEN 1 + ((((s-1)/15)+11)%100)
            ELSE 1 + ((s-1)/15) END,
       CASE WHEN s <= 1260
            THEN TIMESTAMP '2025-01-01 09:00:00' + (s%180)*INTERVAL '1 day'
                 + (s%8)*INTERVAL '1 hour'
            ELSE TIMESTAMP '2026-01-01 09:00:00' + (s%120)*INTERVAL '1 day'
                 + (s%8)*INTERVAL '1 hour' END,
       CASE WHEN s%4=0 THEN 1 ELSE 1+((s*3)%8) END,
       CASE s%5 WHEN 0 THEN 'POKEBOLA'
                WHEN 1 THEN 'GREAT_BALL'
                WHEN 2 THEN 'ULTRA_BALL'
                WHEN 3 THEN 'MASTER_BALL' ELSE 'OUTRO' END
FROM generate_series(1,1500) AS s;

-- 09. 120 golpes, incluindo 18 tipos e categorias distintas.
INSERT INTO golpe (id_golpe,nome,poder,precisao,categoria,id_tipo)
SELECT s,
       CASE WHEN s=1 THEN 'Investida'
            WHEN s=2 THEN 'Brasas'
            WHEN s=3 THEN 'Jato de Agua'
            WHEN s=4 THEN 'Choque do Trovao'
            ELSE 'Golpe '||LPAD(s::text,3,'0') END,
       CASE WHEN s%7=0 THEN 0 ELSE 20+((s*9)%131) END,
       (65+(s*7)%36)::numeric(5,2),
       CASE s%3 WHEN 0 THEN 'STATUS'
                WHEN 1 THEN 'FISICO' ELSE 'ESPECIAL' END,
       1 + ((s-1)%18)
FROM generate_series(1,120) AS s;

-- 10. Quatro golpes possiveis por especie (1000 vinculos).
INSERT INTO especie_golpe (id_especie,id_golpe,nivel_aprendizado)
SELECT e, 1 + (((e-1)*7+k*13)%120), 1+k*10
FROM generate_series(1,250) AS e
CROSS JOIN generate_series(0,3) AS k;

-- 11. Cada Pokemon conhece tres golpes da propria especie.
INSERT INTO pokemon_golpe (id_pokemon,id_golpe,data_aprendizado)
SELECT p.id_pokemon, 1 + (((p.id_especie-1)*7+k*13)%120),
       c.data_captura::date + 1 + k*3
FROM pokemon p
JOIN captura c ON c.id_pokemon=p.id_pokemon
CROSS JOIN generate_series(0,2) AS k;

-- 12. 200 equipes: 120 principais + 80 secundarias.
-- A equipe de ID X (1..120) pertence ao treinador X.
INSERT INTO equipe (id_equipe,nome,id_treinador,data_criacao)
SELECT s,'Equipe principal '||s,s,DATE '2025-07-01'
FROM generate_series(1,120) AS s;
INSERT INTO equipe (id_equipe,nome,id_treinador,data_criacao)
SELECT 120+s,'Equipe reserva '||s,s,DATE '2025-07-02'
FROM generate_series(1,80) AS s;

-- 13. 600 Pokemon nas equipes principais (seis por treinador)
-- e 320 nas equipes reserva (quatro por treinador).
-- Nenhum Pokemon fica ativo em duas equipes ao mesmo tempo.
INSERT INTO equipe_pokemon (id_equipe,id_pokemon,data_entrada,data_saida)
SELECT t, (t-1)*15+k, DATE '2025-07-03', NULL
FROM generate_series(1,100) AS t
CROSS JOIN generate_series(1,6) AS k;
INSERT INTO equipe_pokemon (id_equipe,id_pokemon,data_entrada,data_saida)
SELECT 120+t, (t-1)*15+k, DATE '2025-07-03', NULL
FROM generate_series(1,80) AS t
CROSS JOIN generate_series(7,10) AS k;
-- Historico encerrado: 80 vinculos adicionais, sem violar indice
-- unico de alocacao ativa.
INSERT INTO equipe_pokemon (id_equipe,id_pokemon,data_entrada,data_saida)
SELECT 120+t,(t-1)*15+11, DATE '2025-07-03', DATE '2025-08-01'
FROM generate_series(1,80) AS t;

-- 14. 35 torneios, em 2025 e 2026.
INSERT INTO torneio (id_torneio,nome,data_inicio,data_fim,premiacao,id_regiao)
SELECT s,'Torneio da Liga '||LPAD(s::text,2,'0'),
       DATE '2025-09-01' + (s-1)*INTERVAL '12 days',
       DATE '2025-09-04' + (s-1)*INTERVAL '12 days',
       (1500+s*400)::numeric(14,2),1+((s-1)%8)
FROM generate_series(1,35) AS s;

-- 15. 700 inscricoes: 20 por torneio, treinadores distintos.
-- Em cada torneio a primeira inscricao e do treinador 1;
-- outros participantes sao de 2..84, todos com equipe principal.
INSERT INTO inscricao (id_inscricao,id_torneio,id_treinador,id_equipe,data_inscricao)
SELECT (tr-1)*20+pos,tr,
       CASE WHEN pos=1 THEN 1 ELSE 2+((tr*11+pos-2)%83) END,
       CASE WHEN pos=1 THEN 1 ELSE 2+((tr*11+pos-2)%83) END,
       (DATE '2025-09-01'+(tr-1)*INTERVAL '12 days')::date - 5
FROM generate_series(1,35) AS tr
CROSS JOIN generate_series(1,20) AS pos;

-- 16. 1000 batalhas, ~28-29 por torneio. Primeiro sao criadas
-- como AGENDADA para respeitar o trigger de conclusao.
INSERT INTO batalha (id_batalha,id_torneio,data_hora,fase,duracao_segundos,situacao)
SELECT s,1+((s-1)%35),
       TIMESTAMP '2025-09-01 10:00:00'
         + ((s-1)%35)*INTERVAL '12 days'
         + ((s%3))*INTERVAL '1 day'
         + ((s%8))*INTERVAL '1 hour',
       CASE WHEN s%5=0 THEN 'FINAL'
            WHEN s%5=1 THEN 'SEMIFINAL'
            ELSE 'CLASSIFICATORIA' END,
       120+(s*37)%850,'AGENDADA'
FROM generate_series(1,1000) AS s;

-- Tabela temporaria apenas para facilitar a geracao dos confrontos.
CREATE TEMP TABLE tmp_confrontos ON COMMIT DROP AS
SELECT x.id_batalha,x.id_torneio,x.pos1,
       CASE WHEN x.pos1=1 THEN 2+((x.id_batalha*7)%19)
            WHEN x.id_batalha%5=0 THEN 1
            ELSE 2+((x.pos1-2+7)%19) END AS pos2,
       x.id_batalha%20 NOT IN (0,19) AS concluida,
       x.id_batalha%11=0 AS empate,
       x.id_batalha%7=0 AS vence_segundo
FROM (
    SELECT b.id_batalha,b.id_torneio,
           CASE WHEN b.id_batalha%2=0 THEN 1
                ELSE 2+((b.id_batalha*3)%19) END AS pos1
    FROM batalha b
) x;

-- 17. 2000 participacoes, 2 por batalha, com inscricao do mesmo
-- torneio. Em batalhas nao concluidas, resultados ficam NULL.
INSERT INTO participacao_batalha
    (id_participacao,id_batalha,id_inscricao,id_torneio,resultado)
SELECT (c.id_batalha-1)*2+lado,c.id_batalha,
       (c.id_torneio-1)*20 + CASE WHEN lado=1 THEN c.pos1 ELSE c.pos2 END,
       c.id_torneio,
       CASE WHEN NOT c.concluida THEN NULL
            WHEN c.empate THEN 'EMPATE'
            WHEN (lado=2 AND c.vence_segundo) OR (lado=1 AND NOT c.vence_segundo)
                 THEN 'VITORIA'
            ELSE 'DERROTA' END
FROM tmp_confrontos c
CROSS JOIN generate_series(1,2) AS lado;

-- 18. 900 batalhas concluidas, 50 canceladas e 50 agendadas.
-- O trigger exige dois resultados complementares na conclusao.
UPDATE batalha b
SET situacao = CASE WHEN b.id_batalha%20=0 THEN 'CANCELADA'
                    WHEN b.id_batalha%20=19 THEN 'AGENDADA'
                    ELSE 'CONCLUIDA' END
WHERE TRUE;

-- 19. 6000 usos: cada participante utiliza 3 Pokemon de sua
-- equipe principal, sem repetir o mesmo Pokemon na participacao.
-- O treinador de cada inscricao e dono dos Pokemon utilizados.
INSERT INTO uso_pokemon
 (id_uso,id_participacao,id_pokemon,dano_total,foi_derrotado)
SELECT (pb.id_participacao-1)*3+k,pb.id_participacao,
       (i.id_treinador-1)*15 + 1 + ((k-1+(pb.id_batalha%6))%6),
       0,((pb.id_batalha+k)%4=0)
FROM participacao_batalha pb
JOIN inscricao i ON i.id_inscricao=pb.id_inscricao
CROSS JOIN generate_series(1,3) AS k;

-- 20. 30000 eventos: cinco por uso, golpe conhecido pelo Pokemon.
-- A coluna dano_total de uso_pokemon sera igual a soma dos eventos.
INSERT INTO evento_batalha
  (id_evento,id_uso,id_golpe,rodada,dano,foi_critico)
SELECT (up.id_uso-1)*5+k,up.id_uso,
       1+(((p.id_especie-1)*7+((k-1)%3)*13)%120),
       k, CASE WHEN k=5 AND up.id_uso%6=0 THEN 0
               ELSE 10+((up.id_uso*3+k*11)%85) END,
       ((up.id_uso+k)%9=0)
FROM uso_pokemon up
JOIN pokemon p ON p.id_pokemon=up.id_pokemon
CROSS JOIN generate_series(1,5) AS k;

UPDATE uso_pokemon up
SET dano_total = q.dano
FROM (SELECT id_uso,SUM(dano)::integer AS dano
      FROM evento_batalha GROUP BY id_uso) q
WHERE up.id_uso=q.id_uso;

-- 21. Ajustar sequences/identities para INSERTs posteriores.
SELECT setval(pg_get_serial_sequence('liga_pokemon.regiao','id_regiao'),8,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.especie','id_especie'),250,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.tipo','id_tipo'),18,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.treinador','id_treinador'),120,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.pokemon','id_pokemon'),1500,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.captura','id_captura'),1500,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.golpe','id_golpe'),120,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.equipe','id_equipe'),200,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.equipe_pokemon','id_equipe_pokemon'),1000,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.torneio','id_torneio'),35,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.inscricao','id_inscricao'),700,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.batalha','id_batalha'),1000,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.participacao_batalha','id_participacao'),2000,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.uso_pokemon','id_uso'),6000,true);
SELECT setval(pg_get_serial_sequence('liga_pokemon.evento_batalha','id_evento'),30000,true);

-- 22. Validacao automatica. Se algum total estiver incorreto,
--     a transacao falha e a carga inteira e revertida.
DO $$
DECLARE
    rec RECORD;
    total_obtido BIGINT;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            ('regiao',8),('tipo',18),('especie',250),
            ('especie_tipo',315),('evolucao',20),
            ('treinador',120),('pokemon',1500),('captura',1500),
            ('golpe',120),('especie_golpe',1000),('pokemon_golpe',4500),
            ('equipe',200),('equipe_pokemon',1000),
            ('torneio',35),('inscricao',700),('batalha',1000),
            ('participacao_batalha',2000),('uso_pokemon',6000),
            ('evento_batalha',30000)
        ) AS esperado(tabela,quantidade)
    LOOP
        EXECUTE format('SELECT COUNT(*) FROM liga_pokemon.%I',rec.tabela)
           INTO total_obtido;
        IF total_obtido <> rec.quantidade THEN
            RAISE EXCEPTION 'Tabela %: esperado %, encontrado %',
                rec.tabela,rec.quantidade,total_obtido;
        END IF;
        RAISE NOTICE '%: % registros OK',rec.tabela,total_obtido;
    END LOOP;
    IF (SELECT COUNT(*) FROM liga_pokemon.batalha WHERE situacao='CONCLUIDA')<>900 THEN
        RAISE EXCEPTION 'Quantidade incorreta de batalhas concluidas';
    END IF;
    IF EXISTS (
        SELECT 1 FROM liga_pokemon.batalha b
        JOIN liga_pokemon.participacao_batalha pb ON pb.id_batalha=b.id_batalha
        WHERE b.situacao='CONCLUIDA'
        GROUP BY b.id_batalha
        HAVING COUNT(*)<>2 OR NOT
        ((COUNT(*) FILTER(WHERE pb.resultado='VITORIA')=1 AND
          COUNT(*) FILTER(WHERE pb.resultado='DERROTA')=1) OR
          COUNT(*) FILTER(WHERE pb.resultado='EMPATE')=2)
    ) THEN
        RAISE EXCEPTION 'Resultados de batalha invalidos';
    END IF;
    IF EXISTS (
       SELECT 1 FROM liga_pokemon.uso_pokemon up
       JOIN liga_pokemon.evento_batalha ev ON ev.id_uso=up.id_uso
       GROUP BY up.id_uso,up.dano_total
       HAVING SUM(ev.dano)<>up.dano_total
    ) THEN RAISE EXCEPTION 'Dano total inconsistente'; END IF;
    RAISE NOTICE 'CARGA LIGA POKEMON CONCLUIDA COM SUCESSO';
END $$;
COMMIT;

-- Consultas de verificacao opcionais apos a carga:
-- SELECT situacao, COUNT(*) FROM liga_pokemon.batalha GROUP BY situacao;
-- SELECT COUNT(*) FROM liga_pokemon.treinador t WHERE NOT EXISTS
--   (SELECT 1 FROM liga_pokemon.pokemon p WHERE p.id_treinador=t.id_treinador);
-- SELECT COUNT(*) FROM liga_pokemon.evento_batalha;
