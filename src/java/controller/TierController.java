package controller;

import dao.CustomerTierDAO;
import dto.CustomerTier;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet(name = "TierController", urlPatterns = {"/TierController"})
public class TierController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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
