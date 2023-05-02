"""Módulo responsável pela criação do profile dos dados"""

import os
import logging


import pandas as pd
from ydata_profiling import ProfileReport
import redshift_connector
from dotenv import load_dotenv

load_dotenv()
logging.basicConfig(filename="profile.log", encoding="utf-8", level=logging.INFO)


def create_connection() -> redshift_connector.Cursor:
    """Função que realiza a conexão com o Redshfit utilizando variáveis de ambiente.

    Returns:
        redshift_connector.Cursor: Cursor que representa a conexão com o Redshift
    """
    conn = redshift_connector.connect(
        host=os.getenv("REDSHIFT_HOST"),
        port=int(os.getenv("REDSHIFT_PORT")),
        database=os.getenv("REDSHIFT_DATABASE"),
        user=os.getenv("REDSHIFT_USER"),
        password=os.getenv("REDSHIFT_PASSWORT"),
    )

    logging.info("Conexão realizada com sucesso!")

    return conn.cursor()


def get_data(
    cursor: redshift_connector.Cursor, table: str, limit: str = "10000"
) -> pd.DataFrame:
    """Faz a selecão dos dados que serão utilizados para criar o profile

    Args:
        cursor (redshift_connector.Cursor): Cursor que representa a conexão com o Redshift

    Returns:
        pd.DataFrame: Dataframe com os dados selecionados
    """
    logging.info("Iniciando a busca dos dados")

    data_base = os.getenv("REDSHIFT_DATABASE")

    cursor.execute(f"""SELECT * FROM "{data_base}"."public"."{table}" LIMIT {limit};""")

    logging.info("Dados selecionados com sucesso!")

    return cursor.fetch_dataframe()


def create_profile(df: pd.DataFrame, table: dict[str, str]) -> None:
    """Cria o profile dos dados

    Args:
        df (pd.DataFrame): Dataframe com os dados necessários para a criação do profile
    """
    logging.info("Iniciando a criação do profile")

    profile = ProfileReport(
        df,
        title="Pandas Profiling Report",
        tsmode=True,
        sortby=table["date_column"],
    )

    logging.info("Profile com sucesso!")

    profile.to_file(f"report_for_{table['table_name']}_table.html")

    logging.info("Relatório criado com sucesso!")


def formating_data(df: pd.DataFrame) -> pd.DataFrame:
    """Transformando os tipos das colunas para realizar o profile

    Args:
        df (pd.DataFrame): Dataframe com os dados selecionados

    Returns:
        pd.DataFrame: Dataframe com os dados formatados
    """
    columns_numeric = ["codigo_da_transacao", "valor_da_transacao", "codigo_do_usuario"]
    df[columns_numeric] = df[columns_numeric].apply(pd.to_numeric)

    df["data_e_hora_da_transacao"] = pd.to_datetime(df["data_e_hora_da_transacao"])

    return df


def formating_date(df: pd.DataFrame) -> pd.DataFrame:
    df["dt_mes"] = pd.to_datetime(df["dt_mes"])
    return df


def main():
    """Função main com as chamadas de função necessárias para criar o profile dos dados"""
    tables = [
        {
            "table_name": "raw_transacoes_usuarios",
            "date_column": "data_e_hora_da_transacao",
        },
        {"table_name": "fct_churn", "date_column": "dt_mes"},
        {"table_name": "fct_ticket_medio", "date_column": "dt_mes"},
        {"table_name": "fct_tpv_geral", "date_column": "dt_mes"},
        {"table_name": "fct_tpv_metodo_pagamento", "date_column": "dt_mes"},
    ]

    redshift_connection = create_connection()

    for table in tables:
        data = get_data(redshift_connection, table["table_name"])

        # Aqui foi necessário realizar essa formatação porque o pandas profile estava entendo os
        # campos data e numéricos como string e estava criando o perfil dos dados como se essas
        # colunas fossem categóricas
        if table["table_name"] == "raw_transacoes_usuarios":
            data = formating_data(data)
        else:
            data = formating_date(data)

        create_profile(data, table)


if __name__ == "__main__":
    main()
