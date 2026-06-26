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
                        + "(VehicleID, BookingDate, TimeSlot, ServiceType, BookingStatus, Notes, TotalAmount, DiscountAmount, FinalAmount, PaymentStatus) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
                st.setBoolean(10, booking.isPaymentStatus());

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
        return check;
    }

    // =======================================================================
    // 2. HÀM LẤY CHI TIẾT 1 ĐƠN ĐẶT LỊCH (Dùng để kiểm tra trước khi Hủy)
    // =======================================================================
    public Booking getBookingByID(int bookingID) {
        Booking b = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT * FROM Bookings WHERE BookingID = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, bookingID);
                rs = st.executeQuery();

                if (rs.next()) {
                    b = new Booking();
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
                    b.setPaymentStatus(rs.getBoolean("PaymentStatus"));
                    b.setCreatedAt(rs.getTimestamp("CreatedAt"));
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
        return b;
    }

    // =======================================================================
    // 3. HÀM LẤY LỊCH SẮP TỚI (Trạng thái 'Pending' - Dùng cho Dashboard)
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
                    b.setPaymentStatus(rs.getBoolean("PaymentStatus"));
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

    // =======================================================================
    // 4. HÀM LẤY LỊCH SỬ RỬA XE (Trạng thái 'Completed' hoặc 'Cancelled')
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
                    b.setPaymentStatus(rs.getBoolean("PaymentStatus"));
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

    public boolean cancelBooking(int bookingID) {
        boolean check = false;
        Connection cn = null;
        PreparedStatement st = null;
        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE Bookings SET BookingStatus = 'Cancelled' WHERE BookingID = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, bookingID);

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

    public boolean isSlotBooked(String dateStr, String timeSlot) {
        boolean isBooked = false;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Ép kiểu BookingDate về DATE để so sánh chính xác với chuỗi YYYY-MM-DD từ form gửi lên
                String sql = "SELECT COUNT(*) FROM Bookings "
                        + "WHERE CAST(BookingDate AS DATE) = ? AND TimeSlot = ? AND BookingStatus != 'Cancelled'";

                st = cn.prepareStatement(sql);
                st.setString(1, dateStr);
                st.setString(2, timeSlot);
                rs = st.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    isBooked = true; // Đã có người đặt trước
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
        return isBooked;
    }

    public List<Booking> getAllAdminBookings() {
        List<Booking> list = new ArrayList<>();
        java.sql.Connection cn = null;
        java.sql.PreparedStatement st = null;
        java.sql.ResultSet rs = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn != null) {
                // Lấy toàn bộ lịch, JOIN để lấy tên Khách & Tên Xe, sắp xếp mới nhất lên đầu
                String sql = "SELECT b.*, c.CustomerID, c.FullName AS CustomerName, v.Brand, v.Model, v.LicensePlate "
                        + "FROM Bookings b "
                        + "JOIN Vehicles v ON b.VehicleID = v.VehicleID "
                        + "JOIN Customers c ON v.CustomerID = c.CustomerID "
                        + "ORDER BY b.BookingDate DESC, b.TimeSlot DESC";

                st = cn.prepareStatement(sql);
                rs = st.executeQuery();

                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingID(rs.getInt("BookingID"));
                    b.setVehicleID(rs.getInt("VehicleID"));
                    b.setBookingDate(rs.getTimestamp("BookingDate"));
                    b.setTimeSlot(rs.getString("TimeSlot"));
                    b.setServiceType(rs.getString("ServiceType"));
                    b.setBookingStatus(rs.getString("BookingStatus"));
                    b.setTotalAmount(rs.getDouble("TotalAmount"));
                    b.setFinalAmount(rs.getDouble("FinalAmount"));
                    b.setPaymentStatus(rs.getBoolean("PaymentStatus"));

                    // Lấy CustomerID (Rất quan trọng để lát nữa cộng điểm)
                    b.setCusId(rs.getInt("CustomerID"));

                    // Cột ảo hiển thị
                    b.setCustomerName(rs.getString("CustomerName"));
                    String carName = rs.getString("LicensePlate") + " - " + rs.getString("Brand") + " " + rs.getString("Model");
                    b.setVehicleName(carName);

                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // FIX BUG #3: Đóng connection để tránh connection leak
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
            } catch (java.sql.SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }


    // Get Revenue by Year
    public double getRevenueByYear(int year) {
        double revenue = 0;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT ISNULL(SUM(FinalAmount), 0) AS Revenue "
                        + "FROM Bookings "
                        + "WHERE BookingStatus = 'Completed' "
                        + "AND YEAR(BookingDate) = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, year);
                rs = st.executeQuery();
                if (rs.next()) {
                    revenue = rs.getDouble("Revenue");
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
        return revenue;
    }

    public List<Booking> getBookingsByCustomerId(int customerId) {

        List<Booking> list = new ArrayList<>();

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "SELECT "
                        + "b.*, "
                        + "CONCAT(v.Brand, ' ', v.Model, ' (', v.LicensePlate, ')') AS VehicleName "
                        + "FROM Bookings b "
                        + "JOIN Vehicles v ON b.VehicleID = v.VehicleID "
                        + "WHERE v.CustomerID = ? "
                        + "ORDER BY b.BookingDate DESC";

                st = cn.prepareStatement(sql);

                st.setInt(1, customerId);

                table = st.executeQuery();

                while (table.next()) {

                    Booking b = new Booking();

                    b.setBookingID(table.getInt("BookingID"));
                    b.setVehicleID(table.getInt("VehicleID"));
                    b.setBookingDate(table.getTimestamp("BookingDate"));
                    b.setTimeSlot(table.getString("TimeSlot"));
                    b.setServiceType(table.getString("ServiceType"));
                    b.setBookingStatus(table.getString("BookingStatus"));
                    b.setNotes(table.getString("Notes"));
                    b.setTotalAmount(table.getDouble("TotalAmount"));
                    b.setDiscountAmount(table.getDouble("DiscountAmount"));
                    b.setFinalAmount(table.getDouble("FinalAmount"));
                    b.setPaymentStatus(table.getBoolean("PaymentStatus"));
                    b.setCreatedAt(table.getTimestamp("CreatedAt"));

                    b.setVehicleName(table.getString("VehicleName"));

                    list.add(b);
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

    public List<Booking> getBookingsByVehicleId(int vehicleId, String status) {
        List<Booking> bookingList = new ArrayList<>();

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql = "SELECT BookingID, VehicleID, BookingDate, TimeSlot, "
                        + "ServiceType, BookingStatus, Notes, CreatedAt, "
                        + "TotalAmount, DiscountAmount, FinalAmount "
                        + "FROM Bookings "
                        + "WHERE VehicleID = ? AND BookingStatus = ? "
                        + "ORDER BY BookingDate DESC";

                st = cn.prepareStatement(sql);
                st.setInt(1, vehicleId);
                st.setString(2, status);

                rs = st.executeQuery();

                while (rs.next()) {

                    Booking booking = new Booking();

                    booking.setBookingID(rs.getInt("BookingID"));
                    booking.setVehicleID(rs.getInt("VehicleID"));
                    booking.setBookingDate(rs.getTimestamp("BookingDate"));
                    booking.setTimeSlot(rs.getString("TimeSlot"));
                    booking.setServiceType(rs.getString("ServiceType"));
                    booking.setBookingStatus(rs.getString("BookingStatus"));
                    booking.setNotes(rs.getString("Notes"));
                    booking.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    booking.setTotalAmount(rs.getDouble("TotalAmount"));
                    booking.setDiscountAmount(rs.getDouble("DiscountAmount"));
                    booking.setFinalAmount(rs.getDouble("FinalAmount"));
                    booking.setPaymentStatus(rs.getBoolean("PaymentStatus"));

                    bookingList.add(booking);
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

        return bookingList;
    }

    public int autoCompletePastBookings() {
        int rows = 0;
        Connection cn = null;
        PreparedStatement st = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Tự động chuyển những booking đã quá hạn thành Complete
                String sql = "UPDATE Bookings SET BookingStatus = 'Completed' WHERE BookingStatus = 'Pending' AND BookingDate < GETDATE()";
                st = cn.prepareStatement(sql);
                rows = st.executeUpdate();
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
        return rows;
    }

}
