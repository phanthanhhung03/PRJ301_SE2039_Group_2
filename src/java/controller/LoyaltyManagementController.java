/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.CustomerTierDAO;
import dao.PointTransactionDAO;
import dto.Admin;
import dto.Customer;
import dto.CustomerTier;
import dto.PointTransaction;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
@WebServlet(name = "LoyaltyManagementController", urlPatterns = {"/LoyaltyManagementController"})
public class LoyaltyManagementController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

        String action = request.getParameter("action");

        try {
            CustomerTierDAO tierDAO = new CustomerTierDAO();

            // ------------------------------------------------------------------
            // Hiển thị trang Configure Tier (thay cho modal)
            // ------------------------------------------------------------------
            if ("showConfigureTier".equals(action)) {
                int tierID = Integer.parseInt(request.getParameter("tierID"));

                CustomerTier tier = tierDAO.getTierByID(tierID);
                if (tier == null) {
                    session.setAttribute("TIER_ERR", "Tier not found.");
                    response.sendRedirect("MainController?action=viewLoyaltyManagement");
                    return;
                }

                request.setAttribute("tier", tier);
                request.getRequestDispatcher("/admin/configure-tier.jsp").forward(request, response);
                return;
            }

            // ------------------------------------------------------------------
            // DEFAULT: load and display loyalty management page
            // ------------------------------------------------------------------
            CustomerDAO customerDAO = new CustomerDAO();
            PointTransactionDAO pointTransactionDAO = new PointTransactionDAO();
            List<CustomerTier> tierList = tierDAO.getAllTiers();
            Map<Integer, Integer> customerTierCountMap = tierDAO.getCustomerCountByTier();
            List<PointTransaction> transactionList = pointTransactionDAO.getRecentTransactions(50);
            Map<String, Integer[]> monthlySummary = pointTransactionDAO.getMonthlyPointsSummary(6);
            Map<String, Double> tierPointsAvgMap = pointTransactionDAO.getAveragePointsByTier();
            Map<Integer, Double> revenueByTierMap = customerDAO.getRevenueByTier();
            List<Customer> topCustomersByPoints = customerDAO.getTopCustomersByPoints(5);

            double totalRevenue = 0;
            for (double v : revenueByTierMap.values()) {
                totalRevenue += v;
            }

            request.setAttribute("tierList", tierList);
            request.setAttribute("customerTierCountMap", customerTierCountMap);
            request.setAttribute("transactionList", transactionList);
            request.setAttribute("monthlySummary", monthlySummary);
            request.setAttribute("tierPointsAvgMap", tierPointsAvgMap);
            request.setAttribute("revenueByTierMap", revenueByTierMap);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("topCustomersByPoints", topCustomersByPoints);

            request.getRequestDispatcher("/admin/loyalty-management.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("TIER_ERR", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect("MainController?action=viewLoyaltyManagement");
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
