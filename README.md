# 📱 App de Acompanhamento de IMC (Flutter)

## 🧠 Contexto

Este projeto foi desenvolvido com o objetivo de ir além de uma simples calculadora de IMC, evoluindo para uma aplicação completa de acompanhamento de dados de saúde com persistência local e suporte a múltiplos usuários.

---

## 🎯 Problema

Aplicações simples de IMC geralmente apresentam limitações como:

- Não salvam histórico de medições
- Não permitem acompanhamento ao longo do tempo
- Não suportam múltiplos usuários
- Falta de organização dos dados

👉 Isso impede o uso contínuo e reduz o valor da aplicação.

---

## 💡 Solução

A aplicação foi projetada para permitir o acompanhamento contínuo do IMC, oferecendo:

- Registro de múltiplas pessoas
- Histórico de medições por usuário
- Persistência local de dados
- Operações completas de gerenciamento (CRUD)

---

## 🚀 Funcionalidades

### 👤 Gestão de usuários
- Cadastro de múltiplas pessoas
- Associação de medições por indivíduo

### ⚖️ Cálculo de IMC
- Cálculo automático com base em peso e altura
- Classificação do IMC

### 📊 Histórico
- Listagem de registros por pessoa
- Visualização de evolução ao longo do tempo

### ✏️ Gerenciamento de dados
- Edição de registros
- Exclusão de medições

---

## 🏗️ Arquitetura

O projeto foi estruturado utilizando o padrão **MVVM (Model-View-ViewModel)**, promovendo separação de responsabilidades e escalabilidade.

### 📂 Estrutura em camadas

- **Model** → Representação dos dados
- **View** → Interface do usuário
- **ViewModel** → Controle de estado e regras de negócio
- **Repository** → Abstração de acesso aos dados

---

## 🛠️ Tecnologias

- Flutter
- Dart
- Hive (persistência local)
- Arquitetura MVVM

---

## 💾 Persistência de Dados

O aplicativo utiliza o Hive para armazenamento local, permitindo:

- Salvamento eficiente de dados
- Acesso rápido às informações
- Funcionamento offline

---

## 📷 Demonstração

> Em breve (prints da aplicação)

---

## ⚙️ Como rodar o projeto

```bash
# Clone o repositório
git clone https://github.com/wagnersoaressantos/calculador_de_imc

# Acesse a pasta
cd calculador_de_imc

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

# 📚 Aprendizados

# Durante o desenvolvimento deste projeto, foram trabalhados:

- Estruturação de aplicações com Flutter
- Implementação de arquitetura MVVM
- Gerenciamento de estado sem uso de Provider
- Persistência local com Hive
- Organização de código em camadas
- Implementação de operações CRUD completas
# 🔮 Melhorias futuras
- Implementação de gráficos de evolução do IMC
- Integração com APIs de saúde
- Autenticação de usuários
- Sincronização com banco de dados remoto
- UI/UX aprimorada
# 🤝 Contribuição

- Sugestões e melhorias são bem-vindas.

# 📬 Contato
- GitHub: https://github.com/wagnersoaressantos
- LinkedIn: www.linkedin.com/in/wagner-soaressantos

