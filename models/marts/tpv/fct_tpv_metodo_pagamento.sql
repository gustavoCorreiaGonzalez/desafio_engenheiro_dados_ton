-- marts/ticket_medio/fct_tpv_metodo_pagamento.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('int_transacoes_usuario') }}
),

tpv_geral AS (
    SELECT
        ROUND(
            SUM(
                CASE
                    WHEN nm_metodo_pagamento = 'debit_card' THEN nm_valor_transacao
                END
            ),
            1
        ) AS n_tpv_debito,
        ROUND(
            SUM(
                CASE
                    WHEN nm_metodo_pagamento = 'credit_card' THEN nm_valor_transacao
                END
            ),
            1
        ) AS n_tpv_credito,
        CAST(DATE_TRUNC('month', dt_transacao) AS DATE) AS dt_mes
    FROM
        transacoes
    GROUP BY
        dt_mes
    ORDER BY
        dt_mes ASC
)

SELECT * FROM tpv_geral
