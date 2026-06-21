package controller;

import dao.CustomerDAO;
import dto.Customer;
import dto.CustomerTier;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ADUpdateCustomer", urlPatterns = {"/ADUpdateCustomer"})
public class ADUpdateCustomer extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {

            int customerId = Integer.parseInt(
                    request.getParameter("cusId"));

            String fullName = request.getParameter("fullName");

            String phoneNumber = request.getParameter("phoneNumber");

            String email = request.getParameter("email");

            String address = request.getParameter("address");

            int tierId = Integer.parseInt(
                    request.getParameter("tierId"));

            boolean status = Boolean.parseBoolean(
                    request.getParameter("status"));

            Customer customer = new Customer();

            customer.setCusId(customerId);
            customer.setFullName(fullName);
            customer.setPhoneNumber(phoneNumber);
            customer.setEmail(email);
            customer.setAddress(address);
            customer.setStatus(status);

            CustomerTier tier = new CustomerTier();
            tier.setTierID(tierId);

            customer.setTierId(tier);

            CustomerDAO dao = new CustomerDAO();

            boolean result = dao.updateCustomer(customer);

            if (result) {
                request.getSession().setAttribute(
                        "SUCCESS",
                        "Customer updated successfully.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/MainController?action=viewCustomerManagement");

            } else {

                request.setAttribute(
                        "ERROR",
                        "Failed to update customer.");

                request.setAttribute(
                        "customer",
                        customer);

                request.getRequestDispatcher(
                        "/admin/edit-customer.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/MainController?action=viewCustomerManagement");
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
