--add new user
CREATE PROCEDURE AddUser
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100),
    @role NVARCHAR(10),
    @location NVARCHAR(100),
    @gender NVARCHAR(10)
AS
BEGIN
    INSERT INTO Users (first_name, last_name, email, role, location, gender)
    VALUES (@first_name, @last_name, @email, @role, @location, @gender);
END

EXEC AddUser 
    @first_name = 'ankit',
    @last_name = 'Roka',  
    @email = 'Roka.An@gmail.com', 
    @role = 'client', 
    @location = 'Montreal',
    @gender = 'Male';

-------------------------------------------------------------------------------------------
--Delete User

CREATE PROCEDURE DeleteUser
    @user_id INT
AS
BEGIN
    DELETE FROM Users WHERE user_id = @user_id;
END

--EXEC DeleteUser 1;
-----------------------------------------------------------------------------------------
--Update User
CREATE PROCEDURE UpdateUser
    @user_id INT,
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100),
    @role NVARCHAR(10),
    @location NVARCHAR(100),
    @gender NVARCHAR(10)
AS
BEGIN
    UPDATE Users
    SET first_name = @first_name,
        last_name = @last_name,
        email = @email,
        role = @role,
        location = @location,
        gender = @gender
    WHERE user_id = @user_id;
END

--EXEC UpdateUser 2, 'Jane', 'Doe', 'jane.doe@example.com', 'client', 'Los Angeles', 'Female';
----------------------------------------------------------------------------------------------------
--get  user
CREATE PROCEDURE GetUserById
    @user_id INT
AS
BEGIN
    SELECT * FROM Users WHERE user_id = @user_id;
END

--EXEC GetUserById 3;
----------------------------------------------------------------------------------------------
--Add client
CREATE PROCEDURE AddClient
    @user_id INT
AS
BEGIN
    INSERT INTO Clients (user_id) VALUES (@user_id);
END

--EXEC AddClient 5;
-----------------------------------------------------------------------
--getClientInfo
CREATE PROCEDURE GetClientByUserId
    @user_id INT
AS
BEGIN
    SELECT * FROM Clients WHERE user_id = @user_id;
END

--EXEC GetClientByUserId 5;
-------------------------------------------------------------------------------------------
--Update Client
CREATE PROCEDURE UpdateClient
    @client_id INT,
    @user_id INT
AS
BEGIN
    UPDATE Clients SET user_id = @user_id WHERE client_id = @client_id;
END

--EXEC UpdateClient 1, 2;
--------------------------------------------------------------------------------------
--Delete Client
CREATE PROCEDURE DeleteClient
    @client_id INT
AS
BEGIN
    DELETE FROM Clients WHERE client_id = @client_id;
END

--EXEC DeleteClient 1;
---------------------------------------------------------------------------------------------
--add trainer
CREATE PROCEDURE AddTrainer
    @user_id INT,
    @bio NVARCHAR(MAX),
    @specialisation NVARCHAR(100),
    @rating DECIMAL(2, 1),
    @certification NVARCHAR(100)
AS
BEGIN
    INSERT INTO Trainers (user_id, bio, specialisation, rating, certification)
    VALUES (@user_id, @bio, @specialisation, @rating, @certification);
END

--EXEC AddTrainer 4, 'Fitness Enthusiast', 'Strength Training', 5, 'Certified Trainer';
----------------------------------------------------------------------------------------------------
--Delete Trainer
CREATE PROCEDURE DeleteTrainer
    @trainer_id INT
AS
BEGIN
    DELETE FROM Trainers WHERE trainer_id = @trainer_id;
END
--EXEC DeleteTrainer 1;
----------------------------------------------------------------------------------------------------
--AddBooking
DROP PROCEDURE IF EXISTS AddBooking; -- Drop if it exists

CREATE PROCEDURE AddBooking
    @trainer_id INT,
    @client_id INT,
    @booking_date DATETIME,
    @payment_method NVARCHAR(20),
    @status NVARCHAR(20)
AS
BEGIN
    INSERT INTO Bookings (trainer_id, client_id, booking_date, payment_method, status)
    VALUES (@trainer_id, @client_id, @booking_date, @payment_method, @status);
END;


EXEC AddBooking 
    @trainer_id = 1, 
    @client_id = 2, 
    @booking_date = '2024-10-08', 
    @payment_method = 'Credit Card', 
    @status = 'Confirmed';

----------------------------------------------------------------------------------------------------
-- DeleteBooking 
CREATE PROCEDURE DeleteBooking
    @booking_id INT
AS
BEGIN
    DELETE FROM Bookings WHERE booking_id = @booking_id;
END
--EXEC DeleteBooking 1;

--------------------------------------------------------------------------------------------------
--AddPayment
CREATE PROCEDURE AddPayment
    @client_id INT,
    @amount DECIMAL(10, 2),
    @payment_method NVARCHAR(50),
    @status NVARCHAR(20)
AS
BEGIN
    INSERT INTO Payments (client_id, amount, payment_method, status)
    VALUES (@client_id, @amount, @payment_method, @status);
END
--EXEC AddPayment 2, 150.00, 'Credit Card', 'completed';
--------------------------------------------------------------------------------------------
--Get Client Payments
CREATE PROCEDURE GetClientPayments
    @client_id INT
AS
BEGIN
    SELECT p.payment_id, p.amount, p.payment_date, p.payment_method, p.status
    FROM Payments p
    WHERE p.client_id = @client_id;
END
--EXEC GetClientPayments 2;
---------------------------------------------------------------------------------------------------
--Delete Payment
CREATE PROCEDURE DeletePayment
    @payment_id INT
AS
BEGIN
    DELETE FROM Payments WHERE payment_id = @payment_id;
END
--EXEC DeletePayment 1;

-------------------------------------------------------------------------------------------
--AddMembership
CREATE PROCEDURE AddMembership
    @client_id INT,
    @start_date DATE,
    @end_date DATE,
    @membership_type NVARCHAR(20),
    @status NVARCHAR(20)
AS
BEGIN
    INSERT INTO Memberships (client_id, start_date, end_date, membership_type, status)
    VALUES (@client_id, @start_date, @end_date, @membership_type, @status);
END
--EXEC AddMembership 2, '2024-01-01', '2024-02-01', 'monthly', 'active';
--------------------------------------------------------------------------------------------------------
--DeleteMembership
CREATE PROCEDURE DeleteMembership
    @membership_id INT
AS
BEGIN
    DELETE FROM Memberships WHERE membership_id = @membership_id;
END
--EXEC DeleteMembership 1;

---------------------------------------------------------------------------------------------
--AddReview

CREATE PROCEDURE AddReview
    @trainer_id INT,
    @client_id INT,
    @review TEXT									--========================
AS													--==========================
BEGIN
    INSERT INTO Reviews (trainer_id, client_id, review)
    VALUES (@trainer_id, @client_id, @review);
END
--EXEC AddReview 1, 2, 'Great trainer, highly recommend!';
-----------------------------------------------------------------------------------------
-- GetTrainerReviews

CREATE PROCEDURE GetTrainerReviews
    @trainer_id INT
AS
BEGIN
    SELECT r.review_id, c.client_id, u.first_name, u.last_name, r.review, r.created_at
    FROM Reviews r
    JOIN Clients c ON r.client_id = c.client_id
    JOIN Users u ON c.user_id = u.user_id
    WHERE r.trainer_id = @trainer_id;
END;

--EXEC GetTrainerReviews 1;
-----------------------------------------------------------------------------------------------
--------------------------------------views---------------------------------------------------------
------------------------------------------------------------------------------------------------
--View for Clients with monthly Memberships
CREATE VIEW MonthlyMembershipClients AS
SELECT c.client_id, u.first_name, u.last_name, m.start_date, m.end_date
FROM Clients c
JOIN Users u ON c.user_id = u.user_id
JOIN Memberships m ON c.client_id = m.client_id
WHERE m.membership_type = 'monthly';

--SELECT * FROM MonthlyMembershipClients;
------------------------------------------------------------------------------------------------
-- View for All Trainers with Ratings
CREATE VIEW TrainersWithRatings AS
SELECT t.trainer_id, u.first_name, u.last_name, t.specialisation, t.rating
FROM Trainers t
JOIN Users u ON t.user_id = u.user_id;

--SELECT * FROM TrainersWithRatings;
-----------------------------------------------------------------------------------------------
--View for Total Payments by Client
CREATE VIEW TotalPaymentsByClient AS
SELECT p.client_id, u.first_name, u.last_name, SUM(p.amount) AS total_paid
FROM Payments p
JOIN Clients c ON p.client_id = c.client_id
JOIN Users u ON c.user_id = u.user_id
GROUP BY p.client_id, u.first_name, u.last_name;

--SELECT * FROM TotalPaymentsByClient;
------------------------------------------------------------------------------------------------
--View for All Bookings with Trainer and Client Details
CREATE VIEW AllBookings AS
SELECT b.booking_id, u_first.first_name AS client_first_name, u_first.last_name AS client_last_name,
       u_trainer.first_name AS trainer_first_name, u_trainer.last_name AS trainer_last_name,
       b.booking_date, b.payment_method, b.status
FROM Bookings b
JOIN Clients c ON b.client_id = c.client_id
JOIN Users u_first ON c.user_id = u_first.user_id
JOIN Trainers t ON b.trainer_id = t.trainer_id
JOIN Users u_trainer ON t.user_id = u_trainer.user_id;

--SELECT * FROM AllBookings;
--------------------------------------------------------------------------------------------------
--View for Active Memberships
CREATE VIEW ActiveMemberships AS
SELECT c.client_id, u.first_name, u.last_name, m.start_date, m.end_date
FROM Memberships m
JOIN Clients c ON m.client_id = c.client_id
JOIN Users u ON c.user_id = u.user_id
WHERE m.status = 'active';

--SELECT * FROM ActiveMemberships;
------------------------------------------------------------------------------------------------
--View for Trainers with Specialization and Certification
CREATE VIEW TrainersSpecializationCertification AS
SELECT t.trainer_id, u.first_name, u.last_name, t.specialisation, t.certification
FROM Trainers t
JOIN Users u ON t.user_id = u.user_id;

--SELECT * FROM TrainersSpecializationCertification;
-------------------------------------------------------------------------------------------------
--View for Trainers and Their Active Membership Clients
CREATE VIEW TrainersWithActiveClients AS
SELECT 
    t.trainer_id,
    u.first_name AS trainer_first_name,
    u.last_name AS trainer_last_name,
    c.client_id,
    uc.first_name AS client_first_name,
    uc.last_name AS client_last_name
FROM Trainers t
JOIN Users u ON t.user_id = u.user_id
JOIN Bookings b ON t.trainer_id = b.trainer_id
JOIN Clients c ON b.client_id = c.client_id
JOIN Users uc ON c.user_id = uc.user_id
JOIN Memberships m ON c.client_id = m.client_id
WHERE m.status = 'active';

--SELECT * FROM TrainersWithActiveClients;
-----------------------------------------------------------------------------------------------------
---------------------------------------functions------------------------------------------------------
-- Function to Get the Number of Active Clients
CREATE FUNCTION GetActiveClientsCountByTrainer(
    @trainer_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @activeClientCount INT;
    
    SELECT @activeClientCount = COUNT(DISTINCT c.client_id)
    FROM Clients c
    JOIN Memberships m ON c.client_id = m.client_id
    JOIN Bookings b ON b.client_id = c.client_id
    WHERE b.trainer_id = @trainer_id AND m.status = 'active';

    RETURN ISNULL(@activeClientCount, 0);  -- Return 0 if there are no active clients
END;
--SELECT dbo.GetActiveClientsCountByTrainer(1) AS ActiveClientCount;
-------------------------------------------------------------------------------------------------
--Function to Get Average Rating of a Trainer
CREATE FUNCTION GetAverageRatingByTrainer(
    @trainer_id INT
)
RETURNS DECIMAL(2, 1)
AS
BEGIN
    DECLARE @averageRating DECIMAL(2, 1);
    
    SELECT @averageRating = AVG(rating)
    FROM Reviews
    WHERE trainer_id = @trainer_id;

    RETURN ISNULL(@averageRating, 0);  -- Return 0 if there are no ratings
END;

--SELECT dbo.GetAverageRatingByTrainer(1) AS AverageRating;
----------------------------------------------------------------------------------------------
-- Function to Get Total Payments for a Client

CREATE FUNCTION GetTotalPaymentsByClient(
    @client_id INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @totalPayments DECIMAL(10, 2);
    
    SELECT @totalPayments = SUM(amount)
    FROM Payments
    WHERE client_id = @client_id AND status = 'completed';

    RETURN ISNULL(@totalPayments, 0);  -- Return 0 if there are no payments
END;
--SELECT dbo.GetTotalPaymentsByClient(1) AS TotalPayments;
---------------------------------------------------------------------------------------------------
--Function to Get the Number of Bookings for a Trainer
CREATE FUNCTION GetBookingCountByTrainer(
    @trainer_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @bookingCount INT;

    SELECT @bookingCount = COUNT(*)
    FROM Bookings
    WHERE trainer_id = @trainer_id;

    RETURN ISNULL(@bookingCount, 0); 
END;
--SELECT dbo.GetBookingCountByTrainer(1) AS BookingCount;
----------------------------------------------------------------------------------------------
-----------------------jobs ------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--Job to Clean Up Inactive Memberships
USE msdb;
GO

EXEC sp_add_job
    @job_name = 'Clean Up Inactive Memberships';

EXEC sp_add_jobstep
    @job_name = 'Clean Up Inactive Memberships',
    @step_name = 'Mark Inactive',
    @subsystem = 'TSQL',
    @command = '
    UPDATE Memberships
    SET status = ''inactive''
    WHERE end_date < GETDATE() AND status <> ''inactive'';
    ';

EXEC sp_add_schedule
    @job_name = 'Clean Up Inactive Memberships',
    @name = 'Daily Inactive Cleanup',
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 000000;

EXEC sp_attach_schedule
    @job_name = 'Clean Up Inactive Memberships',
    @schedule_name = 'Daily Inactive Cleanup';

EXEC sp_add_jobserver
    @job_name = 'Clean Up Inactive Memberships';
GO
------------------------------------------------------------------------------------------------
-- Job to Update Trainer Ratings Weekly
USE msdb;
GO

EXEC sp_add_job
    @job_name = 'Update Trainer Ratings';

EXEC sp_add_jobstep
    @job_name = 'Update Trainer Ratings',
    @step_name = 'Recalculate Ratings',
    @subsystem = 'TSQL',
    @command = '
    UPDATE Trainers
    SET rating = (
        SELECT AVG(r.rating)
        FROM Reviews r
        WHERE r.trainer_id = Trainers.trainer_id
    );
    ';

EXEC sp_add_schedule
    @job_name = 'Update Trainer Ratings',
    @name = 'Weekly Rating Update',
    @freq_type = 1,
    @freq_interval = 1,
    @active_start_time = 000000;

EXEC sp_attach_schedule
    @job_name = 'Update Trainer Ratings',
    @schedule_name = 'Weekly Rating Update';

EXEC sp_add_jobserver
    @job_name = 'Update Trainer Ratings';
GO
