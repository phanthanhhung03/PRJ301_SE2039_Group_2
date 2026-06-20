/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.VehicleDAO;
import dto.Customer;
import dto.Vehicle;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddVehicleController")
public class AddVehicleController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Customer customer = (Customer) request.getSession().getAttribute("USER");

        String licensePlate = request.getParameter("licensePlate").trim().toUpperCase();
        String brand = request.getParameter("brand").trim();
        String model = request.getParameter("model").trim();
        if (model != null) {
            model = model.trim();

            if (!model.isEmpty()) {
                model = model.substring(0, 1).toUpperCase()
                        + model.substring(1).toLowerCase();
            }
        }
        String color = request.getParameter("color");

        VehicleDAO dao = new VehicleDAO();
        Vehicle existed = dao.getVehicleByLicensePlate(licensePlate);
        String registerStatus = "";

        //NOT EXISTED
        if (existed == null) {
            Vehicle vehicle = new Vehicle(customer.getCusId(), licensePlate, brand, model, color);

            int result = dao.insertVehicle(vehicle);
            System.out.println(
                    "Insert result = " + result);
            if (result > 0) {
                request.getSession().setAttribute(
                        "SUCCESS_MESSAGE",
                        "Vehicle registered successfully.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/MainController?action=viewDashboard");
                return;

            } else {
                registerStatus
                        = "Failed to register vehicle.";
            }

            //EXISTED AND ACTIVE
        } else if (existed.getStatus()) {
            registerStatus = "This vehicle is already registered.";
            //EXISTED AND UNACTIVE 
        } else {
            int result
                    = dao.restoreVehicle(
                            existed.getVehicleID());

            if (result > 0) {
                request.getSession().setAttribute(
                        "SUCCESS_MESSAGE",
                        "Vehicle restored successfully.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/MainController?action=viewDashboard");
                return;

            } else {
                registerStatus
                        = "Failed to restore vehicle.";
            }
        }

        request.setAttribute("ERROR", registerStatus);
        request.getRequestDispatcher(
                "/customer/addVehicle.jsp")
                .forward(request, response);

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
