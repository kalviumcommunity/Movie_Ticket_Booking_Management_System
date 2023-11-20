CREATE DATABASE Movie_Ticket_Booking_Management_System;

USE Movie_Ticket_Booking_Management_System;

CREATE ROLE UserRole;
CREATE ROLE AdminRole;

GRANT SELECT ON Movie, Showtime, Seat TO UserRole;
GRANT INSERT, UPDATE, DELETE ON Booking TO UserRole;

GRANT SELECT, INSERT, UPDATE, DELETE ON Movie, Showtime, Seat, User, Administrator TO AdminRole;
GRANT SELECT, UPDATE ON Booking TO AdminRole;


GRANT UserRole TO john_doe;
GRANT AdminRole TO admin1;


REVOKE UserRole FROM john_doe;


CREATE TABLE Movie (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(255),
    Description TEXT,
    Genre VARCHAR(50),
    Duration INT,
    ReleaseDate DATE,
    Rating DECIMAL(3, 1)
);

ALTER TABLE Movie
ADD Language VARCHAR(50);


CREATE TABLE Showtime (
    ShowtimeID INT PRIMARY KEY,
    MovieID INT,
    TheaterID INT,
    ShowtimeDateTime DATETIME,
    Price DECIMAL(8, 2),
    FOREIGN KEY (MovieID) REFERENCES Movie(MovieID),
    FOREIGN KEY (TheaterID) REFERENCES Theater(TheaterID)
);

CREATE TABLE Seat (
    SeatID INT PRIMARY KEY,
    TheaterID INT,
    RowNumber INT,
    SeatNumber INT,
    SeatType VARCHAR(50),
    AvailabilityStatus VARCHAR(20),
    FOREIGN KEY (TheaterID) REFERENCES Theater(TheaterID)
);

CREATE TABLE User (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50),
    PasswordHash VARCHAR(255),
    Email VARCHAR(255),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PhoneNumber VARCHAR(20)
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    UserID INT,
    ShowtimeID INT,
    BookingDateTime DATETIME,
    TotalPrice DECIMAL(8, 2),
    Status VARCHAR(20),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (ShowtimeID) REFERENCES Showtime(ShowtimeID)
);

CREATE TABLE Administrator (
    AdminID INT PRIMARY KEY,
    Username VARCHAR(50),
    Email VARCHAR(255),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PhoneNumber VARCHAR(20),
    Role VARCHAR(50)
);

CREATE TABLE DummyTable (
    DummyID INT PRIMARY KEY,
    Name VARCHAR(255)
);

DROP TABLE DummyTable;





INSERT INTO Movie (MovieID, Title, Description, Genre, Duration, ReleaseDate, Rating, Language)
VALUES (1, 'Inception', 'A mind-bending thriller', 'Science Fiction', 148, '2010-07-16', 8.8, 'English');

INSERT INTO Movie (MovieID, Title, Description, Genre, Duration, ReleaseDate, Rating, Language)
VALUES (2, 'The Shawshank Redemption', 'Two imprisoned men bond over several years', 'Drama', 142, '1994-09-10', 9.3, 'English');

INSERT INTO Theater (TheaterID, Name, Address, City, State, ZipCode, ContactInformation)
VALUES (1, 'Cineplex City Center', '123 Main Street', 'YourCity', 'YourState', '12345', 'Contact Info');

INSERT INTO Theater (TheaterID, Name, Address, City, State, ZipCode, ContactInformation)
VALUES (2, 'MegaPlex Theater', '456 Elm Street', 'AnotherCity', 'AnotherState', '54321', 'Contact Info');

INSERT INTO Showtime (ShowtimeID, MovieID, TheaterID, ShowtimeDateTime, Price)
VALUES (1, 1, 1, '2023-10-20 18:00:00', 10.00);

INSERT INTO Showtime (ShowtimeID, MovieID, TheaterID, ShowtimeDateTime, Price)
VALUES (2, 2, 2, '2023-10-21 19:30:00', 12.50);

INSERT INTO Seat (SeatID, TheaterID, RowNumber, SeatNumber, SeatType, AvailabilityStatus)
VALUES (1, 1, 1, 1, 'Standard', 'Available');

INSERT INTO Seat (SeatID, TheaterID, RowNumber, SeatNumber, SeatType, AvailabilityStatus)
VALUES (2, 1, 1, 2, 'Standard', 'Available');

INSERT INTO User (UserID, Username, PasswordHash, Email, FirstName, LastName, PhoneNumber)
VALUES (1, 'john_doe', 'hashed_password', 'john@example.com', 'John', 'Doe', '555-123-4567');

INSERT INTO User (UserID, Username, PasswordHash, Email, FirstName, LastName, PhoneNumber)
VALUES (2, 'jane_smith', 'hashed_password', 'jane@example.com', 'Jane', 'Smith', '555-987-6543');

INSERT INTO Booking (BookingID, UserID, ShowtimeID, BookingDateTime, TotalPrice, Status)
VALUES (1, 1, 1, '2023-10-20 15:30:00', 20.00, 'Confirmed');

INSERT INTO Booking (BookingID, UserID, ShowtimeID, BookingDateTime, TotalPrice, Status)
VALUES (2, 2, 2, '2023-10-21 16:45:00', 25.00, 'Pending');

INSERT INTO Administrator (AdminID, Username, Email, FirstName, LastName, PhoneNumber, Role)
VALUES (1, 'admin1', 'admin1@example.com', 'Admin', 'One', '555-111-2222', 'SuperAdmin');

INSERT INTO Administrator (AdminID, Username, Email, FirstName, LastName, PhoneNumber, Role)
VALUES (2, 'admin2', 'admin2@example.com', 'Admin', 'Two', '555-222-3333', 'Admin');

UPDATE Seat
SET AvailabilityStatus = 'Reserved'
WHERE SeatID = 1;

SELECT SeatID, TheaterID, RowNumber, SeatNumber, SeatType, AvailabilityStatus
FROM Seat;

DELETE FROM User
WHERE UserID = 3;

SELECT MovieID, Title, Genre, Duration, ReleaseDate, Rating, Language
FROM Movie;


SELECT Genre, Title, Rating
FROM (
    SELECT Genre, Title, Rating, 
           ROW_NUMBER() OVER (PARTITION BY Genre ORDER BY Rating DESC) AS RowNum
    FROM Movie
) AS RankedMovies
WHERE RowNum <= 5;



SELECT t.City, t.Name AS TheaterName, AVG(m.Rating) AS AvgRating
FROM Theater t
INNER JOIN Showtime s ON t.TheaterID = s.TheaterID
INNER JOIN Movie m ON s.MovieID = m.MovieID
GROUP BY t.City, t.Name
ORDER BY t.City, AvgRating DESC;



SELECT t.Name AS TheaterName, SUM(b.TotalPrice) AS TotalRevenue
FROM Theater t
INNER JOIN Showtime s ON t.TheaterID = s.TheaterID
INNER JOIN Movie m ON s.MovieID = m.MovieID
INNER JOIN Booking b ON s.ShowtimeID = b.ShowtimeID
WHERE m.Title = 'Inception'
GROUP BY t.Name
ORDER BY TotalRevenue DESC
LIMIT 5;
