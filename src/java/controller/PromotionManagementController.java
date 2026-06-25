package controller;

import dao.CustomerDAO;
import dao.CustomerPromotionDAO;
import dao.PromotionDAO;
import dao.PromotionTierDAO;
import dto.Admin;
import dto.Customer;
import dto.CustomerPromotion;
import dto.Promotion;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
            response.sendRedirect(request.getContextPath() + "/MainController?action=viewAdminSignIn");
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
            // GET actions
            // ------------------------------------------------------------------

            // Show Add Promotion page
            if ("showAddPromotion".equals(action)) {
                request.getRequestDispatcher("/admin/add-promotion.jsp").forward(request, response);
                return;
            } // Show Edit Promotion page
            else if ("showEditPromotion".equals(action)) {
                int promotionID = Integer.parseInt(request.getParameter("promotionID"));

                Promotion promo = promotionDAO.getPromotionByID(promotionID);
                if (promo == null) {
                    session.setAttribute("PROMO_ERR", "Promotion not found.");
                    response.sendRedirect("MainController?action=viewPromotionManagement");
                    return;
                }

                PromotionTierDAO tierDAO = new PromotionTierDAO();
                Integer curMinTier = null;
                if ("TIER_ONLY".equals(promo.getTargetType())) {
                    curMinTier = tierDAO.getMinimumTierID(promotionID);
                }

                request.setAttribute("promo", promo);
                request.setAttribute("curMinTier", curMinTier);
                request.getRequestDispatcher("/admin/edit-promotion.jsp").forward(request, response);
                return;

                // Show Assign Promotion page
            } else if ("showAssignPromotion".equals(action)) {
                int customerID = Integer.parseInt(request.getParameter("customerID"));

                CustomerDAO customerDAO = new CustomerDAO();
                Customer targetCust = customerDAO.getCustomer(customerID);

                if (targetCust == null) {
                    session.setAttribute("PROMO_ERR", "Customer not found.");
                    response.sendRedirect("MainController?action=viewPromotionManagement");
                    return;
                }

                List<Promotion> activePromotions = promotionDAO.getAllPromotions();

                request.setAttribute("targetCust", targetCust);
                request.setAttribute("promotionList", activePromotions);
                request.getRequestDispatcher("/admin/assign-promotion.jsp").forward(request, response);
                return;

                // ------------------------------------------------------------------
                // POST actions
                // ------------------------------------------------------------------
                // Add Promotion
            } else if ("addPromotion".equals(action)) {

                String validateError = validatePromotionInput(request);
                if (validateError != null) {
                    session.setAttribute("PROMO_ERR", validateError);
                    response.sendRedirect("MainController?action=viewPromotionManagement");
                    return;
                }

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

                String validateError = validatePromotionInput(request);
                if (validateError != null) {
                    session.setAttribute("PROMO_ERR", validateError);
                    response.sendRedirect("MainController?action=viewPromotionManagement");
                    return;
                }

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
                        tierDAO.deleteTierMappingByPromotionID(p.getPromotionID());
                    }
                }

                session.setAttribute(isValid ? "PROMO_MSG" : "PROMO_ERR",
                        isValid ? "Promotion updated successfully!" : "Failed to update promotion. Check inputs.");
                response.sendRedirect("MainController?action=viewPromotionManagement");
                return;

                // Delete Promotion
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

                // Promotion outdated or sooner
                if (!promotionDAO.isPromotionValid(promotionID)) {
                    session.setAttribute("PROMO_ERR", "This promotion is expired or sooner than start-date!");
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

            //  Build map promotionID to get selected minTierId
            PromotionTierDAO tierDAO = new PromotionTierDAO();
            Map<Integer, String> promotionMinTierNameMap = new HashMap<>();
            for (Promotion p : promotionList) {
                if ("TIER_ONLY".equals(p.getTargetType())) {
                    String tierName = tierDAO.getTargetTierNames(p.getPromotionID());
                    promotionMinTierNameMap.put(p.getPromotionID(), tierName);
                }
            }

            // Auto update active or inactive promo Up to Date
            java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
            Map<Integer, Boolean> promotionActiveMap = new java.util.HashMap<>();
            for (Promotion p : promotionList) {
                boolean isActuallyActive = p.isStatus()
                        && !p.getStartDate().after(today)
                        && !p.getEndDate().before(today);
                promotionActiveMap.put(p.getPromotionID(), isActuallyActive);

            }
            // Set data to JSP
            request.setAttribute("activePromotionsCount", (int) activeCount);
            request.setAttribute("promotionMinTierNameMap", promotionMinTierNameMap);
            request.setAttribute("promotionActiveMap", promotionActiveMap);
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

    private String validatePromotionInput(HttpServletRequest request) {

        String name = request.getParameter("promotionName");
        String discountStr = request.getParameter("discountPercent");
        String bonusStr = request.getParameter("bonusPoints");
        String startStr = request.getParameter("startDate");
        String endStr = request.getParameter("endDate");
        String targetType = request.getParameter("targetType");

        // Validate promo name input
        if (name == null || name.trim().isEmpty()) {
            return "Promotion name is required.";
        }
        if (name.trim().length() > 100) {
            return "Promotion name must be at most 100 characters.";
        }

        // Validate discount input
        double discount;
        try {
            discount = Double.parseDouble(discountStr);
        } catch (Exception e) {
            return "Discount percent is invalid.";
        }
        if (discount < 0 || discount > 100) {
            return "Discount percent must be between 0 and 100.";
        }

        // Validate bonus points input
        int bonus;
        try {
            bonus = Integer.parseInt(bonusStr);
        } catch (Exception e) {
            return "Bonus points is invalid.";
        }
        if (bonus < 0) {
            return "Bonus points cannot be negative.";
        }

        // Prevent endDate before startDate
        Date startDate, endDate;
        try {
            startDate = Date.valueOf(startStr);
            endDate = Date.valueOf(endStr);
        } catch (Exception e) {
            return "Start date / End date is invalid.";
        }
        if (endDate.before(startDate)) {
            return "End date must be after start date.";
        }

        // Prevent End-Date in Past
        Date today = new Date(System.currentTimeMillis());
        if (endDate.before(today)) {
            return "End date cannot be in the past.";
        }

        if (targetType == null
                || !(targetType.equals("TIER_ONLY")
                || targetType.equals("LOW_ENGAGEMENT"))) {
            return "Target type is invalid.";
        }

        if ("TIER_ONLY".equals(targetType)) {
            String minTierIDParam = request.getParameter("minTierID");
            if (minTierIDParam == null || minTierIDParam.trim().isEmpty()) {
                return "Minimum tier is required when target type is Specific Tiers.";
            }
            try {
                Integer.parseInt(minTierIDParam);
            } catch (Exception e) {
                return "Minimum tier is invalid.";
            }
        }

        return null; // Valid
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
