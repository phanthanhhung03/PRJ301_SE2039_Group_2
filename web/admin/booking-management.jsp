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
                    <div class="site-header__logo-icon" style="background: linear-gradient(135deg, var(--color-accent-blue), var(--color-accent-cyan));"></div>
                    <div class="site-header__logo-text">ADMIN<span>PANEL</span></div>
                </a>
                <nav class="site-header__navigation">
                    <a href="${pageContext.request.contextPath}/MainController?action=viewAdminDashboard" class="site-header__nav-link">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerManagement" class="site-header__nav-link">Customers</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewAdminBookings" class="site-header__nav-link site-header__nav-link--active">Bookings</a>
                    <a href="#" class="site-header__nav-link">Loyalty</a>
                    <a href="#" class="site-header__nav-link">Reports</a>
                </nav>
                <div class="site-header__actions">
                    <span class="status-badge status-badge--completed">Staff Portal</span>
                    <a href="${pageContext.request.contextPath}/MainController?action=logout" class="btn btn--secondary btn--sm">Logout</a>
                </div>
            </div>
        </header>

        <main class="main-wrapper" style="margin-top: var(--spacing-xl);">

            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-xl);">
                <div>
                    <span style="font-size:0.75rem; font-weight:700; color:var(--color-accent-cyan); text-transform:uppercase; letter-spacing:0.1em;">Operations Desk</span>
                    <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Service Schedule</h1>
                </div>
                <a href="#" class="btn btn--primary btn--sm">+ Create Custom Booking</a>
            </div>

            <section class="glass-panel" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); display: flex; align-items: center; justify-content: space-between; gap: var(--spacing-md); flex-wrap: wrap;">
                <div style="display:flex; gap:var(--spacing-sm);">
                    <a href="#" class="btn btn--primary btn--sm" style="padding: 0.5rem 1.0rem; font-size:0.85rem;">All Bookings</a>
                    <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.5rem 1.0rem; font-size:0.85rem;">Active Queue</a>
                    <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.5rem 1.0rem; font-size:0.85rem;">Upcoming</a>
                    <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.5rem 1.0rem; font-size:0.85rem;">Completed</a>
                </div>

                <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                    <span style="font-size:0.8rem; font-weight:600; text-transform:uppercase; color:var(--color-text-tertiary);">Bay Filter:</span>
                    <select class="form-group__input" style="padding: 0.5rem 2.0rem 0.5rem 1.0rem; font-size:0.85rem; width: auto; background-color: var(--color-surface-hover); cursor: pointer;">
                        <option value="all">All Bays</option>
                        <option value="1">Bay 1 (Auto)</option>
                        <option value="2">Bay 2 (Detail)</option>
                        <option value="3">Bay 3 (VIP)</option>
                        <option value="4">Bay 4 (Express)</option>
                    </select>
                </div>
            </section>

            <section class="glass-panel" style="border-radius: var(--radius-xl); overflow: hidden;">
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
                                <th>Status</th>
                                <th style="text-align: right;">Ops Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${ALL_BOOKINGS}" var="b">
                                <tr>
                                    <td style="font-family:monospace; font-weight:600; color:var(--color-text-primary);">
                                        #AWP-${b.bookingID}
                                    </td>
                                    
                                    <td style="font-weight:600; color:var(--color-text-primary);">
                                        ${b.customerName}
                                    </td>
                                    
                                    <td>
                                        <div>${b.vehicleName}</div>
                                    </td>
                                    
                                    <td>
                                        <span class="status-badge status-badge--vip" style="font-size:0.7rem;">${b.serviceType}</span>
                                        <div style="font-size: 0.75rem; margin-top: 5px; color: var(--color-accent-gold);">
                                            Final: ${b.finalAmount} đ
                                        </div>
                                    </td>
                                    
                                    <td>
                                        <div>${b.bookingDate}</div>
                                        <div style="font-size:0.75rem; color:var(--color-accent-blue);">${b.timeSlot}</div>
                                    </td>
                                    
                                    <td>Bay 1</td>
                                    
                                    <td>
                                        <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0;">
                                            <input type="hidden" name="action" value="updateBookingStatus">
                                            <input type="hidden" name="bookingID" value="${b.bookingID}">
                                            <input type="hidden" name="cusID" value="${b.cusId}">
                                            
                                            <select name="newStatus" onchange="this.form.submit()" 
                                                    class="form-group__input" 
                                                    style="padding: 0.4rem; font-size: 0.85rem; width: 120px; background-color: var(--color-surface-hover); cursor: pointer;
                                                    ${b.bookingStatus == 'Completed' ? 'color: #34d399; border-color: #34d399;' : ''}
                                                    ${b.bookingStatus == 'Cancelled' ? 'color: #ef4444; border-color: #ef4444;' : ''}">
                                                <option value="Pending" ${b.bookingStatus == 'Pending' ? 'selected' : ''}>Pending</option>
                                                <option value="Completed" ${b.bookingStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                                <option value="Cancelled" ${b.bookingStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                        </form>
                                    </td>
                                    
                                    <td style="text-align: right;">
                                        <div style="display:inline-flex; gap:var(--spacing-xs);">
                                            <span style="font-size:0.85rem; color:var(--color-text-tertiary);">Log Sync</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty ALL_BOOKINGS}">
                                <tr>
                                    <td colspan="8" style="text-align:center; padding: 20px; color: var(--color-text-tertiary);">
                                        No bookings found in the database.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>

        <footer class="site-footer" style="margin-top: var(--spacing-xxl);">
            <div class="site-footer__container main-wrapper">
                <div class="site-footer__bottom">
                    <p>&copy; 2026 AutoWashPro Operations Desk. Restricted Access.</p>
                    <a href="${pageContext.request.contextPath}/MainController?action=landing" class="site-footer__staff-link">Return to Customer Landing</a>
                </div>
            </div>
        </footer>

    </body>
</html>