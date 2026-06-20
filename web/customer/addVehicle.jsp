<%-- 
    Document   : addVehicle
    Created on : Jun 3, 2026, 2:21:05 PM
    Author     : Asus
--%>

<%@page import="dto.Vehicle"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:if test="${empty USER}">
    <c:redirect url="MainController?action=viewSignIn"/>
</c:if>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register Vehicle | AutoWashPro</title>

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

        <main class="main-wrapper main-wrapper--narrow">
            <div class="auth-card glass-panel">

                <h1 class="auth-card__title">
                    Register New Vehicle
                </h1>

                <p class="auth-card__desc">
                    Add your vehicle information to start booking premium wash services.
                </p>

                <c:if test="${not empty ERROR}">
                    <div class="auth-card__alert auth-card__alert--error">
                        &#9888; ${ERROR}
                    </div>
                </c:if>

                <form id="vehicleForm"
                      action="MainController"
                      method="POST">

                    <div class="form-row">
                        <!-- License Plate -->
                        <div class="form-group">
                            <label class="form-group__label">
                                License Plate
                            </label>
                            <div class="form-group__input-wrapper">
                                <input type="text"
                                       name="licensePlate"
                                       class="form-group__input"
                                       placeholder="51A-12345"
                                       required
                                       maxlength="15"
                                       pattern="[0-9]{2}[A-Z][0-9]?-[0-9]{4,5}"
                                       title="Example: 51A-12345 or 59A1-12345"
                                       value="${ocrVehicle.licensePlate}">
                            </div>
                        </div>

                        <!-- Brand -->
                        <div class="form-group">
                            <label class="form-group__label">
                                Brand
                            </label>
                            <div class="form-group__input-wrapper">
                                <select name="brand"
                                        class="form-group__input form-group__select"
                                        required>
                                    <option value="">Select Brand</option>
                                    <option value="Toyota"    
                                        <c:if test="${ocrVehicle.brand eq 'TOYOTA'}">
                                            selected
                                        </c:if>>
                                        Toyota
                                    </option>
                                    <option value="Honda"
                                        <c:if test="${ocrVehicle.brand eq 'HONDA'}">
                                            selected
                                        </c:if>>
                                        Honda
                                    </option>
                                    <option value="Mazda"
                                        <c:if test="${ocrVehicle.brand eq 'MAZDA'}">
                                            selected
                                        </c:if>>
                                        Mazda
                                    </option>
                                    <option value="Hyundai"
                                        <c:if test="${ocrVehicle.brand eq 'HYUNDAI'}">
                                            selected
                                        </c:if>>
                                        Hyundai
                                    </option>
                                    <option value="Kia"
                                        <c:if test="${ocrVehicle.brand eq 'KIA'}">
                                            selected
                                        </c:if>>
                                        Kia
                                    </option>
                                    <option value="Ford"
                                        <c:if test="${ocrVehicle.brand eq 'FORD'}">
                                            selected
                                        </c:if>>
                                        Ford
                                    </option>
                                    <option value="BMW"
                                        <c:if test="${ocrVehicle.brand eq 'BMW'}">
                                            selected
                                        </c:if>>
                                        BMW
                                    </option>
                                    <option value="Mercedes-Benz"
                                        <c:if test="${ocrVehicle.brand eq 'MERCEDES-BENZ'}">
                                            selected
                                        </c:if>>
                                        Mercedes-Benz
                                    </option>
                                    <option value="Audi"
                                        <c:if test="${ocrVehicle.brand eq 'AUDI'}">
                                            selected
                                        </c:if>>
                                        Audi
                                    </option>
                                    <option value="Lexus"
                                        <c:if test="${ocrVehicle.brand eq 'LEXUS'}">
                                            selected
                                        </c:if>>
                                        Lexus
                                    </option>
                                    <option value="VinFast"
                                        <c:if test="${ocrVehicle.brand eq 'VINFAST'}">
                                            selected
                                        </c:if>>
                                        VinFast
                                    </option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <!-- Model -->
                        <div class="form-group">
                            <label class="form-group__label">
                                Model
                            </label>
                            <div class="form-group__input-wrapper">
                                <input type="text"
                                       name="model"
                                       class="form-group__input"
                                       placeholder="Vios"
                                       required
                                       maxlength="50">
                            </div>
                        </div>

                        <!-- Color -->
                        <div class="form-group">
                            <label class="form-group__label">
                                Color
                            </label>
                            <div class="form-group__input-wrapper">
                                <select name="color"
                                        class="form-group__input form-group__select"
                                        required>
                                    <option value="">Select Color</option>
                                    <option value="White">White</option>
                                    <option value="Black">Black</option>
                                    <option value="Silver">Silver</option>
                                    <option value="Gray">Gray</option>
                                    <option value="Red">Red</option>
                                    <option value="Blue">Blue</option>
                                    <option value="Green">Green</option>
                                    <option value="Yellow">Yellow</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div style="margin-top: var(--spacing-md); display: flex; flex-direction: column; gap: var(--spacing-sm);">

                        <!-- OCR Scan Button -->
                        <button type="button"
                                class="btn btn--secondary btn--block"
                                onclick="document.getElementById('registrationFile').click()">

                            📷 Scan Vehicle Registration

                        </button>

                        <input type="hidden" name="action" value="addVehicle">
                        <!-- Submit -->
                        <button type="submit"
                                class="btn btn--primary btn--block">
                            Register Vehicle
                        </button>
                    </div>

                </form>

                <!-- OCR Form -->
                <form id="ocrForm"
                      action="ScanVehicleRegistrationController"
                      method="POST"
                      enctype="multipart/form-data">

                    <input type="file"
                           id="registrationFile"
                           name="registrationFile"
                           accept="image/*"
                           hidden>

                </form>

                <div class="auth-card__footer">
                    <a href="${pageContext.request.contextPath}/MainController?action=viewDashboard"
                       class="auth-card__footer-link">
                        Back to Dashboard
                    </a>
                </div>

            </div>
        </main>
        <script>
            document.getElementById("registrationFile")
                    .addEventListener("change", function () {

                        if (this.files.length > 0) {

                            document.getElementById("ocrForm")
                                    .submit();
                        }
                    });
        </script>
    </body>
</html>