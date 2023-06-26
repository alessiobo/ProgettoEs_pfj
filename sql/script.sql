-- CREAZIONE TABELLA

CREATE TABLE autori (
    id INT PRIMARY KEY,
    nome VARCHAR(50),
    cognome VARCHAR(50),
    anno_nascita INT,
    anno_morte INT,
    sesso CHAR(1),
    nazione VARCHAR(50)
);

-- INSERIMENTO VALORI

INSERT INTO autori (id, nome, cognome, anno_nascita, anno_morte, sesso, nazione)
VALUES
    (1, 'Alessandro', 'Manzoni', 1785, 1873, 'M', 'ITA'),
    (2, 'Lev', 'Tolstoi', 1828, 1910, 'M', 'RUS'),
    (3, 'Bruno', 'Vespa', 1944, NULL, 'M', 'ITA'),
    (4, 'Stephen', 'King', 1947, NULL, 'M', 'USA'),
    (5, 'Ernest', 'Hemingway', 1899, 1961, 'M', 'USA'),
    (6, 'Umberto', 'Eco', 1932, 2016, 'M', 'ITA'),
    (7, 'Agatha', 'Christie', 1890, 1976, 'F', 'ENG'),
    (8, 'Virginia', 'Woolf', 1882, 1941, 'F', 'ENG');


-- FUNZIONE

DELIMITER //

CREATE FUNCTION get_age_by_autore(
    autore_nome_param VARCHAR(50),
    autore_cognome_param VARCHAR(50)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE autore_id INT;
    DECLARE autore_anno_nascita INT;
    DECLARE autore_anno_morte INT;
    DECLARE autore_eta INT;

    SELECT id, anno_nascita, anno_morte INTO autore_id, autore_anno_nascita, autore_anno_morte
    FROM autori
    WHERE nome = autore_nome_param AND cognome = autore_cognome_param
    LIMIT 1;

    IF autore_id IS NOT NULL THEN
        IF autore_anno_morte IS NULL THEN
            SET autore_eta = YEAR(CURDATE()) - autore_anno_nascita;
        ELSE
            SET autore_eta = autore_anno_morte - autore_anno_nascita;
        END IF;
    ELSE
        SET autore_eta = NULL;
    END IF;

    RETURN autore_eta;
END //

DELIMITER ;


-- PROCEDURA

DELIMITER //

CREATE PROCEDURE get_age_autori_nazione(IN nazione_param VARCHAR(50))
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = 'autori_eta_temp' AND table_schema = DATABASE()
    ) THEN
        DROP TABLE autori_eta_temp;
    END IF;

    CREATE TABLE autori_eta_temp (
        nome VARCHAR(50),
        cognome VARCHAR(50),
        eta INT
    );

    INSERT INTO autori_eta_temp (nome, cognome, eta)
    SELECT nome, cognome, get_age_by_autore(nome, cognome)
    FROM autori
    WHERE nazione = nazione_param;

    SELECT nome, cognome, eta
    FROM autori_eta_temp;
END //

DELIMITER ;



-- PROCEDURA

DELIMITER //

CREATE PROCEDURE get_age_autori_nazione(IN nazione_param VARCHAR(50))
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = 'autori_eta_temp' AND table_schema = DATABASE()
    ) THEN
        DROP TABLE autori_eta_temp;
    END IF;

    CREATE TABLE autori_eta_temp (
        nome VARCHAR(50),
        cognome VARCHAR(50),
        eta INT
    );

    INSERT INTO autori_eta_temp (nome, cognome, eta)
    SELECT nome, cognome, get_age_by_autore(nome, cognome)
    FROM autori
    WHERE nazione = nazione_param;

    SELECT nome, cognome, eta
    FROM autori_eta_temp;
END //

DELIMITER ;
