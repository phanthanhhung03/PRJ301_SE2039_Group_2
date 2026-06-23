
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
    TierID INT NOT NULL,
    CurrentPoints INT DEFAULT 0,
    TotalBookings INT DEFAULT 0,
    TotalSpend DECIMAL(12,2) DEFAULT 0,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Customers_CustomerTiers
        FOREIGN KEY (TierID) REFERENCES CustomerTiers(TierID),

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
    Status BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Vehicles_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
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
    TimeSlot VARCHAR(10) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Bookings_Vehicles
        FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),

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
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_PointTransactions_Bookings
        FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- =========================================
-- TABLE: Promotions  
-- =========================================
CREATE TABLE Promotions
(
    PromotionID INT PRIMARY KEY IDENTITY(1,1),
    AdminID INT NOT NULL,
    PromotionName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    DiscountPercent DECIMAL(5,2) DEFAULT 0,
    BonusPoints INT DEFAULT 0,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    Status BIT DEFAULT 1,
    TargetType VARCHAR(30) NOT NULL DEFAULT 'ALL',
    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Promotions_Admins
        FOREIGN KEY (AdminID) REFERENCES Admins(AdminID),

    CHECK (DiscountPercent BETWEEN 0 AND 100),
    CHECK (BonusPoints >= 0)
);

-- =========================================
-- TABLE: PromotionTiers
-- =========================================
CREATE TABLE PromotionTiers
(
    PromotionID INT NOT NULL,
    TierID INT NOT NULL,

    PRIMARY KEY (PromotionID, TierID),

    CONSTRAINT FK_PromotionTiers_Promotions
        FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    CONSTRAINT FK_PromotionTiers_CustomerTiers
        FOREIGN KEY (TierID) REFERENCES CustomerTiers(TierID)
);

-- =========================================
-- TABLE: CustomerPromotions
-- =========================================
CREATE TABLE CustomerPromotions
(
    CustomerPromotionID INT PRIMARY KEY IDENTITY(1,1),
    PromotionID INT NOT NULL,
    CustomerID INT NOT NULL,
    AssignedDate DATETIME DEFAULT GETDATE(),
    IsUsed BIT NOT NULL DEFAULT 0,
    UsedDate DATETIME NULL,
    Notes NVARCHAR(255),
    IsDeleted BIT DEFAULT 0,

    CONSTRAINT FK_CustomerPromotions_Promotions
        FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    CONSTRAINT FK_CustomerPromotions_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

/* =========================================================================
   SAMPLE DATA
   ========================================================================= */

-- =========================================
-- CustomerTiers
-- =========================================
INSERT INTO CustomerTiers
(TierName, MinBookings, MinSpend, PointMultiplier, DiscountPercent, PriorityLevel, BookingWindowDays)
VALUES
('Member',   0,  0,        1.0, 0,  1, 7),
('Silver',   5,  2000000,  1.1, 5,  2, 10),
('Gold',     15, 6000000,  1.2, 10, 3, 12),
('Platinum', 30, 15000000, 1.3, 15, 4, 14);

-- =========================================
-- Admins
-- =========================================
INSERT INTO Admins (FullName, Email, Password)
VALUES (N'System Administrator', 'admin@autowashpro.com', '123456');

-- =========================================
-- Customers (20 khách hàng, CustomerID 1-20 theo thứ tự insert)
-- 1-5  : dữ liệu gốc (AutoWashProDB.sql)
-- 6-15 : dữ liệu testcase cũ 
-- 16-20: thêm mới để bao các case biên
-- =========================================
INSERT INTO Customers
(FullName, PhoneNumber, Email, Password, Address, TierID, CurrentPoints, TotalBookings, TotalSpend, Status, CreatedAt)
VALUES
-- 1-5: gốc
(N'Nguyen Van A',  '0901234567', 'vana@gmail.com',    '123456', N'Ho Chi Minh City', 1, 100,  2,  500000,    1, '2026-01-10 09:00:00.000'),
(N'Tran Thi B',    '0912345678', 'thib@gmail.com',    '123456', N'Ha Noi',           2, 350,  7,  2500000,   1, '2026-01-15 09:00:00.000'),
(N'Le Van C',      '0933333333', 'levanc@gmail.com',  '123456', N'Da Nang',          3, 850,  18, 7500000,   1, '2026-01-20 09:00:00.000'),
(N'Pham Thi D',    '0944444444', 'phamd@gmail.com',   '123456', N'Can Tho',          4, 2500, 35, 18000000,  1, '2026-01-25 09:00:00.000'),
(N'Hoang Van E',   '0955555555', 'hoange@gmail.com',  '123456', N'Binh Duong',       1, 0,    0,  0,         0, '2026-02-01 09:00:00.000'), -- inactive, chưa có booking

-- 6-15: testcase cũ
(N'Nguyen Van Huy',   '0907737777', 'huy@gmail.com',   '123456', N'District 7',   2, 120,  4,  1200000.00,  1, '2025-02-10 10:00:00.000'),
(N'Tran Minh Khang',  '0908488888', 'khang@gmail.com', '123456', N'Go Vap',       1, 10,   1,  100000.00,   1, '2025-03-15 10:00:00.000'),
(N'Le Thi Mai',       '0909979999', 'mai@gmail.com',   '123456', N'District 1',   4, 5000, 60, 50000000.00, 1, '2025-01-01 10:00:00.000'),
(N'Pham Quoc Dat',    '0911118111', 'dat@gmail.com',   '123456', N'Binh Thanh',   3, 600,  22, 9000000.00,  1, '2025-06-01 10:00:00.000'),
(N'Vo Thi Loan',      '0922222622', 'loan@gmail.com',  '123456', N'Thu Duc',      4, 800,  5,  3000000.00,  1, '2024-12-01 10:00:00.000'), -- tier4 nhưng chỉ 5 booking/3tr -> chưa đủ chuẩn Platinum (case lệch tier do admin set tay)
(N'Do Van Phuc',      '0933333331', 'phuc@gmail.com',  '123456', N'Tan Phu',      1, 0,    0,  0.00,        1, '2026-06-10 10:00:00.000'), -- khách mới, CHƯA có xe nào
(N'Nguyen Bao Tran',  '0944444414', 'tran@gmail.com',  '123456', N'Can Tho',      2, 200,  6,  2000000.00,  0, '2025-08-01 10:00:00.000'), -- bị khóa (Status = 0)
(N'Huynh Gia Bao',    '0955555355', 'bao@gmail.com',   '123456', N'Da Nang',      3, 150,  3,  800000.00,   1, '2025-04-01 10:00:00.000'), -- tier3 nhưng chỉ 3 booking/800k -> lệch chuẩn
(N'Tran Anh Tuan',    '0966166666', 'tuan@gmail.com',  '123456', N'HCMC',         3, 900,  30, 12000000.00, 1, '2025-05-20 10:00:00.000'),
(N'Le Van Dong',      '0977277777', 'dong@gmail.com',  '123456', N'Long An',      1, 50,   2,  500000.00,   1, '2024-06-01 10:00:00.000'),

-- 16-20: thêm mới cho các case biên
(N'Nguyen Thi Kim Ngan', '0988111111', NULL, '123456', N'Quan 3',  1, 0,    0,  0,        1, '2026-06-23 08:00:00.000'), -- Email NULL, khách mới hôm nay, chưa có xe
(N'Bui Van Thanh',       '0988222222', 'thanh.bui@gmail.com', '123456', N'Quan 10', 3, 3000, 30, 15000000.00, 1, '2025-09-01 10:00:00.000'), -- ĐỦ chuẩn Platinum (30 booking/15tr) nhưng vẫn đang ở Gold -> case "chờ nâng tier"
(N'Cao Thi Hoa',         '0988333333', 'hoa.cao@gmail.com',   '123456', N'Quan 5',  4, 1000, 10, 5000000.00,  0, '2025-10-15 10:00:00.000'), -- Platinum nhưng bị khóa account
(N'Đặng Thị Ngọc Phương Anh', '0988444444', 'phuonganh@gmail.com', '123456', N'Quan Phu Nhuan', 2, 300, 6, 2200000.00, 1, '2025-11-01 10:00:00.000'), -- tên dài + dấu đặc biệt
(N'Vu Minh Quang',       '0988555555', 'quang.vu@gmail.com',  '123456', N'Quan Binh Tan', 1, 200, 5, 2000000.00, 1, '2026-03-01 10:00:00.000'); -- ĐỦ chuẩn Silver (5 booking/2tr) nhưng vẫn ở Member -> case "chờ nâng tier"

-- =========================================
-- Vehicles (21 xe)
-- =========================================
INSERT INTO Vehicles (CustomerID, LicensePlate, Brand, Model, Color, Status)
VALUES
(1,  '59A-12345', 'Toyota',    'Vios',         'White',  1),
(1,  '59A-67890', 'Kia',       'K3',           'Red',    1),
(2,  '51G-88888', 'Honda',     'City',         'Black',  1),
(3,  '43A-11111', 'Mazda',     'CX5',          'Gray',   1),
(4,  '65A-22222', 'Mercedes',  'C300',         'White',  1),
(4,  '65A-33333', 'BMW',       'X5',           'Black',  1),
(6,  '59B-10001', 'Honda',     'Civic',        'Blue',   1),
(7,  '59B-10002', NULL,        NULL,           NULL,     1), -- thiếu thông tin brand/model/color (data cũ chưa cập nhật)
(8,  '51F-20003', 'Mercedes',  'S450',         'Black',  1),
(8,  '51F-20004', 'Lexus',     'LX600',        'White',  1), -- khách 8 (Mai) có 2 xe
(9,  '43C-30005', 'Ford',      'Ranger',       'Black',  1),
(10, '72D-40006', 'Hyundai',   'Accent',       'Red',    1),
(12, '65E-50007', 'Toyota',    'Camry',        'White',  1), -- thuộc khách đang bị khóa (12)
(13, '59F-60008', 'Kia',       'Morning',      'Gray',   0), -- xe ngừng hoạt động (Status = 0)
(14, '51G-70009', 'VinFast',   'VF8',          'Blue',   1),
(14, '51G-70010', 'Honda',     'CRV',          'Black',  1), -- khách 14 (Tuan) có 2 xe
(15, '93H-80011', 'Suzuki',    'Swift',        'Yellow', 1),
(17, '59K-90012', 'Mercedes',  'GLC',          'White',  1), -- khách 17 (Thanh, chờ nâng Platinum)
(18, '51L-10013', 'BMW',       '730Li',        'Black',  1), -- khách 18 (Hoa, Platinum nhưng bị khóa)
(19, '59M-20014', 'Toyota',    'CorollaCross', 'Silver', 1), -- khách 19 (Phuong Anh)
(20, '43N-30015', 'Mazda',     '3',            'Red',    1); -- khách 20 (Quang, chờ nâng Silver)

-- =========================================
-- Bookings (22 booking, VehicleID 1-21 theo thứ tự tạo ở trên)
-- =========================================
INSERT INTO Bookings (VehicleID, BookingDate, ServiceType, BookingStatus, Notes, TotalAmount, DiscountAmount, FinalAmount, TimeSlot)
VALUES
(1,  '2026-05-30 09:00:00', N'Premium Wash',      'Completed', N'Wash and wax',                              300000,  0,       300000,  '09:00'),
(3,  '2026-05-31 14:00:00', N'Basic Wash',        'Pending',   N'Customer waits at station',                 150000,  7500,    142500,  '14:00'),
(4,  '2026-06-01 08:00:00', N'Interior Cleaning', 'Completed', N'Full interior cleaning',                     500000,  25000,   475000,  '08:00'),
(5,  '2026-06-02 10:00:00', N'Ceramic Coating',   'Pending',   N'Premium package',                            2000000, 300000,  1700000, '10:00'),
(6,  '2026-06-03 15:00:00', N'Basic Wash',        'Cancelled', N'Customer cancelled',                         150000,  0,       150000,  '15:00'),
(2,  '2026-06-05 09:00:00', N'Basic Wash',        'Completed', NULL,                                          150000,  0,       150000,  '09:00'), -- Notes NULL
(7,  '2026-06-06 10:00:00', N'Premium Wash',      'Completed', N'Regular customer',                          300000,  30000,   270000,  '10:00'),
(8,  '2026-06-07 11:00:00', N'Basic Wash',        'Pending',   N'New plate, no brand info',                   150000,  0,       150000,  NULL),    -- TimeSlot NULL (data nhập trước khi có cột này)
(9,  '2026-06-08 08:00:00', N'Ceramic Coating',   'Completed', N'VIP service',                                2500000, 375000,  2125000, '08:00'),
(10, '2026-06-09 13:00:00', N'Interior Cleaning', 'Pending',   N'Second car of same owner',                   500000,  50000,   450000,  '13:00'),
(11, '2026-06-10 09:00:00', N'Basic Wash',        'Completed', N'Pickup truck',                               180000,  0,       180000,  '09:00'),
(12, '2026-06-11 14:00:00', N'Premium Wash',      'Cancelled', N'Rescheduled later',                          300000,  0,       300000,  '14:00'),
(13, '2026-06-12 10:00:00', N'Basic Wash',        'Completed', N'Owned by locked customer account',           150000,  0,       150000,  '10:00'),
(14, '2026-06-13 09:00:00', N'Basic Wash',        'Completed', N'Old booking before car was decommissioned',  150000,  0,       150000,  '09:00'),
(15, '2026-06-14 08:00:00', N'Premium Wash',      'Pending',   N'EV detailing',                               350000,  0,       350000,  '08:00'),
(16, '2026-06-15 09:00:00', N'Interior Cleaning', 'Completed', NULL,                                          500000,  0,       500000,  '09:00'),
(17, '2026-06-16 10:00:00', N'Basic Wash',        'Pending',   N'Compact car',                                150000,  0,       150000,  '10:00'),
(18, '2026-07-01 09:00:00', N'Ceramic Coating',   'Pending',   N'Platinum 100% free-wash promo applied',      2000000, 2000000, 0,       '09:00'), -- FinalAmount = 0
(19, '2026-07-02 11:00:00', N'Premium Wash',      'Pending',   N'Locked account but vehicle still listed',    300000,  0,       300000,  '11:00'),
(20, '2026-07-03 14:00:00', N'Basic Wash',        'Completed', N'Diacritics name test booking',               150000,  0,       150000,  '14:00'),
(21, '2026-07-04 16:00:00', N'Premium Wash',      'Pending',   N'Boundary Silver customer',                   300000,  15000,   285000,  '16:00'),
(1,  '2026-07-05 09:00:00', N'Basic Wash',        'Pending',   N'Repeat customer, second booking',            150000,  0,       150000,  '09:00');

-- =========================================
-- PointTransactions
-- =========================================
INSERT INTO PointTransactions (CustomerID, BookingID, PointsChanged, TransactionType, ExpiryDate, Description)
VALUES
(1,  1,    100,  'Earned',   DATEADD(YEAR,1,GETDATE()), N'Earned from booking'),
(2,  2,    -50,  'Redeemed', NULL,                      N'Used points for discount'),
(3,  3,    200,  'Earned',   DATEADD(YEAR,1,GETDATE()), N'Interior cleaning reward'),
(4,  4,    500,  'Earned',   DATEADD(YEAR,1,GETDATE()), N'VIP customer reward'),
(4,  4,    -300, 'Redeemed', NULL,                      N'Redeemed points for promotion'),
(6,  7,    30,   'Earned',   DATEADD(YEAR,1,GETDATE()), N'Earned from premium wash'),
(8,  9,    250,  'Earned',   DATEADD(YEAR,1,GETDATE()), N'Earned from ceramic coating'),
(17, 18,   0,    'Earned',   DATEADD(YEAR,1,GETDATE()), N'Promo booking - 100% discount, no points earned'), -- case 0 điểm
(16, NULL, 50,   'Bonus',    DATEADD(YEAR,1,GETDATE()), N'Welcome bonus, not tied to any booking'),          -- case BookingID NULL
(1,  22,   0,    'Earned',   NULL,                      N'Booking still pending, points not awarded yet'),
(10, 12,   0,    'Adjusted', NULL,                      N'Reversed due to booking cancellation'),
(3,  NULL, -50,  'Expired',  '2026-01-01',               N'Points expired unused');                            -- case điểm hết hạn

-- =========================================
-- Promotions (TierID tham khảo: 1=Member, 2=Silver, 3=Gold, 4=Platinum)
-- =========================================
INSERT INTO Promotions (AdminID, PromotionName, Description, DiscountPercent, BonusPoints, StartDate, EndDate, Status, TargetType, IsDeleted)
VALUES
(1, N'Silver+ Summer Sale',     N'10% off for Silver and above',      10, 0,   '2026-06-01', '2026-06-30', 1, 'TIER',     0),
(1, N'VIP Platinum Reward',     N'Free wash for Platinum members',    100,0,   '2026-07-01', '2026-07-31', 1, 'TIER',     0),
(1, N'Premium Member Day',      N'Bonus points for Gold and Platinum',0, 300,  '2026-08-01', '2026-08-15', 1, 'TIER',     0),
(1, N'Welcome Campaign',        N'5% discount for new members',       5, 0,   '2026-06-01', '2026-12-31', 1, 'TIER',     0),
(1, N'Tet Holiday Mega Sale 2025', N'20% off Tet 2025 (đã hết hạn)',  20, 0,   '2025-01-20', '2025-02-10', 1, 'ALL',      1), -- hết hạn + đã soft-delete
(1, N'App Download Bonus',      N'5% off + 50 points for all customers, no tier restriction', 5, 50, '2026-01-01', '2026-12-31', 1, 'ALL', 0),
(1, N'VIP Birthday Surprise',   N'100 bonus points for individually targeted customers', 0, 100, '2026-01-01', '2026-12-31', 1, 'CUSTOMER', 0);

-- =========================================
-- PromotionTiers
-- (chỉ promotion dạng TIER mới có dòng ở đây; ALL/CUSTOMER không cần)
-- =========================================
-- Silver+
INSERT INTO PromotionTiers VALUES (1,2);
INSERT INTO PromotionTiers VALUES (1,3);
INSERT INTO PromotionTiers VALUES (1,4);
-- Platinum
INSERT INTO PromotionTiers VALUES (2,4);
-- Gold+
INSERT INTO PromotionTiers VALUES (3,3);
INSERT INTO PromotionTiers VALUES (3,4);
-- Member
INSERT INTO PromotionTiers VALUES (4,1);

-- =========================================
-- CustomerPromotions
-- =========================================
INSERT INTO CustomerPromotions (PromotionID, CustomerID, AssignedDate, IsUsed, UsedDate, Notes, IsDeleted)
VALUES
(2, 17, '2026-06-25 08:00:00', 1, '2026-07-01 09:00:00', N'Used for free wash on Booking #18', 0),
(7, 8,  '2026-06-20 08:00:00', 0, NULL,                  N'Birthday this month, not used yet', 0),
(5, 12, '2025-01-15 08:00:00', 0, NULL,                  N'Assigned Tet promo, customer is locked', 1), -- soft-deleted assignment
(6, 20, '2026-06-20 08:00:00', 1, '2026-07-04 16:00:00', N'Applied on Booking #21',             0),
(7, 17, '2026-06-25 08:00:00', 0, NULL,                  N'Second active promo assigned to same customer', 0);

-- =========================================
-- TEST QUERIES
-- =========================================
SELECT * FROM CustomerTiers;
SELECT * FROM Admins;
SELECT * FROM Customers;
SELECT * FROM Vehicles;
SELECT * FROM Bookings;
SELECT * FROM PointTransactions;
SELECT * FROM Promotions;
SELECT * FROM PromotionTiers;
SELECT * FROM CustomerPromotions;

-- Case kiểm tra nhanh: khách hàng đủ điều kiện nâng tier nhưng chưa được nâng
SELECT c.CustomerID, c.FullName, c.TierID AS CurrentTierID, t.TierName AS CurrentTier,
       c.TotalBookings, c.TotalSpend
FROM Customers c
JOIN CustomerTiers t ON c.TierID = t.TierID
WHERE EXISTS (
    SELECT 1 FROM CustomerTiers t2
    WHERE t2.MinBookings <= c.TotalBookings
      AND t2.MinSpend <= c.TotalSpend
      AND t2.PriorityLevel > t.PriorityLevel
);

-- Case kiểm tra nhanh: booking miễn phí 100% (FinalAmount = 0)
SELECT * FROM Bookings WHERE FinalAmount = 0;

-- Case kiểm tra nhanh: khách hàng chưa có xe nào
SELECT c.CustomerID, c.FullName
FROM Customers c
LEFT JOIN Vehicles v ON v.CustomerID = c.CustomerID
WHERE v.VehicleID IS NULL;