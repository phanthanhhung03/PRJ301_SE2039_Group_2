package dao;

import dbutils.DBUtils;
import dto.CustomerPromotion;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the CustomerPromotions table.
 *
 */
public class CustomerPromotionDAO {

    public int assignPromotion(int customerID, int promotionID, String notes) {

        // CHECK VALID DATE BEFORE ASSIGN
        PromotionDAO promotionDAO = new PromotionDAO();
        if (!promotionDAO.isPromotionValid(promotionID)) {
            return 0;
        }
        if (!promotionDAO.isCustomerEligibleForPromotion(customerID, promotionID)) {
            return 0;
        }
        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO CustomerPromotions "
                        + "(CustomerID, PromotionID, AssignedDate, IsUsed, Notes) "
                        + "VALUES (?, ?, GETDATE(), 0, ?)";

                st = cn.prepareStatement(sql);
                st.setInt(1, customerID);
                st.setInt(2, promotionID);
                st.setString(3, notes);

                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, null);
        }

        return result;
    }

    // Đánh dấu promotion đã được sử dụng bởi customer
    // Bước 1: Thử UPDATE nếu đã có record trong CustomerPromotions
    // Bước 2: Nếu chưa có record thì INSERT mới với IsUsed = 1
    public boolean markAsUsed(int customerID, int promotionID) {
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Bước 1: Thử UPDATE record có sẵn
                String updateSql = "UPDATE CustomerPromotions "
                        + "SET IsUsed = 1, UsedDate = GETDATE() "
                        + "WHERE CustomerID = ? AND PromotionID = ? AND IsDeleted = 0";
                st = cn.prepareStatement(updateSql);
                st.setInt(1, customerID);
                st.setInt(2, promotionID);
                int updated = st.executeUpdate();
                st.close();

                // Bước 2: Nếu không có record nào được UPDATE thì INSERT mới
                if (updated == 0) {
                    String insertSql = "INSERT INTO CustomerPromotions "
                            + "(CustomerID, PromotionID, AssignedDate, IsUsed, UsedDate, Notes) "
                            + "VALUES (?, ?, GETDATE(), 1, GETDATE(), 'Auto-recorded: used in booking')";
                    st = cn.prepareStatement(insertSql);
                    st.setInt(1, customerID);
                    st.setInt(2, promotionID);
                    st.executeUpdate();
                }

                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, null);
        }

        return false;
    }


    // Revoke an assignment
    public int revokeAssignment(int customerPromotionID) {

        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql = "UPDATE CustomerPromotions SET IsDeleted = 1 WHERE CustomerPromotionID = ?";

                st = cn.prepareStatement(sql);
                st.setInt(1, customerPromotionID);

                result = st.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, null);
        }

        return result;
    }

    public List<CustomerPromotion> getAllAssignments() {

        List<CustomerPromotion> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "SELECT cp.CustomerPromotionID, "
                        + "cp.CustomerID, "
                        + "cp.PromotionID, "
                        + "cp.AssignedDate, "
                        + "cp.IsUsed, "
                        + "cp.UsedDate, "
                        + "cp.Notes, "
                        + "c.FullName AS CustomerName, "
                        + "p.PromotionName, "
                        + "p.DiscountPercent "
                        + "FROM CustomerPromotions cp "
                        + "JOIN Customers c ON c.CustomerID = cp.CustomerID "
                        + "JOIN Promotions p ON p.PromotionID = cp.PromotionID "
                        + "WHERE cp.IsDeleted = 0 "
                        + "ORDER BY cp.AssignedDate DESC";

                st = cn.prepareStatement(sql);
                rs = st.executeQuery();

                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, rs);
        }

        return list;
    }

    public List<CustomerPromotion> getLowEngagementCustomers() {

        List<CustomerPromotion> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {

                String sql
                        = "SELECT c.CustomerID, "
                        + "c.FullName AS CustomerName, "
                        + "MAX(b.BookingDate) AS LastBookingDate "
                        + "FROM Customers c "
                        + "LEFT JOIN Vehicles v ON v.CustomerID = c.CustomerID "
                        + "LEFT JOIN Bookings b ON b.VehicleID = v.VehicleID "
                        + "WHERE c.CustomerID NOT IN ( "
                        + "    SELECT cp.CustomerID FROM CustomerPromotions cp "
                        + "    WHERE cp.IsDeleted = 0 "
                        + ") "
                        + "GROUP BY c.CustomerID, c.FullName "
                        + "HAVING MAX(b.BookingDate) IS NULL "
                        + "OR MAX(b.BookingDate) < DATEADD(MONTH, -3, GETDATE()) "
                        + "ORDER BY LastBookingDate ASC";

                st = cn.prepareStatement(sql);
                rs = st.executeQuery();

                while (rs.next()) {

                    CustomerPromotion cp = new CustomerPromotion();

                    cp.setCustomerID(rs.getInt("CustomerID"));
                    cp.setCustomerName(rs.getString("CustomerName"));

                    Date lastBooking = rs.getDate("LastBookingDate");
                    cp.setLastBookingDate(lastBooking);

                    list.add(cp);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, rs);
        }

        return list;
    }
// Lấy các voucher admin gán riêng cho khách, còn hiệu lực và chưa dùng

    public List<CustomerPromotion> getActiveAssignmentsForCustomer(int customerID) {
        List<CustomerPromotion> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT cp.CustomerPromotionID, cp.CustomerID, cp.PromotionID, "
                        + "cp.AssignedDate, cp.IsUsed, cp.UsedDate, cp.Notes, "
                        + "p.PromotionName, p.DiscountPercent "
                        + "FROM CustomerPromotions cp "
                        + "JOIN Promotions p ON p.PromotionID = cp.PromotionID "
                        + "WHERE cp.CustomerID = ? "
                        + "AND cp.IsDeleted = 0 "
                        + "AND cp.IsUsed = 0 "
                        + "AND p.IsDeleted = 0 "
                        + "AND p.Status = 1 "
                        + "AND CAST(GETDATE() AS DATE) BETWEEN p.StartDate AND p.EndDate "
                        + "ORDER BY cp.AssignedDate DESC";

                st = cn.prepareStatement(sql);
                st.setInt(1, customerID);
                rs = st.executeQuery();

                while (rs.next()) {
                    // Map thủ công, KHÔNG dùng mapRow() — vì query này không JOIN Customers,
                    // không có cột CustomerName, gọi mapRow() sẽ throw SQLException và nuốt mất kết quả
                    CustomerPromotion cp = new CustomerPromotion();
                    cp.setCustomerPromotionID(rs.getInt("CustomerPromotionID"));
                    cp.setCustomerID(rs.getInt("CustomerID"));
                    cp.setPromotionID(rs.getInt("PromotionID"));
                    cp.setAssignedDate(rs.getDate("AssignedDate"));
                    cp.setUsed(rs.getBoolean("IsUsed"));
                    cp.setUsedDate(rs.getDate("UsedDate"));
                    cp.setNotes(rs.getString("Notes"));
                    cp.setPromotionName(rs.getString("PromotionName"));
                    cp.setDiscountPercent(rs.getDouble("DiscountPercent"));
                    list.add(cp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, rs);
        }
        return list;
    }

// Check nhanh: khách này còn quyền dùng promo này không (đã được gán, chưa dùng)
    public boolean hasActiveAssignment(int customerID, int promotionID) {
        boolean exists = false;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT 1 FROM CustomerPromotions "
                        + "WHERE CustomerID = ? AND PromotionID = ? "
                        + "AND IsUsed = 0 AND IsDeleted = 0";

                st = cn.prepareStatement(sql);
                st.setInt(1, customerID);
                st.setInt(2, promotionID);
                rs = st.executeQuery();
                exists = rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(cn, st, rs);
        }
        return exists;
    }

// Đánh dấu đã dùng — gọi NGAY SAU khi tạo booking thành công với voucher gán riêng
    public boolean markAssignmentUsed(int customerID, int promotionID) {
        boolean check = false;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE TOP (1) CustomerPromotions "
                        + "SET IsUsed = 1, UsedDate = GETDATE() "
                        + "WHERE CustomerID = ? AND PromotionID = ? "
                        + "AND IsUsed = 0 AND IsDeleted = 0";

                st = cn.prepareStatement(sql);
                st.setInt(1, customerID);
                st.setInt(2, promotionID);
                check = st.executeUpdate() > 0;
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
        return check;
    }

    // -----------------------------------------------------------------------
    // Helper: map a ResultSet row to a CustomerPromotion object
    // -----------------------------------------------------------------------
    private CustomerPromotion mapRow(ResultSet rs) throws Exception {
        CustomerPromotion customerPromotion = new CustomerPromotion();
        customerPromotion.setCustomerPromotionID(rs.getInt("CustomerPromotionID"));
        customerPromotion.setCustomerID(rs.getInt("CustomerID"));
        customerPromotion.setPromotionID(rs.getInt("PromotionID"));
        customerPromotion.setAssignedDate(rs.getDate("AssignedDate"));
        customerPromotion.setUsed(rs.getBoolean("IsUsed"));
        customerPromotion.setUsedDate(rs.getDate("UsedDate"));
        customerPromotion.setNotes(rs.getString("Notes"));
        customerPromotion.setCustomerName(rs.getString("CustomerName"));
        customerPromotion.setPromotionName(rs.getString("PromotionName"));
        customerPromotion.setDiscountPercent(rs.getDouble("DiscountPercent"));
        return customerPromotion;
    }

    // -----------------------------------------------------------------------
    // Helper: close JDBC resources safely
    // -----------------------------------------------------------------------
    private void closeAll(Connection cn, PreparedStatement st, ResultSet rs) {
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

}
