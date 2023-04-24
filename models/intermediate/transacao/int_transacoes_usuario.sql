-- int_churn_transacoes_usuario.sql

WITH stg_stone__transacoes AS (
  SELECT * FROM {{ ref('stg_stone__transacoes') }}
),

transacoes_realizadas AS (
    SELECT
        id_codigo_usuario,
        nm_estado_transacao,
        nm_metodo_pagamento,
        nm_valor_transacao,
        dt_transacao
    FROM stg_stone__transacoes
    WHERE nm_estado_transacao = 'paid'
)

SELECT * FROM transacoes_realizadas
