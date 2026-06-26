;WITH CurrentMin AS (
    SELECT pt.PromotionID, MIN(ct.PriorityLevel) AS MinPriority
    FROM PromotionTiers pt
    JOIN CustomerTiers ct ON pt.TierID = ct.TierID
    GROUP BY pt.PromotionID
)
INSERT INTO PromotionTiers (PromotionID, TierID)
SELECT cm.PromotionID, ct2.TierID
FROM CurrentMin cm
JOIN CustomerTiers ct2 ON ct2.PriorityLevel >= cm.MinPriority
WHERE NOT EXISTS (
    SELECT 1 FROM PromotionTiers pt2
    WHERE pt2.PromotionID = cm.PromotionID AND pt2.TierID = ct2.TierID
);