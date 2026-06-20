<%-- 
    Document   : updateVehicle
    Created on : Jun 8, 2026, 3:00:00 PM
    Author     : AutoWashPro Refactoring Engineer
--%>

<%@page import="dto.Vehicle"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<c:if test="${empty USER}">
    <c:redirect url="MainController?action=viewSignIn"/>
</c:if>

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

        <main class="main-wrapper main-wrapper--narrow">
            <div class="auth-card glass-panel">

                <h1 class="auth-card__title">
                    Update Vehicle
                </h1>

                <p class="auth-card__desc">
                    Modify your vehicle specifications or update color settings.
                </p>

                <c:if test="${not empty ERROR}">
                    <div class="auth-card__alert auth-card__alert--error">
                        &#9888; ${ERROR}
                    </div>
                </c:if>

                <c:if test="${not empty SUCCESS}">
                    <div class="auth-card__alert auth-card__alert--success">
                        ✓ ${SUCCESS}
                    </div>
                </c:if>

                <form action="MainController" method="POST">
                    <!-- Action details -->
                    <input type="hidden" name="action" value="updateVehicle">
                    <input type="hidden" name="vehicleID" value="${VEHICLE.vehicleID}">

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
                                       value="${VEHICLE.licensePlate}"
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
                                    <option value="Toyota" 
                                            <c:if test="${VEHICLE.color eq 'Toyota'}">
                                                selected
                                            </c:if>>
                                        Toyota
                                    </option>
                                    <option value="Honda"
                                            <c:if test="${VEHICLE.brand eq 'Honda'}">
                                                selected
                                            </c:if>>
                                        Honda
                                    </option>
                                    <option value="Mazda" 
                                            <c:if test="${VEHICLE.brand eq 'Mazda'}">
                                                selected
                                            </c:if>>
                                        Mazda
                                    </option>
                                    <option value="Hyundai" 
                                            <c:if test="${VEHICLE.brand eq 'Hyundai'}">
                                                selected
                                            </c:if>>
                                        Hyundai
                                    </option>
                                    <option value="Kia" 
                                            <c:if test="${VEHICLE.brand eq 'Kia'}">
                                                selected
                                            </c:if>>
                                        Kia
                                    </option>
                                    <option value="Ford" 
                                            <c:if test="${VEHICLE.brand eq 'Ford'}">
                                                selected
                                            </c:if>>
                                        Ford
                                    </option>
                                    <option value="BMW" 
                                            <c:if test="${VEHICLE.brand eq 'BMW'}">
                                                selected
                                            </c:if>>
                                        BMW
                                    </option>
                                    <option value="Mercedes-Benz" 
                                            <c:if test="${VEHICLE.brand eq 'Mercedes-Benz'}">
                                                selected
                                            </c:if>>
                                        Mercedes-Benz
                                    </option>
                                    <option value="Audi" 
                                            <<c:if test="${VEHICLE.brand eq 'Audi'}">
                                                selected
                                            </c:if>>
                                        Audi
                                    </option>
                                    <option value="Lexus" 
                                            <c:if test="${VEHICLE.brand eq 'Lexus'}">
                                                selected
                                            </c:if>>
                                        Lexus
                                    </option>
                                    <option value="VinFast" 
                                            <c:if test="${VEHICLE.brand eq 'VinFast'}">
                                                selected
                                            </c:if>>
                                        VinFast
                                    </option>
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
                                       value="${VEHICLE.model}"
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
                                    <option value="White" 
                                            <c:if test="${VEHICLE.color eq 'White'}">
                                                selected
                                            </c:if>>
                                        White
                                    </option>
                                    <option value="Black" 
                                            <c:if test="${VEHICLE.color eq 'Black'}">
                                                selected
                                            </c:if>>
                                        Black
                                    </option>
                                    <option value="Silver" 
                                            <c:if test="${VEHICLE.color eq 'Silver'}">
                                                selected
                                            </c:if>>
                                        Silver
                                    </option>
                                    <option value="Gray" 
                                            <c:if test="${VEHICLE.color eq 'Gray'}">
                                                selected
                                            </c:if>>
                                        Gray
                                    </option>
                                    <option value="Red" 
                                            <c:if test="${VEHICLE.color eq 'Red'}">
                                                selected
                                            </c:if>>
                                        Red
                                    </option>
                                    <option value="Blue" 
                                            <c:if test="${VEHICLE.color eq 'Blue'}">
                                                selected
                                            </c:if>>
                                        Blue
                                    </option>

                                    <option value="Green" 
                                            <c:if test="${VEHICLE.color eq 'Green'}">
                                                selected
                                            </c:if>>
                                        Green
                                    </option>
                                    <option value="Yellow" 
                                            <c:if test="${VEHICLE.color eq 'Yellow'}">
                                                selected
                                            </c:if>>
                                        Yellow
                                    </option>
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
