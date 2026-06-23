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

    public int createCustomerByAdmin(Customer c) {

        int result = 0;

        Connection cn = null;
        PreparedStatement st = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "INSERT INTO Customers "
                        + "(FullName, PhoneNumber, Email, Password, Address, TierID, Status) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?)";

                st = cn.prepareStatement(sql);

                st.setString(1, c.getFullName());
                st.setString(2, c.getPhoneNumber());
                st.setString(3, c.getEmail());
                st.setString(4, c.getPassword());
                st.setString(5, c.getAddress());
                st.setInt(6, c.getTierId().getTierID());
                st.setBoolean(7, c.isStatus());

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

    // ADMIN MANAGER  
    // Cong diem theo point mutipiler trong CustomerTier
    public boolean updateCustomerAfterCompleted(int cusID, int bookingID, double finalAmount) {
        boolean check = false;
        Connection cn = null;
        PreparedStatement tierSt = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                cn.setAutoCommit(false);

                // Lấy PointMultiplier + TierName theo tier hiện tại của khách
                double multiplier = 1.0;
                String tierName = "Member";

                String tierSql = "SELECT t.PointMultiplier, t.TierName "
                        + "FROM Customers c "
                        + "JOIN CustomerTiers t ON c.TierID = t.TierID "
                        + "WHERE c.CustomerID = ?";

                tierSt = cn.prepareStatement(tierSql);
                tierSt.setInt(1, cusID);
                rs = tierSt.executeQuery();

                if (rs.next()) {
                    multiplier = rs.getDouble("PointMultiplier");
                    tierName = rs.getString("TierName");
                }

                // Tính điểm: 1000đ = 1 điểm, x theo multiplier của tier
                int earnedPoints = (int) Math.floor((finalAmount / 1000) * multiplier);

                String sql = "UPDATE Customers SET "
                        + "TotalSpend = ISNULL(TotalSpend, 0) + ?, "
                        + "CurrentPoints = ISNULL(CurrentPoints, 0) + ?, "
                        + "TotalBookings = ISNULL(TotalBookings, 0) + 1 "
                        + "WHERE CustomerID = ?";

                st = cn.prepareStatement(sql);
                st.setDouble(1, finalAmount);
                st.setInt(2, earnedPoints);
                st.setInt(3, cusID);

                int rows = st.executeUpdate();

                if (rows > 0) {
                    new PointTransactionDAO().insertTransaction(cn, cusID, bookingID, earnedPoints,
                            "EARN", "Booking #" + bookingID + " completed (" + tierName + " x" + multiplier + ")");
                    cn.commit();
                    check = true;
                } else {
                    cn.rollback();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (cn != null) {
                    cn.rollback();
                }
            } catch (Exception ex) {
            }
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (tierSt != null) {
                    tierSt.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
            }
        }
        return check;
    }

    // ==========================================================
    // 1. CHỜ XỬ LÝ -> HỦY (Trừ thẳng 20đ cố định)
    // ==========================================================
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
            try {
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
            }
        }
        return check;
    }

    // ==========================================================
    // 2. HOÀN THÀNH -> HỦY (Thu hồi điểm thưởng, trừ thêm 20đ phạt)
    // ==========================================================
    public boolean revertCompletedBooking(int cusID, double finalAmount) {
        boolean check = false;
        java.sql.Connection cn = null;
        java.sql.PreparedStatement tierSt = null;
        java.sql.PreparedStatement st = null;
        java.sql.ResultSet rs = null;
        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                double multiplier = 1.0;
                String tierSql = "SELECT t.PointMultiplier FROM Customers c JOIN CustomerTiers t ON c.TierID = t.TierID WHERE c.CustomerID = ?";
                tierSt = cn.prepareStatement(tierSql);
                tierSt.setInt(1, cusID);
                rs = tierSt.executeQuery();
                if (rs.next()) {
                    multiplier = rs.getDouble("PointMultiplier");
                }

                // Tổng điểm cần trừ = Điểm thưởng đã nhận trước đó + 20 điểm phạt cố định
                int earnedPoints = (int) Math.floor((finalAmount / 1000) * multiplier);
                int totalPointsToDeduct = earnedPoints + 20;

                String sql = "UPDATE Customers SET "
                        + "TotalSpend = CASE WHEN ISNULL(TotalSpend, 0) - ? < 0 THEN 0 ELSE ISNULL(TotalSpend, 0) - ? END, "
                        + "CurrentPoints = CASE WHEN ISNULL(CurrentPoints, 0) - ? < 0 THEN 0 ELSE ISNULL(CurrentPoints, 0) - ? END "
                        + "WHERE CustomerID = ?";
                st = cn.prepareStatement(sql);
                st.setDouble(1, finalAmount);
                st.setDouble(2, finalAmount);
                st.setInt(3, totalPointsToDeduct);
                st.setInt(4, totalPointsToDeduct);
                st.setInt(5, cusID);

                check = st.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (tierSt != null) {
                    tierSt.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
            }
        }
        return check;
    }

    // ==========================================================
    // 3. HỦY -> HOÀN THÀNH (Hoàn lại 20đ phạt cố định, cộng điểm thưởng)
    // ==========================================================
    public boolean restoreCancelledToCompleted(int cusID, double finalAmount) {
        boolean check = false;
        java.sql.Connection cn = null;
        java.sql.PreparedStatement tierSt = null;
        java.sql.PreparedStatement st = null;
        java.sql.ResultSet rs = null;
        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                double multiplier = 1.0;
                String tierSql = "SELECT t.PointMultiplier FROM Customers c JOIN CustomerTiers t ON c.TierID = t.TierID WHERE c.CustomerID = ?";
                tierSt = cn.prepareStatement(tierSql);
                tierSt.setInt(1, cusID);
                rs = tierSt.executeQuery();
                if (rs.next()) {
                    multiplier = rs.getDouble("PointMultiplier");
                }

                // Tổng điểm cộng lại = Điểm thưởng thực tế + Trả lại 20đ đã phạt trước đó
                int earnedPoints = (int) Math.floor((finalAmount / 1000) * multiplier);
                int totalPointsToAdd = earnedPoints + 20;

                String sql = "UPDATE Customers SET "
                        + "TotalSpend = ISNULL(TotalSpend, 0) + ?, "
                        + "CurrentPoints = ISNULL(CurrentPoints, 0) + ? "
                        + "WHERE CustomerID = ?";
                st = cn.prepareStatement(sql);
                st.setDouble(1, finalAmount);
                st.setInt(2, totalPointsToAdd);
                st.setInt(3, cusID);

                check = st.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (tierSt != null) {
                    tierSt.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
            }
        }
        return check;
    }

    public boolean updateCustomer(Customer customer) {

        Connection cn = null;
        PreparedStatement st = null;

        boolean result = false;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "UPDATE Customers "
                        + "SET FullName = ?, "
                        + "PhoneNumber = ?, "
                        + "Email = ?, "
                        + "Address = ?, "
                        + "TierID = ?, "
                        + "Status = ? "
                        + "WHERE CustomerID = ?";

                st = cn.prepareStatement(sql);

                st.setString(1, customer.getFullName());
                st.setString(2, customer.getPhoneNumber());
                st.setString(3, customer.getEmail());
                st.setString(4, customer.getAddress());
                st.setInt(5, customer.getTierId().getTierID());
                st.setBoolean(6, customer.isStatus());
                st.setInt(7, customer.getCusId());

                result = st.executeUpdate() > 0;
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

    public int updateCustomer(int cusId, String newName, String newPhoneNumber, String newAddress) {
        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn == null) {
                System.out.println("CANNOT CONNECT TO SQL");
                return result;
            }
            String sql = "UPDATE [dbo].[Customers] "
                    + "SET [FullName] = ?, "
                    + "    [PhoneNumber] = ?, "
                    + "    [Address] = ? "
                    + "WHERE [CustomerID] = ?";

            st = cn.prepareStatement(sql);

            st.setString(1, newName);
            st.setString(2, newPhoneNumber);
            st.setString(3, newAddress);
            st.setInt(4, cusId);

            result = st.executeUpdate();
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

    public Customer getCustomer(int cusId) {

        Customer result = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {

            cn = dbutils.DBUtils.getConnection();

            if (cn == null) {
                System.out.println("Cannot connect to database!");
                return null;
            }

            String sql
                    = "SELECT c.CustomerID, "
                    + "c.FullName, "
                    + "c.PhoneNumber, "
                    + "c.Email, "
                    + "c.Password, "
                    + "c.Address, "
                    + "c.CurrentPoints, "
                    + "c.TotalBookings, "
                    + "c.TotalSpend, "
                    + "c.Status, "
                    + "c.CreatedAt, "
                    + "t.TierID, "
                    + "t.TierName, "
                    + "t.MinBookings, "
                    + "t.MinSpend, "
                    + "t.PointMultiplier, "
                    + "t.DiscountPercent, "
                    + "t.PriorityLevel, "
                    + "t.BookingWindowDays, "
                    + "    (\n"
                    + "        SELECT COUNT(*)\n"
                    + "        FROM Vehicles v\n"
                    + "        WHERE v.CustomerID = c.CustomerID\n"
                    + "    ) AS VehicleCount \n"
                    + "FROM Customers c "
                    + "INNER JOIN CustomerTiers t "
                    + "ON c.TierID = t.TierID "
                    + "WHERE c.CustomerID = ?";

            st = cn.prepareStatement(sql);
            st.setInt(1, cusId);

            rs = st.executeQuery();

            if (rs.next()) {

                result = new Customer();

                result.setCusId(rs.getInt("CustomerID"));
                result.setFullName(rs.getString("FullName"));
                result.setPhoneNumber(rs.getString("PhoneNumber"));
                result.setEmail(rs.getString("Email"));
                result.setPassword(rs.getString("Password"));
                result.setAddress(rs.getString("Address"));

                result.setCurrentPoint(rs.getInt("CurrentPoints"));
                result.setTotalBooking(rs.getInt("TotalBookings"));
                result.setTotalSpend(rs.getDouble("TotalSpend"));

                result.setStatus(rs.getBoolean("Status"));
                result.setCreatedAt(rs.getDate("CreatedAt"));
                result.setVehicleCount(rs.getInt("VehicleCount"));

                // CustomerTier
                CustomerTier tier = new CustomerTier();

                tier.setTierID(rs.getInt("TierID"));
                tier.setTierName(rs.getString("TierName"));
                tier.setMinBookings(rs.getInt("MinBookings"));
                tier.setMinSpend(rs.getDouble("MinSpend"));
                tier.setPointMultiplier(rs.getDouble("PointMultiplier"));
                tier.setDiscountPercent(rs.getDouble("DiscountPercent"));
                tier.setPriorityLevel(rs.getInt("PriorityLevel"));
                tier.setBookingWindowDays(rs.getInt("BookingWindowDays"));

                result.setTierId(tier);
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

    public int updatePassword(int customerId, String newPassword) {

        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn == null) {
                System.out.println("CANNOT CONNECT TO SQL");
                return result;
            }
            String sql
                    = "UPDATE Customers "
                    + "SET Password = ? "
                    + "WHERE CustomerID = ?";

            st = cn.prepareStatement(sql);

            st.setString(1, newPassword);
            st.setInt(2, customerId);

            result = st.executeUpdate();
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

    public List<Customer> filterCustomers(String keyword, String tier, String status) {

        List<Customer> list = new ArrayList<>();

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {

            cn = dbutils.DBUtils.getConnection();

            if (cn != null) {

                StringBuilder sql = new StringBuilder();
                sql.append("SELECT "
                        + "c.CustomerID, "
                        + "c.FullName, "
                        + "c.PhoneNumber, "
                        + "c.Email, "
                        + "c.Address, "
                        + "c.CurrentPoints, "
                        + "c.TotalBookings, "
                        + "c.TotalSpend, "
                        + "c.Status, "
                        + "c.CreatedAt, "
                        + "t.TierID, "
                        + "t.TierName, "
                        + "("
                        + "    SELECT COUNT(*) "
                        + "    FROM Vehicles v2 "
                        + "    WHERE v2.CustomerID = c.CustomerID"
                        + ") AS VehicleCount "
                        + "FROM Customers c "
                        + "INNER JOIN CustomerTiers t "
                        + "ON c.TierID = t.TierID "
                        + "WHERE 1 = 1 ");

                List<Object> params = new ArrayList<>();

                //Search
                if (keyword != null && !keyword.trim().isEmpty()) {
                    sql.append("AND ("
                            + "c.FullName LIKE ? "
                            + "OR c.Email LIKE ? "
                            + "OR c.PhoneNumber LIKE ? "
                            + ") ");

                    String search = "%" + keyword.trim() + "%";
                    params.add(search);
                    params.add(search);
                    params.add(search);
                }
                
                // Tier filter
                if (tier != null && !tier.trim().isEmpty() && !"all".equalsIgnoreCase(tier)) {
                    sql.append("AND t.TierName = ? ");
                    params.add(tier);
                }
                
                // Status
                if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
                    boolean active = "ACTIVE".equalsIgnoreCase(status);
                    sql.append("AND c.Status = ? ");
                    params.add(active);
                }

                sql.append("ORDER BY c.CustomerID DESC");
                st = cn.prepareStatement(sql.toString());
                
                for (int i = 0; i < params.size(); i++) {
                    st.setObject(i+1, params.get(i));
                }
                
                table = st.executeQuery();

                while (table.next()) {

                    Customer c = new Customer();

                    c.setCusId(table.getInt("CustomerID"));
                    c.setFullName(table.getString("FullName"));
                    c.setPhoneNumber(table.getString("PhoneNumber"));
                    c.setEmail(table.getString("Email"));
                    c.setAddress(table.getString("Address"));
                    c.setCurrentPoint(table.getInt("CurrentPoints"));
                    c.setTotalSpend(table.getDouble("TotalSpend"));
                    c.setStatus(table.getBoolean("Status"));
                    c.setVehicleCount(table.getInt("VehicleCount"));

                    CustomerTier customerTier = new CustomerTier();
                    customerTier.setTierID(table.getInt("TierID"));
                    customerTier.setTierName(table.getString("TierName"));

                    c.setTierId(customerTier);

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

    public List<Customer> getAllCustomers() {

        List<Customer> list = new ArrayList<>();

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {

            cn = dbutils.DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "SELECT\n"
                        + "    c.CustomerID,\n"
                        + "    c.FullName,\n"
                        + "    c.PhoneNumber,\n"
                        + "    c.Email,\n"
                        + "    c.Password,\n"
                        + "    c.Address,\n"
                        + "    c.CurrentPoints,\n"
                        + "    c.TotalSpend,\n"
                        + "    c.Status,\n"
                        + "    c.TierID,\n"
                        + "    t.TierName,\n"
                        + "    (\n"
                        + "        SELECT COUNT(*)\n"
                        + "        FROM Vehicles v\n"
                        + "        WHERE v.CustomerID = c.CustomerID\n"
                        + "    ) AS VehicleCount \n"
                        + "FROM Customers c\n"
                        + "JOIN CustomerTiers t on t.TierID = c.TierID\n";

                st = cn.prepareStatement(sql);

                table = st.executeQuery();

                while (table.next()) {

                    Customer c = new Customer();

                    c.setCusId(table.getInt("CustomerID"));
                    c.setFullName(table.getString("FullName"));
                    c.setPhoneNumber(table.getString("PhoneNumber"));
                    c.setEmail(table.getString("Email"));
                    c.setPassword(table.getString("Password"));
                    c.setAddress(table.getString("Address"));
                    c.setCurrentPoint(table.getInt("CurrentPoints"));
                    c.setTotalSpend(table.getDouble("TotalSpend"));
                    c.setStatus(table.getBoolean("Status"));
                    c.setVehicleCount(table.getInt("VehicleCount"));

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

    // Map<TierID, TotalRevenue> - tổng doanh thu (TotalSpend) theo từng Tier
    public Map<Integer, Double> getRevenueByTier() {
        Map<Integer, Double> result = new HashMap<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT TierID, SUM(TotalSpend) AS TierRevenue "
                        + "FROM Customers "
                        + "GROUP BY TierID";

                st = cn.prepareStatement(sql);
                rs = st.executeQuery();

                while (rs.next()) {
                    result.put(rs.getInt("TierID"), rs.getDouble("TierRevenue"));
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

    // Top khách hàng có điểm cao nhất hiện tại
    public List<Customer> getTopCustomersByPoints(int limit) {
        List<Customer> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT TOP (?) c.*, t.TierName, t.PriorityLevel, t.DiscountPercent AS TierDiscount "
                        + "FROM Customers c "
                        + "JOIN CustomerTiers t ON c.TierID = t.TierID "
                        + "WHERE c.Status = 1 "
                        + "ORDER BY c.CurrentPoints DESC";

                st = cn.prepareStatement(sql);
                st.setInt(1, limit);
                rs = st.executeQuery();

                while (rs.next()) {
                    Customer c = new Customer();
                    c.setCusId(rs.getInt("CustomerID"));
                    c.setFullName(rs.getString("FullName"));
                    c.setCurrentPoint(rs.getInt("CurrentPoints"));

                    CustomerTier tier = new CustomerTier();
                    tier.setTierID(rs.getInt("TierID"));
                    tier.setTierName(rs.getString("TierName"));
                    c.setTierId(tier);

                    list.add(c);
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
}
