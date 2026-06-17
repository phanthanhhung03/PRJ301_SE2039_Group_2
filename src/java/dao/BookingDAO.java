package dao;

import dbutils.DBUtils;
import dto.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // =======================================================================
    // 1. HÀM THÊM ĐƠN ĐẶT LỊCH MỚI (Dùng cho trang Booking Page)
    // =======================================================================
    public boolean insertBooking(Booking booking) {
        boolean check = false;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // BookingID và CreatedAt sẽ tự động sinh trong SQL Server, không cần Insert
                String sql = "INSERT INTO Bookings "
                           + "(VehicleID, BookingDate, TimeSlot, ServiceType, BookingStatus, Notes, TotalAmount, DiscountAmount, FinalAmount) "
                           + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                st = cn.prepareStatement(sql);
                st.setInt(1, booking.getVehicleID());
                st.setTimestamp(2, booking.getBookingDate());
                st.setString(3, booking.getTimeSlot());
                st.setString(4, booking.getServiceType());
                st.setString(5, booking.getBookingStatus()); // Thường sẽ gán cứng là 'Pending' từ Controller
                st.setString(6, booking.getNotes());
                st.setDouble(7, booking.getTotalAmount());
                st.setDouble(8, booking.getDiscountAmount());
                st.setDouble(9, booking.getFinalAmount());

                // Nếu executeUpdate trả về số dòng thay đổi > 0 tức là Insert thành công
                int rows = st.executeUpdate();
                if (rows > 0) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Đóng kết nối để tránh tràn bộ nhớ Server
            try {
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return check;
    }

    // =======================================================================
    // 2. HÀM LẤY LỊCH SẮP TỚI (Trạng thái 'Pending' - Dùng cho Dashboard)
    // =======================================================================
    public List<Booking> getUpcomingBookings(int customerID) {
        List<Booking> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // JOIN bảng Bookings và Vehicles để lấy được Biển số xe in ra màn hình
                String sql = "SELECT b.*, v.Brand, v.Model, v.LicensePlate "
                           + "FROM Bookings b JOIN Vehicles v ON b.VehicleID = v.VehicleID "
                           + "WHERE v.CustomerID = ? AND b.BookingStatus = 'Pending' "
                           + "ORDER BY b.BookingDate ASC"; // ASC để lịch gần nhất lên đầu
                
                st = cn.prepareStatement(sql);
                st.setInt(1, customerID);
                rs = st.executeQuery();

                while (rs.next()) {
                    Booking b = new Booking();
                    // 10 cột nguyên bản
                    b.setBookingID(rs.getInt("BookingID"));
                    b.setVehicleID(rs.getInt("VehicleID"));
                    b.setBookingDate(rs.getTimestamp("BookingDate"));
                    b.setTimeSlot(rs.getString("TimeSlot"));
                    b.setServiceType(rs.getString("ServiceType"));
                    b.setBookingStatus(rs.getString("BookingStatus"));
                    b.setNotes(rs.getString("Notes"));
                    b.setTotalAmount(rs.getDouble("TotalAmount"));
                    b.setDiscountAmount(rs.getDouble("DiscountAmount"));
                    b.setFinalAmount(rs.getDouble("FinalAmount"));
                    b.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    
                    // Cột ảo (Virtual Column) dùng để hiển thị giao diện
                    String carName = rs.getString("LicensePlate") + " • " + rs.getString("Brand") + " " + rs.getString("Model");
                    b.setVehicleName(carName);
                    
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    // =======================================================================
    // 3. HÀM LẤY LỊCH SỬ RỬA XE (Trạng thái 'Completed' hoặc 'Cancelled')
    // =======================================================================
    public List<Booking> getPastBookings(int customerID) {
        List<Booking> list = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT b.*, v.Brand, v.Model, v.LicensePlate "
                           + "FROM Bookings b JOIN Vehicles v ON b.VehicleID = v.VehicleID "
                           + "WHERE v.CustomerID = ? AND b.BookingStatus IN ('Completed', 'Cancelled') "
                           + "ORDER BY b.BookingDate DESC"; // DESC để lịch vừa làm xong lên trên cùng
                
                st = cn.prepareStatement(sql);
                st.setInt(1, customerID);
                rs = st.executeQuery();

                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingID(rs.getInt("BookingID"));
                    b.setVehicleID(rs.getInt("VehicleID"));
                    b.setBookingDate(rs.getTimestamp("BookingDate"));
                    b.setTimeSlot(rs.getString("TimeSlot"));
                    b.setServiceType(rs.getString("ServiceType"));
                    b.setBookingStatus(rs.getString("BookingStatus"));
                    b.setNotes(rs.getString("Notes"));
                    b.setTotalAmount(rs.getDouble("TotalAmount"));
                    b.setDiscountAmount(rs.getDouble("DiscountAmount"));
                    b.setFinalAmount(rs.getDouble("FinalAmount"));
                    b.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    
                    String carName = rs.getString("LicensePlate") + " • " + rs.getString("Brand") + " " + rs.getString("Model");
                    b.setVehicleName(carName);
                    
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }
    
    public boolean cancelBooking(int bookingID) {
        boolean check = false;
        Connection cn = null;
        PreparedStatement st = null;
        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                // Lưu ý: Thầy dùng 'BookingStatus' theo đúng thuộc tính setBookingStatus("Pending") trong DTO của em
                String sql = "UPDATE Bookings SET BookingStatus = 'Cancelled' WHERE BookingID = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, bookingID);

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
}