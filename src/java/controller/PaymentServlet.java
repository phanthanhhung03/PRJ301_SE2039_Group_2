package controller;

import dao.PromotionDAO;
import dao.VehicleDAO;
import dto.BookingDraft;
import dto.Customer;
import dto.Promotion;
import dto.Vehicle;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * PaymentServlet - Chỉ đọc BOOKING_DRAFT từ Session và hiển thị trang payment.jsp.
 * Mọi logic tính toán đã được xử lý trong BookingController (createBookingProcess).
 */
@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("USER");

        // Bảo mật: phải đăng nhập
        if (customer == null) {
            response.sendRedirect("MainController?action=viewSignIn");
            return;
        }

        // Lấy BookingDraft đã được tạo bởi createBookingProcess
        BookingDraft draft = (BookingDraft) session.getAttribute("BOOKING_DRAFT");

        if (draft == null) {
            // Không có draft → quay về trang booking
            response.sendRedirect("MainController?action=viewNewBooking");
            return;
        }

        // Kiểm tra hết hạn (10 phút)
        if (System.currentTimeMillis() > draft.getExpiredAt()) {
            session.removeAttribute("BOOKING_DRAFT");
            session.setAttribute("ERROR", "Payment session expired. Please try again.");
            response.sendRedirect("MainController?action=viewNewBooking");
            return;
        }

        // Lấy thông tin Vehicle để hiển thị Order Summary
        VehicleDAO vehicleDAO = new VehicleDAO();
        Vehicle vehicle = vehicleDAO.getVehicleById(draft.getVehicleId());

        String vehicleInfo = "";
        if (vehicle != null) {
            vehicleInfo = vehicle.getBrand()
                    + " " + vehicle.getModel()
                    + " (" + vehicle.getLicensePlate() + ")";
        }

        // Lấy thông tin Promotion để hiển thị tên voucher
        Promotion promotion = null;
        if (draft.getPromotionId() != 0) {
            PromotionDAO promotionDAO = new PromotionDAO();
            promotion = promotionDAO.getPromotionByID(draft.getPromotionId());
        }

        // Tính reward point ước tính
        int rewardPoint = (int) Math.floor(
                draft.getFinalAmount() * customer.getTierId().getPointMultiplier() / 1000);

        // Đẩy data sang JSP (chỉ để hiển thị, không tính lại)
        request.setAttribute("vehicleInfo", vehicleInfo);
        request.setAttribute("serviceType", draft.getServiceType());
        request.setAttribute("promotion", promotion);
        request.setAttribute("voucherDiscount", draft.getVoucherDiscount());
        request.setAttribute("tierDiscount", draft.getTierDiscount());
        request.setAttribute("total", draft.getFinalAmount());
        request.setAttribute("rewardPoint", rewardPoint);

        request.getRequestDispatcher("/customer/payment.jsp")
                .forward(request, response);
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
