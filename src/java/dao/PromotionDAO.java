/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.CustomerTier;
import dto.Promotion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class PromotionDAO {

    public int createPromotion(Promotion p) {

        int result = 0;

        Connection cn = null;
        PreparedStatement st = null;

        try {

            cn = DBUtils.getConnection();
            if (cn != null) {

                String sql
                        = "INSERT INTO Promotions "
                        + "(AdminID, PromotionName, Description, "
                        + "DiscountPercent, BonusPoints, "
                        + "StartDate, EndDate, Status) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                st = cn.prepareStatement(sql);

                st.setInt(1, p.getAdminID());
                st.setString(2, p.getPromotionName());
                st.setString(3, p.getDescription());
                st.setDouble(4, p.getDiscountPercent());
                st.setInt(5, p.getBonusPoints());
                st.setDate(6, p.getStartDate());
                st.setDate(7, p.getEndDate());
                st.setBoolean(8, p.isStatus());

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

    public int updatePromotion(Promotion p) {

        int result = 0;

        try {

            Connection cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "UPDATE Promotions "
                        + "SET PromotionName = ?, "
                        + "Description = ?, "
                        + "DiscountPercent = ?, "
                        + "BonusPoints = ?, "
                        + "StartDate = ?, "
                        + "EndDate = ?, "
                        + "Status = ? "
                        + "WHERE PromotionID = ?";

                PreparedStatement st = cn.prepareStatement(sql);

                st.setString(1, p.getPromotionName());
                st.setString(2, p.getDescription());
                st.setDouble(3, p.getDiscountPercent());
                st.setInt(4, p.getBonusPoints());
                st.setDate(5, p.getStartDate());
                st.setDate(6, p.getEndDate());
                st.setBoolean(7, p.isStatus());
                st.setInt(8, p.getPromotionID());

                result = st.executeUpdate();

                st.close();
                cn.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public int deletePromotion(int promotionID) {

        int result = 0;

        try {

            Connection cn = DBUtils.getConnection();

            if (cn != null) {

                String sql = "DELETE FROM Promotions " + "WHERE PromotionID = ?";

                PreparedStatement st = cn.prepareStatement(sql);

                st.setInt(1, promotionID);
                result = st.executeUpdate();

                st.close();
                cn.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public List<Promotion> getAllPromotions() {

        List<Promotion> list = new ArrayList<>();

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "SELECT * "
                        + "FROM Promotions "
                        + "ORDER BY CreatedAt DESC";

                st = cn.prepareStatement(sql);

                rs = st.executeQuery();

                while (rs.next()) {

                    Promotion p = new Promotion();

                    p.setPromotionID(rs.getInt("PromotionID"));
                    p.setAdminID(rs.getInt("AdminID"));
                    p.setPromotionName(rs.getString("PromotionName"));
                    p.setDescription(rs.getString("Description"));

                    p.setDiscountPercent(rs.getDouble("DiscountPercent"));

                    p.setBonusPoints(rs.getInt("BonusPoints"));

                    p.setStartDate(rs.getDate("StartDate"));

                    p.setEndDate(rs.getDate("EndDate"));

                    p.setStatus(rs.getBoolean("Status"));

                    p.setCreatedAt(rs.getDate("CreatedAt"));

                    list.add(p);
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

    public Promotion getPromotionByID(int promotionID) {

        Promotion p = null;

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "SELECT * "
                        + "FROM Promotions "
                        + "WHERE PromotionID = ?";

                st = cn.prepareStatement(sql);

                st.setInt(1, promotionID);

                rs = st.executeQuery();

                if (rs.next()) {

                    p = new Promotion();

                    p.setPromotionID(rs.getInt("PromotionID"));
                    p.setAdminID(rs.getInt("AdminID"));
                    p.setPromotionName(rs.getString("PromotionName"));
                    p.setDescription(rs.getString("Description"));

                    p.setDiscountPercent(
                            rs.getDouble("DiscountPercent"));

                    p.setBonusPoints(
                            rs.getInt("BonusPoints"));

                    p.setStartDate(
                            rs.getDate("StartDate"));

                    p.setEndDate(
                            rs.getDate("EndDate"));

                    p.setStatus(
                            rs.getBoolean("Status"));

                    p.setCreatedAt(
                            rs.getDate("CreatedAt"));
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

        return p;
    }
    
    
    // 
        public List<Promotion> getActiveVouchersByTier(int tierID) { 
        List<Promotion> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Join Promotions với PromotionTiers để lọc theo TierID
                String sql = "SELECT p.* FROM Promotions p " +
                             "JOIN PromotionTiers pt ON p.PromotionID = pt.PromotionID " +
                             "WHERE pt.TierID = ? " +
                             "AND p.Status = 1 " +
                             "AND CAST(GETDATE() AS DATE) BETWEEN p.StartDate AND p.EndDate";

                st = cn.prepareStatement(sql);
                st.setInt(1, tierID); 
                
                rs = st.executeQuery();

                while (rs.next()) {
                    Promotion p = new Promotion();
                    p.setPromotionID(rs.getInt("PromotionID"));
                    p.setPromotionName(rs.getString("PromotionName"));
                    p.setDescription(rs.getString("Description"));
                    p.setDiscountPercent(rs.getDouble("DiscountPercent"));
                    p.setBonusPoints(rs.getInt("BonusPoints"));
                    // Map thêm các trường khác để đối tượng Promotion đầy đủ dữ liệu
                    p.setAdminID(rs.getInt("AdminID"));
                    p.setStartDate(rs.getDate("StartDate"));
                    p.setEndDate(rs.getDate("EndDate"));
                    p.setStatus(rs.getBoolean("Status"));
                    p.setCreatedAt(rs.getDate("CreatedAt"));
                    
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list;
    }
    
    // check voucher khi booking
    public boolean isVoucherValidForTier(int promotionID, int tierID) {
        boolean isValid = false;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT 1 FROM PromotionTiers WHERE PromotionID = ? AND TierID = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, promotionID);
                st.setInt(2, tierID);
                rs = st.executeQuery();
                if (rs.next()) {
                    isValid = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return isValid;
    }
}
