/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.VehicleDAO;
import dto.Customer;
import dto.Vehicle;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Asus
 */
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "/customer/landing-page";
        }

        String url;

        switch (action) {

            case "viewSignIn":
                if (request.getSession().getAttribute("USER") != null) {
                    response.sendRedirect(
                            "MainController?action=viewDashBoard");
                    return;
                }

                url = "/customer/signin.jsp";
                break;

            case "viewSignUp":
                url = "/customer/signup.jsp";
                break;

            case "landing":
                if (request.getSession().getAttribute("USER") != null) {
                    response.sendRedirect(
                            "MainController?action=viewDashBoard");
                    return;
                }

                url = "/customer/landing-page.jsp";
                break;

            case "signIn":
                url = "/SigninController";
                break;

            case "logout":
                url = "/LogoutController";
                break;

            case "signUp":
                url = "/SignupController";
                break;

            case "viewDashBoard":
                url = "/dashboard";
                break;

            case "viewNewBooking": {
                if (request.getParameter("vehicleId") != null) {
                    int vehicleID = Integer.parseInt(
                            request.getParameter("vehicleId"));

                    VehicleDAO dao = new VehicleDAO();
                    Vehicle vehicle = dao.getActiveVehicleById(vehicleID);
                    request.setAttribute("VEHICLE", vehicle);
                }

                url = "/customer/bookingpage.jsp";
                break;
            }

            case "viewPayment":
                url = "/PaymentServlet";
                break;

            case "createBookingProcess":
                url = "/BookingController";
                break;

            case "viewAddVehicle":
                url = "/customer/addVehicle.jsp";
                break;

            // ADMIN
            case "viewAdminSignIn":
                if (request.getSession().getAttribute("ADMIN_USER") != null) {
                    response.sendRedirect("MainController?action=viewAdminDashboard");
                    return;
                }
                url = "/admin/admin-login.jsp";
                break;

            case "adminSignInProcess":
                url = "/AdminSigninController";
                break;

            case "viewAdminDashboard":
                url = "/AdminDashboardController";
                break;
            case "viewLoyaltyManagement":
                url = "/LoyaltyManagementController";
                break;

            case "updateTier":
                url = "/TierController";
                break;

            case "showConfigureTier":
                url = "/LoyaltyManagementController";
                break;

            case "registerVehicle":
                url = "/vehicle/register";
                break;

            case "viewCustomerManagement":
                url = "/ADManagementCustomer";
                break;

            case "viewCustomerBookingHistory":
                url = "ViewCustomerBookingHistoryController";
                break;

            case "viewEditCustomer": {
                int customerId = Integer.parseInt((String) request.getParameter("id"));
                CustomerDAO customerDAO = new CustomerDAO();
                Customer customer = customerDAO.getCustomer(customerId);
                if (customer != null) {

                    request.setAttribute("customer", customer);

                    url = "/admin/edit-customer.jsp";

                } else {

                    url = "/admin/customer-management.jsp";

                }

                break;
            }

            case "viewCustomerVehicles":
                url = "ViewCustomerVehiclesController";
                break;

            case "updateCustomer":
                url = "ADUpdateCustomer";
                break;

            case "viewCreateCustomer":
                url = "/admin/create-customer.jsp";
                break;

            case "createCustomer":
                url = "ADCreateCustomer";
                break;

            case "viewAdminBookings":
            case "updateBookingStatus":
                url = "/AdminBookingController"; // Bắt buộc phải qua đây để lấy Data (ALL_BOOKINGS) trước!
                break;

            case "viewPromotionManagement":
                url = "/PromotionManagementController";
                break;
            case "showAddPromotion":
            case "showEditPromotion":
            case "showAssignPromotion":
                url = "/PromotionManagementController";
                break;

            //VEHICLE
            case "addVehicle":
                url = "/AddVehicleController";
                break;

            case "viewUpdateVehicle":

                int vehicleID = Integer.parseInt(
                        request.getParameter("vehicleID"));

                VehicleDAO dao = new VehicleDAO();

                Vehicle vehicle = dao.getActiveVehicleById(vehicleID);

                if (vehicle != null) {

                    request.setAttribute("VEHICLE", vehicle);

                    url = "/customer/updateVehicle.jsp";

                } else {

                    request.getSession().setAttribute(
                            "ERROR_MESSAGE",
                            "Vehicle not found.");

                    url = "/dashboard";

                }

                break;

            case "updateVehicle":
                url = "/UpdateVehicle";
                break;

            case "removeVehicle":
                url = "RemoveVehicle";
                break;

            case "updateProfile":
                url = "updateProfile";
                break;

            case "changePassword":
                url = "/ChangePasswordController";
                break;

            default:
                url = "/customer/landing-page.jsp";
                break;
        }

        request.getRequestDispatcher(url)
                .forward(request, response);
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
