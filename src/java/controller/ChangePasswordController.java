/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dto.Customer;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ChangePasswordController", urlPatterns = {"/ChangePasswordController"})
public class ChangePasswordController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String oldPassword = request.getParameter("oldPassword");

        String newPassword = request.getParameter("newPassword");

        String confirmPassword = request.getParameter("confirmPassword");

        if (oldPassword == null || oldPassword.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.getSession().setAttribute(
                    "errorMessage_pw",
                    "Please fill in all required fields.");

            response.sendRedirect(
                    "MainController?action=viewDashboard#profile");

            return;
        }

        Customer user
                = (Customer) request.getSession()
                        .getAttribute("USER");

        if (user == null) {

            response.sendRedirect(
                    "MainController?action=viewSignIn");

            return;
        }

        // MATCH CURRENT PW ?
        if (!oldPassword.equals(user.getPassword())) {

            request.getSession().setAttribute(
                    "errorMessage_pw",
                    "Current password is incorrect.");

            response.sendRedirect(
                    "MainController?action=viewDashboard#profile");

            return;
        }

        if (newPassword.equals(oldPassword)) {

            request.getSession().setAttribute(
                    "errorMessage_pw",
                    "New password must be different from current password.");

            response.sendRedirect(
                    "MainController?action=viewDashboard#profile");

            return;
        }

        if (!newPassword.equals(confirmPassword)) {

            request.getSession().setAttribute(
                    "errorMessage_pw",
                    "Confirm password does not match.");

            response.sendRedirect(
                    "MainController?action=viewDashboard#profile");

            return;
        }

        CustomerDAO dao
                = new CustomerDAO();

        int updated
                = dao.updatePassword(
                        user.getCusId(),
                        newPassword);

        if (updated > 0) {

            Customer updatedUser
                    = dao.getCustomer(
                            user.getCusId());

            request.getSession().setAttribute(
                    "USER",
                    updatedUser);

            request.getSession().setAttribute(
                    "SUCCESS_MESSAGE",
                    "Password changed successfully.");

            response.sendRedirect(
                    "MainController?action=viewDashboard#profile");

            return;
        }

        request.getSession().setAttribute(
                "errorMessage_pw",
                "Password update failed.");

        response.sendRedirect(
                "MainController?action=viewDashboard#profile");

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
