<%-- 
    Document   : create-customer
    Created on : Jun 21, 2026, 8:30:15 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty ADMIN_USER}">
    <c:redirect url="/MainController?action=viewAdminSignIn"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create New Customer | AutoWashPro Staff</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <!-- STAFF TOP NAVIGATION -->
        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="${pageContext.request.contextPath}/MainController?action=viewAdminDashboard" class="site-header__logo">
                    <div class="site-header__logo-icon"></div>
                    <div class="site-header__logo-text">ADMIN<span>PANEL</span></div>
                </a>
                <nav class="site-header__navigation">
                    <a href="${pageContext.request.contextPath}/MainController?action=viewAdminDashboard" class="site-header__nav-link">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerManagement" class="site-header__nav-link site-header__nav-link--active">Customers</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewAdminBookings" class="site-header__nav-link">Bookings</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewLoyaltyManagement" class="site-header__nav-link">Loyalty</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewPromotionManagement" class="site-header__nav-link"> Promotions</a>
                </nav>
                <div class="site-header__actions">
                    <span class="status-badge status-badge--completed">Staff Portal</span>
                    <a href="MainController?action=logout" class="btn btn--secondary btn--sm">Logout</a>
                </div>
            </div>
        </header>

        <!-- CONTENT -->
        <main class="main-wrapper main-wrapper--customer-form">

            <!-- HEADER BLOCK -->
            <div class="admin-page-header">
                <div>
                    <span class="admin-page-header__subtitle">Customer Registry</span>
                    <h1 class="admin-page-header__title">Create New Member</h1>
                </div>
                <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerManagement"
                   class="btn btn--secondary btn--sm">
                    Back to Customers
                </a>
            </div>

            <!-- ERROR OR SUCCESS NOTIFICATIONS -->
            <c:if test="${not empty requestScope.ERROR_MESSAGE}">
                <div class="auth-card__alert auth-card__alert--error auth-card__alert--full-width">
                    ${requestScope.ERROR_MESSAGE}
                </div>
            </c:if>



            <!-- TWO COLUMN LAYOUT -->
            <div class="customer-detail-grid">

                <!-- LEFT COLUMN: Guidelines / Information -->
                <aside class="customer-aside">

                    <!-- Guidelines Card -->
                    <div class="glass-panel customer-guide-panel">

                        <div class="customer-guide-header">
                            <h3 class="customer-guide-title">Registration Guide</h3>
                            <p class="customer-guide-subtitle">Staff onboarding rules</p>
                        </div>

                        <div class="customer-guide-list">
                            <div>
                                <strong class="customer-guide-step-title">
                                    1. Customer Consent
                                </strong>
                                <span>
                                    Ask customer for their correct email and active phone number for booking updates.
                                </span>
                            </div>
                            <div>
                                <strong class="customer-guide-step-title">
                                    2. Account Credentials
                                </strong>
                                <span>
                                    Provide a temporary secure password. The customer can change this password later in their personal portal.
                                </span>
                            </div>
                            <div>
                                <strong class="customer-guide-step-title">
                                    3. Membership Tiers
                                </strong>
                                <span>
                                    New registration defaults to Member. Staff can upgrade tier base on business conditions.
                                </span>
                            </div>
                            <div>
                                <strong class="customer-guide-step-title">
                                    4. Verification
                                </strong>
                                <span>
                                    Confirm details before submitting. Inactive accounts will not be able to log in or book.
                                </span>
                            </div>
                        </div>
                    </div>

                </aside>

                <!-- RIGHT COLUMN: Onboarding Registration Form -->
                <form action="${pageContext.request.contextPath}/MainController" method="post">
                    <input type="hidden" name="action" value="createCustomer">
                    <div class="glass-panel customer-form-panel">
                        <c:if test="${not empty ERROR}">
                            <div class="toast toast--error" id="toast--error">
                                <span class="toast__icon" style="color: rgb(239, 68, 68);">✕</span>
                                <span class="toast__message">
                                    ${ERROR}
                                </span>
                            </div>
                        </c:if>
                        <!-- Section 1: Customer Information -->
                        <div>
                            <h3 class="customer-form-section-title">Customer Information</h3>

                            <div class="form-group form-group--no-margin">
                                <label class="form-group__label">Full Name</label>
                                <input type="text" 
                                       name="fullName" 
                                       class="form-group__input" 
                                       value="${customer.fullName}"
                                       required 
                                       placeholder="Enter customer's full name">
                            </div>
                        </div>

                        <!-- Section 2: Contact Information -->
                        <div class="customer-form-section">
                            <h3 class="customer-form-section-title">Contact Information</h3>

                            <div class="form-row form-row--sm-margin">
                                <div class="form-group">
                                    <label class="form-group__label">Phone Number</label>
                                    <input 
                                        type="text" 
                                        name="phoneNumber" 
                                        class="form-group__input" 
                                        value="${customer.phoneNumber}"
                                        required 
                                        placeholder="e.g. 0912345678">
                                </div>
                                <div class="form-group">
                                    <label class="form-group__label">Email Address</label>
                                    <input 
                                        type="email" 
                                        name="email" 
                                        class="form-group__input" 
                                        value="${customer.email}"
                                        required placeholder="e.g. customer@example.com">
                                </div>
                            </div>

                            <div class="form-group form-group--no-margin">
                                <label class="form-group__label">Address</label>
                                <textarea 
                                    name="address" 
                                    rows="3" 
                                    class="form-group__input form-group__textarea" 
                                    placeholder="Customer's physical address details">${customer.address}</textarea>
                            </div>
                        </div>

                        <!-- Section 3: Account Information -->
                        <div class="customer-form-section">
                            <h3 class="customer-form-section-title">Account Information</h3>

                            <div class="form-row form-row--no-margin">
                                <div class="form-group">
                                    <label class="form-group__label">Security Password</label>
                                    <input 
                                        type="password" 
                                        name="password" 
                                        class="form-group__input" 
                                        required 
                                        placeholder="Enter password (min 6 characters)">
                                </div>
                                <div class="form-group">
                                    <label class="form-group__label">Confirm Password</label>
                                    <input 
                                        type="password" 
                                        name="confirmPassword" 
                                        class="form-group__input" 
                                        required 
                                        placeholder="Re-enter password to verify">
                                </div>
                            </div>
                        </div>

                        <!-- Section 4: Membership & Status -->
                        <div class="customer-form-section">
                            <h3 class="customer-form-section-title">Membership Tier & Status</h3>

                            <div class="form-row form-row--no-margin">
                                <div class="form-group">
                                    <label class="form-group__label">Initial Loyalty Tier</label>
                                    <select name="tierId" class="form-group__input form-group__select">
                                        <option value="1" selected
                                                ${customer.tierId.tierID == 1 ? 'selected' : ''}>
                                            MEMBER
                                        </option>
                                        <option value="2"
                                                ${customer.tierId.tierID == 2 ? 'selected' : ''}>
                                            SILVER
                                        </option>
                                        <option value="3"
                                                ${customer.tierId.tierID == 3 ? 'selected' : ''}>
                                            GOLD
                                        </option>
                                        <option value="4"
                                                ${customer.tierId.tierID == 4 ? 'selected' : ''}>
                                            PLATINUM
                                        </option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-group__label">Account Status</label>
                                    <select name="status" class="form-group__input form-group__select">
                                        <option value="true" 
                                                ${customer.status ? 'selected' : ''}>
                                            Active
                                        </option>
                                        <option value="false"
                                                ${!customer.status ? 'selected' : ''}>
                                            Inactive
                                        </option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Section 5: Action Buttons -->
                        <div class="customer-form-actions">
                            <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerManagement" class="btn btn--secondary">
                                Cancel
                            </a>
                            <button type="submit" class="btn btn--primary">
                                Create Customer
                            </button>
                        </div>

                    </div>
                </form>
            </div>

        </main>

        <!-- STAFF FOOTER -->
        <footer class="site-footer site-footer--admin">
            <div class="site-footer__container main-wrapper">
                <div class="site-footer__bottom">
                    <p>&copy; 2026 AutoWashPro Operations Desk. Restricted Access.</p>
                    <a href="index.html" class="site-footer__staff-link">Return to Customer Landing</a>
                </div>
            </div>
        </footer>
        <script>
            document.addEventListener("DOMContentLoaded", function () {

                const toast =
                        document.getElementById("toast--error");

                if (!toast) {
                    return;
                }

                setTimeout(() => {

                    toast.classList.add(
                            "toast--hide");

                    setTimeout(() => {
                        toast.remove();
                    }, 500);

                }, 3000);

            });
        </script>
    </body>
</html>
