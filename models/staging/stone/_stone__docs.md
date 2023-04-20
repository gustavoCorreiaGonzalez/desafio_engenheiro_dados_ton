{% docs description_raw_transacoes_usuarios %}

    Tabela de transações realizadas por clientes da Ton.

    | **Coluna**                   | **Descrição**                                                                |
    |------------------------------|------------------------------------------------------------------------------|
    | **codigo da transacao**      | Código único da transação                                                    |
    | **data e hora da transacao** | Data e hora da transação (UTC 0)                                             |
    | **metodo de captura**        | Dispositivo de captura (POS, Tapton ou Link de pagamento)                    |
    | **bandeira do cartao**       | Bandeira do cartão                                                           |
    | **metodo de pagamento**      | Método de pagamento                                                          |
    | **estado da transacao**      | Estado da transação (valores aceitos: paid, refused, refunded e chargedback) |
    | **valor da transacao**       | Valor da transação (R$)                                                      |
    | **codigo do usuario **       | Código único do usuário                                                      |
    | **estado do usuario **       | Estado do usuário                                                            |
    | **cidade do usuario **       | Cidade do usuário                                                            |

{% enddocs %}
