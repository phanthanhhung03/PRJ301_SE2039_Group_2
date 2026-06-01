/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dto.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author shin
 */
@WebServlet(name = "SignupController", urlPatterns = {"/SignupController"})
public class SignupController extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        //luu du~ lieu cu~ vao` req
        request.setAttribute("oldFullName", fullname);
        request.setAttribute("oldEmail", email);
        request.setAttribute("oldPhone", phone);
        request.setAttribute("oldAddress", address);

        Customer c = new Customer();
        c.setFullName(fullname);
        c.setPhoneNumber(phone);
        c.setEmail(email);
        c.setPassword(password);
        c.setAddress(address);

        CustomerDAO dao = new CustomerDAO();
        Customer check1 = dao.getCustomer(email);
        Customer check2 = dao.getCustomer2(phone);

        // Kiểm tra trùng lặp Database
        if (check1 != null) {
            request.setAttribute("SIGNUP_ERROR", "true");
            request.setAttribute("SIGNUP_ERROR_EMAIL", "This email is already in use.");
            request.getRequestDispatcher("/customer/signup.jsp").forward(request, response);
        } else if (check2 != null) {
            request.setAttribute("SIGNUP_ERROR", "true");
            request.setAttribute("SIGNUP_ERROR_PHONE", "This phone number is already in use.");
            request.getRequestDispatcher("/customer/signup.jsp").forward(request, response);
        } else {
            int result = dao.createCustomer(c);
            if (result >= 1) {
                // Reset form after successful registration.
                request.removeAttribute("oldFullName");
                request.removeAttribute("oldEmail");
                request.removeAttribute("oldPhone");
                request.removeAttribute("oldAddress");
                request.setAttribute("REGISTERED_SUCCESS",
                "Your account has been created successfully. Please sign in to continue.");
                request.getRequestDispatcher("/customer/signin.jsp").forward(request, response);
            } else {
                request.setAttribute("SIGNUP_ERROR", "Something went wrong. Please try again later.");
                request.getRequestDispatcher("/customer/signup.jsp").forward(request, response);
            }
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
