-- dim_usuarios.sql

WITH transacoes AS (
    SELECT * FROM {{ ref('stg_stone__transacoes') }}
),

usuarios AS (
    SELECT
        -- id
        {{ dbt_utils.generate_surrogate_key(['id_codigo_usuario', 'nm_estado_usuario', 'nm_cidade_usuario']) }} AS id_surrogate_key, -- noqa: LT01, LT05
        id_codigo_usuario,
        -- strings
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
