<%-- 
    Document   : customer-management
    Created on : May 30, 2026, 2:24:52 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty ADMIN_USER}">
    <c:redirect url="MainController?action=viewAdminSignIn"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Management | AutoWashPro Staff</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <c:if test="${not empty SUCCESS}">

            <div id="success-toast"
                 class="toast toast--success">

                <span class="toast__icon">✓</span>

                <span class="toast__message">
                    ${SUCCESS}
                </span>
            </div>
            <c:remove var="SUCCESS" scope="session"/>

        </c:if>

        <c:if test="${not empty ERROR}">

            <div id="error-toast"
                 class="toast toast--error">

                <span class="toast__icon">✕</span>

                <span class="toast__message">
                    ${ERROR}
                </span>

            </div>
            <c:remove var="ERROR" scope="session"/>
        </c:if>

        <!-- STAFF TOP NAVIGATION -->
        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="admin-dashboard.html" class="site-header__logo">
                    <div class="site-header__logo-icon" style="background: linear-gradient(135deg, var(--color-accent-blue), var(--color-accent-cyan));"></div>
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
        <main class="main-wrapper" style="margin-top: var(--spacing-xl);">

            <!-- HEADER BLOCK -->
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-xl);">
                <div>
                    <span style="font-size:0.75rem; font-weight:700; color:var(--color-accent-cyan); text-transform:uppercase; letter-spacing:0.1em;">
                        Customer Registry
                    </span>
                    <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Manage Members</h1>
                </div>
                <a href="${pageContext.request.contextPath}/MainController?action=viewCreateCustomer" class="btn btn--primary btn--sm">
                    + Add New Customer
                </a>
            </div>

            <!-- SEARCH & FILTER TOOLBAR -->
            <section class="glass-panel" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); display: flex; align-items: center; justify-content: space-between; gap: var(--spacing-md); flex-wrap: wrap;">

                <!-- Search Form -->
                <form action="MainController" method="POST" style="display:flex; gap:var(--spacing-sm); flex-grow:1; max-width: 500px;">
                    <input type="hidden" name="action" value="viewCustomerManagement">
                    <input type="text" 
                           class="form-group__input" 
                           value="${param.search}"
                           name="search"
                           placeholder="Search by name, email, phone..." 
                           style="padding: 0.6rem 1.0rem; font-size: 0.85rem;">
                    <button class="btn btn--primary btn--sm" style="padding:0.6rem 1.2rem;">
                        Search
                    </button>
                </form>

                <!-- Filters Selects -->
                <div style="display:flex; gap:var(--spacing-md); align-items:center;">
                    <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                        <span style="font-size:0.8rem; font-weight:600; text-transform:uppercase; color:var(--color-text-tertiary);">
                            Tier:
                        </span>
                        <select disabled="" class="form-group__input" style="padding: 0.5rem 2.0rem 0.5rem 1.0rem; font-size:0.85rem; width: auto; background-color: var(--color-surface-hover); cursor: pointer;">
                            <option value="all">All Tiers</option>
                            <option value="vip">Platinum</option>
                            <option value="signature">Gold</option>
                            <option value="elite">Silver</option>
                            <option value="none">Member</option>
                        </select>
                    </div>

                    <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                        <span style="font-size:0.8rem; font-weight:600; text-transform:uppercase; color:var(--color-text-tertiary);">Status:</span>
                        <select disabled="" class="form-group__input" style="padding: 0.5rem 2.0rem 0.5rem 1.0rem; font-size:0.85rem; width: auto; background-color: var(--color-surface-hover); cursor: pointer;">
                            <option value="all">All Statuses</option>
                            <option value="active">Active Members</option>
                            <option value="suspended">Suspended</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>
                </div>
            </section>

            <!-- CUSTOMERS DATA TABLE -->
            <section class="glass-panel" style="border-radius: var(--radius-xl); overflow: hidden;">
                <div class="data-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Customer</th>
                                <th>Contact Details</th>
                                <th>Membership Tier</th>
                                <th>Loyalty Points</th>
                                <th>Fleet size</th>
                                <th>Status</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach items="${customers}" var="customer">
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">
                                        <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                                            <div class="testimonial-card__avatar testimonial-card__avatar--vip" style="width:32px; height:32px; font-size:0.75rem;">
                                                ${customer.initials}
                                            </div>
                                            ${customer.fullName}
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-size:0.85rem;">
                                            ${customer.email}
                                        </div>
                                        <div style="font-size:0.75rem; color:var(--color-text-tertiary);">
                                            ${customer.phoneNumber}
                                        </div>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${customer.tierId.tierName eq 'Member'}">
                                                <span class="status-badge status-badge--member">
                                                    MEMBER
                                                </span>
                                            </c:when>

                                            <c:when test="${customer.tierId.tierName eq 'Silver'}">
                                                <span class="status-badge status-badge--silver">
                                                    SILVER
                                                </span>
                                            </c:when>

                                            <c:when test="${customer.tierId.tierName eq 'Gold'}">
                                                <span class="status-badge status-badge--gold">
                                                    GOLD
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="status-badge status-badge--platinum">
                                                    PLATINUM
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td style="font-weight:600; color:var(--color-text-primary);">
                                        ${customer.currentPoint} pts
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerVehicles&id=${customer.cusId}"
                                           class="customer-vehicles-link">
                                            ${customer.vehicleCount} 
                                            ${customer.vehicleCount == 1 ? 'vehicle' : 'vehicles'}
                                        </a>
                                    </td>
                                    <td style="font-size:0.85rem;">
                                        <c:choose>
                                            <c:when test="${customer.status}">
                                                <span class="status-badge status-badge--completed">
                                                    Active
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-badge--cancelled">
                                                    Inactive
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: right;">
                                        <div style="display:inline-flex; gap:var(--spacing-xs);">
                                            <a href="${pageContext.request.contextPath}/MainController?action=viewEditCustomer&id=${customer.cusId}"
                                               class="btn btn--secondary btn--sm" 
                                               style="padding: 0.35rem 0.65rem; font-size:0.8rem;">
                                                Edit
                                            </a>
                                            <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerBookingHistory&id=${customer.cusId}" 
                                               class="btn btn--primary btn--sm" 
                                               style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Bookings
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>
                </div>

                <!-- Table Pagination (Pure HTML/CSS layout) -->
                <div style="display:flex; justify-content:space-between; align-items:center; padding:var(--spacing-md) var(--spacing-lg); background-color:rgba(255,255,255,0.01); border-top:1px solid var(--color-border); font-size:0.85rem;">
                    <span style="color:var(--color-text-tertiary);">Total Customers: ${customerCount}</span>
                </div>
            </section>

        </main>

        <!-- STAFF FOOTER -->
        <footer class="site-footer" style="margin-top: var(--spacing-xxl);">
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
                        document.getElementById("success-toast");

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

