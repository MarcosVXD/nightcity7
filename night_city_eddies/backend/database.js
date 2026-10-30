const Database = require('better-sqlite3');

const db = new Database('nightcity.db');
db.pragma('journal_mode = WAL');

db.exec(`
  CREATE TABLE IF NOT EXISTS mercenarios (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    codinome TEXT NOT NULL,
    especialidade TEXT NOT NULL,
    distrito TEXT NOT NULL,
    descricao TEXT NOT NULL,
    experiencia INTEGER NOT NULL,
    reputacao REAL NOT NULL,
    valor INTEGER NOT NULL,
    disponibilidade TEXT NOT NULL,
    imagem TEXT NOT NULL,
    destaque INTEGER NOT NULL DEFAULT 0
  );

  CREATE TABLE IF NOT EXISTS contratos (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    categoria TEXT NOT NULL,
    distrito TEXT NOT NULL,
    dificuldade TEXT NOT NULL,
    descricao TEXT NOT NULL,
    recompensa INTEGER NOT NULL,
    prazo TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS contratacoes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mercenario_id INTEGER NOT NULL,
    contrato_id INTEGER NOT NULL,
    valor_total INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'Solicitado',
    criado_em TEXT NOT NULL,
    FOREIGN KEY (mercenario_id) REFERENCES mercenarios(id),
    FOREIGN KEY (contrato_id) REFERENCES contratos(id)
  );
`);

const mercenarios = [
  {
    id: 1, nome: 'Panam Palmer', codinome: 'NOMAD-01', especialidade: 'Combate / Direção',
    distrito: 'Badlands', descricao: 'Nômade habilidosa, especialista em operações fora da cidade, veículos e combate tático. Perfil de contratação fictício para esta simulação.',
    experiencia: 8, reputacao: 4.9, valor: 4200, disponibilidade: 'Disponível', destaque: 1,
    imagem: 'https://www.cyberpunk.net/build/images/cyberpunk/character/character-panam%401x-b51d31a7.png'
  },
  {
    id: 2, nome: 'Jackie Welles', codinome: 'HEYWOOD-02', especialidade: 'Combate / Proteção',
    distrito: 'Heywood', descricao: 'Mercenário leal e determinado, conhecido pela força em combate e pela capacidade de trabalhar em equipe. Perfil de contratação fictício.',
    experiencia: 7, reputacao: 4.8, valor: 3500, disponibilidade: 'Disponível', destaque: 1,
    imagem: 'https://www.cyberpunk.net/build/images/cyberpunk/character/character-jackie%401x-907b804d.png'
  },
  {
    id: 3, nome: 'V', codinome: 'AFTERLIFE-03', especialidade: 'Solo / Infiltração',
    distrito: 'Watson', descricao: 'Mercenário versátil de Night City. Atua em combate, infiltração e trabalhos de alto risco. Perfil de contratação fictício.',
    experiencia: 9, reputacao: 5.0, valor: 6000, disponibilidade: 'Disponível', destaque: 1,
    imagem: 'https://www.cyberpunk.net/build/images/cyberpunk/character/character-v%401x-f8c0f6ef.png'
  },
  {
    id: 4, nome: 'Judy Álvarez', codinome: 'MOX-04', especialidade: 'Tecnologia / Braindance',
    distrito: 'Watson', descricao: 'Especialista em tecnologia, edição de braindance e análise de dados. Nesta simulação alternativa, oferece suporte técnico para contratos.',
    experiencia: 8, reputacao: 4.9, valor: 3900, disponibilidade: 'Em análise', destaque: 0,
    imagem: 'https://www.svg.com/img/gallery/the-cyberpunk-2077-hackers-actually-did-it/l-intro-1613140594.jpg'
  },
  {
    id: 5, nome: 'Johnny Silverhand', codinome: 'SAMURAI-05', especialidade: 'Sabotagem / Distração',
    distrito: 'City Center', descricao: 'Ícone rebelde associado à banda Samurai. Aqui aparece como personagem de uma simulação de contratos, com foco em distração e sabotagem.',
    experiencia: 10, reputacao: 4.7, valor: 5000, disponibilidade: 'Disponível', destaque: 0,
    imagem: 'https://www.cyberpunk.net/build/images/cyberpunk/character/character-johnny%401x-3a4afbd5.png'
  },
  {
    id: 6, nome: 'Rogue Amendiares', codinome: 'AFTERLIFE-06', especialidade: 'Planejamento / Contatos',
    distrito: 'Afterlife', descricao: 'Fixer lendária, com experiência em conexões, planejamento e negociação de trabalhos. Perfil de apoio fictício para a plataforma.',
    experiencia: 10, reputacao: 5.0, valor: 7000, disponibilidade: 'Disponível', destaque: 0,
    imagem: 'https://img.gurugamer.com/resize/1200x-/2020/12/23/rogue-cyberpunk-2077-4417.jpg'
  }
];

const contratos = [
  { id: 1, titulo: 'Pacote Fantasma', categoria: 'Infiltração', distrito: 'Watson', dificuldade: 'Média', descricao: 'Invada um depósito corporativo e recupere um pacote de dados antes da troca de turno.', recompensa: 8500, prazo: '2 horas' },
  { id: 2, titulo: 'Comboio em Chamas', categoria: 'Escolta', distrito: 'Badlands', dificuldade: 'Alta', descricao: 'Escolte um veículo nômade até um ponto seguro nas estradas fora de Night City.', recompensa: 12000, prazo: '4 horas' },
  { id: 3, titulo: 'Olhos na Rede', categoria: 'Tecnologia', distrito: 'City Center', dificuldade: 'Média', descricao: 'Identifique a origem de uma transmissão bloqueada e extraia os arquivos necessários.', recompensa: 9500, prazo: '3 horas' },
  { id: 4, titulo: 'Última Saída', categoria: 'Extração', distrito: 'Pacifica', dificuldade: 'Extrema', descricao: 'Retire um contato de uma área hostil e conduza-o até um local de encontro.', recompensa: 18000, prazo: '5 horas' },
  { id: 5, titulo: 'Proteção VIP', categoria: 'Proteção', distrito: 'Heywood', dificuldade: 'Baixa', descricao: 'Acompanhe um cliente durante uma reunião e garanta uma rota segura de saída.', recompensa: 6500, prazo: '1 hora' },
  { id: 6, titulo: 'Ruído Corporativo', categoria: 'Sabotagem', distrito: 'Westbrook', dificuldade: 'Alta', descricao: 'Desative um terminal de comunicação e saia da região sem chamar atenção.', recompensa: 14500, prazo: '3 horas' },
  { id: 7, titulo: 'Carga Perdida', categoria: 'Recuperação', distrito: 'Santo Domingo', dificuldade: 'Média', descricao: 'Localize uma carga extraviada e leve-a ao ponto indicado pelo contratante.', recompensa: 9000, prazo: '2 horas' }
];

const insertMercenario = db.prepare(`
  INSERT OR IGNORE INTO mercenarios
  (id, nome, codinome, especialidade, distrito, descricao, experiencia, reputacao, valor, disponibilidade, imagem, destaque)
  VALUES (@id, @nome, @codinome, @especialidade, @distrito, @descricao, @experiencia, @reputacao, @valor, @disponibilidade, @imagem, @destaque)
`);
const insertContrato = db.prepare(`
  INSERT OR IGNORE INTO contratos
  (id, titulo, categoria, distrito, dificuldade, descricao, recompensa, prazo)
  VALUES (@id, @titulo, @categoria, @distrito, @dificuldade, @descricao, @recompensa, @prazo)
`);

const seed = db.transaction(() => {
  mercenarios.forEach((item) => insertMercenario.run(item));
  contratos.forEach((item) => insertContrato.run(item));
});
seed();

module.exports = db;
