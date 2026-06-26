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
            // NHÁNH 1: ĐỔ DATA RA TRANG QUẢN LÝ
            if ("viewAdminBookings".equals(action)) {
                bDao.autoCompletePastBookings();
                List<Booking> list = bDao.getAllAdminBookings();
                request.setAttribute("ALL_BOOKINGS", list);
                request.getRequestDispatcher("/admin/booking-management.jsp").forward(request, response);
                return;
            }
            
            // NHÁNH 2: XỬ LÝ ĐỔI STATUS TỰ ĐỘNG (Khi Admin chọn thẻ select)
            else if ("updateBookingStatus".equals(action)) {
                int bID = Integer.parseInt(request.getParameter("bookingID"));
                int customerID = Integer.parseInt(request.getParameter("cusID"));
                String newStatus = request.getParameter("newStatus");

                // 1. Lấy trạng thái cũ trước khi cập nhật
                Booking oldBooking = bDao.getBookingByID(bID);
                String oldStatus = (oldBooking != null) ? oldBooking.getBookingStatus() : "";

                // 2. Cập nhật trạng thái mới vào Database
                boolean isUpdated = bDao.updateBookingStatus(bID, newStatus);

                if (isUpdated && oldBooking != null) {
                    double amount = oldBooking.getFinalAmount();

                    // Chỉ xử lý điểm/tiền cho 2 luồng từ Pending
                    if ("Pending".equals(oldStatus) && "Completed".equals(newStatus)) {
                        // Chờ xử lý -> Hoàn thành: Cộng tiền, cộng điểm thưởng, +1 lượt rửa
                        cDao.updateCustomerAfterCompleted(customerID, bID, amount);
                        cDao.checkAndUpdateTier(customerID);
                    } else if ("Pending".equals(oldStatus) && "Cancelled".equals(newStatus)) {
                        // Chờ xử lý -> Hủy: Trừ thẳng 20đ phạt cố định, +1 lượt rửa
                        cDao.updateCustomerAfterCancelled(customerID);
                        cDao.checkAndUpdateTier(customerID);
                    }
                    // Không xử lý điểm/tiền cho Completed->Cancelled và Cancelled->Completed
                }
                
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