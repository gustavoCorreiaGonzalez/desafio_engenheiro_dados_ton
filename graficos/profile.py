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


def get_data(cursor: redshift_connector.Cursor) -> pd.DataFrame:
    """Faz a selecão dos dados que serão utilizados para criar o profile

    Args:
        cursor (redshift_connector.Cursor): Cursor que representa a conexão com o Redshift

    Returns:
        pd.DataFrame: Dataframe com os dados selecionados
    """
    logging.info("Iniciando a busca dos dados")

    cursor.execute(
        """SELECT * FROM "dev"."public"."raw_transacoes_usuarios" LIMIT 10000;"""
    )

    logging.info("Dados selecionados com sucesso!")

    return cursor.fetch_dataframe()


def create_profile(df: pd.DataFrame) -> None:
    """Cria o profile dos dados

    Args:
        df (pd.DataFrame): Dataframe com os dados necessários para a criação do profile
    """
    logging.info("Iniciando a criação do profile")

    profile = ProfileReport(df, title="Pandas Profiling Report", minimal=True)

    logging.info("Profile com sucesso!")

    profile.to_file("your_report.html")

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


def main():
    """Função main com as chamadas de função necessárias para criar o profile dos dados"""
    redshift_connection = create_connection()

    data = get_data(redshift_connection)

    # Aqui foi necessário realizar essa formatação porque o pandas profile estava entendo os
    # campos data e numéricos como string e estava criando o perfil dos dados como se essas
    # colunas fossem categóricas
    data_formatted = formating_data(data)

    create_profile(data_formatted)


if __name__ == "__main__":
    main()
