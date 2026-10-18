CREATE EXTENSION IF NOT EXISTS pgcrypto;

create table categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_cadastro TIMESTAMPTZ NOT NULL DEFAULT now(),
    data_alteracao TIMESTAMPTZ NOT NULL DEFAULT now()
);

create table usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    identificacao VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    telefone VARCHAR(11) NOT NULL,
    senha_hash TEXT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    data_cadastro TIMESTAMPTZ NOT NULL DEFAULT now(),
    data_alteracao TIMESTAMPTZ NOT NULL DEFAULT now()
);

create table profissionais (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id BIGINT NOT NULL,
    localizacao GEOGRAPHY(POINT, 4326),
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
    data_cadastro TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT uq_profissional_categoria
    UNIQUE (profissional_id, categoria_id)
);

create table pedidos(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id BIGINT NOT NULL,
    servico_id BIGINT NOT NULL,
    localizacao GEOGRAPHY(POINT, 4326),
    status status_pedido DEFAULT 'pendente' NOT NULL,
    data_agendamento TIMESTAMP NOT NULL,
    data_cadastro TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_pedidos_usuarios FOREIGN KEY (usuarios_id)
    REFERENCES usuarios(id)
    ON DELETE RESTRICT,

    CONSTRAINT fk_pedidos_servicos FOREIGN KEY (servico_id)
    REFERENCES servicos_oferecidos(id)
    ON DELETE RESTRICT
);

CREATE INDEX idx_usuarios_localizacao
ON usuarios
USING GIST(localizacao);