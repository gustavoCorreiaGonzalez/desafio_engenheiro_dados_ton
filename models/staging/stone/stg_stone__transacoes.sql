-- stg_stone__transacoes.sql

WITH source AS (
    SELECT * FROM {{ source('dev','raw_transacoes_usuarios') }}
),

transacoes AS (
    SELECT
        -- ids
        codigo_da_transacao AS id_codigo_transacao,
        codigo_do_usuario AS id_codigo_usuario,
        -- strings
        LOWER(metodo_de_captura) AS nm_metodo_captura,
        LOWER(bandeira_do_cartao) AS nm_bandeira_cartao,
        LOWER(metodo_de_pagamento) AS nm_metodo_pagamento,
        LOWER(estado_da_transacao) AS nm_estado_transacao,
        LOWER(estado_do_usuario) AS nm_estado_usuario,
        LOWER(cidade_do_usuario) AS nm_cidade_usuario,
        -- numerics
        CAST(valor_da_transacao AS FLOAT) AS nm_valor_transacao,
        -- dates
        TO_TIMESTAMP(data_e_hora_da_transacao, 'YYYY-MM-DD HH24:MI:SS.MS') AS dt_transacao
    FROM source
)

SELECT * FROM transacoes
