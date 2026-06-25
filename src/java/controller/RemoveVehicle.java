/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookingDAO;
import dao.VehicleDAO;
import dto.Booking;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Asus
 */
@WebServlet(name = "RemoveVehicle", urlPatterns = {"/RemoveVehicle"})
public class RemoveVehicle extends HttpServlet {

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

        int vehicleId = Integer.parseInt(request.getParameter("vehicleID"));

        VehicleDAO dao = new VehicleDAO();
        BookingDAO bookingDao = new BookingDAO();
        List<Booking> bookings = bookingDao.getBookingsByVehicleId(vehicleId, "Pending");

        if (!bookings.isEmpty()) {
            request.getSession().setAttribute(
                    "ERROR_MESSAGE",
                    "Failed to remove vehicle. You must cancel booking first");

            response.sendRedirect(
                    request.getContextPath()
                    + "/MainController?action=viewDashboard");
            return;
        }

        int result = dao.softDeleteVehicle(vehicleId);

        if (result > 0) {

            request.getSession().setAttribute(
                    "SUCCESS_MESSAGE",
                    "Vehicle removed successfully.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/MainController?action=viewDashboard");

            return;

        } else {

            request.getSession().setAttribute(
                    "ERROR_MESSAGE",
                    "Failed to remove vehicle.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/MainController?action=viewDashboard");

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
