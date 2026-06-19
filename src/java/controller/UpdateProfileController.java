/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

        if (newName == null || newName.trim().isEmpty()) {
            request.setAttribute("nameError", "Full name is required.");
            hasError = true;
        }

        if (newPhoneNumber == null || newPhoneNumber.trim().isEmpty()) {
            request.setAttribute("phoneError", "Phone number is required.");
            hasError = true;
        }

        if (newAddress == null || newAddress.trim().isEmpty()) {
            request.setAttribute("addressError", "Address is required.");
            hasError = true;
        }

        request.setAttribute("newName", newName);
        request.setAttribute("newPhoneNumber", newPhoneNumber);
        request.setAttribute("newAddress", newAddress);
        if (hasError) {
            request.getRequestDispatcher("dashboard.jsp")
                    .forward(request, response);
            return;
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
