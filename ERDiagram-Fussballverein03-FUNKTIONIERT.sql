---------------------------------------------------------------------------------------------------------
-- Daher habe ich die Tabellen spiel bis betreut rausgelöscht
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
 
);


ALTER TABLE mannschaft ADD CONSTRAINT PK_mannschaft PRIMARY KEY (bezeichnung,ist_chef,ist_assistent);


CREATE TABLE mitglied (
 persnr SERIAL NOT NULL,
 beitrag VARCHAR(20) NOT NULL,
 gehalt FLOAT(20) NOT NULL,--df: alpha=3000 beta=5
 ueberstunden FLOAT(20) NOT NULL,--df: alpha=10 beta=5
 e_mail VARCHAR(255) NOT NULL-- df: pattern='[a-z]{3,8}\.[a-z]{3,8}@(gmail|yahoo)\.com'
);

ALTER TABLE mitglied ADD CONSTRAINT PK_mitglied PRIMARY KEY (persnr);


ALTER TABLE trainer ADD CONSTRAINT FK_trainer_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE angestellter ADD CONSTRAINT FK_angestellter_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE mannschaft ADD CONSTRAINT FK_mannschaft_0 FOREIGN KEY (ist_chef) REFERENCES trainer (persnr);
ALTER TABLE mannschaft ADD CONSTRAINT FK_mannschaft_1 FOREIGN KEY (ist_assistent) REFERENCES trainer (persnr);


ALTER TABLE mitglied ADD CONSTRAINT FK_mitglied_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


