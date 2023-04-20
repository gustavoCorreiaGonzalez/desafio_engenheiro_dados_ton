-- dim_usuarios.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('stg_stone__transacoes') }}
),

usuarios AS (
    SELECT
        -- id
        id_codigo_usuario,
        -- strings
        nm_estado_usuario,
        nm_cidade_usuario
    FROM
        transacoes
)

SELECT * FROM usuarios
