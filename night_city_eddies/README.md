# NIGHT CITY // EDDIES

Marketplace fictício de contratação de mercenários inspirado em Cyberpunk 2077. Projeto de estudo com Flutter, Dart, Node.js, Express e SQLite.

> Fan-made / sem vínculo com CD PROJEKT RED. Personagens, serviços, contratos, avaliações e valores são usados em uma simulação. Não há pagamentos reais.

## Estrutura

```text
night_city_eddies/
├── backend/
│   ├── database.js
│   ├── server.js
│   └── package.json
├── mobile/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   ├── screens/
│   │   ├── services/
│   │   ├── theme/
│   │   └── widgets/
│   └── pubspec.yaml
├── setup_flutter.bat
├── iniciar_api.bat
├── configure_android.ps1
└── README.md
```

## O que já está implementado

- Splash screen temática.
- Navegação inferior: Início, Mercenários, Gigs, Pedidos e Perfil.
- Catálogo de mercenários com imagens, reputação, preço e disponibilidade.
- Pesquisa e filtros por especialidade.
- Tela de detalhes do mercenário.
- Lista de contratos com filtro por dificuldade.
- Fluxo de contratação com seleção de um contrato e cálculo do valor simulado.
- Registro das solicitações no SQLite pela API.
- Tela para acompanhar e cancelar solicitações.
- Tela de favoritos (mantidos durante a execução atual do app).

## Requisitos

- Flutter instalado e configurado.
- Android Studio / emulador Android ou dispositivo Android.
- Node.js 20 ou superior recomendado.
- Conexão com a internet para carregar as fotografias hospedadas externamente e instalar as dependências.

## 1. Preparar o projeto Flutter

Na primeira vez, execute `setup_flutter.bat` com o Flutter disponível no PATH. O script cria a estrutura Android e copia o código que está na pasta `mobile` para `night_city_eddies_app`.

O script também configura automaticamente a permissão de internet e o acesso HTTP local no AndroidManifest.xml. Depois, abra `night_city_eddies_app/android/app/src/main/AndroidManifest.xml` e confira se existem estas configurações:

1. Dentro de `<manifest>`, antes de `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

2. Dentro da abertura de `<application>`:

```xml
android:usesCleartextTraffic="true"
```

Essa configuração permite que o app de desenvolvimento acesse a API local por HTTP. Para publicar o aplicativo, configure HTTPS e remova a permissão de tráfego sem criptografia.

Entre na pasta `night_city_eddies_app` e execute:

```bash
flutter pub get
```

## 2. Iniciar a API

Execute `iniciar_api.bat` ou abra um terminal na pasta `backend`:

```bash
npm install
npm start
```

A API ficará disponível em:

```text
http://localhost:3000/api
```

Teste no navegador:

- `http://localhost:3000/api/health`
- `http://localhost:3000/api/mercenarios`
- `http://localhost:3000/api/contratos`
- `http://localhost:3000/api/contratacoes`

O arquivo `nightcity.db` é criado automaticamente na primeira inicialização do servidor e recebe os dados iniciais.

## 3. Conectar o Flutter à API

O endereço padrão do app está configurado para o emulador Android:

```text
http://10.0.2.2:3000/api
```

Esse endereço especial permite que o emulador Android acesse o servidor que está rodando no computador.

Para executar no emulador:

```bash
flutter run
```

Para usar um celular físico, conecte o computador e o celular à mesma rede Wi-Fi, descubra o IPv4 do computador com `ipconfig` e execute substituindo o IP:

```bash
flutter run --dart-define=API_URL=http://192.168.0.10:3000/api
```

O IP acima é apenas um exemplo. Use o IPv4 real do seu computador. No celular físico, também permita a conexão na rede privada pelo Firewall do Windows.

## 4. Endpoints da API

| Método | Endpoint | Função |
|---|---|---|
| GET | `/api/health` | Verifica se a API está online |
| GET | `/api/mercenarios` | Lista mercenários; aceita `busca` e `especialidade` |
| GET | `/api/mercenarios/:id` | Consulta um mercenário |
| GET | `/api/contratos` | Lista contratos; aceita `dificuldade` e `distrito` |
| GET | `/api/contratos/:id` | Consulta um contrato |
| POST | `/api/contratacoes` | Registra uma contratação |
| GET | `/api/contratacoes` | Lista contratações registradas |
| PATCH | `/api/contratacoes/:id` | Atualiza o status da contratação |

Exemplo de corpo para criar uma contratação:

```json
{
  "mercenarioId": 1,
  "contratoId": 2
}
```

Os status aceitos pelo endpoint de atualização são `Solicitado`, `Aceito`, `Em andamento`, `Concluído` e `Cancelado`.

## Observações

- O app depende da API estar ligada para carregar o catálogo e registrar contratações.
- As imagens dos personagens são carregadas por URLs externas. Se um endereço mudar ou estiver indisponível, o app apresenta um ícone substituto.
- Esta versão não tem login real, pagamento, saldo persistente nem autorização por usuário. O saldo mostrado no perfil é ilustrativo.
- Os pedidos são armazenados no SQLite do backend, então permanecem após fechar e reabrir o aplicativo enquanto o arquivo do banco for mantido.
- Os personagens aparecem em uma simulação alternativa de marketplace; a disponibilidade para contratação não representa a história oficial do jogo.

## Referência visual

As imagens de personagens utilizam endereços públicos de páginas promocionais e materiais de Cyberpunk 2077. O centro de imprensa oficial da CD PROJEKT RED reúne materiais de mídia do jogo: https://press.cdprojektred.com/en/224/808.
