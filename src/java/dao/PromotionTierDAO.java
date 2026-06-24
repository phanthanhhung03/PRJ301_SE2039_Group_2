/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class PromotionTierDAO {

    /*
     * Add Tier To Promotion
     */
    public int addTierToPromotion(int promotionID, int tierID) {

        int result = 0;

        Connection cn = null;
        PreparedStatement st = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "INSERT INTO PromotionTiers "
                        + "(PromotionID, TierID) "
                        + "VALUES (?, ?)";

                st = cn.prepareStatement(sql);

                st.setInt(1, promotionID);
                st.setInt(2, tierID);

                result = st.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            try {

                if (st != null) {
                    st.close();
                }

                if (cn != null) {
                    cn.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return result;
    }

    /*
     * Get All Tier IDs Of A Promotion
     */
    public List<Integer> getTierIDsByPromotion(int promotionID) {

        List<Integer> list = new ArrayList<>();

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "SELECT TierID "
                        + "FROM PromotionTiers "
                        + "WHERE PromotionID = ?";

                st = cn.prepareStatement(sql);

                st.setInt(1, promotionID);

                rs = st.executeQuery();

                while (rs.next()) {
                    list.add(rs.getInt("TierID"));
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            try {

                if (rs != null) {
                    rs.close();
                }

                if (st != null) {
                    st.close();
                }

                if (cn != null) {
                    cn.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return list;
    }

    /*
     * Delete All Tiers Of A Promotion
     */
    public int removePromotionTiers(int promotionID) {

        int result = 0;

        Connection cn = null;
        PreparedStatement st = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "DELETE FROM PromotionTiers "
                        + "WHERE PromotionID = ?";

                st = cn.prepareStatement(sql);

                st.setInt(1, promotionID);

                result = st.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            try {

                if (st != null) {
                    st.close();
                }

                if (cn != null) {
                    cn.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return result;
    }

    public String getTargetTierNames(int promotionID) {

        String tierName = "-";
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Chỉ lấy tier THẤP NHẤT (anchor tier) — vì giờ 1 promo "Silver+"
                // sẽ có nhiều dòng (Silver, Gold, Platinum) trong PromotionTiers,
                // hiển thị hết ra sẽ thành "Platinum, Gold, Silver+" rất rối.
                String sql = "SELECT TOP 1 ct.TierName "
                        + "FROM PromotionTiers pt "
                        + "JOIN CustomerTiers ct ON pt.TierID = ct.TierID "
                        + "WHERE pt.PromotionID = ? "
                        + "ORDER BY ct.PriorityLevel ASC";

                st = cn.prepareStatement(sql);
                st.setInt(1, promotionID);
                rs = st.executeQuery();

                if (rs.next()) {
                    tierName = rs.getString("TierName");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return tierName;
    }

    public void deleteTierMappingByPromotionID(int promotionID) {

        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {
                String sql = "DELETE FROM PromotionTiers WHERE PromotionID = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, promotionID);
                st.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /*
 * Set Minimum Tier For Promotion (xóa mapping cũ, chỉ insert 1 dòng minTierID)
     */
    public int setMinimumTier(int promotionID, int minTierID) {

        // Xóa mapping cũ trước (đảm bảo không lẫn dữ liệu cũ)
        deleteTierMappingByPromotionID(promotionID);

        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {

                // 1. Lấy tất cả TierID có PriorityLevel >= PriorityLevel của minTierID
                String sql = "SELECT TierID FROM CustomerTiers "
                        + "WHERE PriorityLevel >= ("
                        + "    SELECT PriorityLevel FROM CustomerTiers WHERE TierID = ?"
                        + ")";

                st = cn.prepareStatement(sql);
                st.setInt(1, minTierID);
                rs = st.executeQuery();

                List<Integer> eligibleTierIDs = new ArrayList<>();
                while (rs.next()) {
                    eligibleTierIDs.add(rs.getInt("TierID"));
                }
                rs.close();
                st.close();

                // 2. Insert 1 dòng cho MỖI tier hợp lệ (tier đó + mọi tier cao hơn)
                String insertSql = "INSERT INTO PromotionTiers (PromotionID, TierID) VALUES (?, ?)";
                st = cn.prepareStatement(insertSql);

                for (int tierID : eligibleTierIDs) {
                    st.setInt(1, promotionID);
                    st.setInt(2, tierID);
                    result += st.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return result;
    }

    /*
 * Get Minimum Tier ID Of A Promotion (trả về null nếu chưa gán)
     */
    public Integer getMinimumTierID(int promotionID) {

        Integer minTierID = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT TOP 1 pt.TierID "
                        + "FROM PromotionTiers pt "
                        + "JOIN CustomerTiers ct ON pt.TierID = ct.TierID "
                        + "WHERE pt.PromotionID = ? "
                        + "ORDER BY ct.PriorityLevel ASC";

                st = cn.prepareStatement(sql);
                st.setInt(1, promotionID);
                rs = st.executeQuery();

                if (rs.next()) {
                    minTierID = rs.getInt("TierID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return minTierID;
    }
}
