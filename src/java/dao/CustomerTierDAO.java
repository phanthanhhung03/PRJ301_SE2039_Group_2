package dao;

import dbutils.DBUtils;
import dto.CustomerTier;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerTierDAO {

    public List<CustomerTier> getAllTiers() {

        List<CustomerTier> list = new ArrayList<>();

        Connection cn = null;

        try {

            // Step 1: Connect DB
            cn = DBUtils.getConnection();

            if (cn != null) {

                // Step 2: SQL
                String sql = "SELECT * "
                        + "FROM CustomerTiers "
                        + "ORDER BY PriorityLevel DESC";

                PreparedStatement st = cn.prepareStatement(sql);

                // Step 3: Execute
                ResultSet rs = st.executeQuery();

                while (rs.next()) {

                    CustomerTier tier = new CustomerTier();

                    tier.setTierID(rs.getInt("TierID"));
                    tier.setTierName(rs.getString("TierName"));
                    tier.setMinBookings(rs.getInt("MinBookings"));
                    tier.setMinSpend(rs.getDouble("MinSpend"));
                    tier.setPointMultiplier(rs.getDouble("PointMultiplier"));
                    tier.setDiscountPercent(rs.getDouble("DiscountPercent"));
                    tier.setPriorityLevel(rs.getInt("PriorityLevel"));
                    tier.setBookingWindowDays(rs.getInt("BookingWindowDays"));

                    list.add(tier);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            try {

                if (cn != null) {
                    cn.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return list;
    }

    public CustomerTier getTierByID(int tierID) {

        CustomerTier tier = null;

        Connection cn = null;

        try {

            // Step 1: Connect DB
            cn = DBUtils.getConnection();

            if (cn != null) {

                // Step 2: SQL
                String sql = "SELECT * "
                        + "FROM CustomerTiers "
                        + "WHERE TierID = ?";

                PreparedStatement st = cn.prepareStatement(sql);

                st.setInt(1, tierID);

                // Step 3: Execute
                ResultSet rs = st.executeQuery();

                if (rs.next()) {

                    tier = new CustomerTier();

                    tier.setTierID(rs.getInt("TierID"));
                    tier.setTierName(rs.getString("TierName"));
                    tier.setMinBookings(rs.getInt("MinBookings"));
                    tier.setMinSpend(rs.getDouble("MinSpend"));
                    tier.setPointMultiplier(rs.getDouble("PointMultiplier"));
                    tier.setDiscountPercent(rs.getDouble("DiscountPercent"));
                    tier.setPriorityLevel(rs.getInt("PriorityLevel"));
                    tier.setBookingWindowDays(rs.getInt("BookingWindowDays"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            try {

                if (cn != null) {
                    cn.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return tier;
    }

    public Map<Integer, Integer> getCustomerCountByTier() {

        Map<Integer, Integer> result = new HashMap<>();

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "SELECT TierID, "
                        + "COUNT(*) AS TotalCustomers "
                        + "FROM Customers "
                        + "WHERE Status = ? "
                        + "GROUP BY TierID";

                st = cn.prepareStatement(sql);
                st.setBoolean(1, true);

                table = st.executeQuery();

                while (table.next()) {

                    result.put(
                            table.getInt("TierID"),
                            table.getInt("TotalCustomers")
                    );
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

    public boolean updateTier(CustomerTier tier) {
        String sql = "UPDATE CustomerTiers\n"
                + "        SET minBookings = ?,\n"
                + "            minSpend = ?,\n"
                + "            pointMultiplier = ?,\n"
                + "            discountPercent = ?\n"
                + "        WHERE tierID = ?";

        try (
                 Connection conn = dbutils.DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tier.getMinBookings());
            ps.setDouble(2, tier.getMinSpend());
            ps.setDouble(3, tier.getPointMultiplier());
            ps.setDouble(4, tier.getDiscountPercent());
            ps.setInt(5, tier.getTierID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public CustomerTier getNextTier(int currentPriorityLevel) {

        CustomerTier tier = null;

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {

            cn = DBUtils.getConnection();

            String sql
                    = "SELECT TOP 1 * "
                    + "FROM CustomerTiers "
                    + "WHERE PriorityLevel > ? "
                    + "ORDER BY PriorityLevel ASC";

            st = cn.prepareStatement(sql);
            st.setInt(1, currentPriorityLevel);

            rs = st.executeQuery();

            if (rs.next()) {

                tier = new CustomerTier();

                tier.setTierID(rs.getInt("TierID"));
                tier.setTierName(rs.getString("TierName"));
                tier.setMinBookings(rs.getInt("MinBookings"));
                tier.setMinSpend(rs.getDouble("MinSpend"));
                tier.setPriorityLevel(rs.getInt("PriorityLevel"));

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return tier;
    }
}
