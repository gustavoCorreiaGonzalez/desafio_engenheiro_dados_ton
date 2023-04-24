-- marts/ticket_medio/fct_ticket_medio.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('int_transacoes_usuario') }}
),

ticket_medio AS (
    SELECT
        ROUND(
            SUM(nm_valor_transacao) / COUNT(id_codigo_usuario), 1
        ) AS nm_ticket_medio,
        CAST(DATE_TRUNC('month', dt_transacao) AS DATE) AS dt_mes
    FROM
        transacoes
    GROUP BY
        dt_mes
    ORDER BY
        dt_mes ASC
)

SELECT * FROM ticket_medio
