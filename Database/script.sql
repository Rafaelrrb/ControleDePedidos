create database cardapio 
default character set utf8
default collate utf8_general_ci;

/*-------------------------------------------------------------*/

create table config(
	vl_entrega decimal(5, 2)
) default charset = utf8;

create table usuario(
	id_usuario int not null auto_increment,
	nome varchar(100),
    email varchar(100),
    senha varchar(50),
    endereco varchar(100),
    bairro varchar(50),
    cidade varchar(50),
    uf varchar(2),
    cep varchar(10),
    dt_cadastro datetime,
    
    primary key(id_usuario)
) default charset = utf8;

create table produto_categoria(
	id_categoria int not null auto_increment,
    descricao varchar(100),
    ordem tinyint,
    	
    primary key(id_categoria)
) default charset = utf8;

create table produto(
	id_produto int not null auto_increment,
    id_categoria int not null,
	nome varchar(100),    
    descricao varchar(1000),    
    preco decimal(9, 2),
    url_foto varchar(1000),
    	
    primary key(id_produto),
    foreign key(id_categoria) references produto_categoria(id_categoria)
) default charset = utf8;


create table pedido(
	id_pedido int not null auto_increment,    
    id_usuario int not null,	    
    dt_pedido datetime,
    vl_subtotal decimal(9,2),
    vl_entrega decimal(5, 2),
    vl_total decimal(9,2),
    status char(1), /* A (Aguardando), P (Em Produção), E (Saiu Entrega), F (Finalizado)  */
    	
    primary key(id_pedido),    
    foreign key(id_usuario) references usuario(id_usuario)
) default charset = utf8;

create table pedido_item(
	id_item int not null auto_increment,
    id_pedido int not null,
    id_produto int not null,
    qtd decimal(9,3),
    vl_unitario decimal(9,2),
    vl_total decimal(9,2),
    
    primary key(id_item),
    foreign key(id_pedido) references pedido(id_pedido),
    foreign key(id_produto) references produto(id_produto)
) default charset = utf8;


/*-------------------------------------------------------------*/

insert into config(vl_entrega) values(4.00);

insert into usuario(nome, email, senha, endereco, bairro, cidade, uf, cep, dt_cadastro)
values('Heber Mazutti', 'heber@teste.com.br', '123', 'Rua São Bento, 850', 'Centro', 'São Paulo', 'SP', '02410-010', current_timestamp());

insert into produto_categoria(descricao, ordem) values('Ofertas', 1);
insert into produto_categoria(descricao, ordem) values('Burgers', 2);
insert into produto_categoria(descricao, ordem) values('Dogs', 3);
insert into produto_categoria(descricao, ordem) values('Bebidas', 4);


insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(1, 'X-Salada Picanha', 'Pão,hamburguer de picanha 150 g,queijo prato, alface, tomate, maionese hamburguinho.', 33.80,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/95f6be76-f09e-4d21-bdb6-4420b94e95cc/201910151403_Rgiv_h.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(1, 'Cheese Steak', 'Rosbife 120g, cheddar e cebola frita, servido no pão de queijo.', 35,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/6662320c-1cf1-4deb-8c58-e749526bd34e/201801051234_25999151.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(1, 'X-Burguer', 'Pão, hambúrguer de carne angus e queijo prato.', 21.70,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/95f6be76-f09e-4d21-bdb6-4420b94e95cc/201909201848_bUJH_.jpeg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(2, 'X-Egg', 'Pão, hambúrguer de carne angus, queijo prato e ovo.', 24.90,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/95f6be76-f09e-4d21-bdb6-4420b94e95cc/201909201848_tn67_.jpeg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(2, 'X-Bacon', 'Pão, hambúrguer de carne angus, queijo prato e bacon.', 27.90,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/95f6be76-f09e-4d21-bdb6-4420b94e95cc/201909201848_BLHp_.jpeg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(2, 'X-Filé Frango', 'Pão, filet de frango e queijo prato.', 25.60,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/afeef31a-10d0-4e4e-b9cc-1fc0d13a690b/202107241944_1DU7_i.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(2, 'X-Cebola Maionese', 'Pão, hambúrguer de 150g (angus), queijo prato, cebola frita e maionese artesanal.', 28.90,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/afeef31a-10d0-4e4e-b9cc-1fc0d13a690b/202106212018_G2V5_i.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(3, 'Hot Dog Tradicional', 'Pão de Hot Dog, 1 Salsicha, Ketchup, Maionese, Mostarda e Batata Palha', 14.50,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/900a5bab-f13e-4b24-9d5d-ed7b7c3d02d6/202202251323_TGR8_i.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(3, 'Hot Dog Soja', 'Salsicha de soja, requeijão, oregano, cheddar, vinagrete, milho, maionese, batata palha, pure e parmesão (vegetariano ou vegano)', 28.00,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/f83739c1-9ab8-4ce0-a0a0-8891ef7d1441/202010162138_2GDU_.jpeg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(3, 'Hot Dogão', 'Quatro salsichas, requeijão, oregano, cheddar, vinagrete, milho, maionese, batata palha, pure e parmesão', 31.00,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/f83739c1-9ab8-4ce0-a0a0-8891ef7d1441/202203041656_VIM7_i.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(4, 'Coca-Cola Lata', 'Refrigerante Coca-Cola lata 350ml', 6.00,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/49e47d63-261c-40e3-8aaa-c7394c8bd52d/202106101838_7X5C_i.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(4, 'Água mineral', 'Água mineral 330ml', 4.00,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/49e47d63-261c-40e3-8aaa-c7394c8bd52d/202110051245_8FA8_i.jpg');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(4, 'Schweppes', 'Schweppes citrus 350ml', 6.00,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/02802197-f7f6-4024-886d-140ba81e4d71/202007181050_7sIi_.jfif');

insert into produto(id_categoria, nome, descricao, preco, url_foto)
values(4, 'Sprite Lemon', 'Sprite Lemon fresh 500ml', 8.90,  
'https://static-images.ifood.com.br/image/upload/t_medium/pratos/02802197-f7f6-4024-886d-140ba81e4d71/202006061837_0mL7_4.jpg');


insert into pedido(id_usuario, dt_pedido, vl_subtotal, vl_entrega, vl_total, status)
values(1, current_timestamp(), 85.60, 4.00, 89.60, 'A');

insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total) values(1, 1, 2, 33.80, 67.60);
insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total) values(1, 11, 3, 6.00, 18.00);


/*----------------------------------------------------------*/

ALTER USER 'admin'@'localhost' IDENTIFIED WITH mysql_native_password BY 'the_password_you_wish_here';

flush privileges;






