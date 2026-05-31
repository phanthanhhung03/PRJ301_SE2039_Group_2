
package dao;

import dbutils.DBUtils;
import dto.Customer;
import dto.CustomerTier;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Asus
 */
public class CustomerDAO {

    public int createCustomer(Customer c){
        int result=0;
        Connection cn=null;
        try {
            //buoc 1: make connection
            cn=DBUtils.getConnection();
            if(cn!=null){
                //buoc 2 : viet sql
                String sql = "insert dbo.Customers([FullName], [PhoneNumber], [Email], [Password], [Address])\n"
                        + "values(?, ?, ?, ?, ?)";
                PreparedStatement st=cn.prepareStatement(sql);
                st.setString(1, c.getFullName());
                st.setString(2, c.getPhoneNumber());
                st.setString(3, c.getEmail());
                st.setString(4, c.getPassword());
                st.setString(5, c.getAddress());
                result=st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                //buoc 4
                if(cn!=null) 
                    cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }
    
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
                System.out.println("DAO EMAIL = [" + email + "]");
                System.out.println("DAO PASSWORD = [" + password + "]");
                table = st.executeQuery();

                if (table.next()) {

                    // Create Tier Object
                    CustomerTier tier = new CustomerTier();
                    tier.setTierID(table.getInt("TierID"));
                    tier.setTierName(table.getString("TierName"));
                    tier.setMinBookings(table.getInt("MinBookings"));
                    tier.setMinSpend(table.getDouble("MinSpend"));
                    tier.setPointMultiplier(table.getDouble("PointMultiplier"));
                    tier.setDiscountPercent(table.getDouble("DiscountPercent"));
                    tier.setPriorityLevel(table.getInt("PriorityLevel"));
                    tier.setBookingWindowDays(table.getInt("BookingWindowDays"));

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
}

