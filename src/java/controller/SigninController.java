package controller;

import dao.CustomerDAO;
import dto.Customer;
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
@WebServlet(name = "SigninController", urlPatterns = {"/SigninController"})
public class SigninController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            //  Kiểm tra rỗng hoặc toàn khoảng trắng
            if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                request.setAttribute("ERROR", "Vui lòng nhập đầy đủ Email và Mật khẩu!");
                request.getRequestDispatcher("/customer/signin.jsp").forward(request, response);
                return; 
            }

            // Dọn dẹp khoảng trắng dư thừa do copy/paste ở ô email
            email = email.trim();

            //  XÁC THỰC DATABASE
            CustomerDAO d = new CustomerDAO();
            Customer customer = d.getCustomer(email, password);

            // XỬ LÝ ĐIỀU HƯỚNG
            if (customer == null) {
                // Sai tài khoản/mật khẩu
                request.setAttribute("ERROR", "Email hoặc mật khẩu không chính xác!");
                request.getRequestDispatcher("/customer/signin.jsp").forward(request, response);

            } else if (!customer.isStatus()) {
                // Tài khoản bị khóa
                request.setAttribute("ERROR", "Tài khoản của bạn đã bị vô hiệu hóa!");
                request.getRequestDispatcher("/customer/signin.jsp").forward(request, response);

            } else {
                // Đăng nhập thành công -> Cấp Session và đẩy vào Dashboard
                request.getSession().setAttribute("USER", customer);
                response.sendRedirect("MainController?action=viewDashBoard");
            }
        } catch (Exception e) {
            e.printStackTrace(); 
            request.setAttribute("ERROR", "Hệ thống đang bảo trì hoặc gặp sự cố. Vui lòng thử lại sau!");
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
