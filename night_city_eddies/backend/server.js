const express = require('express');
const cors = require('cors');
const db = require('./database');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ status: 'online', sistema: 'Night City Eddies API' });
});

app.get('/api/mercenarios', (req, res) => {
  const { busca, especialidade } = req.query;
  let sql = 'SELECT * FROM mercenarios WHERE 1 = 1';
  const params = [];

  if (busca) {
    sql += ' AND (nome LIKE ? OR codinome LIKE ? OR especialidade LIKE ? OR distrito LIKE ?)';
    const termo = `%${busca}%`;
    params.push(termo, termo, termo, termo);
  }
  if (especialidade && especialidade !== 'Todas') {
    sql += ' AND especialidade LIKE ?';
    params.push(`%${especialidade}%`);
  }

  sql += ' ORDER BY destaque DESC, reputacao DESC';
  res.json(db.prepare(sql).all(...params));
});

app.get('/api/mercenarios/:id', (req, res) => {
  const item = db.prepare('SELECT * FROM mercenarios WHERE id = ?').get(req.params.id);
  if (!item) return res.status(404).json({ erro: 'Mercenário não encontrado.' });
  res.json(item);
});

app.get('/api/contratos', (req, res) => {
  const { dificuldade, distrito } = req.query;
  let sql = 'SELECT * FROM contratos WHERE 1 = 1';
  const params = [];

  if (dificuldade && dificuldade !== 'Todas') {
    sql += ' AND dificuldade = ?';
    params.push(dificuldade);
  }
  if (distrito && distrito !== 'Todos') {
    sql += ' AND distrito = ?';
    params.push(distrito);
  }

  sql += ' ORDER BY recompensa DESC';
  res.json(db.prepare(sql).all(...params));
});

app.get('/api/contratos/:id', (req, res) => {
  const item = db.prepare('SELECT * FROM contratos WHERE id = ?').get(req.params.id);
  if (!item) return res.status(404).json({ erro: 'Contrato não encontrado.' });
  res.json(item);
});

app.post('/api/contratacoes', (req, res) => {
  const mercenarioId = Number(req.body.mercenarioId);
  const contratoId = Number(req.body.contratoId);

  if (!Number.isInteger(mercenarioId) || !Number.isInteger(contratoId)) {
    return res.status(400).json({ erro: 'Informe um mercenário e um contrato válidos.' });
  }

  const mercenario = db.prepare('SELECT * FROM mercenarios WHERE id = ?').get(mercenarioId);
  const contrato = db.prepare('SELECT * FROM contratos WHERE id = ?').get(contratoId);

  if (!mercenario || !contrato) {
    return res.status(404).json({ erro: 'Mercenário ou contrato não encontrado.' });
  }

  const valorTotal = mercenario.valor + contrato.recompensa;
  const resultado = db.prepare(`
    INSERT INTO contratacoes (mercenario_id, contrato_id, valor_total, status, criado_em)
    VALUES (?, ?, ?, 'Solicitado', datetime('now', 'localtime'))
  `).run(mercenarioId, contratoId, valorTotal);

  const novaContratacao = db.prepare(`
    SELECT c.id, c.valor_total, c.status, c.criado_em,
           m.nome AS mercenario, m.imagem AS imagem,
           j.titulo AS contrato, j.distrito AS distrito
    FROM contratacoes c
    JOIN mercenarios m ON m.id = c.mercenario_id
    JOIN contratos j ON j.id = c.contrato_id
    WHERE c.id = ?
  `).get(resultado.lastInsertRowid);

  res.status(201).json(novaContratacao);
});

app.get('/api/contratacoes', (req, res) => {
  const lista = db.prepare(`
    SELECT c.id, c.valor_total, c.status, c.criado_em,
           m.nome AS mercenario, m.imagem AS imagem,
           j.titulo AS contrato, j.distrito AS distrito
    FROM contratacoes c
    JOIN mercenarios m ON m.id = c.mercenario_id
    JOIN contratos j ON j.id = c.contrato_id
    ORDER BY c.id DESC
  `).all();
  res.json(lista);
});

app.patch('/api/contratacoes/:id', (req, res) => {
  const statusPermitidos = ['Solicitado', 'Aceito', 'Em andamento', 'Concluído', 'Cancelado'];
  const { status } = req.body;

  if (!statusPermitidos.includes(status)) {
    return res.status(400).json({ erro: 'Status inválido.' });
  }

  const resultado = db.prepare('UPDATE contratacoes SET status = ? WHERE id = ?')
    .run(status, req.params.id);

  if (!resultado.changes) {
    return res.status(404).json({ erro: 'Contratação não encontrada.' });
  }

  res.json({ mensagem: 'Status atualizado.', id: Number(req.params.id), status });
});

app.use((req, res) => {
  res.status(404).json({ erro: 'Endpoint não encontrado.' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Night City Eddies API rodando em http://localhost:${PORT}`);
});
