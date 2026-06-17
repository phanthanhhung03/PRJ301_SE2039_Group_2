-- =========================================
-- PROMOTIONS
-- =========================================

INSERT INTO Promotions
(
    AdminID,
    PromotionName,
    Description,
    DiscountPercent,
    BonusPoints,
    StartDate,
    EndDate,
    Status
)
VALUES
(
    1,
    N'Silver+ Summer Sale',
    N'10% off for Silver and above',
    10,
    0,
    '2026-06-01',
    '2026-06-30',
    1
),
(
    1,
    N'VIP Platinum Reward',
    N'Free wash for Platinum members',
    100,
    0,
    '2026-07-01',
    '2026-07-31',
    1
),
(
    1,
    N'Premium Member Day',
    N'Bonus points for Gold and Platinum',
    0,
    300,
    '2026-08-01',
    '2026-08-15',
    1
),
(
    1,
    N'Welcome Campaign',
    N'5% discount for new members',
    5,
    0,
    '2026-06-01',
    '2026-12-31',
    1
);

-- =========================================
-- PROMOTION TIERS
-- TierID:
-- 1 = Member
-- 2 = Silver
-- 3 = Gold
-- 4 = Platinum
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