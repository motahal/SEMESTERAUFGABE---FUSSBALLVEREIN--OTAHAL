---------------------------------------------------------------------------------------------------------
-- Es gab ein Fehler beim erstellen der INSERTS bzw beim Laden der INSERTS in die Datenbank des SQL Files
---------------------------------------------------------------------------------------------------------

--df fncountries: word=countries
--df fnposition: word=position
--df fnort: word=ort
--df fngeschlecht: word=geschlecht

CREATE TABLE person (
 persnr SERIAL NOT NULL,
 vname VARCHAR(20) NOT NULL,
 nname VARCHAR(20) NOT NULL,
 geschlecht VARCHAR(255) NOT NULL,--df: use=fngeschlecht
 gebdat DATE NOT NULL-- df: start=1923-01-01 end=2015-01-01
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (persnr);


CREATE TABLE spieler (
 persnr SERIAL NOT NULL,
 position VARCHAR(255) NOT NULL,--df: use=fnposition
 gehalt FLOAT(20) NOT NULL,--df: alpha=3000 beta=5
 von DATE NOT NULL,-- df: start=1923-01-01 end=2015-01-01
 bis DATE NOT NULL,-- df: start=1923-01-01 end=2015-01-01
 ueberstunden FLOAT(20) NOT NULL,--df: alpha=10 beta=5
 e_mail VARCHAR(255) NOT NULL-- df: pattern='[a-z]{3,8}\.[a-z]{3,8}@(gmail|yahoo)\.com'
);

ALTER TABLE spieler ADD CONSTRAINT PK_spieler PRIMARY KEY (persnr);


CREATE TABLE standort (
 sid INT NOT NULL,
 land VARCHAR(255) NOT NULL,--df: use=fncountries
 plz INT NOT NULL,-- df: offset=10000 size=100000
 ort VARCHAR(255) NOT NULL--df: use=fnort
);

ALTER TABLE standort ADD CONSTRAINT PK_standort PRIMARY KEY (sid);


CREATE TABLE trainer (
 persnr SERIAL NOT NULL,
 gehalt FLOAT(20) NOT NULL,--df: alpha=3000 beta=5
 von DATE NOT NULL,-- df: start=1923-01-01 end=2015-01-01 
 bis DATE NOT NULL,-- df: start=1923-01-01 end=2015-01-01
 ueberstunden FLOAT(20) NOT NULL,--df: alpha=10 beta=5
 e_mail VARCHAR(255) NOT NULL-- df: pattern='[a-z]{3,8}\.[a-z]{3,8}@(gmail|yahoo)\.com'
);

ALTER TABLE trainer ADD CONSTRAINT PK_trainer PRIMARY KEY (persnr);


CREATE TABLE angestellter (
 persnr SERIAL NOT NULL,
 gehalt FLOAT(20) NOT NULL,--df: alpha=3000 beta=5
 ueberstunden FLOAT(20) NOT NULL,--df: alpha=10 beta=5
 e_mail VARCHAR(255) NOT NULL-- df: pattern='[a-z]{3,8}\.[a-z]{3,8}@(gmail|yahoo)\.com'
);

ALTER TABLE angestellter ADD CONSTRAINT PK_angestellter PRIMARY KEY (persnr);


CREATE TABLE mannschaft (
 bezeichnung VARCHAR(20) NOT NULL,
 ist_chef SERIAL NOT NULL,
 ist_assistent SERIAL NOT NULL,
 klasse VARCHAR(20) NOT NULL,
 naechstes_spiel DATE NOT NULL-- df: start=1923-01-01 end=2015-01-01
 CHECK (ist_chef != ist_assistent)
);
create function valid_mannschaft(INT, INT) returns boolean as
 	'select (($1 not in (select ist_assistent from mannschaft where
 	ist_assistent=$1)) and ($2 not in (select ist_assistent from mannschaft
 	where ist_assistent=$2)) and ($1 not in (select ist_chef from mannschaft
 	where ist_chef=$1)) and ($2 not in (select ist_chef from mannschaft where
 	ist_chef=$2)))'
 	LANGUAGE SQL;

ALTER TABLE mannschaft ADD CONSTRAINT chef_assistent_ok CHECK(valid_mannschaft(ist_chef, ist_assistent));


CREATE TABLE mitglied (
 persnr SERIAL NOT NULL,
 beitrag VARCHAR(20) NOT NULL,
 gehalt FLOAT(20) NOT NULL,--df: alpha=3000 beta=5
 ueberstunden FLOAT(20) NOT NULL,--df: alpha=10 beta=5
 e_mail VARCHAR(255) NOT NULL-- df: pattern='[a-z]{3,8}\.[a-z]{3,8}@(gmail|yahoo)\.com'
);

ALTER TABLE mitglied ADD CONSTRAINT PK_mitglied PRIMARY KEY (persnr);


CREATE TABLE spiel (
 datum DATE NOT NULL,-- df: start=1923-01-01 end=2015-01-01
 mannschaft VARCHAR(20) NOT NULL REFERENCES mannschaft(bezeichnung), 
 gegner VARCHAR(20) NOT NULL,
 ergebnis VARCHAR(20) NOT NULL
);

ALTER TABLE spiel ADD CONSTRAINT PK_spiel PRIMARY KEY (datum,bezeichnung,ist_chef,ist_assistent);


CREATE TABLE spieldauer (
 persnr SERIAL NOT NULL,
 datum DATE NOT NULL,-- df: start=1923-01-01 end=2015-01-01
 bezeichnung VARCHAR(20) NOT NULL,
 ist_chef SERIAL NOT NULL,
 dauer FLOAT(10) NOT NULL --df: alpha=10 beta=4
);

ALTER TABLE spieldauer ADD CONSTRAINT PK_spieldauer PRIMARY KEY (persnr,datum,bezeichnung,ist_chef);


CREATE TABLE spielnummer (
 bezeichnung VARCHAR(20) NOT NULL,
 persnr SERIAL NOT NULL,
 ist_assistent SERIAL NOT NULL,
 nummer INT NOT NULL-- df: offset=1 size=99
);

ALTER TABLE spielnummer ADD CONSTRAINT PK_spielnummer PRIMARY KEY (bezeichnung,persnr,ist_assistent);


CREATE TABLE fanclub (
 name CHAR(10) NOT NULL,
 obmann SERIAL NOT NULL,
 gegruendet DATE NOT NULL,-- df: start=1923-01-01 end=2015-01-01
 sid INT NOT NULL
);

ALTER TABLE fanclub ADD CONSTRAINT PK_fanclub PRIMARY KEY (name,obmann);


CREATE TABLE ist_kapitaen (
 persnr SERIAL NOT NULL,
 bezeichnung VARCHAR(20) NOT NULL,
 ist_chef SERIAL NOT NULL
);

ALTER TABLE ist_kapitaen ADD CONSTRAINT PK_ist_kapitaen PRIMARY KEY (persnr,bezeichnung,ist_chef);


CREATE TABLE betreut (
 name CHAR(10) NOT NULL,
 obmann SERIAL NOT NULL,
 anfang DATE NOT NULL,-- df: start=1923-01-01 end=2015-01-01
 ende DATE NOT NULL-- df: start=1923-01-01 end=2015-01-01
);

ALTER TABLE betreut ADD CONSTRAINT PK_betreut PRIMARY KEY (name,obmann);


ALTER TABLE spieler ADD CONSTRAINT FK_spieler_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE trainer ADD CONSTRAINT FK_trainer_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE angestellter ADD CONSTRAINT FK_angestellter_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE mannschaft ADD CONSTRAINT FK_mannschaft_0 FOREIGN KEY (ist_chef) REFERENCES trainer (persnr);
ALTER TABLE mannschaft ADD CONSTRAINT FK_mannschaft_1 FOREIGN KEY (ist_assistent) REFERENCES trainer (persnr);


ALTER TABLE mitglied ADD CONSTRAINT FK_mitglied_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE spiel ADD CONSTRAINT FK_spiel_0 FOREIGN KEY (mannschaft) REFERENCES mannschaft (bezeichnung);


ALTER TABLE spieldauer ADD CONSTRAINT FK_spieldauer_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE spieldauer ADD CONSTRAINT FK_spieldauer_1 FOREIGN KEY (datum,bezeichnung,ist_chef,persnr) REFERENCES spiel (datum,bezeichnung,ist_chef,ist_assistent);


ALTER TABLE spielnummer ADD CONSTRAINT FK_spielnummer_0 FOREIGN KEY (bezeichnung,persnr,ist_assistent) REFERENCES mannschaft (bezeichnung,ist_chef,ist_assistent);
ALTER TABLE spielnummer ADD CONSTRAINT FK_spielnummer_1 FOREIGN KEY (persnr) REFERENCES spieler (persnr);


ALTER TABLE fanclub ADD CONSTRAINT FK_fanclub_0 FOREIGN KEY (obmann) REFERENCES mitglied (persnr);
ALTER TABLE fanclub ADD CONSTRAINT FK_fanclub_1 FOREIGN KEY (sid) REFERENCES standort (sid);


ALTER TABLE ist_kapitaen ADD CONSTRAINT FK_ist_kapitaen_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE ist_kapitaen ADD CONSTRAINT FK_ist_kapitaen_1 FOREIGN KEY (bezeichnung,ist_chef,persnr) REFERENCES mannschaft (bezeichnung,ist_chef,ist_assistent);


ALTER TABLE betreut ADD CONSTRAINT FK_betreut_0 FOREIGN KEY (name,obmann) REFERENCES fanclub (name,obmann);
ALTER TABLE betreut ADD CONSTRAINT FK_betreut_1 FOREIGN KEY (obmann) REFERENCES angestellter (persnr);


