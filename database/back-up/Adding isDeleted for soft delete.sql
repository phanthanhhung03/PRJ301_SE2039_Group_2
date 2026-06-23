ALTER TABLE Promotions
ADD IsDeleted BIT DEFAULT 0;
ALTER TABLE CustomerPromotions
ADD IsDeleted BIT DEFAULT 0;

-- Anh em chay cai o tren truoc roi moi update, vi neu khong thi se bi loi~
UPDATE Promotions
SET IsDeleted = 0
WHERE IsDeleted IS NULL;

