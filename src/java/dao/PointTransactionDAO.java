/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.PointTransaction;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class PointTransactionDAO {
    // Dùng connection có sẵn để gộp chung transaction với chỗ gọi (CustomerDAO)

    public boolean insertTransaction(Connection cn, int customerID, Integer bookingID,
            int pointsChanged, String transactionType, String description) throws SQLException {
        String sql = "INSERT INTO PointTransactions (CustomerID, BookingID, PointsChanged, TransactionType, Description) "
                + "VALUES (?, ?, ?, ?, ?)";
        try ( PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, customerID);
            if (bookingID != null) {
                st.setInt(2, bookingID);
            } else {
                st.setNull(2, Types.INTEGER);
            }
            st.setInt(3, pointsChanged);
            st.setString(4, transactionType);
            st.setString(5, description);
            return st.executeUpdate() > 0;
        }
    }

    public List<PointTransaction> getRecentTransactions(int limit) {
        List<PointTransaction> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT TOP (?) "
                        + "pt.PointTransactionID, pt.CustomerID, pt.BookingID, pt.PointsChanged, "
                        + "pt.TransactionType, pt.Description, pt.CreatedAt, "
                        + "c.FullName, c.CurrentPoints "
                        + "FROM PointTransactions pt "
                        + "JOIN Customers c ON pt.CustomerID = c.CustomerID "
                        + "ORDER BY pt.CreatedAt DESC";

                st = cn.prepareStatement(sql);
                st.setInt(1, limit);
                rs = st.executeQuery();

                while (rs.next()) {
                    PointTransaction t = new PointTransaction();
                    t.setPointTransactionID(rs.getInt("PointTransactionID"));
                    t.setCustomerID(rs.getInt("CustomerID"));

                    int bookingID = rs.getInt("BookingID");
                    t.setBookingID(rs.wasNull() ? null : bookingID);

                    t.setPointsChanged(rs.getInt("PointsChanged"));
                    t.setCreatedAt(rs.getTimestamp("CreatedAt"));

                    t.setCustomerName(rs.getString("FullName"));
                    t.setCurrentBalance(rs.getInt("CurrentPoints"));

                    list.add(t);
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
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

// Map<MonthLabel, [PointsEarned, PointsDeducted]>
    public Map<String, Integer[]> getMonthlyPointsSummary(int monthsBack) {
        Map<String, Integer[]> result = new LinkedHashMap<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT "
                        + "CONVERT(VARCHAR(7), CreatedAt, 23) AS MonthLabel, "
                        + "SUM(CASE WHEN PointsChanged > 0 THEN PointsChanged ELSE 0 END) AS PointsEarned, "
                        + "SUM(CASE WHEN PointsChanged < 0 THEN ABS(PointsChanged) ELSE 0 END) AS PointsDeducted "
                        + "FROM PointTransactions "
                        + "WHERE CreatedAt >= DATEADD(MONTH, ?, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)) "
                        + "GROUP BY CONVERT(VARCHAR(7), CreatedAt, 23) "
                        + "ORDER BY MonthLabel ASC";

                st = cn.prepareStatement(sql);
                st.setInt(1, -(monthsBack - 1));
                rs = st.executeQuery();

                while (rs.next()) {
                    String month = rs.getString("MonthLabel");
                    int earned = rs.getInt("PointsEarned");
                    int deducted = rs.getInt("PointsDeducted");
                    result.put(month, new Integer[]{earned, deducted});
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
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

// Map<TierName, AvgCurrentPoints>
    public Map<String, Double> getAveragePointsByTier() {
        Map<String, Double> result = new LinkedHashMap<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT "
                        + "t.TierName, "
                        + "AVG(CAST(c.CurrentPoints AS FLOAT)) AS AvgPoints "
                        + "FROM Customers c "
                        + "JOIN CustomerTiers t ON c.TierID = t.TierID "
                        + "GROUP BY t.TierName, t.PriorityLevel "
                        + "ORDER BY t.PriorityLevel DESC";

                st = cn.prepareStatement(sql);
                rs = st.executeQuery();

                while (rs.next()) {
                    result.put(rs.getString("TierName"),
                            rs.getDouble("AvgPoints"));
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
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return result;
    }
}
