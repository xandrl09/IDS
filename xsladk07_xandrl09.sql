DROP TABLE Barva CASCADE CONSTRAINTS;
DROP TABLE Rasa CASCADE CONSTRAINTS;
DROP TABLE Kocka CASCADE CONSTRAINTS;
DROP TABLE Rasa_Barva CASCADE CONSTRAINTS;
DROP TABLE Kocka_Barva CASCADE CONSTRAINTS;
DROP TABLE Hostitel CASCADE CONSTRAINTS;
DROP TABLE Hostitel_Rasa CASCADE CONSTRAINTS;
DROP TABLE Teritorium CASCADE CONSTRAINTS;
DROP TABLE Vec CASCADE CONSTRAINTS;
DROP TABLE Vlastnictvi CASCADE CONSTRAINTS;
DROP TABLE Kocka_Teritorium CASCADE CONSTRAINTS;
DROP TABLE Zivot CASCADE CONSTRAINTS;
DROP TABLE Hostitel_Zivot CASCADE CONSTRAINTS;
DROP TABLE Kocka CASCADE CONSTRAINTS;
DROP TABLE Smrt CASCADE CONSTRAINTS;
DROP TABLE Admeowstrator CASCADE CONSTRAINTS;

CREATE TABLE Barva
(
	vlnova_delka INTEGER CONSTRAINT PK_barva PRIMARY KEY,
	nazev VARCHAR(64),
	popis VARCHAR(1024)
);

CREATE TABLE Rasa
(
	nazev_rasy VARCHAR(64) CONSTRAINT PK_rasa PRIMARY KEY,
	puvod VARCHAR(128),
	maximalni_delka_tesaku INTEGER CONSTRAINT minimalni_delka_tesaku CHECK (maximalni_delka_tesaku > 0)
);

CREATE TABLE Kocka
(
	id_kocka INTEGER CONSTRAINT PK_kocka PRIMARY KEY,
	hlavni_jmeno VARCHAR(64) CONSTRAINT kocka_jmeno_not_null NOT NULL,
	vzorek_srsti VARCHAR(64) CONSTRAINT kocka_vzorek_srsti_not_null NOT NULL,
	nazev_rasy VARCHAR(64) NOT NULL CONSTRAINT FK_kocka_rasa REFERENCES Rasa (nazev_rasy) ON DELETE SET NULL
);

--vazba N:M mezi rasou a barvou
CREATE TABLE Rasa_Barva
(
	nazev_rasy VARCHAR(64) CONSTRAINT FK_barva_rasa REFERENCES Rasa (nazev_rasy) ON DELETE CASCADE,
	vlnova_delka INTEGER CONSTRAINT FK_rasa_barva REFERENCES Barva (vlnova_delka) ON DELETE CASCADE,
	CONSTRAINT PK_rasa_barva PRIMARY KEY (vlnova_delka, nazev_rasy)
);

--vazba N:M mezi kockou a barvou
CREATE TABLE Kocka_Barva
(
	id_kocka INTEGER CONSTRAINT FK_barva_kocka REFERENCES Kocka (id_kocka) ON DELETE CASCADE,
	vlnova_delka INTEGER CONSTRAINT FK_kocka_barva REFERENCES Barva (vlnova_delka) ON DELETE CASCADE,
	CONSTRAINT PK_kocka_barva PRIMARY KEY (id_kocka, vlnova_delka)
);

CREATE TABLE Hostitel
(
	id_hostitel INTEGER CONSTRAINT PK_hostitel PRIMARY KEY,
	jmeno VARCHAR(64),
	datum_narozeni DATE CONSTRAINT hostitel_datum_narozeni NOT NULL,
	pohlavi VARCHAR(5),
	adresa VARCHAR(64)
);

--vazba N:M mezi hostitelem a rasou
CREATE TABLE Hostitel_Rasa
(
	id_hostitel INTEGER CONSTRAINT FK_rasa_hostitel REFERENCES Hostitel (id_hostitel) ON DELETE CASCADE,
	nazev_rasy VARCHAR(64) CONSTRAINT FK_hostitel_rasa REFERENCES Rasa (nazev_rasy) ON DELETE CASCADE,
	CONSTRAINT PK_hostitel_rasa PRIMARY KEY (id_hostitel, nazev_rasy)
);

CREATE TABLE Teritorium
(
	souradnice VARCHAR(128) CONSTRAINT PK_teritorium PRIMARY KEY,
	kapacita INTEGER CONSTRAINT minimalni_kapacita_teritoria CHECK (kapacita > -1),
	typ VARCHAR(64),
	nazev VARCHAR(64)
);


CREATE TABLE Vec
(
	id_vec INTEGER CONSTRAINT PK_vec PRIMARY KEY,
	typ VARCHAR(64),
	souradnice VARCHAR(128) CONSTRAINT FK_vec REFERENCES Teritorium (souradnice)
);

CREATE TABLE Vlastnictvi
(
	id_kocka INTEGER CONSTRAINT FK_id_kocka_vlastnictvi REFERENCES Kocka (id_kocka),
	id_vec INTEGER CONSTRAINT FK_id_veci_vlastnictvi REFERENCES Vec (id_vec),
	id_hostitel INTEGER CONSTRAINT FK_id_hostitele_vlastnictvi REFERENCES Hostitel (id_hostitel),
	od DATE CONSTRAINT vlastnictvi_od_not_null NOT NULL,
	do DATE,
	CONSTRAINT PK_vlastnictvi PRIMARY KEY (id_kocka, id_vec)
);

--vazba N:M mezi kockou a teritoriem
CREATE TABLE Kocka_Teritorium
(
	id_kocka INTEGER CONSTRAINT FK_teritorium_kocka REFERENCES Kocka (id_kocka),
	souradnice VARCHAR(64) CONSTRAINT FK_kocka_teritorium REFERENCES Teritorium (souradnice),
	od DATE CONSTRAINT kocka_teritorium_od_not_null NOT NULL,
	do DATE,
	CONSTRAINT PK_kocka_teritorium PRIMARY KEY (id_kocka, souradnice)
);

CREATE TABLE Zivot
(
	id_zivot INTEGER CONSTRAINT PK_zivot PRIMARY KEY,
	zacatek TIMESTAMP NOT NULL,
	konec TIMESTAMP,
	zpusob_umrti VARCHAR(128),
	souradnice_narozeni VARCHAR(128) NOT NULL CONSTRAINT FK_souradnice_narozeni REFERENCES Teritorium (souradnice),
	souradnice_umrti VARCHAR(128) CONSTRAINT FK_souradnice_umrti REFERENCES Teritorium (souradnice),
	id_kocka INTEGER CONSTRAINT FK_zivot_kocky REFERENCES Kocka (id_kocka)
);

--vazba N:M mezi hostitelem a zivotem
CREATE TABLE Hostitel_Zivot
(
	id_zivot INTEGER CONSTRAINT FK_hostitelstvi_cislo_zivota REFERENCES Zivot (id_zivot),
	id_hostitel INTEGER CONSTRAINT FK_hostitelstvi_id_hostitele REFERENCES Hostitel (id_hostitel),
	pojmenovani VARCHAR(64),
	CONSTRAINT PK_hostitel_zivot PRIMARY KEY (id_zivot, id_hostitel)
);

CREATE TABLE Smrt
(
	id_kocka INTEGER CONSTRAINT FK_smrt REFERENCES Kocka (id_kocka) ON DELETE CASCADE,
	odbavenych_zivotu INTEGER NOT NULL,
	CONSTRAINT PK_Smrt PRIMARY KEY (id_kocka)
);

CREATE TABLE Admeowstrator
(
	id_kocka INTEGER CONSTRAINT FK_admeowstrator REFERENCES Kocka (id_kocka) ON DELETE CASCADE,
	CONSTRAINT PK_admeowstrator PRIMARY KEY (id_kocka)
);

INSERT INTO Barva VALUES (680, 'Červená', 'Červená Červená');
INSERT INTO Barva VALUES (615, 'Oranžová', 'Oranžová Oranžová');
INSERT INTO Barva VALUES (575, 'Žlutá', 'Žlutá Žlutá');
INSERT INTO Barva VALUES (540, 'Zelená', 'Zelená Zelená');
INSERT INTO Barva VALUES (470, 'Modrá', 'Modrá Modrá');
INSERT INTO Barva VALUES (425, 'Fialová', 'Fialová Fialová');

INSERT INTO Rasa VALUES ('Barmská kočka', 'Barma', 23);
INSERT INTO Rasa VALUES ('Bengálská kočka', 'Bengálsko', 25);
INSERT INTO Rasa VALUES ('Britská krátkosrstá kočka', 'Británie', 26);
INSERT INTO Rasa VALUES ('Evropská kočka', 'Evropa', 22);
INSERT INTO Rasa VALUES ('Kanadský sphynx', 'Kanada', 20);
INSERT INTO Rasa VALUES ('Perská kočka', 'Persie', 19);
INSERT INTO Rasa VALUES ('Mainská mývalí kočka', 'Mainie', 25);
INSERT INTO Rasa VALUES ('Skotská klapouchá', 'Skotsko', 18);

INSERT INTO Kocka VALUES (1, 'Ničitel', 'puntíky', 'Bengálská kočka');
INSERT INTO Kocka VALUES (2, 'Pobíječ', 'čtverečky', 'Perská kočka');
INSERT INTO Kocka VALUES (3, 'Požírač', 'žíhaný', 'Skotská klapouchá');
INSERT INTO Kocka VALUES (4, 'Nájezdník', 'gepard', 'Bengálská kočka');
INSERT INTO Kocka VALUES (5, 'Nemilosrdný', 'jednobarevný', 'Barmská kočka');

INSERT INTO Rasa_Barva VALUES ('Barmská kočka', 680);
INSERT INTO Rasa_Barva VALUES ('Bengálská kočka', 615);
INSERT INTO Rasa_Barva VALUES ('Britská krátkosrstá kočka', 575);
INSERT INTO Rasa_Barva VALUES ('Evropská kočka', 540);
INSERT INTO Rasa_Barva VALUES ('Kanadský sphynx', 470);
INSERT INTO Rasa_Barva VALUES ('Perská kočka', 425);
INSERT INTO Rasa_Barva VALUES ('Mainská mývalí kočka', 680);
INSERT INTO Rasa_Barva VALUES ('Skotská klapouchá', 615);

INSERT INTO Kocka_Barva VALUES (1, 425);
INSERT INTO Kocka_Barva VALUES (2, 470);
INSERT INTO Kocka_Barva VALUES (3, 540);
INSERT INTO Kocka_Barva VALUES (4, 575);
INSERT INTO Kocka_Barva VALUES (5, 615);

INSERT INTO Hostitel VALUES (1, 'Slouha', TO_DATE('12-12-2012', 'DD-MM/-YYYY'), 'muž', 'Jehlička 11');
INSERT INTO Hostitel VALUES (2, 'Krmná', TO_DATE('11-11-2011', 'DD-MM/-YYYY'), 'žena', 'Smrček 12');
INSERT INTO Hostitel VALUES (3, 'Blboun', TO_DATE('10-10-2010', 'DD-MM/-YYYY'), 'muž', 'Dub 13');
INSERT INTO Hostitel VALUES (4, 'Neposlušný', TO_DATE('09-09-2009', 'DD-MM/-YYYY'), 'žena', 'Šiška 14');

INSERT INTO Hostitel_Rasa VALUES (1, 'Skotská klapouchá');
INSERT INTO Hostitel_Rasa VALUES (2, 'Mainská mývalí kočka');
INSERT INTO Hostitel_Rasa VALUES (3, 'Perská kočka');
INSERT INTO Hostitel_Rasa VALUES (4, 'Kanadský sphynx');

INSERT INTO Teritorium VALUES ('64z32s', 25, 'Hřiště', 'U Velké trojce');
INSERT INTO Teritorium VALUES ('31v11j', 19, 'Louka', 'U Myší díry');
INSERT INTO Teritorium VALUES ('1s1v', 32, 'Staveniště', 'Strážní věž');

INSERT INTO Vec VALUES (1, 'míček', '64z32s');
INSERT INTO Vec VALUES (2, 'myška', '31v11j');
INSERT INTO Vec VALUES (3, 'balónek', '1s1v');
INSERT INTO Vec VALUES (4, 'váza', '64z32s');
INSERT INTO Vec VALUES (5, 'dečka', '31v11j');

INSERT INTO Vlastnictvi VALUES (1, 1, 1, TO_DATE('08-08-2008', 'DD-MM/-YYYY'), NULL);
INSERT INTO Vlastnictvi VALUES (2, 2, 2, TO_DATE('07-07-2008', 'DD-MM/-YYYY'), NULL);
INSERT INTO Vlastnictvi VALUES (3, 3, 3, TO_DATE('06-06-2008', 'DD-MM/-YYYY'), NULL);
INSERT INTO Vlastnictvi VALUES (4, 4, 4, TO_DATE('05-05-2008', 'DD-MM/-YYYY'), NULL);

INSERT INTO Kocka_Teritorium VALUES (1, '64z32s', TO_DATE('04-04-2008', 'DD-MM/-YYYY'), NULL);
INSERT INTO Kocka_Teritorium VALUES (2, '31v11j', TO_DATE('03-03-2008', 'DD-MM/-YYYY'), NULL);
INSERT INTO Kocka_Teritorium VALUES (3, '1s1v', TO_DATE('02-02-2008', 'DD-MM/-YYYY'), NULL);
INSERT INTO Kocka_Teritorium VALUES (4, '64z32s', TO_DATE('01-01-2008', 'DD-MM/-YYYY'), NULL);
INSERT INTO Kocka_Teritorium VALUES (5, '31v11j', TO_DATE('12-12-2007', 'DD-MM/-YYYY'), NULL);

INSERT INTO Zivot VALUES (1, TO_DATE('01-01-2008', 'DD-MM/-YYYY'), TO_DATE('01-01-2008', 'DD-MM/-YYYY'), 'utopení', '64z32s', '64z32s', 1);
INSERT INTO Zivot VALUES (2, TO_DATE('01-01-2008', 'DD-MM/-YYYY'), NULL, NULL, '64z32s', NULL, 1);
INSERT INTO Zivot VALUES (3, TO_DATE('02-01-2008', 'DD-MM/-YYYY'), TO_DATE('05-01-2008', 'DD-MM/-YYYY'), 'přejetí', '31v11j', '1s1v', 2);
INSERT INTO Zivot VALUES (4, TO_DATE('05-01-2008', 'DD-MM/-YYYY'), NULL, NULL, '1s1v', NULL, 2);
INSERT INTO Zivot VALUES (5, TO_DATE('02-08-2008', 'DD-MM/-YYYY'), NULL, NULL, '64z32s', NULL, 3);
INSERT INTO Zivot VALUES (6, TO_DATE('09-08-2008', 'DD-MM/-YYYY'), NULL, NULL, '31v11j', NULL, 4);
INSERT INTO Zivot VALUES (7, TO_DATE('02-08-2009', 'DD-MM/-YYYY'), NULL, NULL, '1s1v', NULL, 5);

INSERT INTO Hostitel_Zivot VALUES (1, 1, 'Tlapka');
INSERT INTO Hostitel_Zivot VALUES (2, 2, 'Oto');
INSERT INTO Hostitel_Zivot VALUES (3, 3, 'Minda');
INSERT INTO Hostitel_Zivot VALUES (4, 1, 'Káťa');
INSERT INTO Hostitel_Zivot VALUES (5, 2, 'Pupíček');

INSERT INTO Smrt VALUES (4, 42);

INSERT INTO Admeowstrator VALUES (5);


--------------------- selects -------------------------------

-- Zobrazí údaje o rase pro kočky mající tesáky delší než 20cm
-- seřazené podle délky tesáků
SELECT NAZEV_RASY ,
PUVOD ,
MAXIMALNI_DELKA_TESAKU 
FROM rasa
WHERE MAXIMALNI_DELKA_TESAKU>20
ORDER BY maximalni_delka_tesaku DESC;


-- dva dotazy využívající spojení dvou tabulek, jeden využívající spojení tří tabulek, dva dotazy s klauzulí GROUP BY
-- a agregační funkcí, jeden dotaz obsahující predikát EXISTS a jeden dotaz s predikátem IN s vnořeným selectem


-- dva dotazy využívající spojení dvou tabulek
-- Zobrazí vlnovou délku kočky s id=1 nebo id=3
SELECT Kocka_Barva.id_kocka, Barva.nazev
FROM Barva
JOIN Kocka_Barva ON Kocka_Barva.vlnova_delka=Barva.vlnova_delka
WHERE Kocka_Barva.id_kocka='1' OR Kocka_Barva.id_kocka='3';

-- Zobrazí informace o životě koček, jejiž hostitel má id>1
SELECT Zivot.zacatek, Zivot.konec, Zivot.zpusob_umrti,
    Zivot.souradnice_narozeni, Zivot.souradnice_umrti, Zivot.id_kocka 
FROM Zivot 
JOIN Hostitel_Zivot ON Hostitel_Zivot.id_zivot=Zivot.id_zivot
WHERE Hostitel_Zivot.id_hostitel>1;

--jeden využívající spojení tří tabulek
-- Zobrazí jaké rasi je kočka vlastněná konkrétním hostitelem
SELECT Rasa.nazev_rasy,  Hostitel.Jmeno
FROM Rasa, Hostitel_Rasa, Hostitel
WHERE Rasa.nazev_rasy = Hostitel_Rasa.nazev_rasy AND Hostitel_Rasa.id_hostitel = Hostitel.id_hostitel
;
--dva dotazy s klauzulí GROUP BY a agregační funkcí
-- U každé rasy zobrazí kolik koček k ní patří
SELECT COUNT(nazev_rasy) AS POCET_CLENU_RASI, nazev_rasy
FROM Kocka
GROUP BY nazev_rasy;

-- Vypíše maximální vlnovou délku u jednotlivích barev
SELECT nazev, MAX(Barva.vlnova_delka) AS maximalni_vlnova_delka
FROM Barva
GROUP BY nazev 
;

--jeden dotaz obsahující predikát EXISTS
-- Vypíše informace o teritoriích ve kterých je umístěna nějaká věc
SELECT *
FROM Teritorium
WHERE EXISTS(
    SELECT Vec.id_vec
    FROM Vec
    WHERE Vec.souradnice = Teritorium.souradnice
);


--jeden dotaz s predikátem IN s vnořeným selectem
-- Vypíše informace o hostitelích, u nihž žije žije kočka se jménem 'Tlapka', nebo 'Oto'
SELECT *
FROM Hostitel
WHERE Hostitel.id_hostitel
IN(
    SELECT Hostitel_Zivot.id_hostitel
    FROM Hostitel_Zivot
    WHERE Hostitel_Zivot.pojmenovani = 'Tlapka' 
    OR Hostitel_Zivot.pojmenovani = 'Oto'
);

COMMIT;