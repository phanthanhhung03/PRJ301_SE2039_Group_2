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
    Status,
    CreatedAt
)
VALUES
(
    N'Truong Van Loc',
    '0988666666',
    'loc.truong@gmail.com',
    '123456',
    N'Quan 7',
    3,                  -- Gold
    1200,
    25,
    11000000,
    1,
    '2024-01-10'
);
INSERT INTO Vehicles
(
    CustomerID,
    LicensePlate,
    Brand,
    Model,
    Color,
    Status
)
VALUES
(
    (SELECT CustomerID
     FROM Customers
     WHERE PhoneNumber = '0988666666'),
    '51Z-99999',
    'Toyota',
    'Fortuner',
    'Black',
    1
);
INSERT INTO Bookings
(
    VehicleID,
    BookingDate,
    ServiceType,
    BookingStatus,
    Notes,
    TotalAmount,
    DiscountAmount,
    FinalAmount,
    TimeSlot
)
VALUES
(
    (SELECT VehicleID
     FROM Vehicles
     WHERE LicensePlate = '51Z-99999'),
    '2025-01-15 09:00:00',
    N'Premium Wash',
    'Completed',
    N'Last booking long ago',
    350000,
    0,
    350000,
    '09:00'
);