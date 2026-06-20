package dao;

import dbutils.DBUtils;
import dto.Customer;
import dto.CustomerTier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Asus
 */
public class CustomerDAO {

    public int createCustomer(Customer c) {
        int result = 0;
        Connection cn = null;
        try {
            //buoc 1: make connection
            cn = DBUtils.getConnection();
            if (cn != null) {
                //buoc 2 : viet sql
                String sql = "insert dbo.Customers([FullName], [PhoneNumber], [Email], [Password], [Address], [TierID])\n"
                        + "values(?, ?, ?, ?, ?, 1)";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, c.getFullName());
                st.setString(2, c.getPhoneNumber());
                st.setString(3, c.getEmail());
                st.setString(4, c.getPassword());
                st.setString(5, c.getAddress());
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                //buoc 4
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    private static final Map<Integer, CustomerTier> tierMap = new HashMap<>();

    public Customer getCustomer(String email, String password) {
        Customer result = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            // Step 1: Connect DB
            cn = dbutils.DBUtils.getConnection();

            if (cn == null) {
                System.out.println("not connect");
            }

            if (cn != null) {

                // Step 2: SQL
                String sql = "SELECT " + "c.CustomerID, " + "c.FullName, " + "c.PhoneNumber, " + "c.Email, " + "c.Address, " + "c.CurrentPoints, " + "c.TotalBookings, "
                        + "c.TotalSpend, "
                        + "c.Status, "
                        + "c.CreatedAt, "
                        + "t.TierID, " + "t.TierName, " + "t.MinBookings, " + "t.MinSpend, " + "t.PointMultiplier, "
                        + "t.DiscountPercent, "
                        + "t.PriorityLevel, "
                        + "t.BookingWindowDays "
                        + "FROM Customers c " + "JOIN CustomerTiers t " + "ON c.TierID = t.TierID "
                        + "WHERE c.Email = ? " + "AND c.Password = ?";

                // Step 3
                st = cn.prepareStatement(sql);

                st.setString(1, email);
                st.setString(2, password);

                // Step 4
                table = st.executeQuery();

                if (table.next()) {

                    // Create Tier Object
                    int tierID = table.getInt("TierID");

                    CustomerTier tier = tierMap.get(tierID);

                    if (tier == null) {

                        tier = new CustomerTier();

                        tier.setTierID(tierID);
                        tier.setTierName(table.getString("TierName"));
                        tier.setMinBookings(table.getInt("MinBookings"));
                        tier.setMinSpend(table.getDouble("MinSpend"));
                        tier.setPointMultiplier(table.getDouble("PointMultiplier"));
                        tier.setDiscountPercent(table.getDouble("DiscountPercent"));
                        tier.setPriorityLevel(table.getInt("PriorityLevel"));
                        tier.setBookingWindowDays(table.getInt("BookingWindowDays"));

                        tierMap.put(tierID, tier);
                    }

                    // Create Customer Object
                    result = new Customer();
                    result.setCusId(table.getInt("CustomerID"));
                    result.setFullName(table.getString("FullName"));
                    result.setPhoneNumber(table.getString("PhoneNumber"));
                    result.setEmail(email);
                    result.setPassword(password);
                    result.setAddress(table.getString("Address"));
                    result.setCurrentPoint(table.getInt("CurrentPoints"));
                    result.setTotalBooking(table.getInt("TotalBookings"));
                    result.setTotalSpend(table.getDouble("TotalSpend"));
                    result.setStatus(table.getBoolean("Status"));
                    result.setCreatedAt(table.getDate("CreatedAt"));

                    // Set Tier Object
                    result.setTierId(tier);

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {

                if (table != null) {
                    table.close();
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

    public Customer getCustomer(String email) {
        Customer result = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            // Step 1: Connect DB
            cn = dbutils.DBUtils.getConnection();

            if (cn == null) {
                System.out.println("not connect");
            }

            if (cn != null) {

                // Step 2: SQL
                String sql = "SELECT CustomerID, FullName, PhoneNumber, Address, "
                        + "TierID, CurrentPoints, TotalBookings, TotalSpend, "
                        + "Status, CreatedAt "
                        + "FROM Customers "
                        + "WHERE Email = ?";

                // Step 3
                st = cn.prepareStatement(sql);

                st.setString(1, email);

                // Step 4
                table = st.executeQuery();

                if (table.next()) {

                    result = new Customer();

                    result.setCusId(table.getInt("CustomerID"));
                    result.setFullName(table.getString("FullName"));
                    result.setPhoneNumber(table.getString("PhoneNumber"));
                    result.setEmail(email);
                    result.setAddress(table.getString("Address"));
                    result.setCurrentPoint(table.getInt("CurrentPoints"));
                    result.setTotalBooking(table.getInt("TotalBookings"));
                    result.setTotalSpend(table.getDouble("TotalSpend"));
                    result.setStatus(table.getBoolean("Status"));
                    result.setCreatedAt(table.getDate("CreatedAt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {

                if (table != null) {
                    table.close();
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

    public Customer getCustomer2(String phone) {
        Customer result = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            // Step 1: Connect DB
            cn = dbutils.DBUtils.getConnection();

            if (cn == null) {
                System.out.println("not connect");
            }

            if (cn != null) {

                // Step 2: SQL
                String sql = "SELECT CustomerID, FullName, Email, Address, "
                        + "TierID, CurrentPoints, TotalBookings, TotalSpend, "
                        + "Status, CreatedAt "
                        + "FROM Customers "
                        + "WHERE PhoneNumber = ?";

                // Step 3
                st = cn.prepareStatement(sql);

                st.setString(1, phone);

                // Step 4
                table = st.executeQuery();

                if (table.next()) {

                    result = new Customer();

                    result.setCusId(table.getInt("CustomerID"));
                    result.setFullName(table.getString("FullName"));
                    result.setPhoneNumber(phone);
                    result.setEmail(table.getString("Email"));
                    result.setAddress(table.getString("Address"));
                    result.setCurrentPoint(table.getInt("CurrentPoints"));
                    result.setTotalBooking(table.getInt("TotalBookings"));
                    result.setTotalSpend(table.getDouble("TotalSpend"));
                    result.setStatus(table.getBoolean("Status"));
                    result.setCreatedAt(table.getDate("CreatedAt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {

                if (table != null) {
                    table.close();
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

    public int countCustomers() {

        int total = 0;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                String sql
                        = "SELECT COUNT(*) AS TotalCustomers "
                        + "FROM Customers "
                        + "WHERE Status = ?";

                st = cn.prepareStatement(sql);
                st.setBoolean(1, true);
                table = st.executeQuery();

                if (table.next()) {
                    total = table.getInt("TotalCustomers");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            try {

                if (table != null) {
                    table.close();
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

        return total;
    }

    public List<Customer> getTopCustomers() {

        List<Customer> list = new ArrayList<>();

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {

            cn = dbutils.DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "SELECT TOP 3 "
                        + "c.CustomerID, "
                        + "c.FullName, "
                        + "c.CurrentPoints, "
                        + "c.TotalSpend, "
                        + "t.TierID, "
                        + "t.TierName "
                        + "FROM Customers c "
                        + "JOIN CustomerTiers t ON c.TierID = t.TierID "
                        + "WHERE c.Status = 1 "
                        + "ORDER BY c.TotalSpend DESC";

                st = cn.prepareStatement(sql);

                table = st.executeQuery();

                while (table.next()) {

                    Customer c = new Customer();

                    c.setCusId(table.getInt("CustomerID"));
                    c.setFullName(table.getString("FullName"));
                    c.setCurrentPoint(table.getInt("CurrentPoints"));
                    c.setTotalSpend(table.getDouble("TotalSpend"));

                    CustomerTier tier = new CustomerTier();
                    tier.setTierID(table.getInt("TierID"));
                    tier.setTierName(table.getString("TierName"));

                    c.setTierId(tier);

                    list.add(c);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            try {

                if (table != null) {
                    table.close();
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
    
    // CẬP NHẬT ĐIỂM (Dùng khi phạt hủy lịch sát giờ)
    public boolean updateCustomerPoint(int cusID, int newPoints) {
        boolean check = false;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE Customers SET CurrentPoints = ? WHERE CustomerID = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, newPoints);
                st.setInt(2, cusID);
                
                check = st.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return check;
    }
    // ADMIN MANAGER
    // ==========================================================
    // TRƯỜNG HỢP 1: HOÀN THÀNH ĐƠN (Cộng Điểm + Doanh thu + Số lượt  booking)
    public boolean updateCustomerAfterCompleted(int cusID, double finalAmount) {
        boolean check = false;
        java.sql.Connection cn = null;
        java.sql.PreparedStatement st = null;
        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                // Tính điểm: 1000đ = 1 điểm 
                int earnedPoints = (int) Math.floor(finalAmount / 1000);
                
                String sql = "UPDATE Customers SET "
                           + "TotalSpend = ISNULL(TotalSpend, 0) + ?, "     
                           + "CurrentPoints = ISNULL(CurrentPoints, 0) + ?, " 
                           + "TotalBookings = ISNULL(TotalBookings, 0) + 1 "  
                           + "WHERE CustomerID = ?";
                
                st = cn.prepareStatement(sql);
                st.setDouble(1, finalAmount);
                st.setInt(2, earnedPoints);
                st.setInt(3, cusID);
                
                check = st.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (st != null) st.close(); if (cn != null) cn.close(); } catch (Exception e) { }
        }
        return check;
    }

    // ==========================================================
    // TRƯỜNG HỢP 2: HỦY ĐƠN (Trừ 20 điểm + Số lượt)
    public boolean updateCustomerAfterCancelled(int cusID) {
        boolean check = false;
        java.sql.Connection cn = null;
        java.sql.PreparedStatement st = null;
        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE Customers SET "
                           + "CurrentPoints = CASE WHEN ISNULL(CurrentPoints, 0) - 20 < 0 THEN 0 ELSE ISNULL(CurrentPoints, 0) - 20 END, "
                           + "TotalBookings = ISNULL(TotalBookings, 0) + 1 " 
                           + "WHERE CustomerID = ?";
                
                st = cn.prepareStatement(sql);
                st.setInt(1, cusID);
                
                check = st.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (st != null) st.close(); if (cn != null) cn.close(); } catch (Exception e) { }
        }
        return check;
    }
}
