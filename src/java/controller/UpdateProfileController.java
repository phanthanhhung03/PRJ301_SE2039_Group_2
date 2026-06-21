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
import org.apache.tomcat.jni.SSLContext;

/**
 *
 * @author Asus
 */
@WebServlet(name = "UpdateProfileController", urlPatterns = {"/updateProfile"})
public class UpdateProfileController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String newName = request.getParameter("newName");
        String newPhoneNumber = request.getParameter("newPhoneNumber");
        String newAddress = request.getParameter("newAddress");

        boolean hasError = false;

        if (newName == null || newName.trim().isEmpty()
                || newPhoneNumber == null || newPhoneNumber.trim().isEmpty()
                || newAddress == null || newAddress.trim().isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Please fill in all required fields."
            );

            hasError = true;
        }

        if (hasError) {
            request.getRequestDispatcher("customer/dashboard.jsp")
                    .forward(request, response);
            return;
        }

        Customer user = (Customer) request.getSession().getAttribute("USER");
        int cusId = user.getCusId();

        CustomerDAO dao = new CustomerDAO();

        int updated = dao.updateCustomer(
                cusId,
                newName,
                newPhoneNumber,
                newAddress
        );

        if (updated > 0) {

            Customer updatedUser = dao.getCustomer(cusId);

            request.getSession().setAttribute(
                    "USER",
                    updatedUser
            );

            request.getSession().setAttribute(
                    "SUCCESS_MESSAGE",
                    "Profile updated successfully."
            );

            response.sendRedirect(
                    "MainController?action=viewDashboard#profile"
            );
            return;
        }

        request.setAttribute(
                "errorMessage",
                "Update profile failed!"
        );

        request.getRequestDispatcher(
                "customer/dashboard.jsp#profile"
        ).forward(request, response);

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
