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
