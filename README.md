# 📱 IMC+ (Calculadora de Saúde & Atividades)

Bem-vindo ao **IMC+**, muito mais do que uma simples calculadora de Índice de Massa Corporal. Uma aplicação completa desenvolvida em Flutter para gestão de saúde, acompanhamento de metas e estimativa de queima calórica.

---

## 🚀 Teste Agora! (Android)

Uma versão de testes final foi gerada e distribuída profissionalmente através do **Google Firebase App Distribution**. Se estiver num dispositivo Android, instale e teste a aplicação na íntegra clicando no link abaixo:

🔗 **[Descarregar e Testar o IMC+ (Versão Beta)](https://appdistribution.firebase.dev/i/f8ff027d8d7817d7)**

---

## 📸 Galeria do Aplicativo

### 📊 1. Dashboard e Navegação
Visão geral do progresso, gráficos de tendência e navegação principal adaptada ao Modo Escuro.

| Dashboard Interativo | Tela Inicial (Home) | Menu Lateral (Drawer) |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/ccfa2283-d9e4-4f9d-a347-96c63e5a8468" width="220"> | <img src="https://github.com/user-attachments/assets/72c01a17-d623-4e21-9cc5-bf6319bfd3e3" width="220"> | <img src="https://github.com/user-attachments/assets/80a1e0e0-11ea-47cc-8d16-caeff0e92d63" width="220"> |

### ⚖️ 2. Configurações e Calculadora
Interface fluida para definição de metas (Emagrecimento, Hipertrofia) e cálculo do estado atual.

| Perfil e Metas | Preenchimento do IMC | Resultado e Classificação |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/7e769a19-2c71-40e0-a729-781696426a89" width="220"> | <img src="https://github.com/user-attachments/assets/0ce9a4e8-fc6f-4e2c-a8cb-e81fab1b7b53" width="220"> | <img src="https://github.com/user-attachments/assets/abbfcbd5-8c1d-4b2a-b1ad-f66e4ba94f8f" width="220"> |

### 🏃‍♂️ 3. Histórico e Atividades Físicas
Acompanhamento detalhado do gasto calórico das atividades e registo de todas as medições passadas.

| Histórico de IMC | Registo de Atividade | Histórico de Atividades |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/9113aa0f-a237-40d5-906b-e50726b9b381" width="220"> | <img src="https://github.com/user-attachments/assets/6321d3fc-9c3b-4d7b-b443-7bb3b119e9bf" width="220"> | <img src="https://github.com/user-attachments/assets/ae4f0946-c1aa-4539-a554-1aa84514eb53" width="220"> |

---

## 🧠 Contexto

Este projeto foi desenvolvido com o objetivo de ir além de uma simples calculadora de IMC, evoluindo para uma aplicação completa de acompanhamento de dados de saúde com persistência local e suporte a múltiplos usuários.

## 🎯 Problema

Aplicações simples de IMC geralmente apresentam limitações como:
- Não salvam histórico de medições.
- Não permitem acompanhamento ao longo do tempo.
- Não suportam múltiplos usuários.
- Falta de organização dos dados.

👉 Isso impede o uso contínuo e reduz o valor e a retenção da aplicação.

## 💡 Solução

A aplicação foi projetada para permitir o acompanhamento contínuo do IMC e das atividades físicas diárias, oferecendo:
- Registro de múltiplas pessoas.
- Histórico de medições por indivíduo.
- Persistência local de dados (Offline first).
- Operações completas de gerenciamento (CRUD).

---

## ✨ Funcionalidades

### 👤 Gestão de usuários
- Cadastro de múltiplas pessoas.
- Associação de medições por perfil.

### ⚖️ Cálculo de IMC
- Cálculo automático com base em peso e altura.
- Classificação do IMC e sugestão de melhorias baseadas nas metas.

### 🏃‍♂️ Registro de Atividades
- Cálculo inteligente de queima calórica baseado no tipo de exercício (Corrida, Academia, Caminhada), duração, intensidade e peso atual da pessoa.

### 📊 Histórico e Dashboard
- Listagem de registros organizados.
- Visualização de evolução ao longo do tempo através de um Dashboard interativo.

### ✏️ Gerenciamento de dados
- Edição de perfis e configurações de metas.
- Exclusão de medições indesejadas.

---

## 🏗️ Arquitetura

O projeto foi estruturado utilizando o padrão **MVVM (Model-View-ViewModel)**, promovendo alta separação de responsabilidades e escalabilidade do código.

### 📂 Estrutura em camadas
- **Model** → Representação e tipagem dos dados.
- **View** → Interface do usuário moderna com total suporte a Dark Mode e proteção de SafeArea.
- **ViewModel** → Controle de estado e regras de negócio complexas.
- **Repository** → Abstração de acesso aos dados persistidos.

## 🛠️ Tecnologias
- **Flutter / Dart**
- **Hive** (Banco de dados local rápido e leve)
- **Arquitetura MVVM / Clean Code**
- **Injeção de Dependências** (GetIt)
- **Firebase App Distribution** (CI/CD e QA)

---

## ⚙️ Como rodar o projeto localmente

```bash
# Clone o repositório
git clone [https://github.com/wagnersoaressantos/calculador_de_imc.git](https://github.com/wagnersoaressantos/calculador_de_imc.git)

# Acesse a pasta
cd calculador_de_imc

# Instale as dependências
flutter pub get

# Execute o app (Certifique-se de ter um emulador rodando ou dispositivo conectado)
flutter run

```

## 📚 Aprendizados
Durante o desenvolvimento deste projeto, aprofundei conhecimentos em:

- Estruturação de aplicações robustas com Flutter multiplataforma.

- Implementação prática da arquitetura MVVM e injeção de dependências.

- Gerenciamento de estado nativo de forma otimizada.

- Persistência local NoSQL com o Hive.

- Otimização de UI/UX (Adaptação a notches, barra de navegação e Modo Escuro).

- Geração de Keystore, assinatura de código e empacotamento de Releases (.apk).

- Distribuição de software em fase beta via Firebase.

## 🔮 Melhorias futuras
- Implementação de gráficos de linha avançados para a evolução do IMC.

- Integração com APIs nativas de saúde (Google Fit / Apple Health).

- Autenticação de usuários na nuvem.

- Sincronização e backup com banco de dados remoto (Firebase Firestore).

## 🤝 Contribuição
Sugestões e melhorias são sempre bem-vindas! Sinta-se à vontade para abrir uma Issue ou enviar um Pull Request.

## 📬 Contato
GitHub:  **[wagnersoaressantos](https://github.com/wagnersoaressantos/)**
LinkedIn:  **[Wagner Soares Santos](www.linkedin.com/in/wagner-soaressantos)**

Desenvolvido em Serra Talhada - PE como parte das atividades práticas do Bacharelado em Sistemas de Informação e do Bootcamp Santander (DIO).
