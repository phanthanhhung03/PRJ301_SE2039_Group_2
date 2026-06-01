/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

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
                url = "SignupController";
                break;

            case "viewDashBoard":
                url = "/dashboard";
                break;

            case "viewAdminSignIn":
                url = "/admin/admin-login.jsp";
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
