ALTER TABLE Promotions
ADD TargetType VARCHAR(30) NOT NULL DEFAULT 'ALL';

-- Anh em chay cai o tren truoc roi moi update, vi neu khong thi se bi loi~
UPDATE Promotions
SET TargetType = 'ALL'
WHERE TargetType IS NULL;