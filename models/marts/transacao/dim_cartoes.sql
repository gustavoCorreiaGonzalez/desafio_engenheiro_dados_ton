-- dim_cartoes.sql

WITH totalizacoes AS (
    SELECT * FROM {{ ref('int_totalizacoes_usuario') }}
),

cartoes AS (
    SELECT * FROM totalizacoes
)

SELECT * FROM cartoes
