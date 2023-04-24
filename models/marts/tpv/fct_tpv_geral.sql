-- marts/ticket_medio/fct_tpv_geral.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('int_transacoes_usuario') }}
),

tpv_geral AS (
    SELECT
        ROUND(SUM(nm_valor_transacao), 1) AS nm_tpv_geral,
        CAST(DATE_TRUNC('month', dt_transacao) AS DATE) AS dt_mes
    FROM
        transacoes
    GROUP BY
        dt_mes
    ORDER BY
        dt_mes ASC
)

SELECT * FROM tpv_geral
