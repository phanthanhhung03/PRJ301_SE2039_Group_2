/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.CustomerTierDAO;
import dao.PromotionDAO;
import dao.PromotionTierDAO;
import dao.VehicleDAO;
import dto.Admin;
import dto.Booking;
import dto.Customer;
import dto.CustomerTier;
import dto.Promotion;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminDashboardController",
        urlPatterns = {"/AdminDashboardController"})
public class AdminDashboardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Check Admin Login
        if (session == null || session.getAttribute("ADMIN_USER") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/MainController?action=viewAdminSignIn");

            return;
        }
        Admin admin = (Admin) session.getAttribute("ADMIN_USER");

        try {

            CustomerDAO customerDAO = new CustomerDAO();
            VehicleDAO vehicleDAO = new VehicleDAO();
            CustomerTierDAO tierDAO = new CustomerTierDAO();
            PromotionDAO promotionDAO = new PromotionDAO();
            PromotionTierDAO promotionTierDAO = new PromotionTierDAO();
            BookingDAO bookingDAO = new BookingDAO();
            // Statistics
            int totalCustomers = customerDAO.countCustomers();
            int totalVehicles = vehicleDAO.countVehicles();
            List<Customer> topCustomers = customerDAO.getTopCustomers();
            List<Promotion> promotionList = promotionDAO.getAllPromotions();
            List<Booking> allBookings = bookingDAO.getAllAdminBookings();
            // Tier Data
            List<CustomerTier> tierList = tierDAO.getAllTiers();
            Map<Integer, Integer> customerTierCountMap = tierDAO.getCustomerCountByTier();

            Map<Integer, Double> percentageMap = new HashMap<>(); // Lay percentage de hien thi
            for (CustomerTier tier : tierList) {

                int customerCount = customerTierCountMap.getOrDefault(tier.getTierID(), 0);
                double percentage = 0;
                if (totalCustomers > 0) {
                    percentage = customerCount * 100.0 / totalCustomers;
                }

                percentageMap.put(tier.getTierID(), percentage);
            }

            Map<Integer, String> targetTierMap = new HashMap<>(); // Lay tier target
            for (Promotion p : promotionList) {
                targetTierMap.put(p.getPromotionID(), promotionTierDAO.getTargetTierNames(p.getPromotionID()));
            }

            // Get Revenue by Year
            int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
            double yearRevenue = bookingDAO.getRevenueByYear(currentYear);

            // Send Data To JSP
            request.setAttribute("totalCustomers", totalCustomers);

            request.setAttribute("totalVehicles", totalVehicles);

            request.setAttribute("tierList", tierList);

            request.setAttribute("customerTierCountMap", customerTierCountMap);

            request.setAttribute("percentageMap", percentageMap);

            request.setAttribute("topCustomers", topCustomers);

            request.setAttribute("promotionList", promotionList);

            request.setAttribute("targetTierMap", targetTierMap);

            request.setAttribute("yearRevenue", yearRevenue);
            request.setAttribute("currentYear", currentYear);

            request.setAttribute("ALL_BOOKINGS", allBookings);
            request.setAttribute("totalBookings", allBookings.size());
            // Forward
            request.getRequestDispatcher("/admin/admin-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
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
