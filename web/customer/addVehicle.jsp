<%-- 
    Document   : addVehicle
    Created on : Jun 3, 2026, 2:21:05 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

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

                <% if (request.getAttribute("ERROR") != null) {%>
                <div class="auth-card__alert auth-card__alert--error">
                    &#9888; <%= request.getAttribute("ERROR")%>
                </div>
                <% }%>

                <form action="MainController" method="POST">

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
                                       title="Example: 51A-12345 or 59A1-12345">
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
                                    <option value="Toyota">Toyota</option>
                                    <option value="Honda">Honda</option>
                                    <option value="Mazda">Mazda</option>
                                    <option value="Hyundai">Hyundai</option>
                                    <option value="Kia">Kia</option>
                                    <option value="Ford">Ford</option>
                                    <option value="BMW">BMW</option>
                                    <option value="Mercedes-Benz">Mercedes-Benz</option>
                                    <option value="Audi">Audi</option>
                                    <option value="Lexus">Lexus</option>
                                    <option value="VinFast">VinFast</option>
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
                                class="btn btn--secondary btn--block">
                            📷 Scan Vehicle Registration
                        </button>

                        <!-- Submit -->
                        <button type="submit"
                                class="btn btn--primary btn--block"
                                name="action"
                                value="registerVehicle">
                            Register Vehicle
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