package controller;

import dao.CustomerDAO;
import dao.CustomerTierDAO;
import dao.VehicleDAO;
import dto.Customer;
import dto.CustomerTier;
import dto.Vehicle;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        Customer user = (Customer) request.getSession().getAttribute("USER");

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/MainController?action=viewSignIn");

            return;
        }
        CustomerDAO cDao = new CustomerDAO();
        Customer freshUser = cDao.getCustomer(user.getCusId());
        if (freshUser != null) {
            user = freshUser; // Gán lại data mới
            request.getSession().setAttribute("USER", user); // Đè ngược lại vào Session
        }
        VehicleDAO vd = new VehicleDAO();
        List<Vehicle> vehicleList = vd.getVehiclesByCustomerId(user.getCusId());

        if (user == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/MainController?action=viewSignIn");
            return;
        }

        // === Next Reward ===
        CustomerTier currentTier = user.getTierId();

        CustomerTierDAO tierDAO = new CustomerTierDAO();

        CustomerTier nextTier
                = tierDAO.getNextTier(
                        currentTier.getPriorityLevel());

        boolean isMaxTier = (nextTier == null);

        String nextTierName = null;
        double bookingTarget = 0;
        double spendTarget = 0;

        if (!isMaxTier) {

            nextTierName = nextTier.getTierName();

            bookingTarget = nextTier.getMinBookings();

            spendTarget = nextTier.getMinSpend();
        }

        int currentBookings = user.getTotalBooking();
        double currentSpend = user.getTotalSpend();
        int currentPoints = user.getCurrentPoint();
        
        int remainingWashes = 0;
        double remainingSpend = 0;
        double progressPercent = 100;
        int remainingPoints = 0;

        if (!isMaxTier) {

            remainingWashes = (int) Math.max(0, bookingTarget - currentBookings);

            remainingSpend = Math.max(0, spendTarget - currentSpend);

            double bookingProgress = currentBookings * 100.0 / bookingTarget;
            double spendProgress = currentSpend * 100.0 / spendTarget;

            progressPercent = Math.min(100,
                            Math.max(
                                    bookingProgress,
                                    spendProgress));

            remainingPoints= (int) Math.ceil(remainingSpend / 1000.0);
        }

        // Finding Member Tier
        String tierMessage = isMaxTier ? "Highest Tier Achieved" : "Next Tier: " + nextTierName;
        String progressMessage = isMaxTier ? "Platinum Member" : String.format("%,d pts remaining", remainingPoints);

        //Total Vehicles
        int totalVehicles = vehicleList.size();

        //Set data forward to JSP
        request.setAttribute(
                "tierMessage",
                tierMessage);

        request.setAttribute("isMaxTier", isMaxTier);

        request.setAttribute(
                "progressMessage",
                progressMessage);

        String formattedCurrentPoints
                = String.format("%,d", currentPoints);

        request.setAttribute(
                "formattedCurrentPoints",
                formattedCurrentPoints);

        request.setAttribute(
                "progressPercent",
                progressPercent);

        request.setAttribute(
                "remainingWashes",
                remainingWashes);

        request.setAttribute(
                "remainingSpend",
                remainingSpend);

        request.setAttribute(
                "totalVehicles",
                totalVehicles);

        String formattedRemainingSpend
                = String.format("%,.0f", remainingSpend);

        request.setAttribute(
                "formattedRemainingSpend",
                formattedRemainingSpend);

        request.getSession().setAttribute("vehicleList", vehicleList);
        request.getRequestDispatcher("/customer/dashboard.jsp").forward(request, response);

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
