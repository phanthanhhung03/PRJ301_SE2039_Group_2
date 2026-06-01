package controller;

import dao.CustomerDAO;
import dto.Customer;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Asus
 */
@WebServlet(name = "SigninController", urlPatterns = {"/SigninController"})
public class SigninController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Dọn dẹp khoảng trắng dư thừa do copy/paste ở ô email
            email = email.trim();

            //  XÁC THỰC DATABASE
            CustomerDAO d = new CustomerDAO();
            Customer customer = d.getCustomer(email, password);

            // XỬ LÝ ĐIỀU HƯỚNG
            if (customer == null) {
                // Sai tài khoản/mật khẩu
                request.setAttribute("ERROR", "Incorrect email or password!");
                request.getRequestDispatcher("/customer/signin.jsp").forward(request, response);

            } else if (!customer.isStatus()) {
                // Tài khoản bị khóa
                request.setAttribute("ERROR", "Your account has been disabled!");
                request.getRequestDispatcher("/customer/signin.jsp").forward(request, response);

            } else {
                // Đăng nhập thành công -> Cấp Session và đẩy vào Dashboard
                request.getSession().setAttribute("USER", customer);
                response.sendRedirect("MainController?action=viewDashBoard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "The system is undergoing maintenance or experiencing technical issues. Please try again later!");
            request.getRequestDispatcher("/customer/signin.jsp").forward(request, response);
        }
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
