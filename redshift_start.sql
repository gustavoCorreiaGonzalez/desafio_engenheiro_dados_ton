-- Criando a tabela raw;

CREATE TABLE IF NOT EXISTS transacoes_usuarios_raw(
    codigo_da_transacao VARCHAR(255),
    data_e_hora_da_transacao VARCHAR(255),
    metodo_de_captura VARCHAR(255),
    bandeira_do_cartao VARCHAR(255),
    metodo_de_pagamento VARCHAR(255),
    estado_da_transacao VARCHAR(255),
    valor_da_transacao VARCHAR(255),
    codigo_do_usuario VARCHAR(255),
    estado_do_usuario VARCHAR(255),
    cidade_do_usuario VARCHAR(255)
);