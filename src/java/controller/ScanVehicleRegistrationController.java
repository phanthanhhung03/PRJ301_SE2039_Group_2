package controller;

import dto.Vehicle;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import service.OcrSpaceService;

@WebServlet(name = "ScanVehicleRegistrationController", urlPatterns = {"/ScanVehicleRegistrationController"})
@MultipartConfig
public class ScanVehicleRegistrationController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {

            Part file = request.getPart("registrationFile");

            File tempFile = File.createTempFile(
                    "ocr_",
                    ".png");

            Files.copy(
                    file.getInputStream(),
                    tempFile.toPath(),
                    StandardCopyOption.REPLACE_EXISTING);

            OcrSpaceService service
                    = new OcrSpaceService();

            Vehicle vehicle
                    = service.extractVehicle(tempFile);

            request.setAttribute(
                    "ocrVehicle",
                    vehicle);

        } catch (Exception e) {

            request.setAttribute(
                    "ERROR",
                    "Failed to scan registration document.");

            e.printStackTrace();
        }

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
