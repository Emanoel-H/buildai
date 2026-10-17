CREATE EXTENSION IF NOT EXISTS pgcrypto;

create table categorias (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

create table usuarios (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    IDENTIFICACAO VARCHAR(20) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    telefone VARCHAR(11) NOT NULL,
    senha TEXT NOT NULL,
    localizacao GEOGRAPHY(POINT, 4326),
    data_cadastro TIMESTAMP DEFAULT NOW(),
    data_alteracao timestamp(6) NULL
);

create table profissionais (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    raio_atendimento_km DECIMAL(5,2) NOT NULL,

    CONSTRAINT fk_usuarios_profissionais FOREIGN KEY (usuario_id)
	REFERENCES usuarios(id)
	ON DELETE CASCADE,

    CONSTRAINT uq_usuario
    UNIQUE (usuario_id)
);