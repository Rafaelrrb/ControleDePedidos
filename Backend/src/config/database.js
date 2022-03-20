const mysql = require('mysql')
const db = mysql.createConnection({
  host: 'localhost',
  user: 'admin',
  password: 'the_password_you_wish_here',
  database: 'cardapio'
})

db.connect(function (err) {
  if (err) {
    console.log('Erro ao conectar com o banco:', err.message)
  }
})

module.exports = db

// npm install nodemon -g     pra atualizar altomatico quando ouver mudanças

// agora para executar se usa nodemon src/index.js
