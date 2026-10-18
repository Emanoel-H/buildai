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
    usuario_id UUID PRIMARY KEY REFERENCES usuarios(id),
    localizacao GEOGRAPHY(POINT, 4326),
    raio_atendimento_km DECIMAL(5,2) NOT NULL,

    CONSTRAINT fk_usuarios_profissionais FOREIGN KEY (usuario_id)
	REFERENCES usuarios(id)
	ON DELETE CASCADE
);

create table servicos_oferecidos(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profissional_id UUID NOT NULL,
    categoria_id UUID NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    preco_negociavel BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    data_cadastro TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_servicos_oferecidos_usuarios FOREIGN KEY (profissional_id)
    REFERENCES usuarios(id)
    ON DELETE NO ACTION,

    CONSTRAINT fk_servicos_oferecidos_categorias FOREIGN KEY (categoria_id)
    REFERENCES categorias(id)
    ON DELETE NO ACTION,

    CONSTRAINT uq_profissional_categoria
    UNIQUE (profissional_id, categoria_id)
);

create table pedidos(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id BIGINT NOT NULL,
    servico_id BIGINT NOT NULL,
    localizacao GEOGRAPHY(POINT, 4326),
    preco_pedido DECIMAL(10,2) NOT NULL,
    status_pedido DEFAULT 'pendente' NOT NULL,
    data_agendamento TIMESTAMP NOT NULL,
    data_cadastro TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_pedidos_usuarios FOREIGN KEY (cliente_id)
    REFERENCES usuarios(id)
    ON DELETE RESTRICT,

    CONSTRAINT fk_pedidos_servicos FOREIGN KEY (servico_id)
    REFERENCES servicos_oferecidos(id)
    ON DELETE RESTRICT
);

CREATE INDEX idx_profissionais_localizacao
ON profissionais
USING GIST(localizacao);

CREATE INDEX idx_servicos_oferecidos_categorias
ON servicos_oferecidos (categoria_id);