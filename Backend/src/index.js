/* npm init
   npm install mysql
   npm install express
   npm install cors
*/

const express = require('express')
const cors = require('cors')
const db = require('./config/database')

const app = express()

//Middleware JSON
app.use(express.json())

//Middleware CORS
app.use(cors())

// Rotas
app.get('/produtos/cardapio', function (request, response) {
  let ssql = 'SELECT  c.descricao as categoria , p.* '
  ssql += 'FROM produto p '
  ssql += 'join produto_categoria c on (c.id_categoria = p.id_categoria) '
  ssql += 'ORDER BY c.ordem '

  db.query(ssql, function (err, result) {
    if (err) {
      return response.status(500).send(err)
    } else {
      return response.status(200).json(result)
    }
  })
})

app.post('/pedidos', function (request, response) {
  db.beginTransaction(function (err) {
    let ssql =
      'insert into pedido(id_usuario, dt_pedido,vl_subtotal, vl_entrega, vl_total, status)'
    ssql += "values(?, current_timestamp(), ?, ?, ?, 'A') "

    db.query(
      ssql,
      [
        request.body.id_usuario,
        request.body.vl_subtotal,
        request.body.vl_entrega,
        request.body.vl_total
      ],
      function (err, result) {
        if (err) {
          db.rollback()
          response.status(500).json(err)
        } else {
          var id_pedido = result.insertId

          if (id_pedido > 0) {
            const itens = request.body.itens
            var values = []

            for (var i = 0; i < itens.length; i++) {
              values.push([
                id_pedido,
                itens[i].id_produto,
                itens[i].qtd,
                itens[i].vl_unitario,
                itens[i].vl_total
              ])
            }

            ssql =
              'insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total) '
            ssql += 'values ?'

            db.query(ssql, [values], function (err, result) {
              if (err) {
                db.rollback()
                response.status(500).json(err)
              } else {
                db.commit()
                response.status(201).json({ id_pedido: id_pedido })
              }
            })
          }
        }
      }
    )
  })
})

app.get('/pedidos', function (request, response) {
  let ssql =
    "SELECT p.id_pedido, p.status, DATE_FORMAT(p.dt_pedido, '%d/%m/%Y %H:%i:%s') as dt_pedido , p.vl_total, COUNT(*) "
  ssql += 'FROM pedido p '
  ssql += 'join pedido_item i on (i.id_pedido = p.id_pedido) '
  ssql += 'GROUP BY p.id_pedido, p.status, p.dt_pedido, p.vl_total '

  db.query(ssql, function (err, result) {
    if (err) {
      return response.status(500).send(err)
    } else {
      return response.status(200).json(result)
    }
  })
})

app.get('/pedidos/itens', function (request, response) {
  let ssql =
    "SELECT p.id_pedido, p.status, DATE_FORMAT(p.dt_pedido, '%d/%m/%Y %H:%i:%s') as dt_pedido, "
  ssql +=
    'u.nome as nome_usuario , u.endereco, i.id_item, o.nome, 0.url_foto, i.qtd '
  ssql += 'FROM pedido p '
  ssql += 'join usuario u on (u.id_usuario = p.id_usuario) '
  ssql += 'join pedido_item i on (i.id_pedido = p.id_pedido) '
  ssql += 'join produto o on (o.id_produto = i.id_produto) '
  ssql += 'order by p.dt_pedido '

  db.query(ssql, function (err, result) {
    if (err) {
      return response.status(500).send(err)
    } else {
      let id_pedidos = []
      let pedidos = []
      let itens = []

      result.map(function (ped) {
        if (id_pedidos.indexOf(ped.id_pedido) < 0) {
          id_pedidos.push(ped.id_pedido)

          pedidos.push({
            id_pedido: ped.id_pedido,
            dt_pedido: ped.dt_pedido,
            status: ped.status,
            nome: ped.nome_usuario,
            endereco: ped.endereco,
            itens: []
          })
        }
      })

      pedidos.map(ped => {
        itens = []
        result.map(pedResult => {
          if (pedResult.id_pedido == ped.id_pedido) {
            itens.push({
              id_item: pedResult.id_item,
              nome: pedResult.nome,
              url_foto: pedResult.url_foto,
              qtd: pedResult.qtd
            })
          }
        })

        ped.itens = itens
      })

      return response.status(200).json(pedidos)
    }
  })
})

app.put('/pedidos/status/:id_pedido', function (request, response) {
  let ssql = 'update pedido set status = ? where id_pedido = ? '

  db.query(
    ssql,
    [request.body.status, request.params.id_pedido],
    function (err, result) {
      if (err) {
        return response.status(500).send(err)
      } else {
        return response
          .status(200)
          .json({ id_pedido: request.params.id_pedido })
      }
    }
  )
})

app.get('/configs', function (request, response) {
  let ssql = 'SELECT * FROM config '

  db.query(ssql, function (err, result) {
    if (err) {
      return response.status(500).send(err)
    } else {
      return response.status(200).json(result[0])
    }
  })
})

app.listen(3000, function () {
  console.log('Servidor no ar na porta 3000')
})

// node src/index.js
