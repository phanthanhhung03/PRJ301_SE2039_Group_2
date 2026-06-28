package controller;

import dao.CustomerTierDAO;
import dto.CustomerTier;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "TierController", urlPatterns = {"/TierController"})
public class TierController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // Guard: admin must be logged in
        if (session == null || session.getAttribute("ADMIN_USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=viewAdminSignIn");
            return;
        }
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("MainController?action=viewLoyaltyManagement");
            return;
        }

        CustomerTierDAO tierDAO = new CustomerTierDAO();
        switch (action) {

            // =========================
            // UPDATE TIER
            // =========================
            case "updateTier": {
                try {
                    int tierID = Integer.parseInt(request.getParameter("tierID"));
                    int minBookings = Integer.parseInt(request.getParameter("minBookings"));
                    double minSpend = Double.parseDouble(request.getParameter("minSpend"));
                    double pointMultiplier = Double.parseDouble(request.getParameter("pointMultiplier"));
                    double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));

                    // ===== VALIDATE =====
                    CustomerTier currentTier = tierDAO.getTierByID(tierID);
                    if (currentTier == null) {
                        request.getSession().setAttribute("ERROR_MESSAGE", "Tier not found.");
                        response.sendRedirect("MainController?action=viewLoyaltyManagement");
                        return;
                    }

                    CustomerTier prevTier = tierDAO.getPreviousTier(currentTier.getPriorityLevel());
                    CustomerTier nextTier = tierDAO.getNextTier(currentTier.getPriorityLevel());

                    // Update Min Booking
                    if (minBookings < 0) {
                        request.getSession().setAttribute("ERROR_MESSAGE", "Minimum bookings cannot be negative.");
                        response.sendRedirect("MainController?action=viewLoyaltyManagement");
                        return;
                    }
                    if (prevTier != null && minBookings <= prevTier.getMinBookings()) {
                        request.getSession().setAttribute("ERROR_MESSAGE",
                                "Minimum bookings must be greater than " + prevTier.getTierName()
                                + "'s threshold (" + prevTier.getMinBookings() + ").");
                        response.sendRedirect("MainController?action=viewLoyaltyManagement");
                        return;
                    }

                    if (nextTier != null && minBookings >= nextTier.getMinBookings()) {
                        request.getSession().setAttribute("ERROR_MESSAGE",
                                "Minimum bookings must be less than " + nextTier.getTierName()
                                + "'s threshold (" + nextTier.getMinBookings() + ").");
                        response.sendRedirect("MainController?action=viewLoyaltyManagement");
                        return;
                    }
                    
                    // Update Min Spend
                    if (minSpend < 0) {
                        request.getSession().setAttribute("ERROR_MESSAGE", "Minimum spend cannot be negative.");
                        response.sendRedirect("MainController?action=viewLoyaltyManagement");
                        return;
                    }
                    if (prevTier != null && minSpend <= prevTier.getMinSpend()) {
                        request.getSession().setAttribute("ERROR_MESSAGE",
                                "Minimum spend must be greater than " + prevTier.getTierName()
                                + "'s threshold (" + prevTier.getMinSpend() + ").");
                        response.sendRedirect("MainController?action=viewLoyaltyManagement");
                        return;
                    }
                    if (nextTier != null && minSpend >= nextTier.getMinSpend()) {
                        request.getSession().setAttribute("ERROR_MESSAGE",
                                "Minimum spend must be less than " + nextTier.getTierName()
                                + "'s threshold (" + nextTier.getMinSpend() + ").");
                        response.sendRedirect("MainController?action=viewLoyaltyManagement");
                        return;
                    }

                    // Point & Discount Percent
                    if (pointMultiplier < 0) {
                        request.getSession().setAttribute("ERROR_MESSAGE", "Point multiplier cannot be negative.");
                        response.sendRedirect("MainController?action=viewLoyaltyManagement");
                        return;
                    }
                    if (discountPercent < 0 || discountPercent > 100) {
                        request.getSession().setAttribute("ERROR_MESSAGE", "Discount percent must be between 0 and 100.");
                        response.sendRedirect("MainController?action=viewLoyaltyManagement");
                        return;
                    }

                    CustomerTier tier = new CustomerTier();
                    tier.setTierID(tierID);
                    tier.setMinBookings(minBookings);
                    tier.setMinSpend(minSpend);
                    tier.setPointMultiplier(pointMultiplier);
                    tier.setDiscountPercent(discountPercent);

                    boolean updated = tierDAO.updateTier(tier);
                    if (updated) {
                        request.getSession().setAttribute("SUCCESS_MESSAGE", "Update tier successfully!");
                    } else {
                        request.getSession().setAttribute("ERROR_MESSAGE", "Update tier failed!");
                    }
                } catch (Exception e) {
                    request.getSession().setAttribute("ERROR_MESSAGE", "Invalid input data!");
                    e.printStackTrace();
                }
                response.sendRedirect("MainController?action=viewLoyaltyManagement");
                return;
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
