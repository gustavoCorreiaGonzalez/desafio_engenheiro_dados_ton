-- marts/transacao/fct_transacoes.sql

WITH cartoes AS (
    SELECT * FROM {{ ref('dim_cartoes') }}
),

usuarios AS (
    SELECT * FROM {{ ref('dim_usuarios') }}
),

transacoes AS (
    SELECT
        u.id_surrogate_key,
        u.id_codigo_usuario,
        u.nm_estado_usuario,
        u.nm_cidade_usuario,
        c.nm_metodo_captura,
        c.nm_bandeira_cartao,
        c.nm_metodo_pagamento,
        c.nm_estado_transacao
    FROM
        cartoes c
    INNER JOIN
        usuarios u
    ON c.id_surrogate_key = u.id_surrogate_key
)

SELECT * FROM transacoes
