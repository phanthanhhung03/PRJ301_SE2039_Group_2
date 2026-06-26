<%@page import="dto.Booking"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Management | AutoWashPro Staff</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="${pageContext.request.contextPath}/MainController?action=viewAdminDashboard" class="site-header__logo">
                    <div class="site-header__logo-icon"></div>
                    <div class="site-header__logo-text">ADMIN<span>PANEL</span></div>
                </a>
                <nav class="site-header__navigation">
                    <a href="${pageContext.request.contextPath}/MainController?action=viewAdminDashboard" class="site-header__nav-link">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerManagement" class="site-header__nav-link">Customers</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewAdminBookings" class="site-header__nav-link site-header__nav-link--active">Bookings</a>
                    <a href="MainController?action=viewLoyaltyManagement" class="site-header__nav-link">Loyalty</a>
                    <a href="MainController?action=viewPromotionManagement" class="site-header__nav-link"> Promotions </a>
                </nav>
                <div class="site-header__actions">
                    <span class="status-badge status-badge--completed">Staff Portal</span>
                    <a href="${pageContext.request.contextPath}/MainController?action=logout" class="btn btn--secondary btn--sm">Logout</a>
                </div>
            </div>
        </header>

        <main class="main-wrapper main-wrapper--booking">

            <div class="admin-page-header">
                <div>
                    <span class="admin-page-header__subtitle">Operations Desk</span>
                    <h1 class="admin-page-header__title">Service Schedule</h1>

            <section class="glass-panel booking-filter-panel">
                <div class="booking-filter-group">
                    <a href="#" class="btn btn--primary btn--sm booking-filter-btn">All Bookings</a>
                </div>

            </section>

            <section class="glass-panel booking-table-panel">
                <div class="data-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Customer</th>
                                <th>Vehicle Details</th>
                                <th>Service Selection</th>
                                <th>Schedule Time</th>
                                <th>Assigned Bay</th>
                                <th>Payment</th>
                                <th>Status</th>
                                <th class="table-header-align-right">Ops Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${ALL_BOOKINGS}" var="b">
                                <tr>
                                    <td class="booking-id-cell">
                                        #AWP-${b.bookingID}
                                    </td>
                                    
                                    <td class="booking-customer-cell">
                                        ${b.customerName}
                                    </td>
                                    
                                    <td>
                                        <div>${b.vehicleName}</div>
                                    </td>
                                    
                                    <td>
                                        <span class="status-badge status-badge--vip status-badge--service-type">${b.serviceType}</span>
                                        <div class="booking-amount">
                                            Final: ${b.finalAmount} đ
                                        </div>
                                    </td>
                                    
                                    <td>
                                        <div>${b.bookingDate}</div>
                                        <div class="booking-timeslot">${b.timeSlot}</div>
                                    </td>
                                    
                                    <td>Bay 1</td>
                                    
                                    <td>
                                        <span class="status-badge 
                                              ${b.paymentStatus ? 'status-badge--completed' : 'status-badge--cancelled'}">
                                            ${b.paymentStatus ? 'Paid' : 'Unpaid'}
                                        </span>
                                    </td>
                                    
                                    <td>
                                        <span class="status-badge 
                                              ${b.bookingStatus == 'Cancelled' ? 'status-badge--cancelled' : 
                                                b.bookingStatus == 'Completed' ? 'status-badge--completed' : 'status-badge--pending'}">
                                            ${b.bookingStatus}
                                        </span>
                                    </td>
                                    
                                    <td class="table-cell-align-right">
                                        <div class="booking-actions-wrapper">
                                            <span class="booking-actions-label">Log Sync</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty ALL_BOOKINGS}">
                                <tr>
                                    <td colspan="8" class="table-no-data-cell">
                                        No bookings found in the database.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>

        <footer class="site-footer site-footer--admin">
            <div class="site-footer__container main-wrapper">
                <div class="site-footer__bottom">
                    <p>&copy; 2026 AutoWashPro Operations Desk. Restricted Access.</p>
                    <a href="${pageContext.request.contextPath}/MainController?action=landing" class="site-footer__staff-link">Return to Customer Landing</a>
                </div>
            </div>
        </footer>

    </body>
</html>
