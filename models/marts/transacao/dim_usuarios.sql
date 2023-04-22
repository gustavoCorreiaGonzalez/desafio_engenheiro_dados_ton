-- marts/transacao/dim_usuarios.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('stg_stone__transacoes') }}
),

usuarios AS (
    SELECT
        -- id
        id_surrogate_key,
        id_codigo_usuario,
        -- string
        nm_estado_usuario,
        nm_cidade_usuario
    FROM
        transacoes
    GROUP BY
        id_codigo_usuario,
        nm_estado_usuario,
        nm_cidade_usuario
)

SELECT * FROM usuarios
