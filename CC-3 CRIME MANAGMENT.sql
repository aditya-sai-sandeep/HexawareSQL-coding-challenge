
-- CODING CHALLANGE CRIME MANAGMENT

CREATE TABLE Crime (
CrimeID INT PRIMARY KEY,
IncidentType VARCHAR(255),
IncidentDate DATE,
Location VARCHAR(255),
Description TEXT,
Status VARCHAR(20)
);
CREATE TABLE Victim (
VictimID INT PRIMARY KEY,
CrimeID INT,
age INT,
Name VARCHAR(255),
ContactInfo VARCHAR(255),
Injuries VARCHAR(255),
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);
CREATE TABLE Suspect (
SuspectID INT PRIMARY KEY,
CrimeID INT,
age INT,
Name VARCHAR(255),
Description TEXT,
CriminalHistory TEXT,
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

-- Insert sample data
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description,
Status)
VALUES
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a
convenience store', 'Open'),
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a
murder case', 'Under Investigation'),
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a
mall', 'Closed');
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries,age) VALUES
(1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries',35),
(2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased',23),
(3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None',31);
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory,age) VALUES
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions',30),
(2, 2, 'Unknown', 'Investigation ongoing', NULL,34),
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests',65);


-- select * from Crime
-- select * from Victim
-- select * from Suspect


--1
SELECT * FROM Crime WHERE Status = 'Open';

--2
SELECT COUNT(CrimeID) AS TotalIncidents FROM Crime;

--3
SELECT DISTINCT IncidentType FROM Crime;

--4
SELECT * FROM Crime WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

--5
SELECT v.Name AS VictimName, v.age AS VictimAge
FROM Crime c
INNER JOIN Victim v ON c.CrimeID = v.CrimeID
ORDER BY v.age DESC 

SELECT s.Name AS SuspectName,s.age AS SuspectAge
FROM Crime c
INNER JOIN Suspect s ON c.CrimeID = s.CrimeID
ORDER BY s.age DESC 

--6
SELECT AVG(age) AS AverageAge
FROM (SELECT age FROM Victim WHERE age IS NOT NULL
UNION ALL
SELECT age FROM Suspect WHERE age IS NOT NULL) AS Ages;

--7
SELECT c.IncidentType,COUNT(*) AS IncidentCount
FROM Crime c
WHERE c.Status = 'Open'
GROUP BY c.IncidentType;

--8
SELECT v.Name AS PersonName FROM Victim v
WHERE v.Name LIKE '%Doe%'
UNION
SELECT s.Name AS PersonName FROM Suspect s
WHERE s.Name LIKE '%Doe%';

--9
select name from victim where CrimeID in (
select CrimeID from Crime WHERE
Status = 'open' or Status = 'closed')
union 
select name from Suspect where CrimeID in (
select CrimeID from Crime WHERE
Status = 'open' or Status = 'closed')

--10
SELECT DISTINCT c.IncidentType
FROM Crime c
LEFT JOIN Victim v ON c.CrimeID = v.CrimeID
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE v.age = 30 OR v.age = 35 OR s.age = 30 OR s.age = 35;

--11
select Name from Victim where CrimeID in (
select CrimeID from Crime where IncidentType = 'Robbery')
union 
select Name from Suspect where CrimeID in (
select CrimeID from Crime where IncidentType = 'Robbery')

--12
SELECT IncidentType FROM Crime WHERE Status='Open'
GROUP BY IncidentType
HAVING COUNT(Status)>1
--13
SELECT c.*
FROM Crime c
JOIN Suspect s ON c.CrimeID = s.CrimeID
JOIN Victim v ON s.Name = v.Name AND s.CrimeID <> v.CrimeID;

--14
SELECT c.*, v.*, s.*
FROM Crime c
LEFT JOIN Victim v ON c.CrimeID = v.CrimeID
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

--15
SELECT c.*
FROM Crime c
JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.age > ANY (SELECT age FROM Victim v WHERE c.CrimeID = v.CrimeID);

--16
SELECT s.SuspectID, s.Name, COUNT(c.CrimeID) AS IncidentsCount
FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID
GROUP BY s.SuspectID, s.Name
HAVING COUNT(c.CrimeID) > 1;

--17
SELECT c.*
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.Name IS NULL;

--18
DECLARE @homicidecount INT
SELECT @homicidecount = COUNT(IncidentType) 
FROM Crime WHERE IncidentType= 'Homicide'

if @homicidecount>1
BEGIN
 select * from Crime 
 where IncidentType= 'Homicide'
END
ELSE
BEGIN
 select * from Crime 
 where IncidentType= 'Robbery'
END;

--19
SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location, c.Description, c.Status,
COALESCE(s.Name, 'No Suspect') AS SuspectName
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

--20
SELECT DISTINCT s.Name
FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType IN ('Robbery', 'Assault');









