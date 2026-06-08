<%-- 
    Document   : updateVehicle
    Created on : Jun 8, 2026, 3:00:00 PM
    Author     : AutoWashPro Refactoring Engineer
--%>

<%@page import="dto.Vehicle"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Vehicle | AutoWashPro</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/style.css">

        <style>
            body {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
            }
        </style>
    </head>

    <body>
        <%
            Vehicle vehicle = (Vehicle) request.getAttribute("VEHICLE");
        %>

        <main class="main-wrapper main-wrapper--narrow">
            <div class="auth-card glass-panel">

                <h1 class="auth-card__title">
                    Update Vehicle
                </h1>

                <p class="auth-card__desc">
                    Modify your vehicle specifications or update color settings.
                </p>

                <% if (request.getAttribute("ERROR") != null) {%>
                <div class="auth-card__alert auth-card__alert--error">
                    &#9888; <%= request.getAttribute("ERROR")%>
                </div>
                <% }%>

                <% if (request.getAttribute("SUCCESS") != null) {%>
                <div class="auth-card__alert auth-card__alert--success">
                    ✓ <%= request.getAttribute("SUCCESS")%>
                </div>
                <% }%>

                <form action="MainController" method="POST">
                    <!-- Action details -->
                    <input type="hidden" name="action" value="updateVehicle">
                    <input type="hidden" name="vehicleID" value="<%= vehicle.getVehicleID()%>">

                    <div class="form-row">
                        <!-- License Plate (Read-Only) -->
                        <div class="form-group">
                            <label class="form-group__label">
                                License Plate
                            </label>
                            <div class="form-group__input-wrapper">
                                <input type="text"
                                       name="licensePlate"
                                       class="form-group__input"
                                       value="<%= vehicle.getLicensePlate()%>"
                                       readonly
                                       style="opacity: 0.65; cursor: not-allowed; background: rgba(255, 255, 255, 0.01);"
                                       title="License plate cannot be changed. Contact support for assistance.">
                            </div>
                        </div>

                        <!-- Brand (Editable Dropdown) -->
                        <div class="form-group">
                            <label class="form-group__label">
                                Brand
                            </label>
                            <div class="form-group__input-wrapper">
                                <select name="brand"
                                        class="form-group__input form-group__select"
                                        required>
                                    <option value="">Select Brand</option>
                                    <option value="Toyota" <%= "Toyota".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>Toyota</option>
                                    <option value="Honda" <%= "Honda".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>Honda</option>
                                    <option value="Mazda" <%= "Mazda".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>Mazda</option>
                                    <option value="Hyundai" <%= "Hyundai".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>Hyundai</option>
                                    <option value="Kia" <%= "Kia".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>Kia</option>
                                    <option value="Ford" <%= "Ford".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>Ford</option>
                                    <option value="BMW" <%= "BMW".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>BMW</option>
                                    <option value="Mercedes-Benz" <%= "Mercedes-Benz".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>Mercedes-Benz</option>
                                    <option value="Audi" <%= "Audi".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>Audi</option>
                                    <option value="Lexus" <%= "Lexus".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>Lexus</option>
                                    <option value="VinFast" <%= "VinFast".equalsIgnoreCase(vehicle.getBrand()) ? "selected" : ""%>>VinFast</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <!-- Model (Editable) -->
                        <div class="form-group">
                            <label class="form-group__label">
                                Model
                            </label>
                            <div class="form-group__input-wrapper">
                                <input type="text"
                                       name="model"
                                       class="form-group__input"
                                       value="<%= vehicle.getModel()%>"
                                       placeholder="Vios"
                                       required
                                       maxlength="50">
                            </div>
                        </div>

                        <!-- Color (Editable Dropdown) -->
                        <div class="form-group">
                            <label class="form-group__label">
                                Color
                            </label>
                            <div class="form-group__input-wrapper">
                                <select name="color"
                                        class="form-group__input form-group__select"
                                        required>
                                    <option value="">Select Color</option>
                                    <option value="White" <%= "White".equalsIgnoreCase(vehicle.getColor()) ? "selected" : ""%>>White</option>
                                    <option value="Black" <%= "Black".equalsIgnoreCase(vehicle.getColor()) ? "selected" : ""%>>Black</option>
                                    <option value="Silver" <%= "Silver".equalsIgnoreCase(vehicle.getColor()) ? "selected" : ""%>>Silver</option>
                                    <option value="Gray" <%= "Gray".equalsIgnoreCase(vehicle.getColor()) ? "selected" : ""%>>Gray</option>
                                    <option value="Red" <%= "Red".equalsIgnoreCase(vehicle.getColor()) ? "selected" : ""%>>Red</option>
                                    <option value="Blue" <%= "Blue".equalsIgnoreCase(vehicle.getColor()) ? "selected" : ""%>>Blue</option>
                                    <option value="Green" <%= "Green".equalsIgnoreCase(vehicle.getColor()) ? "selected" : ""%>>Green</option>
                                    <option value="Yellow" <%= "Yellow".equalsIgnoreCase(vehicle.getColor()) ? "selected" : ""%>>Yellow</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div style="margin-top: var(--spacing-lg); display: flex; flex-direction: column; gap: var(--spacing-sm);">
                        <!-- Submit -->
                        <button type="submit"
                                class="btn btn--primary btn--block">
                            Update Vehicle
                        </button>
                    </div>

                </form>

                <div class="auth-card__footer">
                    <a href="${pageContext.request.contextPath}/MainController?action=viewDashboard"
                       class="auth-card__footer-link">
                        Back to Dashboard
                    </a>
                </div>

            </div>
        </main>

    </body>
</html>
