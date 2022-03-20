delete from pedido_item;
delete from pedido;
delete from produto;


insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(1, 'X-Salada Picanha', 'Pão,hamburguer de picanha 150 g,queijo prato, alface, tomate, maionese hamburguinho.', 33.80,  
'https://jornada-dev2.s3.amazonaws.com/xsalada.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(1, 'Cheese Steak', 'Rosbife 120g, cheddar e cebola frita, servido no pão de queijo.', 35,  
'https://jornada-dev2.s3.amazonaws.com/xespaco_fama.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(1, 'X-Tudo', 'Pão, hambúrguer de carne angus, alface, tomate e queijo prato.', 33.90,  
'https://jornada-dev2.s3.amazonaws.com/xtudo.png');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(2, 'X-Egg', 'Pão, hambúrguer de carne angus, queijo prato e ovo.', 24.90,  
'https://jornada-dev2.s3.amazonaws.com/xegg.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(2, 'X-Bacon', 'Pão, hambúrguer de carne angus, queijo prato e bacon.', 27.90,  
'https://jornada-dev2.s3.amazonaws.com/xbacon.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(2, 'X-Filé Frango', 'Pão, filet de frango e queijo prato.', 25.60,  
'https://jornada-dev2.s3.amazonaws.com/x-frango-egg.png');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(2, 'X-Cebola Maionese', 'Pão, hambúrguer de 150g (angus), queijo prato, cebola frita e maionese artesanal.', 28.90,  
'https://jornada-dev2.s3.amazonaws.com/xcebola.png');

/*-------------------*/

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(3, 'Hot Dog Tradicional', 'Pão de Hot Dog, 1 Salsicha, Ketchup, Maionese, Mostarda e Batata Palha', 14.50,  
'https://jornada-dev2.s3.amazonaws.com/dog1.png');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(3, 'Hot Dog Soja', 'Salsicha de soja, requeijão, oregano, cheddar, vinagrete, milho, maionese, batata palha, pure e parmesão (vegetariano ou vegano)', 28.00,  
'https://jornada-dev2.s3.amazonaws.com/dog2.png');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(3, 'Hot Dogão', 'Quatro salsichas, requeijão, oregano, cheddar, vinagrete, milho, maionese, batata palha, pure e parmesão', 31.00,  
'https://jornada-dev2.s3.amazonaws.com/dog3.png');

/*-------------------*/

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(4, 'Coca-Cola Lata', 'Refrigerante Coca-Cola lata 350ml', 6.00,  
'https://jornada-dev2.s3.amazonaws.com/coca-cola.png');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(4, 'Água mineral', 'Água mineral 330ml', 4.00,  
'https://jornada-dev2.s3.amazonaws.com/agua.png');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(4, 'Schweppes', 'Schweppes citrus 350ml', 6.00,  
'https://jornada-dev2.s3.amazonaws.com/Schweppes.png');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(4, 'Sprite Lemon', 'Sprite Lemon fresh 500ml', 8.90,  
'https://jornada-dev2.s3.amazonaws.com/sprite.png');


insert into pedido(id_usuario, dt_pedido, vl_subtotal, vl_entrega, vl_total, status)
values(1, current_timestamp(), 85.60, 4.00, 89.60, 'A');

insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total) values(2, 17, 2, 33.80, 67.60);

insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total) values(2, 15, 2, 33.80, 67.60);



