
-- CC-4 Virtual Art Gallery

CREATE TABLE Artists (
ArtistID INT PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Biography TEXT,
Nationality VARCHAR(100));

CREATE TABLE Categories (
CategoryID INT PRIMARY KEY,
Name VARCHAR(100) NOT NULL);

CREATE TABLE Artworks (
ArtworkID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
ArtistID INT,
CategoryID INT,
Year INT,
Description TEXT,
ImageURL VARCHAR(255),
FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

CREATE TABLE Exhibitions (
ExhibitionID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
StartDate DATE,
EndDate DATE,
Description TEXT);

CREATE TABLE ExhibitionArtworks (
ExhibitionID INT,
ArtworkID INT,
PRIMARY KEY (ExhibitionID, ArtworkID),
FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));


INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');


INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description,
ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.',
'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.',
'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, "Pablo Picasso\'s powerful anti-war mural.",
'guernica.jpg');

INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description)
VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01','A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01','A showcase of Renaissance art treasures.');

INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);

--1
SELECT a.Name AS ArtistName, COUNT(aw.ArtworkID) AS ArtworkCount
FROM Artists a
LEFT JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
ORDER BY ArtworkCount DESC;

--2
SELECT a.Name AS ArtistName, aw.Title AS ArtworkTitle, aw.Year
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
WHERE a.Nationality IN ('Spanish', 'Dutch')
ORDER BY aw.Year ASC;

--3
SELECT a.Name AS ArtistName, COUNT(aw.ArtworkID) AS ArtworkCount FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
JOIN Categories c ON aw.CategoryID = c.CategoryID
WHERE c.Name = 'Painting'
GROUP BY a.ArtistID, a.Name
ORDER BY ArtworkCount DESC;

--4,16
SELECT a.Name AS ArtistName, aw.Title AS ArtworkTitle, c.Name AS CategoryName
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
JOIN Categories c ON aw.CategoryID = c.CategoryID
JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
WHERE e.Title = 'Modern Art Masterpieces';

--5,14
SELECT a.Name AS ArtistName, COUNT(aw.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(aw.ArtworkID) > 2;

--6
select  Title from Artworks where ArtworkID in (
select ArtworkID from ExhibitionArtworks where ExhibitionID in (
select ExhibitionID from Exhibitions where Title = 'Modern Art Masterpieces'
)
intersect
select ArtworkID from ExhibitionArtworks where ExhibitionID in (
select ExhibitionID from Exhibitions where Title = 'Renaissance Art'
)
)

--7
SELECT c.Name AS CategoryName, COUNT(aw.ArtworkID) AS TotalArtworks
FROM Categories c
LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.Name;

--8
SELECT a.ArtistID, a.Name AS ArtistName, COUNT(aw.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(aw.ArtworkID) > 3;

--9
Select title from artworks where artistID in(
Select ArtistID from Artists where nationality= "Spanish")

--10

SELECT e.ExhibitionID
FROM Exhibitions e
JOIN ExhibitionArtworks ea ON e.ExhibitionID = ea.ExhibitionID
JOIN Artworks aw ON ea.ArtworkID = aw.ArtworkID
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Name IN ('Vincent van Gogh', 'Leonardo da Vinci')
GROUP BY e.ExhibitionID
HAVING COUNT(DISTINCT a.Name) = 2;
/*
SELECT e.ExhibitionID, e.Title, e.StartDate, e.EndDate
FROM Exhibitions e
JOIN ExhibitionArtworks ea ON e.ExhibitionID = ea.ExhibitionID
JOIN Artworks aw ON ea.ArtworkID = aw.ArtworkID
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Name = 'Vincent van Gogh'

INTERSECT

SELECT e.ExhibitionID, e.Title, e.StartDate, e.EndDate
FROM Exhibitions e
JOIN ExhibitionArtworks ea ON e.ExhibitionID = ea.ExhibitionID
JOIN Artworks aw ON ea.ArtworkID = aw.ArtworkID
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Name = 'Leonardo da Vinci';
*/

--11,18
SELECT ArtworkID from Artworks where ArtworkID not in 
(select ArtworkID from ExhibitionArtworks)

--12
SELECT A.ArtistID FROM Artists AS A
INNER JOIN Artworks AS AW ON AW.ArtistID=A.ArtistID
RIGHT JOIN Categories AS C ON C.CategoryID=AW.CategoryID
GROUP BY A.ArtistID
HAVING COUNT(DISTINCT C.CategoryID)=(SELECT COUNT(CategoryID) FROM Categories)

--13
SELECT c.CategoryID, c.Name AS CategoryName, COUNT(aw.ArtworkID) AS TotalArtworks
FROM Categories c
LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID, c.Name;

--15
SELECT c.CategoryID, c.Name AS CategoryName, AVG(aw.Year) AS AverageYear
FROM Categories c
JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID, c.Name
HAVING COUNT(aw.ArtworkID) > 1;

--17
SELECT c.CategoryID, c.Name AS CategoryName, AVG(aw.Year) AS CategoryAverageYear, (SELECT AVG(Year) FROM Artworks) AS OverallAverageYear
FROM Categories c
JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID, c.Name
HAVING AVG(aw.Year) > (SELECT AVG(Year) FROM Artworks);

--19
Select name from artists where ArtistID in(
Select ArtistID from Artworks where CategoryID in(
Select CategoryID from Artworks where title = "mona Lisa"
)
)


/*
12. List artists who have created artworks in all available categories.
*/













