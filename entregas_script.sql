-- Modelo Físico (MySQL) — Sistema de Entregas
-- Script de criação das tabelas. Ajuste tipos e constraints conforme o seu SGBD (MySQL/MariaDB/Postgres).

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS item_pedido;
DROP TABLE IF EXISTS entrega;
DROP TABLE IF EXISTS pagamento;
DROP TABLE IF EXISTS pedido;
DROP TABLE IF EXISTS veiculo;
DROP TABLE IF EXISTS produto;
DROP TABLE IF EXISTS rota;
DROP TABLE IF EXISTS endereco;
DROP TABLE IF EXISTS entregador;
DROP TABLE IF EXISTS cliente;

SET FOREIGN_KEY_CHECKS = 1;

-- Tabela CLIENTE
CREATE TABLE cliente (
  cliente_id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE,
  telefone VARCHAR(20)
) ENGINE=InnoDB;

-- Tabela ENDERECO
CREATE TABLE endereco (
  endereco_id INT AUTO_INCREMENT PRIMARY KEY,
  rua VARCHAR(120),
  numero VARCHAR(10),
  complemento VARCHAR(50),
  bairro VARCHAR(80),
  cidade VARCHAR(80),
  estado CHAR(2),
  cep VARCHAR(10),
  cliente_id INT NOT NULL,
  CONSTRAINT fk_endereco_cliente FOREIGN KEY (cliente_id)
    REFERENCES cliente(cliente_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabela PRODUTO
CREATE TABLE produto (
  produto_id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120),
  descricao TEXT,
  peso DECIMAL(10,2),
  preco DECIMAL(10,2)
) ENGINE=InnoDB;

-- Tabela ENTREGADOR
CREATE TABLE entregador (
  entregador_id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  telefone VARCHAR(20),
  cpf VARCHAR(14) UNIQUE
) ENGINE=InnoDB;

-- Tabela VEICULO
CREATE TABLE veiculo (
  veiculo_id INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10) UNIQUE,
  modelo VARCHAR(80),
  capacidade_kg DECIMAL(10,2),
  entregador_id INT,
  CONSTRAINT fk_veiculo_entregador FOREIGN KEY (entregador_id)
    REFERENCES entregador(entregador_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- Tabela ROTA
CREATE TABLE rota (
  rota_id INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(120),
  origem VARCHAR(120),
  destino VARCHAR(120)
) ENGINE=InnoDB;

-- Tabela PEDIDO
CREATE TABLE pedido (
  pedido_id INT AUTO_INCREMENT PRIMARY KEY,
  data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
  valor_total DECIMAL(10,2),
  status_pedido VARCHAR(20),
  cliente_id INT NOT NULL,
  endereco_entrega_id INT,
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id)
    REFERENCES cliente(cliente_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_pedido_endereco FOREIGN KEY (endereco_entrega_id)
    REFERENCES endereco(endereco_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- Tabela ENTREGA
CREATE TABLE entrega (
  entrega_id INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL UNIQUE,
  entregador_id INT,
  veiculo_id INT,
  rota_id INT,
  data_saida DATETIME,
  data_entrega_prevista DATETIME,
  data_entrega_real DATETIME,
  status_entrega VARCHAR(20),
  observacoes TEXT,
  CONSTRAINT fk_entrega_pedido FOREIGN KEY (pedido_id)
    REFERENCES pedido(pedido_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_entrega_entregador FOREIGN KEY (entregador_id)
    REFERENCES entregador(entregador_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,
  CONSTRAINT fk_entrega_veiculo FOREIGN KEY (veiculo_id)
    REFERENCES veiculo(veiculo_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,
  CONSTRAINT fk_entrega_rota FOREIGN KEY (rota_id)
    REFERENCES rota(rota_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- Tabela PAGAMENTO
CREATE TABLE pagamento (
  pagamento_id INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL UNIQUE,
  data_pagamento DATETIME,
  valor_pago DECIMAL(10,2),
  metodo_pagamento VARCHAR(30),
  status_pagamento VARCHAR(20),
  CONSTRAINT fk_pagamento_pedido FOREIGN KEY (pedido_id)
    REFERENCES pedido(pedido_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- Tabela ITEM_PEDIDO
CREATE TABLE item_pedido (
  item_pedido_id INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL,
  produto_id INT NOT NULL,
  quantidade INT NOT NULL DEFAULT 1,
  preco_unitario DECIMAL(10,2),
  CONSTRAINT fk_itempedido_pedido FOREIGN KEY (pedido_id)
    REFERENCES pedido(pedido_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_itempedido_produto FOREIGN KEY (produto_id)
    REFERENCES produto(produto_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Índices auxiliares (opcionais)
CREATE INDEX idx_pedido_cliente ON pedido(cliente_id);
CREATE INDEX idx_endereco_cliente ON endereco(cliente_id);
CREATE INDEX idx_itempedido_pedido ON item_pedido(pedido_id);

-- Fim do script
