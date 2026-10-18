CREATE EXTENSION IF NOT EXISTS pgcrypto;

create table categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

create table usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    IDENTIFICACAO VARCHAR(20) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    telefone VARCHAR(11) NOT NULL,
    senha TEXT NOT NULL,
    localizacao GEOGRAPHY(POINT, 4326),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT NOW(),
    data_alteracao timestamp(6) NULL
);

create table profissionais (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id BIGINT NOT NULL,
    raio_atendimento_km DECIMAL(5,2) NOT NULL,

    CONSTRAINT fk_usuarios_profissionais FOREIGN KEY (usuario_id)
	REFERENCES usuarios(id)
	ON DELETE CASCADE,

    CONSTRAINT uq_usuario
    UNIQUE (usuario_id)
);

create table servicos_oferecidos(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profissional_id BIGINT NOT NULL,
    categoria_id BIGINT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT NOW(),

    CONSTRAINT uq_profissional_categoria
    UNIQUE (profissional_id, categoria_id)
);

CREATE INDEX idx_usuarios_localizacao
ON usuarios
USING GIST(localizacao);