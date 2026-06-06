<%-- 
    Document   : addVehicle
    Created on : Jun 3, 2026, 2:21:05 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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

                    <div class="form-group">
                        <label class="form-group__label">
                            License Plate
                        </label>

                        <div class="form-group__input-wrapper">
                            <input type="text"
                                   name="licensePlate"
                                   class="form-group__input"
                                   placeholder="51A-12345"
                                   required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-group__label">
                            Brand
                        </label>

                        <div class="form-group__input-wrapper">
                            <input type="text"
                                   name="brand"
                                   class="form-group__input"
                                   placeholder="Toyota"
                                   required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-group__label">
                            Model
                        </label>

                        <div class="form-group__input-wrapper">
                            <input type="text"
                                   name="model"
                                   class="form-group__input"
                                   placeholder="Vios"
                                   required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-group__label">
                            Color
                        </label>

                        <div class="form-group__input-wrapper">
                            <input type="text"
                                   name="color"
                                   class="form-group__input"
                                   placeholder="White"
                                   required>
                        </div>
                    </div>

                    <button type="submit"
                            class="btn btn--primary btn--block"
                            name="action"
                            value="registerVehicle">
                        Register Vehicle
                    </button>

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
