<%-- 
    Document   : customer-booking-history
    Created on : Jun 21, 2026, 7:35:43 PM
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
        <title>Customer Booking History | AutoWashPro Staff</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        
        <!-- STAFF TOP NAVIGATION -->
        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="${pageContext.request.contextPath}/MainController?action=viewAdminDashboard" class="site-header__logo">
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
        <main class="main-wrapper" style="margin-top: var(--spacing-xl); padding-bottom: var(--spacing-xxl);">

            <!-- HEADER BLOCK -->
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-xl);">
                <div>
                    <span style="font-size:0.75rem; font-weight:700; color:var(--color-accent-cyan); text-transform:uppercase; letter-spacing:0.1em;">Customer Insights</span>
                    <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Booking History</h1>
                </div>
                <a href="MainController?action=viewCustomerManagement" class="btn btn--secondary btn--sm">
                    Back to Customers
                </a>
            </div>

            <!-- TWO COLUMN DASHBOARD LAYOUT -->
            <div class="customer-detail-grid">
                
                <!-- LEFT COLUMN: Profile Overview -->
                <aside class="glass-panel" style="padding: var(--spacing-lg); border-radius: var(--radius-xl); display: flex; flex-direction: column; gap: var(--spacing-lg);">
                    
                    <div style="display: flex; flex-direction: column; align-items: center; text-align: center; gap: var(--spacing-sm); border-bottom: 1px solid var(--color-border); padding-bottom: var(--spacing-lg);">
                        <div class="testimonial-card__avatar testimonial-card__avatar--vip" style="width: 72px; height: 72px; font-size: 1.8rem; border-radius: 50%; font-weight: 700; box-shadow: var(--shadow-card); background: linear-gradient(135deg, var(--color-accent-blue), var(--color-accent-cyan)); display: flex; align-items: center; justify-content: center; color: var(--color-text-primary);">
                            ${customer.initials}
                        </div>
                        <h3 style="font-size: 1.35rem; margin-top: var(--spacing-sm); color: var(--color-text-primary); font-weight: 600;">
                            ${customer.fullName}
                        </h3>
                        
                        <c:choose>
                            <c:when test="${customer.tierId.tierName eq 'Member'}">
                                <span class="status-badge status-badge--member">MEMBER</span>
                            </c:when>
                            <c:when test="${customer.tierId.tierName eq 'Silver'}">
                                <span class="status-badge status-badge--silver">SILVER</span>
                            </c:when>
                            <c:when test="${customer.tierId.tierName eq 'Gold'}">
                                <span class="status-badge status-badge--gold">GOLD</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-badge--platinum">PLATINUM</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div style="display: flex; flex-direction: column; gap: var(--spacing-md); font-size: 0.9rem;">
                        <div>
                            <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--color-text-tertiary); display: block; margin-bottom: 2px;">
                                Customer ID
                            </span>
                            <span style="color: var(--color-text-primary); font-weight: 600;">
                                # ${customer.cusId}
                            </span>
                        </div>
                        <div>
                            <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--color-text-tertiary); display: block; margin-bottom: 2px;">
                                Email Address
                            </span>
                            <span style="color: var(--color-text-primary); font-weight: 500; word-break: break-all;">
                                ${customer.email}
                            </span>
                        </div>
                        <div>
                            <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--color-text-tertiary); display: block; margin-bottom: 2px;">
                                Phone Number
                            </span>
                            <span style="color: var(--color-text-primary); font-weight: 500;">
                                ${customer.phoneNumber}
                            </span>
                        </div>
                        <div>
                            <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--color-text-tertiary); display: block; margin-bottom: 2px;">
                                Address
                            </span>
                            <span style="color: var(--color-text-primary); line-height: 1.4;">
                                ${customer.address}
                            </span>
                        </div>
                        <div>
                            <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--color-text-tertiary); display: block; margin-bottom: 2px;">
                                Account Status
                            </span>
                            <c:choose>
                                <c:when test="${customer.status}">
                                    <span class="status-badge status-badge--completed" style="font-size: 0.7rem; padding: 0.15rem 0.5rem;">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-badge--cancelled" style="font-size: 0.7rem; padding: 0.15rem 0.5rem;">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </aside>
                
                <!-- RIGHT COLUMN: Stats & Booking History Table -->
                <div style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                    
                    <!-- Stats Dashboard Grid -->
                    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: var(--spacing-md);">
                        
                        <div class="stat-card glass-panel" style="border-radius: var(--radius-lg); padding: var(--spacing-md); display: flex; flex-direction: column; justify-content: space-between; gap: var(--spacing-sm);">
                            <span class="stat-card__label" style="font-size: 0.75rem; color: var(--color-text-secondary); text-transform: uppercase; letter-spacing: 0.05em;">
                                Total Bookings
                            </span>
                            <div class="stat-card__value" style="font-size: 1.6rem; font-weight: 700; color: var(--color-text-primary);">
                                ${customer.totalBooking}
                            </div>
                        </div>
                        
                        <div class="stat-card glass-panel" style="border-radius: var(--radius-lg); padding: var(--spacing-md); display: flex; flex-direction: column; justify-content: space-between; gap: var(--spacing-sm);">
                            <span class="stat-card__label" style="font-size: 0.75rem; color: var(--color-text-secondary); text-transform: uppercase; letter-spacing: 0.05em;">
                                Loyalty Points
                            </span>
                            <div class="stat-card__value" style="font-size: 1.6rem; font-weight: 700; color: var(--color-accent-gold);">
                                ${customer.currentPoint} 
                                <span style="font-size: 0.8rem; color: var(--color-text-secondary); font-weight: normal;">
                                    pts
                                </span>
                            </div>
                        </div>
                        
                        <div class="stat-card glass-panel" style="border-radius: var(--radius-lg); padding: var(--spacing-md); display: flex; flex-direction: column; justify-content: space-between; gap: var(--spacing-sm);">
                            <span class="stat-card__label" style="font-size: 0.75rem; color: var(--color-text-secondary); text-transform: uppercase; letter-spacing: 0.05em;">
                                Vehicles Fleet
                            </span>
                            <div class="stat-card__value" style="font-size: 1.6rem; font-weight: 700; color: var(--color-accent-cyan);">
                                ${customer.vehicleCount}
                            </div>
                        </div>
                        
                        <div class="stat-card glass-panel" style="border-radius: var(--radius-lg); padding: var(--spacing-md); display: flex; flex-direction: column; justify-content: space-between; gap: var(--spacing-sm);">
                            <span class="stat-card__label" style="font-size: 0.75rem; color: var(--color-text-secondary); text-transform: uppercase; letter-spacing: 0.05em;">
                                Total Spend
                            </span>
                            <div class="stat-card__value" style="font-size: 1.6rem; font-weight: 700; color: var(--color-text-primary);">
                                $ ${customer.totalSpend}
                            </div>
                        </div>
                        
                    </div>
                    
                    <!-- Table Logs Panel -->
                    <div class="glass-panel" style="border-radius: var(--radius-xl); overflow: hidden; padding: var(--spacing-lg);">
                        <h3 style="font-size: 1.15rem; margin-bottom: var(--spacing-md); border-bottom: 1px solid var(--color-border); padding-bottom: var(--spacing-sm); color: var(--color-text-primary);">Booking History Logs</h3>
                        
                        <div class="data-table-wrapper" style="border: none;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Vehicle Name</th>
                                        <th>Service Type</th>
                                        <th>Date</th>
                                        <th>Time Slot</th>
                                        <th>Status</th>
                                        <th>Final Amount</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty bookings}">
                                            <tr>
                                                <td colspan="7" style="text-align: center; padding: var(--spacing-xxl); color: var(--color-text-tertiary);">
                                                    <div class="vehicle-empty" style="border: none; background: transparent; min-height: auto; padding: 0;">
                                                        <div class="vehicle-empty__icon">📅</div>
                                                        <div class="vehicle-empty__title" style="margin-top: 1rem;">
                                                            No Bookings Found
                                                        </div>
                                                        <div class="vehicle-empty__description">This customer has no historical service logs.</div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${bookings}" var="booking">
                                                <tr>
                                                    <td style="font-weight: 600; color: var(--color-text-primary);">
                                                        #${booking.bookingID}
                                                    </td>
                                                    <td style="font-weight: 500; color: var(--color-text-primary);">
                                                        ${booking.vehicleName}
                                                    </td>
                                                    <td>
                                                        <span style="color: var(--color-accent-cyan); font-weight: 500;">
                                                            ${booking.serviceType}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div style="font-size: 0.9rem; color: var(--color-text-primary); font-weight: 500;">
                                                            ${booking.bookingDate}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div style="font-size: 0.85rem; font-weight: 500; padding: 0.25rem 0.5rem; background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: var(--radius-sm); width: fit-content; color: var(--color-text-secondary);">
                                                            ${booking.timeSlot}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${booking.bookingStatus eq 'COMPLETED'}">
                                                                <span class="status-badge status-badge--completed">
                                                                    Completed
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${booking.bookingStatus eq 'PENDING'}">
                                                                <span class="status-badge status-badge--pending">
                                                                    Pending
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${booking.bookingStatus eq 'CONFIRMED'}">
                                                                <span class="status-badge status-badge--vip">
                                                                    Confirmed
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge status-badge--cancelled">
                                                                    Cancelled
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="font-weight: 700; color: var(--color-text-primary); font-size: 1.05rem;">
                                                        $ ${booking.finalAmount}
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
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

    </body>
</html>
