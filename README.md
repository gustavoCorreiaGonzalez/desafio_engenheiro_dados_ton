# Desafio Engenheiro(a) de Dados/Analytics

Desafio para a vaga de Engenheiro de Dados/Analytics da Ton

## Terraform

Para realizar a criação da infraestrutura na AWS, foi desenvolvido um script em Terraform para automatizar e ter o controle das versões da infraestrutura escolhida. Foi considerado a utilização de boas práticas descritas nesse [site][1] que foi criado pelo Anton Babenko que é um dos principais contribuidores do Terraform para a plataforma da AWS.

## AWS Redshift

Utilizei o AWS Redshift Serverless para o projeto, fiz o upload da base que estava upada em um S3 utilizando o comando COPY para a tabela raw_transacoes_usuarios e assim inserindo todos os dados.

Para fazer o cálculo do Churn, para melhorar o desempenho do script, usei as funções LAG e LEAD que retorna os valores para uma linha em um determinado deslocamento acima e a abaixo da linha atual na partição respectivamente. Com esses retornos, foi possível ver se o usuário tinha realizado uma compra no mês anterior e posterior, assim o cálculo do Churn ficou muito mais fácil.

## DBT

Para a criação do projeto do DBT, segui as boas práticas descritas na própria [documentação][2] do DBT para ter uma melhor organização das pastas e para seguir a convenção que os próprios desenvolvedores do DBT seguem [internamente][3].

Para realizar o desenvolvimento dos modelos, primeiro precisei realizar algumas alterações nos nomes das colunas da fonte de dados. Utilizei uma convenção referente ao nome das colunas apresentada pela [Emily Riederer][4], onde ela defende a utilização de um conjunto de vocabulário restrito para criar um entendimento compartilhado de como cada campo em um conjunto de dados deve funcionar. Nesse [post][5] existe um exemplo de utilização dessa abordagem.

Resumindo, é a utilização de alguns prefixos antes do nome da coluna para apresentar uma ideia de qual tipo de dado a coluna está representando. Segue abaixo os prefixos que utilizei:

| Prefixo | Descrição                                        |
|---------|--------------------------------------------------|
| id_     | Identificador único para uma entidade            |
| n_      | Contagem de quantidade ou ocorrências de eventos |
| dt_     | Data de algum evento                             |
| nm_     | Descrição de algo                                |

### Modelagem

Utilizei como sugerido no desafio a star schema que está descrita na [documentação][6] do DBT.

Criei algumas dimensões e tabelas fatos referente à base de dados, minha ideia foi separar as informações dos usuários e das transações, assim criei a dimensões de usuários e cartões para que na tabela fato fizesse a junção dessas informações.

As outras tabelas fato foram criadas para representar algumas métricas de negócio, como o Churn, TPV e Ticket Médio. Assim será possível criar gráficos que mostrarão por mês como estão essas métricas.

### Testes

Quando trabalhei com o DBT, segui uma linha de criação de testes seguindo esse [tutorial][7]. Algumas coisas foram adaptadas para o escopo do projeto e também é necessário cuidado na utilização dos testes para não gastar muitos recursos na Cloud. A princípio para esse desafio utilizei os testes nativos do DBT e também alguns testes do pacote dbt-utils, mas também já desenvolvi testes personalizados e também utilizei o pacote dbt-great-expectations para alguns testes mais elaborados.

[1]: https://www.terraform-best-practices.com/code-styling
[2]: https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview
[3]: https://github.com/dbt-labs/corp/blob/main/dbt_style_guide.md
[4]: https://emilyriederer.netlify.app/post/column-name-contracts/
[5]: https://emilyriederer.netlify.app/post/convo-dbt/
[6]: https://docs.getdbt.com/terms/dimensional-modeling
[7]: https://www.datafold.com/blog/7-dbt-testing-best-practices#s5
