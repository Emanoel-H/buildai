CREATE EXTENSION IF NOT EXISTS pgcrypto;

create table categorias (
                                    id BIGSERIAL PRIMARY KEY,
                                    codigo VARCHAR(10) NOT NULL,
                                    nome VARCHAR(100) NOT NULL,
                                    descricao TEXT
);