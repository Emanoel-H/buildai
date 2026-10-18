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
    codigo VARCHAR(10) NOT NULL,
    profissional_id BIGINT NOT NULL,
    categoria_id BIGINT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_servicos_profissionais FOREIGN KEY (profissional_id)
    REFERENCES profissionais(id)
    ON DELETE CASCADE,

    CONSTRAINT fk_servicos_categorias FOREIGN KEY (categoria_id)
    REFERENCES categorias(id)
    ON DELETE CASCADE,

    CONSTRAINT uq_profissional_categoria
    UNIQUE (profissional_id, categoria_id)
);

CREATE INDEX idx_usuarios_localizacao
ON usuarios
USING GIST(localizacao);

CREATE OR REPLACE FUNCTION generate_code()
RETURNS TRIGGER AS $$
BEGIN
    NEW.codigo := to_char(CURRENT_DATE, 'YYMMDD') || lpad(floor(random() * 10000)::text, 4, '0');
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_generate_usuarios_code
BEFORE INSERT ON usuarios
FOR EACH ROW
EXECUTE FUNCTION generate_code();

CREATE TRIGGER trg_generate_servicos_oferecidos_code
BEFORE INSERT ON servicos_oferecidos
FOR EACH ROW
EXECUTE FUNCTION generate_code();

CREATE TRIGGER trg_generate_categorias_code
BEFORE INSERT ON categorias
FOR EACH ROW
EXECUTE FUNCTION generate_code();