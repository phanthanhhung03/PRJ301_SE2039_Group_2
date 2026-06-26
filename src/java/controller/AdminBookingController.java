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