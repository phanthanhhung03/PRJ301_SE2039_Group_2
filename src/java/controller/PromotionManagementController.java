package controller;

import dao.CustomerPromotionDAO;
import dao.PromotionDAO;
import dao.PromotionTierDAO;
import dto.Admin;
import dto.CustomerPromotion;
import dto.Promotion;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Handles all Promotion-Management page actions.
 */
@WebServlet(name = "PromotionManagementController",
        urlPatterns = {"/PromotionManagementController"})
public class PromotionManagementController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // Guard: admin must be logged in
        if (session == null || session.getAttribute("ADMIN_USER") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/MainController?action=viewAdminSignIn");
            return;
        }

        Admin admin = (Admin) session.getAttribute("ADMIN_USER");

        String action = request.getParameter("action");
        if (action == null) {
            action = "viewPromotionManagement";
        }
        PromotionDAO promotionDAO = new PromotionDAO();
        CustomerPromotionDAO customerPromotionDAO = new CustomerPromotionDAO();
        try {
            // ------------------------------------------------------------------
            // POST actions
            // ------------------------------------------------------------------

            // Add Promotion
            if ("addPromotion".equals(action)) {
                Promotion p = new Promotion();
                p.setAdminID(admin.getAdminID());
                p.setPromotionName(request.getParameter("promotionName").trim());
                p.setDescription(request.getParameter("description").trim());
                p.setDiscountPercent(Double.parseDouble(request.getParameter("discountPercent")));
                p.setBonusPoints(Integer.parseInt(request.getParameter("bonusPoints")));
                p.setStartDate(Date.valueOf(request.getParameter("startDate")));
                p.setEndDate(Date.valueOf(request.getParameter("endDate")));
                p.setStatus(true);

                String targetType = request.getParameter("targetType");
                p.setTargetType(targetType);

                int promotionID = promotionDAO.createPromotion(p);
                if (promotionID > 0) {
                    PromotionTierDAO tierDAO = new PromotionTierDAO();
                    if ("TIER_ONLY".equals(targetType)) {
                        String minTierIDParam = request.getParameter("minTierID");
                        if (minTierIDParam != null && !minTierIDParam.isEmpty()) {
                            tierDAO.setMinimumTier(promotionID, Integer.parseInt(minTierIDParam));
                        }
                    }
                    session.setAttribute("PROMO_MSG", "Promotion created successfully!");
                } else {
                    session.setAttribute("PROMO_ERR", "Failed to create promotion.");
                }

                response.sendRedirect("MainController?action=viewPromotionManagement");
                return;

                // Edit Promotion
            } else if ("editPromotion".equals(action)) {
                Promotion p = new Promotion();
                String targetType = request.getParameter("targetType");
                p.setTargetType(targetType);
                p.setPromotionID(Integer.parseInt(request.getParameter("promotionID")));
                p.setPromotionName(request.getParameter("promotionName").trim());
                p.setDescription(request.getParameter("description").trim());
                p.setDiscountPercent(Double.parseDouble(request.getParameter("discountPercent")));
                p.setBonusPoints(Integer.parseInt(request.getParameter("bonusPoints")));
                p.setStartDate(Date.valueOf(request.getParameter("startDate")));
                p.setEndDate(Date.valueOf(request.getParameter("endDate")));
                p.setStatus("on".equals(request.getParameter("status")));

                boolean isValid = promotionDAO.updatePromotion(p) > 0;
                if (isValid) {

                    PromotionTierDAO tierDAO = new PromotionTierDAO();
                    if ("TIER_ONLY".equals(targetType)) {
                        String minTierIDParam = request.getParameter("minTierID");
                        if (minTierIDParam != null && !minTierIDParam.isEmpty()) {
                            tierDAO.setMinimumTier(p.getPromotionID(), Integer.parseInt(minTierIDParam));
                        }
                    } else {
                        // Không còn TIER_ONLY nữa thì xóa mapping cũ
                        tierDAO.deleteTierMappingByPromotionID(p.getPromotionID());
                    }

                }
                session.setAttribute(isValid ? "PROMO_MSG" : "PROMO_ERR",
                        isValid ? "Promotion updated successfully!" : "Failed to update promotion. Check inputs.");
                response.sendRedirect("MainController?action=viewPromotionManagement");
                return;

                // Remove Promotion
            } else if ("deletePromotion".equals(action)) {
                int id = Integer.parseInt(request.getParameter("promotionID"));

                boolean isValid = promotionDAO.deletePromotion(id) > 0;
                session.setAttribute(isValid ? "PROMO_MSG" : "PROMO_ERR",
                        isValid ? "Promotion deleted successfully!" : "Failed to delete promotion. It may still be assigned to customers.");
                response.sendRedirect("MainController?action=viewPromotionManagement");
                return;

                // Assign Promotion for Customer
            } else if ("assignPromotion".equals(action)) {

                int customerID = Integer.parseInt(request.getParameter("customerID"));
                int promotionID = Integer.parseInt(request.getParameter("promotionID"));
                String notes = request.getParameter("notes");

                if (notes == null) {
                    notes = "";
                }

                // Promotion outdated or start soon
                if (!promotionDAO.isPromotionValid(promotionID)) {
                    session.setAttribute("PROMO_ERR", "This promotion is expired or start soon !.");
                    response.sendRedirect("MainController?action=viewPromotionManagement");
                    return;
                }

                // Tier is not suitable
                if (!promotionDAO.isCustomerEligibleForPromotion(customerID, promotionID)) {
                    session.setAttribute("PROMO_ERR", "Customer is not eligible for this promotion.");
                    response.sendRedirect("MainController?action=viewPromotionManagement");
                    return;
                }

                boolean isValid = customerPromotionDAO.assignPromotion(customerID, promotionID, notes.trim()) > 0;
                session.setAttribute(isValid ? "PROMO_MSG" : "PROMO_ERR",
                        isValid ? "Promotion granted to customer successfully!" : "Failed to assign promotion.");
                response.sendRedirect("MainController?action=viewPromotionManagement");
                return;

                // Remove Customer Assigned Promotion
            } else if ("removeAssignedPromotion".equals(action)) {
                int cpID = Integer.parseInt(request.getParameter("customerPromotionID"));

                boolean isValid = customerPromotionDAO.revokeAssignment(cpID) > 0;
                session.setAttribute(isValid ? "PROMO_MSG" : "PROMO_ERR",
                        isValid ? "Assignment removed successfully!" : "Failed to remove assignment.");
                response.sendRedirect("MainController?action=viewPromotionManagement");
                return;
            }

            // ------------------------------------------------------------------
            // DEFAULT: load and display the page
            // ------------------------------------------------------------------
            List<Promotion> promotionList = promotionDAO.getAllPromotions();
            List<CustomerPromotion> assignments = customerPromotionDAO.getAllAssignments();
            List<CustomerPromotion> lowEngagementCustomer = customerPromotionDAO.getLowEngagementCustomers();

            int activeCount = 0;
            for (Promotion p : promotionList) {
                if (p.isStatus()) {
                    activeCount++;
                }
            }
            // ➕ Build map promotionID -> selected tierIDs
            PromotionTierDAO tierDAO = new PromotionTierDAO();
            java.util.Map<Integer, Integer> promotionMinTierMap = new java.util.HashMap<>();
            for (Promotion p : promotionList) {
                if ("TIER_ONLY".equals(p.getTargetType())) {
                    Integer minTierID = tierDAO.getMinimumTierID(p.getPromotionID());
                    if (minTierID != null) {
                        promotionMinTierMap.put(p.getPromotionID(), minTierID);
                    }
                }
            }

            // Set data to JSP
            request.setAttribute("activePromotionsCount", (int) activeCount);
            request.setAttribute("promotionTiersMap", promotionMinTierMap);
            request.setAttribute("assignedCount", assignments.size());
            request.setAttribute("lowEngagementCustomerCount", lowEngagementCustomer.size());
            request.setAttribute("promotionList", promotionList);
            request.setAttribute("assignedPromotions", assignments);
            request.setAttribute("lowEngagementCustomer", lowEngagementCustomer);

            // Forward
            request.getRequestDispatcher("/admin/promotion-management.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("PROMO_ERR", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect("MainController?action=viewPromotionManagement");
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
