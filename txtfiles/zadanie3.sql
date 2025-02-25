-- 1. Pobierz listę wszystkich uczniów wraz z informację o klasie, do której uczęszczają

SELECT 
    Uczen.Imie, 
    Uczen.Nazwisko, 
    Klasa.Nazwa AS Klasa, 
    Klasa.DataRozpoczecia
FROM 
    Uczen
LEFT JOIN 
    Klasa ON Uczen.KlasaID = Klasa.ID;

-- 2. Pobierz listę wszystkich klas oraz uczniów, którzy do niej należą. Jeżeli w danej klasie jest N uczniów, w wyniku ma pojawić się N wierszy. Jeżeli w danej klasie nie ma uczniów, klasa ma pojawić się w wyniku 1 raz

SELECT 
    Klasa.Nazwa AS Klasa, 
    Klasa.DataRozpoczecia, 
    Uczen.Imie, 
    Uczen.Nazwisko
FROM 
    Klasa
LEFT JOIN 
    Uczen ON Klasa.ID = Uczen.KlasaID;

-- 3. Pobierz listę wszystkich uczniów, których uczył nauczyciel X. Jako nauczyciela można wybrać dowolną osobę z listy nauczycieli (wg nazwiska, a nie Id)

SELECT 
    DISTINCT Uczen.Imie, 
    Uczen.Nazwisko
FROM 
    Uczen
INNER JOIN 
    Klasa ON Uczen.KlasaID = Klasa.ID
INNER JOIN 
    Lekcja ON Klasa.ID = Lekcja.KlasaID
INNER JOIN 
    Nauczyciel ON Lekcja.NauczycielPesel = Nauczyciel.Pesel
WHERE 
    Nauczyciel.Nazwisko = 'Mazur';

-- 4. Pobierz listę wszystkich uczniów wraz z liczbą lekcji, w których uczestniczyli. W wyniku każdy uczeń ma pojawić się 1 raz, a liczba lekcji powinna być kolumną wyniku

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
    Uczen.Nazwisko;

-- 5. Pobierz plan lekcji wybranego nauczyciela. W wyniku mają znaleźć się wszystkie lekcje prowadzone przez wybranego nauczyciela wraz z datą rozpoczęcia posortowane chronologicznie.

SELECT 
    Lekcja.Temat, 
    Lekcja.DataRozpoczecia, 
    Lekcja.CzasTrwania, 
    Lekcja.Sala
FROM 
    Lekcja
INNER JOIN 
    Nauczyciel ON Lekcja.NauczycielPesel = Nauczyciel.Pesel
WHERE 
    Nauczyciel.Nazwisko = 'Mazur'
ORDER BY 
    Lekcja.DataRozpoczecia;

-- 6. Przygotuj następujące widoki: 
-- #Nazwa klasy, Liczba uczniów 

CREATE VIEW Widok_LiczbaUczniowNaKlase AS
SELECT 
    Klasa.Nazwa AS Klasa, 
    COUNT(Uczen.Pesel) AS LiczbaUczniow
FROM 
    Klasa
LEFT JOIN 
    Uczen ON Klasa.ID = Uczen.KlasaID
GROUP BY 
    Klasa.Nazwa;

-- #Imię nauczyciela, Nazwisko nauczyciela, Liczba prowadzonych lekcji 

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
    Nauczyciel.Nazwisko;

-- #Nazwa przedmiotu, Liczba lekcji

CREATE VIEW Widok_LiczbaLekcjiPrzedmioty AS
SELECT 
    CAST(Przedmiot.Zakres AS NVARCHAR(MAX)) AS Przedmiot, 
    COUNT(Lekcja.ID) AS LiczbaLekcji
FROM 
    Przedmiot
LEFT JOIN 
    Lekcja ON Przedmiot.ID = Lekcja.PrzedmiotID
GROUP BY 
    CAST(Przedmiot.Zakres AS NVARCHAR(MAX));

