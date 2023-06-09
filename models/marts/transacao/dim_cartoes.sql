-- marts/transacao/dim_cartoes.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('stg_stone__transacoes') }}
),

cartoes AS (
    SELECT 
        -- id
        id_surrogate_key,
        id_codigo_usuario,
        -- string
        nm_metodo_captura,
        nm_bandeira_cartao,
        nm_metodo_pagamento,
        nm_estado_transacao,
        -- value
        nm_valor_transacao
    FROM transacoes
)

SELECT * FROM cartoes
