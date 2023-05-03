-- marts/ticket_medio/fct_tpv_metodo_pagamento.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('int_transacoes_usuario') }}
),

tpv_geral AS (
    SELECT
        nm_metodo_pagamento,
        ROUND(SUM(nm_valor_transacao), 1) AS n_valor_tpv,
        CAST(DATE_TRUNC('month', dt_transacao) AS DATE) AS dt_mes
    FROM
        transacoes
    GROUP BY
        dt_mes,
        nm_metodo_pagamento
    ORDER BY
        dt_mes ASC
)

SELECT * FROM tpv_geral
