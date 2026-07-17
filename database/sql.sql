-- Cria a tabela de mensagens usada pelo backend PHP.
-- Cria a tabela de mensagens usada pelo backend. `id` é auto-increment.
CREATE TABLE mensagens (
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome varchar(50),
    email varchar(100),
    comentario varchar(500)
);
