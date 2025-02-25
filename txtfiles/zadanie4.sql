-- 1. Użyć klauzuli HAVING w zapytaniu z zadania 3 tam, gdzie używany jest warunek GROUP BY, aby dodatkowo ograniczyć pobierane dane

-- zapytanie 4
SELECT 
    Uczen.Imie, 
    Uczen.Nazwisko, 
    COUNT(Lekcja.ID) AS LiczbaLekcji
FROM 
    Uczen
LEFT JOIN 
    Klasa ON Uczen.KlasaID = Klasa.ID
LEFT JOIN 
    Lekcja ON Klasa.ID = Lekcja.KlasaID
GROUP BY 
    Uczen.Imie, 
    Uczen.Nazwisko
HAVING 
    COUNT(Lekcja.ID) > 0; -- Pomijamy uczniów bez lekcji

-- zapytanie 6.1
CREATE VIEW Widok_LiczbaUczniowNaKlase AS
SELECT 
    Klasa.Nazwa AS Klasa, 
    COUNT(Uczen.Pesel) AS LiczbaUczniow
FROM 
    Klasa
LEFT JOIN 
    Uczen ON Klasa.ID = Uczen.KlasaID
GROUP BY 
    Klasa.Nazwa
HAVING 
    COUNT(Uczen.Pesel) >= 1; -- Tylko dla klas z min. 1 uczniem

-- zapytanie 6.2
CREATE VIEW Widok_LiczbaLekcjiNauczycieli AS
SELECT 
    Nauczyciel.Imie, 
    Nauczyciel.Nazwisko, 
    COUNT(Lekcja.ID) AS LiczbaLekcji
FROM 
    Nauczyciel
LEFT JOIN 
    Lekcja ON Nauczyciel.Pesel = Lekcja.NauczycielPesel
GROUP BY 
    Nauczyciel.Imie, 
    Nauczyciel.Nazwisko
HAVING 
    COUNT(Lekcja.ID) >= 3; -- Tylko nauczyciele z min. 3 lekcjami

-- zapytanie 6.3
CREATE VIEW Widok_LiczbaLekcjiPrzedmioty AS
SELECT 
    CAST(Przedmiot.Zakres AS NVARCHAR(MAX)) AS Przedmiot, 
    COUNT(Lekcja.ID) AS LiczbaLekcji
FROM 
    Przedmiot
LEFT JOIN 
    Lekcja ON Przedmiot.ID = Lekcja.PrzedmiotID
GROUP BY 
    CAST(Przedmiot.Zakres AS NVARCHAR(MAX))
HAVING 
    COUNT(Lekcja.ID) > 2; -- Pomijamy przedmioty z mniej jak 2 lekcjami

-- 2. Założyć indeksy przyspieszające wszystkie zapytania z zadania 3

-- zapytanie 1: pobranie listy uczniów i klas
CREATE INDEX idx_uczen_klasa_id ON Uczen(KlasaID);
CREATE INDEX idx_klasa_id ON Klasa(ID);

-- zapytanie 2: również pobranie listy klas i przypisanych uczniów
CREATE INDEX idx_uczen_klasa_id ON Uczen(KlasaID);
CREATE INDEX idx_klasa_id ON Klasa(ID);

-- zapytanie 3: pobranie uczniów uczonych przez konkretnych nauczycieli
CREATE INDEX idx_nauczyciel_nazwisko ON Nauczyciel(Nazwisko);
CREATE INDEX idx_lekcja_nauczyciel ON Lekcja(NauczycielPesel);
CREATE INDEX idx_klasa_id ON Klasa(ID);
CREATE INDEX idx_uczen_klasa_id ON Uczen(KlasaID);

-- zapytanie 4: pobranie uczniów i liczby ich lekcji
CREATE INDEX idx_uczen_klasa_id ON Uczen(KlasaID);
CREATE INDEX idx_klasa_id ON Klasa(ID);
CREATE INDEX idx_lekcja_klasa_id ON Lekcja(KlasaID);
CREATE INDEX idx_lekcja_id ON Lekcja(ID);

-- zapytanie 5: pobranie planu lekcji nauczyciela
CREATE INDEX idx_nauczyciel_nazwisko ON Nauczyciel(Nazwisko);
CREATE INDEX idx_lekcja_nauczyciel ON Lekcja(NauczycielPesel);
CREATE INDEX idx_lekcja_data ON Lekcja(DataRozpoczecia);

-- zapytanie 6.1 pobieranie uczniów w klasach
CREATE INDEX idx_uczen_klasa_id ON Uczen(KlasaID);

-- zapytanie 6.2 pobieranie lekcji nauczyciela
CREATE INDEX idx_lekcja_nauczyciel ON Lekcja(NauczycielPesel);

-- zapytanie 6.3 pobieranie lekcji przedmiotów
CREATE INDEX idx_lekcja_przedmiot ON Lekcja(PrzedmiotID);

-- 3. Stworzyć CHECK CONSTRAINT, który uniemożliwi wpisanie do tabeli UCZEN lub NAUCZYCIEL daty urodzenia lub zatrudnienia z przyszłości oraz jakiejkolwiek (wybranej) liczby mniejszej od 0

-- CHECK CONSTRAINT uniemożliwia datę urodzenia w przyszłości
ALTER TABLE Uczen
ADD CONSTRAINT chk_Uczen_DataUrodzenia
CHECK (DataUrodzenia <= GETDATE());

-- CHECK CONSTRAINT uniemożliwia datę zatrudnienia w przyszłości
ALTER TABLE Nauczyciel
ADD CONSTRAINT chk_Nauczyciel_DataZatrudnienia
CHECK (DataZatrudnienia <= GETDATE());
