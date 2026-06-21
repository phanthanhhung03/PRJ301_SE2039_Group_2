package controller;

import dao.CustomerDAO;
import dto.Customer;
import dto.CustomerTier;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ADCreateCustomer", urlPatterns = {"/ADCreateCustomer"})
public class ADCreateCustomer extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {

            String fullName = request.getParameter("fullName");
            String phoneNumber = request.getParameter("phoneNumber");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            int tierId = Integer.parseInt(
                    request.getParameter("tierId"));

            boolean status = Boolean.parseBoolean(
                    request.getParameter("status"));

            Customer customer = new Customer();

            customer.setFullName(fullName);
            customer.setPhoneNumber(phoneNumber);
            customer.setEmail(email);
            customer.setAddress(address);
            customer.setPassword(password);
            customer.setStatus(status);

            CustomerTier tier = new CustomerTier();
            tier.setTierID(tierId);

            customer.setTierId(tier);

            // Password confirmation validation
            if (!password.equals(confirmPassword)) {

                request.setAttribute(
                        "ERROR",
                        "Password and Confirm Password do not match.");

                request.setAttribute(
                        "customer",
                        customer);

                request.getRequestDispatcher(
                        "/admin/create-customer.jsp")
                        .forward(request, response);

                return;
            }

            CustomerDAO dao = new CustomerDAO();

            Customer existedCustomer = dao.getCustomer(email);

            if (existedCustomer != null) {

                request.setAttribute(
                        "ERROR",
                        "Email already exists.");

                request.setAttribute(
                        "customer",
                        customer);

                request.getRequestDispatcher(
                        "/admin/create-customer.jsp")
                        .forward(request, response);

                return;
            }

            int result = dao.createCustomerByAdmin(customer);

            if (result > 0) {

                HttpSession session = request.getSession();

                session.setAttribute(
                        "SUCCESS",
                        "Customer created successfully.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/MainController?action=viewCustomerManagement");

            } else {

                request.setAttribute(
                        "ERROR",
                        "Unable to create customer.");

                request.setAttribute(
                        "customer",
                        customer);

                request.getRequestDispatcher(
                        "/admin/create-customer.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "ERROR",
                    "Unexpected error occurred.");

            request.getRequestDispatcher(
                    "/admin/create-customer.jsp")
                    .forward(request, response);
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
