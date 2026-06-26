package controller;

import dao.PromotionDAO;
import dao.VehicleDAO;
import dto.BookingDraft;
import dto.Customer;
import dto.CustomerTier;
import dto.Promotion;
import dto.Vehicle;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        BookingDraft draft
                = (BookingDraft) session.getAttribute("BOOKING_DRAFT");

        // ==========================
        // Booking Information
        // ==========================
        int vehicleID = Integer.parseInt(request.getParameter("vehicleID"));
        String bookingDate = request.getParameter("bookingDate");
        String bookingTime = request.getParameter("bookingTime");
        String serviceType = request.getParameter("serviceType");
        int promotionID = Integer.parseInt(request.getParameter("promoCode"));

        // ==========================
        // Vehicle
        // ==========================
        VehicleDAO vehicleDAO = new VehicleDAO();
        Vehicle vehicle = vehicleDAO.getVehicleById(vehicleID);

        String vehicleInfo = vehicle.getBrand()
                + " "
                + vehicle.getModel()
                + " ("
                + vehicle.getLicensePlate()
                + ")";

        // ==========================
        // Service Price
        // ==========================
        int amount = 0;

        switch (serviceType) {

            case "Normal Wash":
                amount = 150000;
                break;

            case "Premium Wash":
                amount = 300000;
                break;
        }

        // ==========================
        // Promotion
        // ==========================
        Promotion promotion = null;
        double voucherDiscount = 0;

        if (promotionID != 0) {

            PromotionDAO promotionDAO = new PromotionDAO();

            promotion = promotionDAO.getPromotionById(promotionID);

            voucherDiscount = amount
                    * promotion.getDiscountPercent()
                    / 100.0;
        }

        // ==========================
        // Tier Discount
        // ==========================
        Customer customer = (Customer) session.getAttribute("USER");
        String bookingCode = "BK" + customer.getCusId() + " " + System.currentTimeMillis();
        long expiredAt = System.currentTimeMillis() + (10 * 60 * 1000);

        double tierDiscount = 0;
        CustomerTier customerTier = customer.getTierId();

        switch (customerTier.getTierName()) {

            case "Silver":
                tierDiscount = amount * customerTier.getDiscountPercent() / 100;
                break;

            case "Gold":
                tierDiscount = amount * customerTier.getDiscountPercent() / 100;
                break;

            case "Platinum":
                tierDiscount = amount * customerTier.getDiscountPercent() / 100;
                break;
        }

        // ==========================
        // Total
        // ==========================
        double total = amount - voucherDiscount - tierDiscount;

        int rewardPoint = (int) Math.floor((total * customerTier.getPointMultiplier() / 1000));

        if (draft == null) {

            draft = new BookingDraft();

            // set toàn bộ dữ liệu
            draft.setCustomerId(customer.getCusId());
            draft.setVehicleId(vehicleID);
            draft.setPromotionId(promotionID);

            draft.setServiceType(serviceType);

            draft.setBookingDate(Date.valueOf(bookingDate));
            draft.setBookingTime(Time.valueOf(bookingTime + ":00"));

            draft.setTotalAmount(total);
            draft.setVoucherDiscount(voucherDiscount);
            draft.setTierDiscount(tierDiscount);
            draft.setFinalAmount(total);

            draft.setBookingCode(bookingCode);
            draft.setExpiredAt(expiredAt);

            draft.setBookingCode(
                    "BK"
                    + customer.getCusId()
                    + System.currentTimeMillis());

            draft.setExpiredAt(
                    System.currentTimeMillis()
                    + 10 * 60 * 1000);

            session.setAttribute("BOOKING_DRAFT", draft);

        }

        // ==========================
        // Send to payment.jsp
        // ==========================
        request.setAttribute("vehicle", vehicle);
        request.setAttribute("vehicleInfo", vehicleInfo);

        request.setAttribute("bookingDate", bookingDate);
        request.setAttribute("bookingTime", bookingTime);

        request.setAttribute("serviceType", serviceType);
        request.setAttribute("servicePrice", amount);

        request.setAttribute("promotion", promotion);

        request.setAttribute("voucherDiscount", voucherDiscount);
        request.setAttribute("tierDiscount", tierDiscount);

        request.setAttribute("total", total);
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