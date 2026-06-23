<%-- 
    Document   : loyalty-management
    Created on : May 30, 2026, 2:26:12 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Loyalty Management | AutoWashPro Staff</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <!-- Style for flash message -->
        <style>
            .flash-message {
                transition: opacity 0.4s ease;
            }
            .flash-message.flash-hide {
                opacity: 0;
            }
        </style>
    </head>

    <body>

        <!-- STAFF TOP NAVIGATION -->
        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="MainController?action=viewAdminDashboard" class="site-header__logo">
                    <div class="site-header__logo-icon" style="background: linear-gradient(135deg, var(--color-accent-blue), var(--color-accent-cyan));"></div>
                    <div class="site-header__logo-text">ADMIN<span>PANEL</span></div>
                </a>
                <nav class="site-header__navigation">
                    <a href="MainController?action=viewAdminDashboard" class="site-header__nav-link">Dashboard</a>
                    <a href="MainController?action=viewCustomerManagement" class="site-header__nav-link">Customers</a>
                    <a href="MainController?action=viewAdminBookings" class="site-header__nav-link">Bookings</a>
                    <a href="#" class="site-header__nav-link site-header__nav-link--active">Loyalty</a>
                    <a href="MainController?action=viewPromotionManagement" class="site-header__nav-link"> Promotions </a>
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
                        Loyalty Management
                    </span>

                    <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">
                        Customer Tier Overview
                    </h1>
                </div>
            </div>

            <!-- FLASH MESSAGE -->
            <c:if test="${not empty sessionScope.SUCCESS_MESSAGE}">
                <div class="glass-panel flash-message" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); border-left: 3px solid var(--color-accent-cyan); color: var(--color-accent-cyan); font-weight:600;">
                    &#10003; ${sessionScope.SUCCESS_MESSAGE}
                </div>
                <c:remove var="SUCCESS_MESSAGE" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.ERROR_MESSAGE}">
                <div class="glass-panel flash-message" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); border-left: 3px solid var(--color-accent-red); color: var(--color-accent-red); font-weight:600;">
                    &#10007; ${sessionScope.ERROR_MESSAGE}
                </div>
                <c:remove var="ERROR_MESSAGE" scope="session"/>
            </c:if>

            <!-- TIER STRUCTURE CONFIGURATION -->
            <section style="margin-bottom: var(--spacing-xl);">

                <h3 style="font-size:1.15rem; margin-bottom:var(--spacing-md); color:var(--color-text-primary);">
                    Membership Tiers Structure
                </h3>

                <div class="grid-cols-4">

                    <c:forEach var="tier" items="${tierList}">

                        <div class="glass-panel"
                             style="
                             padding:var(--spacing-lg);
                             border-radius:var(--radius-lg);
                             border-top:3px solid var(--color-accent-cyan);">

                            <h4 style="font-size:1.1rem; color:var(--color-text-primary);">
                                ${tier.tierName}
                            </h4>

                            <p style="
                               font-size:0.8rem;
                               color:var(--color-text-tertiary);
                               margin:var(--spacing-xs) 0 var(--spacing-md);">

                                Tier Level ${tier.priorityLevel}
                            </p>

                            <div style="
                                 font-size:0.9rem;
                                 font-weight:600;
                                 margin-bottom:var(--spacing-sm);">
                                Requirements
                            </div>

                            <div style="font-size:0.85rem; margin-bottom:var(--spacing-xs);">
                                ${tier.minBookings} bookings
                            </div>

                            <div style="font-size:0.85rem; margin-bottom:var(--spacing-md);">
                                <fmt:formatNumber value="${tier.minSpend}" pattern="#,###"/>
                                VND spending
                            </div>

                            <div style="
                                 font-size:0.9rem;
                                 font-weight:600;
                                 margin-bottom:var(--spacing-sm);">

                                Benefits
                            </div>

                            <div style="font-size:0.85rem; margin-bottom:var(--spacing-xs);">
                                ${tier.pointMultiplier}x point multiplier
                            </div>

                            <div style="font-size:0.85rem; margin-bottom:var(--spacing-md);">
                                ${tier.discountPercent}% discount
                            </div>

                            <a href="MainController?action=showConfigureTier"
                               class="btn btn--secondary btn--sm btn--block">
                                Configure Tier
                            </a>

                        </div>

                    </c:forEach>

                </div>

            </section>
            <!-- LOYALTY INSIGHTS -->
            <div class="grid-cols-2" style="margin-bottom:var(--spacing-xl);">

                <!-- Top Customers by Points -->
                <div class="glass-panel" style="padding:var(--spacing-lg); border-radius:var(--radius-xl);">
                    <h3 style="font-size:1.2rem; margin-bottom:var(--spacing-md);">Top 5 Customers by Points</h3>

                    <c:if test="${empty topCustomersByPoints}">
                        <p style="color:var(--color-text-tertiary); font-style:italic;">No customer data found.</p>
                    </c:if>

                    <div class="data-table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Customer</th>
                                    <th>Tier</th>
                                    <th style="text-align:right;">Current Points</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${topCustomersByPoints}">
                                    <tr>
                                        <td style="font-weight:600;">${c.fullName}</td>
                                        <td>
                                            <span class="status-badge status-badge--${fn:toLowerCase(c.tierId.tierName)}">${c.tierId.tierName}</span>
                                        </td>
                                        <td style="text-align:right; font-weight:700; color:var(--color-accent-gold);">
                                            ${c.currentPoint} pts
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Tier Activity Summary (table) -->
                <div class="glass-panel" style="padding:var(--spacing-lg); border-radius:var(--radius-xl);">
                    <h3 style="font-size:1.2rem; margin-bottom:var(--spacing-md);">Tier Activity Summary</h3>

                    <div class="data-table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Tier</th>
                                    <th>Customers</th>
                                    <th>Avg Pts/Booking</th>
                                    <th>% Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="tier" items="${tierList}">
                                    <c:set var="custCount" value="${customerTierCountMap[tier.tierID] != null ? customerTierCountMap[tier.tierID] : 0}"/>
                                    <c:set var="tierRevenue" value="${revenueByTierMap[tier.tierID] != null ? revenueByTierMap[tier.tierID] : 0}"/>
                                    <c:set var="revenuePercent" value="${totalRevenue > 0 ? (tierRevenue / totalRevenue * 100) : 0}"/>
                                    <c:set var="avgPts" value="${tierPointsAvgMap[tier.tierName]}"/>

                                    <tr>
                                        <td>
                                            <span class="status-badge status-badge--${fn:toLowerCase(tier.tierName)}">${tier.tierName}</span>
                                        </td>
                                        <td>${custCount}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty avgPts}">&mdash;</c:when>
                                                <c:otherwise><fmt:formatNumber value="${avgPts}" maxFractionDigits="1"/> pts</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatNumber value="${revenuePercent}" maxFractionDigits="1"/>%</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

            <!-- LOYALTY TRANSACTION LOGS -->
            <section class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl); margin-bottom: var(--spacing-xl);">
                <h2 style="font-size:1.25rem; margin-bottom:var(--spacing-lg);">Loyalty Transaction Ledger</h2>
                <div class="data-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Timestamp</th>
                                <th>Customer Name</th>
                                <th>Points Flow</th>
                                <th>Current Points</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty transactionList}">
                                <tr>
                                    <td colspan="6" style="text-align:center; padding: var(--spacing-md); color: var(--color-text-tertiary); font-style:italic;">
                                        No loyalty transactions found.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="tx" items="${transactionList}">
                                <tr>
                                    <td><fmt:formatDate value="${tx.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td style="font-weight:600; color:var(--color-text-primary);">${tx.customerName}</td>
                                    <td style="font-weight:600;
                                        color:${tx.pointsChanged >= 0 ? 'var(--color-accent-cyan)' : 'var(--color-accent-red)'};">
                                        <c:if test="${tx.pointsChanged >= 0}">+</c:if>${tx.pointsChanged} pts
                                        </td>
                                        <td style="font-weight:600; color:var(--color-text-primary);">${tx.currentBalance} pts</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>

        </main>

        <!-- STAFF FOOTER -->
        <footer class="site-footer" style="margin-top: var(--spacing-xxl);">
            <div class="site-footer__container main-wrapper">
                <div class="site-footer__bottom">
                    <p>&copy; 2026 AutoWashPro Operations Desk. Restricted Access.</p>
                    <a href="MainController?action=logout" class="site-footer__staff-link">Return to Customer Landing</a>
                </div>
            </div>
        </footer>

        <!-- Flash message -->
        <script>
            document.querySelectorAll('.flash-message').forEach(function (el) {
                setTimeout(function () {
                    el.classList.add('flash-hide');
                    setTimeout(function () {
                        el.remove();
                    }, 400);
                }, 5000);
            });
        </script>

    </body>
</html>