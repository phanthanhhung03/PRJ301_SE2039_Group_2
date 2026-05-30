CREATE DATABASE AutoWashProDB;
GO

USE AutoWashProDB;
GO

-- =========================================
-- TABLE: CustomerTiers
-- =========================================

CREATE TABLE CustomerTiers
(
    TierID INT PRIMARY KEY IDENTITY(1,1),

    TierName NVARCHAR(50) NOT NULL UNIQUE,

    MinBookings INT NOT NULL DEFAULT 0,

    MinSpend DECIMAL(12,2) NOT NULL DEFAULT 0,

    PointMultiplier DECIMAL(5,2) NOT NULL DEFAULT 1.0,

    DiscountPercent DECIMAL(5,2) NOT NULL DEFAULT 0,

    PriorityLevel INT NOT NULL DEFAULT 1,

    BookingWindowDays INT NOT NULL DEFAULT 7,

    CreatedAt DATETIME DEFAULT GETDATE(),

    CHECK (PointMultiplier >= 1),
    CHECK (DiscountPercent BETWEEN 0 AND 100)
);

-- =========================================
-- TABLE: Admins
-- =========================================

CREATE TABLE Admins
(
    AdminID INT PRIMARY KEY IDENTITY(1,1),

    FullName NVARCHAR(100) NOT NULL,

    Email VARCHAR(100) NOT NULL UNIQUE,

    Password NVARCHAR(255) NOT NULL,

    Status BIT DEFAULT 1,

    CreatedAt DATETIME DEFAULT GETDATE()
);

-- =========================================
-- TABLE: Customers
-- =========================================

CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY IDENTITY(1,1),

    FullName NVARCHAR(100) NOT NULL,

    PhoneNumber VARCHAR(15) NOT NULL UNIQUE,

    Email NVARCHAR(100) UNIQUE,

    Password NVARCHAR(255) NOT NULL,

    Address NVARCHAR(255),

    TierID INT DEFAULT 1,

    CurrentPoints INT DEFAULT 0,

    TotalBookings INT DEFAULT 0,

    TotalSpend DECIMAL(12,2) DEFAULT 0,

    Status BIT DEFAULT 1,

    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Customers_CustomerTiers
    FOREIGN KEY (TierID)
    REFERENCES CustomerTiers(TierID),

    CHECK (CurrentPoints >= 0),
    CHECK (TotalBookings >= 0),
    CHECK (TotalSpend >= 0)
);

-- =========================================
-- TABLE: Vehicles
-- =========================================

CREATE TABLE Vehicles
(
    VehicleID INT PRIMARY KEY IDENTITY(1,1),

    CustomerID INT NOT NULL,

    LicensePlate VARCHAR(20) NOT NULL UNIQUE,

    Brand NVARCHAR(50),

    Model NVARCHAR(50),

    Color NVARCHAR(30),

    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Vehicles_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)
);

-- =========================================
-- TABLE: Bookings
-- =========================================

CREATE TABLE Bookings
(
    BookingID INT PRIMARY KEY IDENTITY(1,1),

    VehicleID INT NOT NULL,

    BookingDate DATETIME NOT NULL,

    ServiceType NVARCHAR(100) NOT NULL,

    BookingStatus NVARCHAR(20) DEFAULT 'Pending',

    Notes NVARCHAR(255),

    TotalAmount DECIMAL(12,2) NOT NULL,

    DiscountAmount DECIMAL(12,2) DEFAULT 0,

    FinalAmount DECIMAL(12,2) NOT NULL,

    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Bookings_Vehicles
    FOREIGN KEY (VehicleID)
    REFERENCES Vehicles(VehicleID),

    CHECK (TotalAmount >= 0),
    CHECK (DiscountAmount >= 0),
    CHECK (FinalAmount >= 0)
);

-- =========================================
-- TABLE: PointTransactions
-- =========================================

CREATE TABLE PointTransactions
(
    PointTransactionID INT PRIMARY KEY IDENTITY(1,1),

    CustomerID INT NOT NULL,

    BookingID INT NULL,

    PointsChanged INT NOT NULL,

    TransactionType NVARCHAR(20) NOT NULL,

    ExpiryDate DATETIME NULL,

    Description NVARCHAR(255),

    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_PointTransactions_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID),

    CONSTRAINT FK_PointTransactions_Bookings
    FOREIGN KEY (BookingID)
    REFERENCES Bookings(BookingID)
);

-- =========================================
-- SAMPLE DATA
-- =========================================

-- Customer Tiers

INSERT INTO CustomerTiers
(
    TierName,
    MinBookings,
    MinSpend,
    PointMultiplier,
    DiscountPercent,
    PriorityLevel,
    BookingWindowDays
)
VALUES
('Member', 0, 0, 1.0, 0, 1, 7),
('Silver', 5, 2000000, 1.1, 5, 2, 10),
('Gold', 15, 6000000, 1.2, 10, 3, 12),
('Platinum', 30, 15000000, 1.3, 15, 4, 14);

-- Admin

INSERT INTO Admins
(
    FullName,
    Email,
    Password
)
VALUES
(
    N'System Administrator',
    'admin@autowashpro.com',
    '123456'
);

-- Customers

INSERT INTO Customers
(
    FullName,
    PhoneNumber,
    Email,
    Password,
    Address,
    TierID,
    CurrentPoints,
    TotalBookings,
    TotalSpend,
    Status
)
VALUES
(
    N'Nguyen Van A',
    '0901234567',
    'vana@gmail.com',
    '123456',
    N'Ho Chi Minh City',
    1,
    100,
    2,
    500000,
    1
),
(
    N'Tran Thi B',
    '0912345678',
    'thib@gmail.com',
    '123456',
    N'Ha Noi',
    2,
    350,
    7,
    2500000,
    1
),
(
    N'Le Van C',
    '0933333333',
    'levanc@gmail.com',
    '123456',
    N'Da Nang',
    3,
    850,
    18,
    7500000,
    1
),
(
    N'Pham Thi D',
    '0944444444',
    'phamd@gmail.com',
    '123456',
    N'Can Tho',
    4,
    2500,
    35,
    18000000,
    1
),
(
    N'Hoang Van E',
    '0955555555',
    'hoange@gmail.com',
    '123456',
    N'Binh Duong',
    1,
    0,
    0,
    0,
    0
);

-- Vehicles

INSERT INTO Vehicles
(
    CustomerID,
    LicensePlate,
    Brand,
    Model,
    Color
)
VALUES
(1, '59A-12345', 'Toyota', 'Vios', 'White'),
(1, '59A-67890', 'Kia', 'K3', 'Red'),
(2, '51G-88888', 'Honda', 'City', 'Black'),
(3, '43A-11111', 'Mazda', 'CX5', 'Gray'),
(4, '65A-22222', 'Mercedes', 'C300', 'White'),
(4, '65A-33333', 'BMW', 'X5', 'Black');

-- Bookings

INSERT INTO Bookings
(
    VehicleID,
    BookingDate,
    ServiceType,
    BookingStatus,
    Notes,
    TotalAmount,
    DiscountAmount,
    FinalAmount
)
VALUES
(
    1,
    '2026-05-30 09:00:00',
    N'Premium Wash',
    'Completed',
    N'Wash and wax',
    300000,
    0,
    300000
),
(
    3,
    '2026-05-31 14:00:00',
    N'Basic Wash',
    'Pending',
    N'Customer waits at station',
    150000,
    7500,
    142500
),
(
    4,
    '2026-06-01 08:00:00',
    N'Interior Cleaning',
    'Completed',
    N'Full interior cleaning',
    500000,
    25000,
    475000
),
(
    5,
    '2026-06-02 10:00:00',
    N'Ceramic Coating',
    'Pending',
    N'Premium package',
    2000000,
    300000,
    1700000
),
(
    6,
    '2026-06-03 15:00:00',
    N'Basic Wash',
    'Cancelled',
    N'Customer cancelled',
    150000,
    0,
    150000
);

-- Point Transactions

INSERT INTO PointTransactions
(
    CustomerID,
    BookingID,
    PointsChanged,
    TransactionType,
    ExpiryDate,
    Description
)
VALUES
(
    1,
    1,
    100,
    'Earned',
    DATEADD(YEAR,1,GETDATE()),
    N'Earned from booking'
),
(
    2,
    2,
    -50,
    'Redeemed',
    NULL,
    N'Used points for discount'
),
(
    3,
    3,
    200,
    'Earned',
    DATEADD(YEAR,1,GETDATE()),
    N'Interior cleaning reward'
),
(
    4,
    4,
    500,
    'Earned',
    DATEADD(YEAR,1,GETDATE()),
    N'VIP customer reward'
),
(
    4,
    4,
    -300,
    'Redeemed',
    NULL,
    N'Redeemed points for promotion'
);

-- =========================================
-- TEST QUERIES
-- =========================================

SELECT * FROM CustomerTiers;
SELECT * FROM Admins;
SELECT * FROM Customers;
SELECT * FROM Vehicles;
SELECT * FROM Bookings;
SELECT * FROM PointTransactions;