package controller;

import dao.BookingDAO;
import dto.Booking;
import dto.Customer;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BookingController", urlPatterns = {"/BookingController"})
public class BookingController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Customer user = (Customer) session.getAttribute("USER");
        
        // Kiểm tra bảo mật Session
        if (user == null) {
            response.sendRedirect("MainController?action=viewSignIn");
            return;
        }

        try {
            // 1. LẤY DỮ LIỆU TỪ FORM JSP GỬI LÊN
            int vehicleID = Integer.parseInt(request.getParameter("vehicleID"));
            String dateStr = request.getParameter("bookingDate"); // Định dạng: YYYY-MM-DD
            String timeStr = request.getParameter("bookingTime"); // Định dạng: HH:mm
            String serviceType = request.getParameter("serviceType");
            String notes = request.getParameter("notes");
            
            // 2. CHUYỂN ĐỔI NGÀY & GIỜ THÀNH JAVA.SQL.TIMESTAMP
            // Ghép chuỗi ngày và giờ lại thành một định dạng chuẩn
            String dateTimeStr = dateStr + " " + timeStr + ":00";
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date parsedDate = dateFormat.parse(dateTimeStr);
            Timestamp bookingDate = new Timestamp(parsedDate.getTime());
            
            //KIỂM TRA THỜI GIAN TRONG QUÁ KHỨ
            Timestamp currentTime = new Timestamp(System.currentTimeMillis());
            // Hàm before() sẽ trả về true nếu thời gian khách chọn nhỏ hơn thời gian hiện tại
            if (bookingDate.before(currentTime)) {
                request.setAttribute("BOOKING_ERROR", "Cannot book an appointment in the past. Please select a valid time!");
                request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                return; // Dừng lại ngay lập tức
            }
            BookingDAO isbooked = new BookingDAO();
            //KIỂM TRA TRÙNG LỊCH
            boolean isBooked = isbooked.isSlotBooked(dateStr, timeStr);
            if (isBooked) {
                // Tạo thông báo lỗi gửi về lại giao diện
                request.setAttribute("BOOKING_ERROR", "This time slot has already been booked. Please choose a different time!");
                // Forward người dùng về lại trang đặt lịch
                request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                return; // CHỐT: Dừng toàn bộ luồng xử lý phía dưới, không insert bậy bạ vào DB
            }
        
            // 3. TÍNH TOÁN GIÁ TIỀN GỐC (TOTAL AMOUNT) Ở BACKEND
            double totalAmount = 0;
            if (serviceType.equals("Basic Wash")) {
                totalAmount = 150000;
            } else if (serviceType.equals("Premium Wash")) {
                totalAmount = 300000;
            } else if (serviceType.equals("Ceramic Coating")) {
                totalAmount = 2000000;
            }

            // 4. TÍNH TOÁN GIẢM GIÁ (DISCOUNT AMOUNT) THEO TIER CỦA CUSTOMER
            // Mặc định lấy phần trăm giảm giá từ đối tượng Tier liên kết trong Database của em
            double discountPercent = user.getTierId().getDiscountPercent(); // Ví dụ: Gold là 10.0
            double discountAmount = totalAmount * (discountPercent / 100.0);
            double finalAmount = totalAmount - discountAmount;

            // 5. ĐÓNG GÓI DỮ LIỆU VÀO ĐỐI TƯỢNG BOOKING DTO (10 cột)
            Booking booking = new Booking();
            booking.setVehicleID(vehicleID);
            booking.setBookingDate(bookingDate);
            booking.setTimeSlot(timeStr);
            booking.setServiceType(serviceType);
            booking.setBookingStatus("Pending"); // Lịch mới tạo mặc định ở trạng thái Chờ duyệt
            booking.setNotes(notes);
            booking.setTotalAmount(totalAmount);
            booking.setDiscountAmount(discountAmount);
            booking.setFinalAmount(finalAmount);

            // 6. GỌI DAO ĐỂ THỰC THI GHI VÀO SQL SERVER
            BookingDAO dao = new BookingDAO();
            boolean isSuccess = dao.insertBooking(booking);

            if (isSuccess) {
                // Đặt lịch thành công, cập nhật lại số lượng booking tạm thời trong session nếu cần
                user.setTotalBooking(user.getTotalBooking() + 1);
                
                // Đẩy người dùng về lại trang Dashboard chính thông qua Controller điều hướng dữ liệu
                response.sendRedirect("MainController?action=viewDashBoard");
            } else {
                // Nếu thất bại, có thể tạo biến báo lỗi truyền ngược lại trang booking
                request.setAttribute("BOOKING_ERROR", "Failed to create appointment. Please try again.");
                request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MainController?action=viewDashBoard");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}