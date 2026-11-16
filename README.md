# CidadeSegura
### Global Solution 2026.2 — CitizenTech

**FIAP | Sistemas de Informação — 3º ano**  
**Disciplina:** Desenvolvimento Cross-Platform com Flutter

**Integrantes**

- Caíque de Lacerda Braga — RM 555532
- Vitor Garcia Correia — RM 558516

## Sobre o projeto

O CidadeSegura é um aplicativo que desenvolvemos para facilitar o registro e o acompanhamento de problemas encontrados no dia a dia da cidade. A proposta surgiu a partir de uma situação bastante comum: muitas vezes percebemos um poste apagado, um buraco na rua, lixo acumulado ou um local com risco de enchente, mas essas informações acabam se perdendo ou ficando espalhadas em mensagens e conversas.

Pensando nisso, criamos uma maneira simples de organizar essas ocorrências pelo celular. O usuário pode informar o que aconteceu, onde fica o problema, qual é a prioridade e em que situação está o registro. Também pode consultar as ocorrências já cadastradas, atualizar as informações e remover registros quando necessário.

Nosso objetivo com essa primeira versão é mostrar como a tecnologia pode ajudar os moradores a observar melhor as necessidades do bairro e manter um histórico dos problemas urbanos. O público que pensamos atender inclui moradores, associações de bairro e pessoas envolvidas em iniciativas comunitárias.

### Relação com o CitizenTech e os ODS

O projeto está ligado ao **ODS 11 — Cidades e Comunidades Sustentáveis**, que trata da construção de cidades mais inclusivas, seguras, resilientes e sustentáveis. Ao reunir informações sobre iluminação, conservação das vias, limpeza e outros problemas urbanos, o CidadeSegura contribui para organizar demandas que impactam a qualidade de vida da população.

Nesta versão, os registros ficam armazenados no próprio aparelho. O aplicativo não envia solicitações automaticamente para a prefeitura nem substitui os canais oficiais de atendimento.

## Funcionalidades

Organizamos o aplicativo em cinco telas para que o usuário consiga realizar todo o fluxo de cadastro e acompanhamento:

1. **Início:** apresenta o projeto, o ODS relacionado e um resumo das ocorrências cadastradas, separadas em abertas, em andamento e resolvidas. Também oferece acesso ao cadastro e à listagem.
2. **Ocorrências:** mostra os registros em uma lista que pode ser filtrada por status. A tela também informa quando não há registros e apresenta mensagens em caso de erro ou carregamento.
3. **Nova ocorrência / edição:** permite preencher título, descrição, categoria, bairro, endereço ou ponto de referência, prioridade e status. Os campos obrigatórios são validados antes de salvar.
4. **Detalhes:** reúne todas as informações de uma ocorrência, incluindo as datas de criação e atualização, e oferece as opções de editar e excluir. Antes da exclusão, o usuário precisa confirmar a ação.
5. **Sobre:** explica a proposta do CidadeSegura, a relação com o ODS 11 e apresenta os integrantes do grupo.

Com essas funcionalidades, implementamos o **CRUD completo**: cadastrar, listar/consultar, editar e excluir ocorrências.

## Tecnologias e organização do projeto

Desenvolvemos o aplicativo com **Flutter e Dart**, utilizando componentes do Material Design para manter as telas padronizadas e fáceis de navegar.

Para organizar o código, separamos as responsabilidades em pastas:

```text
lib/
├── main.dart                 # Inicialização do aplicativo
├── models/                  # Modelo dos dados de uma ocorrência
├── data/                    # Repositório e acesso ao SQLite
├── providers/               # Gerenciamento de estado
├── screens/                 # Telas do aplicativo
├── widgets/                 # Componentes reutilizáveis
├── theme/                   # Cores e estilos
└── utils/                   # Validações dos formulários

test/                        # Testes unitários
screenshots/                 # Capturas das telas
```

### Gerenciamento de estado com Provider

Utilizamos o pacote **Provider** com `ChangeNotifier` para centralizar os dados das ocorrências. É o `OcorrenciasProvider` que faz a comunicação entre as telas e o repositório, controla os estados de carregamento e atualiza os indicadores da página inicial.

Assim, quando uma ocorrência é cadastrada, editada ou excluída, a lista e os números do painel são atualizados sem precisar controlar os mesmos dados separadamente em cada tela. A navegação utiliza `Navigator.push` e `Navigator.pop`, com passagem dos dados necessários para visualizar ou editar um registro.

### Persistência de dados — SQLite

Escolhemos a **Opção B do enunciado: persistência local com SQLite**, utilizando os pacotes `sqflite` e `path`. Fizemos essa escolha porque o aplicativo pode funcionar sem depender de uma API externa, de login ou de um servidor configurado à parte.

O banco de dados se chama `cidadesegura.db` e é criado automaticamente na primeira execução do aplicativo. Ele possui a tabela `ocorrencias`, com a seguinte estrutura:

| Campo | Tipo | Finalidade |
| --- | --- | --- |
| `id` | INTEGER | Identificador do registro, gerado automaticamente |
| `titulo` | TEXT | Nome resumido do problema |
| `descricao` | TEXT | Explicação da ocorrência |
| `categoria` | TEXT | Tipo de problema urbano |
| `bairro` | TEXT | Bairro em que o problema foi identificado |
| `endereco` | TEXT | Endereço ou ponto de referência |
| `prioridade` | TEXT | Baixa, Média ou Alta |
| `status` | TEXT | Aberta, Em andamento ou Resolvida |
| `criado_em` | TEXT | Data e hora do cadastro |
| `atualizado_em` | TEXT | Data e hora da última alteração |

As operações de leitura, cadastro, atualização e exclusão são feitas de forma assíncrona, com `Future`, `async` e `await`. Dessa forma, os registros ficam salvos no dispositivo e podem ser consultados novamente quando o aplicativo é aberto.

## Galeria de telas

### Tela inicial

O painel mostra a quantidade total de ocorrências e os indicadores por status, além de apresentar o ODS 11.

![Tela inicial do CidadeSegura](screenshots/01-home.png)

### Lista de ocorrências

Os registros aparecem em uma lista, com a possibilidade de filtrar por situação.

![Lista de ocorrências](screenshots/02-listagem.png)

### Cadastro de ocorrência

O formulário permite informar o problema e sua localização, além de selecionar categoria, prioridade e status.

![Formulário de cadastro](screenshots/03-formulario.png)

### Validação do formulário

O aplicativo verifica os campos obrigatórios e exibe mensagens quando algum dado precisa ser corrigido.

![Validação dos campos](screenshots/04-formulario-validacao.png)

### Detalhes da ocorrência

Nesta tela é possível consultar os dados completos, editar o registro ou solicitar sua exclusão.

![Detalhes da ocorrência](screenshots/05-detalhes.png)

### Edição de ocorrência

O formulário é aberto com as informações já preenchidas para facilitar a atualização.

![Edição de ocorrência](screenshots/06-edicao.png)

## Como executar o projeto no VS Code

Para rodar o CidadeSegura, é necessário ter o **Flutter SDK**, o **Android SDK** e as extensões **Flutter** e **Dart** instalados no VS Code, além de um emulador Android ou celular conectado.

**1. Clonar o repositório**

No terminal do VS Code, utilize o endereço do repositório publicado no GitHub:

```bash
git clone URL_DO_REPOSITORIO
cd cidadesegura_flutter
```

**2. Instalar as dependências**

```bash
flutter pub get
```

**3. Executar o aplicativo**

Inicie um emulador Android ou conecte um celular com a depuração USB habilitada. Depois, execute:

```bash
flutter run
```

Na primeira execução, o banco SQLite e a tabela de ocorrências são criados automaticamente. Não é necessário iniciar uma API ou configurar um banco externo.

**4. Executar os testes**

```bash
flutter test
```

O projeto contém **21 testes unitários**, organizados nos arquivos `test/ocorrencia_test.dart` e `test/provider_test.dart`. Eles verificam o modelo de dados, as validações dos campos, as operações de cadastro, edição e exclusão, os indicadores e o tratamento de erros do Provider.

## Considerações finais

Com o CidadeSegura, buscamos reunir em um único aplicativo informações que normalmente ficam dispersas e facilitar o acompanhamento de questões que afetam os bairros. O projeto nos permitiu aplicar, na prática, conceitos de interfaces com Flutter, navegação, formulários, gerenciamento de estado, persistência local e testes automatizados, sempre mantendo o foco na proposta do CitizenTech.
