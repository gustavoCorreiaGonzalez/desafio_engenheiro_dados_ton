-- marts/churn/fct_churn.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('int_transacoes_usuario') }}
),

atividade_mes AS (
    SELECT
        id_codigo_usuario,
        CAST(DATE_TRUNC('month', dt_transacao) AS DATE) AS dt_mes
    FROM
        transacoes
    GROUP BY
        1, 2
    ORDER BY
        1, 2
),

lag_lead AS (
    SELECT
        id_codigo_usuario,
        dt_mes,
        LAG(dt_mes, 1) OVER (PARTITION BY id_codigo_usuario ORDER BY id_codigo_usuario, dt_mes) AS nm_lag,
        LEAD(dt_mes, 1) OVER (PARTITION BY id_codigo_usuario ORDER BY id_codigo_usuario, dt_mes) AS nm_lead
    FROM
        atividade_mes
),

lag_lead_with_diffs AS (
    SELECT
        id_codigo_usuario,
        dt_mes,
        nm_lag,
        nm_lead, 
        dt_mes-nm_lag AS nm_lag_size, 
        nm_lead-dt_mes AS nm_lead_size
    FROM lag_lead
),

calculated AS (
    SELECT
        CASE
            WHEN nm_lag is null THEN 'novos usuarios'
            WHEN nm_lag_size = 1 THEN 'usuarios ativos'
            WHEN nm_lag_size > 1 THEN 'usuarios que retornaram'
        END AS nm_evento,
        CASE
            WHEN (nm_lead > 1 OR nm_lead_size IS NULL) THEN 'churn'
            ELSE NULL
        END AS nm_next_month_churn,
        dt_mes,
        COUNT(DISTINCT id_codigo_usuario) AS n_quantidade_usuarios
    FROM
        lag_lead_with_diffs
    GROUP BY
        1, 2, 3
),

churn AS (
    SELECT
        nm_evento, 
        dt_mes,
        SUM(n_quantidade_usuarios) AS n_quantidade_usuarios
    FROM
        calculated 
    GROUP BY
        1, 2

    UNION

    SELECT
        'churn' AS nm_evento,
        CAST(ADD_MONTHS(dt_mes, 1) AS DATE) AS dt_mes,
        n_quantidade_usuarios
    FROM
        calculated
    WHERE
        nm_next_month_churn IS NOT NULL
    ORDER BY
        2
)

SELECT * FROM churn
