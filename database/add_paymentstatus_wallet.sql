-- 1. Thêm c?t WalletBalance vào b?ng Customers (ki?u s? th?c, m?c ??nh là 0)
ALTER TABLE Customers 
ADD WalletBalance FLOAT DEFAULT 0;

-- 2. Thêm c?t PaymentStatus vào b?ng Bookings (ki?u BIT t??ng ???ng boolean, m?c ??nh là 0 - Ch?a thanh toán)
ALTER TABLE Bookings 
ADD PaymentStatus BIT DEFAULT 1;

-- (Tùy ch?n) C?p nh?t l?i các d? li?u c? ?ang b? NULL thành 0 ?? tránh l?i hi?n th? sau này
UPDATE Customers SET WalletBalance = 0 WHERE WalletBalance IS NULL;
UPDATE Bookings SET PaymentStatus = 0 WHERE PaymentStatus IS NULL;
