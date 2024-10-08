CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    role NVARCHAR(10) NOT NULL,
    location NVARCHAR(100) NOT NULL,
    gender NVARCHAR(10) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Clients (
    client_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE Trainers (
    trainer_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    bio NVARCHAR(MAX),
    specialisation NVARCHAR(100),
    rating DECIMAL(2, 1) CHECK (rating >= 0 AND rating <= 5),
    certification NVARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE Bookings (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    trainer_id INT NOT NULL,
    client_id INT NOT NULL,
    booking_date DATETIME,
    payment_method NVARCHAR(20),
    status NVARCHAR(20),
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);
CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_method NVARCHAR(50) NOT NULL,
    status NVARCHAR(20)NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);
CREATE TABLE Memberships (
    membership_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    membership_type NVARCHAR(20) CHECK (membership_type IN ('monthly', 'yearly')),
    status NVARCHAR(20) CHECK (status IN ('active', 'inactive')),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

CREATE TABLE Reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    trainer_id INT NOT NULL,
    client_id INT NOT NULL,
    review TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);





