-- int_totalizacoes_usuario.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('stg_stone__transacoes') }}
),

totalizacoes AS (
    SELECT
        -- id
        id_codigo_usuario,
        -- string
        nm_metodo_captura,
        nm_bandeira_cartao,
        nm_metodo_pagamento,
        -- numerics
        COUNT(*) AS n_utilizacoes_do_cartao,
        SUM(
            CASE
                WHEN nm_estado_transacao = 'refused' THEN nm_valor_transacao
            END
        ) AS n_total_aprovado,
        SUM(
            CASE
                WHEN nm_estado_transacao = 'chargedback' THEN nm_valor_transacao
            END
        ) AS n_total_estornado,
        SUM(
            CASE
                WHEN nm_estado_transacao = 'refunded' THEN nm_valor_transacao
            END
        ) AS n_total_devolvido,
        SUM(
            CASE
                WHEN nm_estado_transacao = 'processing' THEN nm_valor_transacao
            END
        ) AS n_total_processando,
        SUM(
            CASE WHEN nm_estado_transacao = 'paid' THEN nm_valor_transacao END
        ) AS n_total_pago
    FROM
        transacoes
    GROUP BY
        id_codigo_usuario,
        nm_metodo_captura,
        nm_bandeira_cartao,
        nm_metodo_pagamento
)

SELECT * FROM totalizacoes
