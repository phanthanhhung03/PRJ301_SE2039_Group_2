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

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "INSERT INTO Promotions "
                        + "(AdminID, PromotionName, Description, "
                        + "DiscountPercent, BonusPoints, StartDate, EndDate, Status, TargetType) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

                st = cn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

                st.setInt(1, p.getAdminID());
                st.setString(2, p.getPromotionName());
                st.setString(3, p.getDescription());
                st.setDouble(4, p.getDiscountPercent());
                st.setInt(5, p.getBonusPoints());
                st.setDate(6, p.getStartDate());
                st.setDate(7, p.getEndDate());
                st.setBoolean(8, p.isStatus());
                st.setString(9, p.getTargetType());

                int affectedRows = st.executeUpdate();

                if (affectedRows > 0) {
                    rs = st.getGeneratedKeys();
                    if (rs.next()) {
                        return rs.getInt(1); // PromotionID has been generated
                    }
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

        return 0;
    }

    public int updatePromotion(Promotion p) {

        int result = 0;

        try {

            Connection cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "UPDATE Promotions SET "
                        + "PromotionName = ?, "
                        + "Description = ?, "
                        + "DiscountPercent = ?, "
                        + "BonusPoints = ?, "
                        + "StartDate = ?, "
                        + "EndDate = ?, "
                        + "Status = ?, "
                        + "TargetType = ? "
                        + "WHERE PromotionID = ?";

                PreparedStatement st = cn.prepareStatement(sql);

                st.setString(1, p.getPromotionName());
                st.setString(2, p.getDescription());
                st.setDouble(3, p.getDiscountPercent());
                st.setInt(4, p.getBonusPoints());
                st.setDate(5, p.getStartDate());
                st.setDate(6, p.getEndDate());
                st.setBoolean(7, p.isStatus());
                st.setString(8, p.getTargetType());
                st.setInt(9, p.getPromotionID());

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

                String sql = "UPDATE Promotions SET IsDeleted = 1 WHERE PromotionID = ?";

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
                        + "WHERE IsDeleted = 0 "
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

                    p.setTargetType(rs.getString("TargetType"));

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
                    p.setTargetType(rs.getString("TargetType"));
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

    // Checking if Promo is outdated or start soon ?
    public boolean isPromotionValid(int promotionID) {

        Promotion p = getPromotionByID(promotionID);
        if (p == null) {
            return false;
        }

        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());

        // must be active flag
        if (!p.isStatus()) {
            return false;
        }

        //  chưa tới ngày bắt đầu
        if (p.getStartDate() != null && p.getStartDate().after(today)) {
            return false;
        }

        //  đã hết hạn
        if (p.getEndDate() != null && p.getEndDate().before(today)) {
            return false;
        }

        return true;
    }

    public Promotion getValidPromotion(int promotionID) {

        if (!isPromotionValid(promotionID)) {
            return null;
        }
        

        return getPromotionByID(promotionID);
    }

    // Checking if customer suitable for promo
    public boolean isCustomerEligibleForPromotion(int customerID, int promotionID) {

        Promotion p = getPromotionByID(promotionID);
        if (p == null) {
            return false;
        }

        String type = p.getTargetType();

        // 1. ALL → luôn được
        if ("ALL".equals(type)) {
            return true;
        }

        // 2. TIER_ONLY → check tier mapping
        if ("TIER_ONLY".equals(type)) {
            return isCustomerEligibleByTier(customerID, promotionID);
        }

        // 3. LOW_ENGAGEMENT → check inactivity
        if ("LOW_ENGAGEMENT".equals(type)) {
            return isLowEngagement(customerID);
        }

        // 4. FIRST_TIME → never booking
        if ("FIRST_TIME".equals(type)) {
            return isFirstTimeCustomer(customerID);
        }

        return false;
    }

    // Checking if customer's tier meets the minimum tier required by promotion
    public boolean isCustomerEligibleByTier(int customerID, int promotionID) {
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            String sql
                    = "SELECT COUNT(*) "
                    + "FROM Customers c "
                    + "JOIN CustomerTiers custTier ON custTier.TierID = c.TierID "
                    + "JOIN PromotionTiers pt ON pt.PromotionID = ? "
                    + "JOIN CustomerTiers minTier ON minTier.TierID = pt.TierID "
                    + "WHERE c.CustomerID = ? "
                    + "AND custTier.PriorityLevel >= minTier.PriorityLevel";

            st = cn.prepareStatement(sql);
            st.setInt(1, promotionID);
            st.setInt(2, customerID);

            rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, rs);
        }

        return false;
    }

    // 1. Lấy danh sách Voucher hợp lệ theo Tier
    public List<Promotion> getActiveVouchersByTier(int tierID) { 
        List<Promotion> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT p.* FROM Promotions p " +
                             "JOIN PromotionTiers pt ON p.PromotionID = pt.PromotionID " +
                             "WHERE pt.TierID = ? AND p.Status = 1 " +
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
            closeAll(cn, st, rs);
        }
        return list;
    }
    
    // 2. Kiểm tra voucher khi booking
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
            closeAll(cn, st, rs);
        }
        return isValid;
    }

    // Checking is Low Engagement
    public boolean isLowEngagement(int customerID) {

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();

            String sql
                    = "SELECT c.CustomerID "
                    + "FROM Customers c "
                    + "LEFT JOIN Vehicles v ON v.CustomerID = c.CustomerID "
                    + "LEFT JOIN Bookings b ON b.VehicleID = v.VehicleID "
                    + "WHERE c.CustomerID = ? "
                    + "GROUP BY c.CustomerID "
                    + "HAVING MAX(b.BookingDate) IS NULL "
                    + "   OR MAX(b.BookingDate) < DATEADD(MONTH, -3, GETDATE())";

            st = cn.prepareStatement(sql);
            st.setInt(1, customerID);

            rs = st.executeQuery();

            return rs.next(); // có dòng => eligible

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, rs);
        }

        return false;
    }

    public boolean isFirstTimeCustomer(int customerID) {

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();

            String sql
                    = "SELECT 1 "
                    + "FROM Bookings b "
                    + "JOIN Vehicles v ON v.VehicleID = b.VehicleID "
                    + "WHERE v.CustomerID = ?";

            st = cn.prepareStatement(sql);
            st.setInt(1, customerID);

            rs = st.executeQuery();

            return !rs.next(); // không có dòng => chưa từng booking

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, rs);
        }

        return false;
    }
    // -----------------------------------------------------------------------
    // Helper: close JDBC resources safely
    // -----------------------------------------------------------------------
    private void closeAll(Connection cn, PreparedStatement st, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (cn != null) cn.close();
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
    }    
}
