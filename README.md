# VolleyMatch

VolleyMatch é um aplicativo Flutter desenvolvido para facilitar o gerenciamento de jogos de vôlei. Com esta aplicação, você pode cadastrar jogadores, criar times de forma automática ou manual, controlar placares e manter um histórico de todas as partidas realizadas.

## 📱 Funcionalidades

### 👥 Gerenciamento de Jogadores
- Cadastro de jogadores com nome e gênero (Masculino/Feminino)
- Listagem de todos os jogadores cadastrados
- Remoção de jogadores
- Interface intuitiva com identificação visual por gênero

### 🏐 Criação de Times
- **Sorteio Automático**: Distribui jogadores automaticamente em times balanceados, respeitando o gênero
- **Criação Manual**: Permite definir manualmente os jogadores de cada time
  - Escolha o número de times (2 a 10)
  - Personalize o nome de cada time
  - Selecione jogadores para cada time através de uma interface interativa
- Visualização detalhada dos times criados com lista de jogadores

### 📊 Placar e Partidas
- Controle de placar em tempo real
- Seleção de dois times para a partida
- Incremento/decremento de pontos
- Salvamento de partidas com histórico completo
- Visualização de todas as partidas realizadas com detalhes dos times e placares

## 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework multiplataforma
- **Hive** - Banco de dados NoSQL local para armazenamento de dados
- **Material Design 3** - Design system moderno e profissional

## 📦 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados
│   ├── player.dart          # Modelo de Jogador
│   ├── team.dart            # Modelo de Time
│   └── match_model.dart     # Modelo de Partida
├── screens/                  # Telas da aplicação
│   ├── home_screen.dart     # Tela inicial
│   ├── players_screen.dart  # Gerenciamento de jogadores
│   ├── teams_screen.dart    # Criação e visualização de times
│   ├── scoreboard_screen.dart # Controle de placar
│   └── matches_screen.dart  # Histórico de partidas
└── services/                 # Serviços e lógica de negócio
    ├── hive_service.dart    # Serviço de persistência
    └── team_generator.dart  # Geração automática de times
```

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (versão 3.7.2 ou superior)
- Dart SDK
- Um dispositivo ou emulador configurado

### Instalação

1. Clone o repositório:
```bash
git clone <url-do-repositorio>
cd volley_match
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

### Geração de Código (Hive)

Se precisar regenerar os adapters do Hive após modificar os modelos:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Ou em modo watch (regenera automaticamente ao salvar):

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 📱 Como Usar

1. **Cadastrar Jogadores**: 
   - Acesse a tela "Jogadores"
   - Informe o nome e o gênero
   - Clique em "Adicionar Jogador"

2. **Criar Times**:
   - Acesse a tela "Times"
   - Escolha entre "Manual" ou "Sortear"
   - Para sorteio automático, defina quantos jogadores por time e clique em "Sortear"
   - Para criação manual, use o diálogo para selecionar jogadores para cada time

3. **Controlar Placar**:
   - Acesse a tela "Placar"
   - Selecione os dois times que irão jogar
   - Use os botões +/- para ajustar os pontos
   - Clique em "Salvar Partida" ao finalizar

4. **Ver Histórico**:
   - Acesse a tela "Partidas"
   - Visualize todas as partidas salvas com seus respectivos placares

## 🎨 Design

O aplicativo utiliza Material Design 3 com:
- Interface moderna e profissional
- Cores vibrantes e gradientes
- Navegação intuitiva
- Feedback visual através de animações e notificações
- Layout responsivo que se adapta a diferentes tamanhos de tela

## 📄 Licença

Este projeto é privado e não está destinado à publicação pública.

## 👨‍💻 Desenvolvimento

Para mais informações sobre o desenvolvimento Flutter, consulte:
- [Documentação Flutter](https://docs.flutter.dev/)
- [Documentação Hive](https://docs.hivedb.dev/)
- [Material Design 3](https://m3.material.io/)
