"""Módulo responsável pela criação do profil e gráfico dos dados"""

import os
import logging


import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from ydata_profiling import ProfileReport
import redshift_connector
from dotenv import load_dotenv

load_dotenv()
sns.set_theme()
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
    """Transformando os tipos das colunas data para realizar o profile

    Args:
        df (pd.DataFrame): Dataframe com os dados selecionados

    Returns:
        pd.DataFrame: Dataframe com os dados formatados
    """
    df["dt_mes"] = pd.to_datetime(df["dt_mes"])

    return df


def main():
    """Função main com as chamadas de função necessárias para criar o profile dos dados"""
    redshift_connection = create_connection()

    # Profile da raw_transacoes_usuarios
    table = {
        "table_name": "raw_transacoes_usuarios",
        "date_column": "data_e_hora_da_transacao",
    }

    data = get_data(redshift_connection, table["table_name"])
    data = formating_data(data)
    create_profile(data, table)

    # Profile da tabela fct_churn
    table = {
        "table_name": "fct_churn",
        "value_column": "n_quantidade_usuarios",
        "date_column": "dt_mes",
    }

    data = get_data(redshift_connection, table["table_name"])
    data = formating_date(data)
    # create_profile(data, table)

    # Plot da tablea fct_churn=
    _, ax = plt.subplots(figsize=(14, 8))
    sns.barplot(
        x=table["date_column"],
        y=table["value_column"],
        hue="nm_evento",
        data=data,
        ax=ax,
    )

    for container in ax.containers:
        ax.bar_label(container, fmt="%.1f")

    x_dates = data[table["date_column"]].dt.strftime("%Y-%m-%d").sort_values().unique()
    ax.set_xticklabels(labels=x_dates, rotation=45, ha="right")
    sns.move_legend(ax, "upper left")

    plt.savefig(f"{table['table_name']}_plot.png")

    # Profile da tabela fct_ticket_medio
    table = {
        "table_name": "fct_ticket_medio",
        "value_column": "nm_ticket_medio",
        "date_column": "dt_mes",
    }

    data = get_data(redshift_connection, table["table_name"])
    data = formating_date(data)
    # create_profile(data, table)

    _, ax = plt.subplots(figsize=(14, 8))
    sns.barplot(
        x=table["date_column"],
        y=table["value_column"],
        data=data,
        ax=ax,
    )

    for container in ax.containers:
        ax.bar_label(container, fmt="%.1f")

    x_dates = data[table["date_column"]].dt.strftime("%Y-%m-%d").sort_values().unique()
    ax.set_xticklabels(labels=x_dates, rotation=45, ha="right")

    plt.savefig(f"{table['table_name']}_plot.png")

    # Profile da tabela fct_tpv_geral
    table = {
        "table_name": "fct_tpv_geral",
        "value_column": "nm_tpv_geral",
        "date_column": "dt_mes",
    }

    data = get_data(redshift_connection, table["table_name"])
    data = formating_date(data)
    # create_profile(data, table)

    _, ax = plt.subplots(figsize=(14, 8))
    sns.barplot(
        x=table["date_column"],
        y=table["value_column"],
        data=data,
        ax=ax,
    )

    for container in ax.containers:
        ax.bar_label(container, fmt="%.1f")

    x_dates = data[table["date_column"]].dt.strftime("%Y-%m-%d").sort_values().unique()
    ax.set_xticklabels(labels=x_dates, rotation=45, ha="right")

    plt.savefig(f"{table['table_name']}_plot.png")

    # Profile da tabela fct_tpv_geral
    table = {
        "table_name": "fct_tpv_metodo_pagamento",
        "value_column": "n_valor_tpv",
        "date_column": "dt_mes",
    }

    data = get_data(redshift_connection, table["table_name"])
    data = formating_date(data)
    # create_profile(data, table)

    _, ax = plt.subplots(figsize=(14, 8))
    sns.barplot(
        x=table["date_column"],
        y=table["value_column"],
        hue="nm_metodo_pagamento",
        data=data,
        ax=ax,
    )

    x_dates = data[table["date_column"]].dt.strftime("%Y-%m-%d").sort_values().unique()
    ax.set_xticklabels(labels=x_dates, rotation=45, ha="right")

    plt.savefig(f"{table['table_name']}_plot.png")


if __name__ == "__main__":
    main()
