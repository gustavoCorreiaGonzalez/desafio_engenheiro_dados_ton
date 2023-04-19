-- stg_transacoes__usuarios.sql

WITH source AS (
    SELECT * FROM {{ source('dev','raw_transacoes_usuarios') }}
),

transacoes AS (
    SELECT
        -- ids
        codigo_da_transacao AS id_codigo_transacao,
        codigo_do_usuario AS id_codigo_usuario,
        -- strings
        metodo_de_captura AS nm_metodo_captura,
        bandeira_do_cartao AS nm_bandeira_cartao,
        metodo_de_pagamento AS nm_metodo_pagamento,
        estado_da_transacao AS nm_estado_transacao,
        estado_do_usuario AS nm_estado_usuario,
        cidade_do_usuario AS nm_cidade_usuario,
        -- numerics
        valor_da_transacao AS nm_valor_transacao,
        -- dates
        data_e_hora_da_transacao AS dt_transacao
    FROM source
)

SELECT * FROM transacoes
