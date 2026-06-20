package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dto.Booking;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminBookingController", urlPatterns = {"/AdminBookingController"})
public class AdminBookingController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        BookingDAO bDao = new BookingDAO();
        CustomerDAO cDao = new CustomerDAO();

        try {
            // NHÁNH 1: ĐỔ DATA RA TRANG QUẢN LÝ (Khi bấm View All từ Dashboard)
            if ("viewAdminBookings".equals(action)) {
                List<Booking> list = bDao.getAllAdminBookings();
                request.setAttribute("ALL_BOOKINGS", list);
                
                // Đi sang trang giao diện quản lý
                request.getRequestDispatcher("/admin/booking-management.jsp").forward(request, response);
                return;
            }
            
            // NHÁNH 2: XỬ LÝ ĐỔI STATUS TỰ ĐỘNG (Khi Admin chọn thẻ select)
            else if ("updateBookingStatus".equals(action)) {
                int bID = Integer.parseInt(request.getParameter("bookingID"));
                int customerID = Integer.parseInt(request.getParameter("cusID"));
                String newStatus = request.getParameter("newStatus");

                // 1. Cập nhật trạng thái đơn đặt lịch trước
                boolean isUpdated = bDao.updateBookingStatus(bID, newStatus);

                if (isUpdated) {
                    // Lấy chi tiết đơn đặt lịch để lấy số tiền FinalAmount chính xác
                        Booking b = bDao.getBookingByID(bID);
                        if (b != null) {
                            if ("Completed".equals(newStatus)) {
                            // Luồng 1: Hoàn thành -> Tăng chi tiêu, cộng điểm, tăng số lượt rửa
                                cDao.updateCustomerAfterCompleted(customerID, b.getFinalAmount());
                            } else if ("Cancelled".equals(newStatus)) {
                            // Luồng 2: Hủy lịch sát giờ -> Phạt trừ 20 điểm, tăng số lượt
                                cDao.updateCustomerAfterCancelled(customerID);
                            }
                        }
                    }
                
                // Xử lý xong quay trở lại luồng hiển thị danh sách đơn cho Admin
                response.sendRedirect("MainController?action=viewAdminBookings");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MainController?action=viewAdminDashboard");
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