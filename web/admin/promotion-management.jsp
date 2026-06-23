<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Promotion Management | AutoWashPro Admin</title>
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

        <!-- ===== TOP NAVIGATION ===== -->
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
                    <a href="MainController?action=viewLoyaltyManagement" class="site-header__nav-link">Loyalty</a>
                    <a href="MainController?action=viewPromotionManagement" class="site-header__nav-link site-header__nav-link--active">Promotions</a>
                </nav>
                <div class="site-header__actions">
                    <span class="status-badge status-badge--completed">Admin Portal</span>
                    <a href="MainController?action=logout" class="btn btn--secondary btn--sm">Logout</a>
                </div>
            </div>
        </header>

        <main class="main-wrapper" style="margin-top: var(--spacing-xl);">

            <!-- ===== PAGE HEADER ===== -->
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-xl); flex-wrap:wrap; gap:var(--spacing-md);">
                <div>
                    <span style="font-size:0.75rem; font-weight:700; color:var(--color-accent-cyan); text-transform:uppercase; letter-spacing:0.1em;">
                        Promotion Management
                    </span>
                    <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Campaigns</h1>
                </div>
                <a href="MainController?action=showAddPromotion" class="btn btn--primary btn--sm">
                    + New Promotion
                </a>
            </div>

            <!-- ===== FLASH MESSAGES ===== -->
            <c:if test="${not empty sessionScope.PROMO_MSG}">
                <div class="glass-panel flash-message" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); border-left: 3px solid var(--color-accent-cyan); color: var(--color-accent-cyan); font-weight:600;">
                    &#10003; ${sessionScope.PROMO_MSG}
                </div>
                <c:remove var="PROMO_MSG" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.PROMO_ERR}">
                <div class="glass-panel flash-message" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); border-left: 3px solid var(--color-accent-red); color: var(--color-accent-red); font-weight:600;">
                    &#10007; ${sessionScope.PROMO_ERR}
                </div>
                <c:remove var="PROMO_ERR" scope="session"/>
            </c:if>
            <!-- ===== STAT CARDS ===== -->
            <section class="grid-cols-4" style="margin-bottom: var(--spacing-xl);">

                <div class="stat-card glass-panel">
                    <div class="stat-card__header">
                        <span class="stat-card__label">Active Promotions</span>
                    </div>
                    <div class="stat-card__body">
                        <span class="stat-card__value">${activePromotionsCount}</span>
                    </div>
                </div>

                <div class="stat-card glass-panel">
                    <div class="stat-card__header">
                        <span class="stat-card__label">Total Promotions</span>
                    </div>
                    <div class="stat-card__body">
                        <span class="stat-card__value">${promotionList.size()}</span>
                    </div>
                </div>

                <div class="stat-card glass-panel">
                    <div class="stat-card__header">
                        <span class="stat-card__label">Total Assignments</span>
                    </div>
                    <div class="stat-card__body">
                        <span class="stat-card__value">${assignedCount}</span>
                    </div>
                </div>

                <div class="stat-card glass-panel">
                    <div class="stat-card__header">
                        <span class="stat-card__label">Low Engagement Customers</span>
                    </div>
                    <div class="stat-card__body">
                        <span class="stat-card__value">${lowEngagementCustomerCount}</span>
                    </div>
                </div>

            </section>

            <!-- ===== ALL PROMOTIONS TABLE ===== -->
            <section class="glass-panel" style="border-radius: var(--radius-xl); overflow: hidden; margin-bottom: var(--spacing-xl);">

                <div style="display:flex; justify-content:space-between; align-items:center; padding: var(--spacing-lg) var(--spacing-lg) 0;">
                    <h3 style="font-size:1.2rem;">All Promotions</h3>
                    <span style="font-size:0.8rem; color:var(--color-text-tertiary);">${promotionList.size()} promotion(s) found</span>
                </div>

                <div class="data-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Promotion</th>
                                <th>Target Type</th>
                                <th>Discount / Bonus Points</th>
                                <th>Validity Period</th>
                                <th>Status</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>

                            <c:if test="${empty promotionList}">
                                <tr>
                                    <td colspan="6" style="text-align:center; padding: var(--spacing-xl); color: var(--color-text-tertiary); font-style:italic;">
                                        No promotions found. Click "+ New Promotion" to create one.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="promo" items="${promotionList}">
                                <tr>
                                    <td>
                                        <div style="font-weight:600;">${promo.promotionName}</div>
                                        <div style="font-size:0.78rem; color:var(--color-text-tertiary); max-width:280px;">${promo.description}</div>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${promo.targetType == 'ALL'}">
                                                <span class="status-badge status-badge--completed">All Customers</span>
                                            </c:when>
                                            <c:when test="${promo.targetType == 'TIER_ONLY'}">
                                                <span class="status-badge status-badge--pending">
                                                    Tier: ${promotionMinTierNameMap[promo.promotionID]}+
                                                </span>
                                            </c:when>
                                            <c:when test="${promo.targetType == 'LOW_ENGAGEMENT'}">
                                                <span class="status-badge status-badge--cancelled">Low Engagement</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:var(--color-text-tertiary);">&mdash;</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <div style="font-weight:600;">
                                            <fmt:formatNumber value="${promo.discountPercent}" maxFractionDigits="1"/>% off
                                        </div>
                                        <c:if test="${promo.bonusPoints > 0}">
                                            <div style="font-size:0.78rem; color:var(--color-accent-gold);">+${promo.bonusPoints} pts</div>
                                        </c:if>
                                    </td>

                                    <td style="font-size:0.85rem;">
                                        <fmt:formatDate value="${promo.startDate}" pattern="dd/MM/yyyy"/> &ndash;
                                        <fmt:formatDate value="${promo.endDate}" pattern="dd/MM/yyyy"/>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${promo.status}">
                                                <span class="status-badge status-badge--completed">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-badge--cancelled">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td style="text-align:right;">
                                        <a href="MainController?action=showEditPromotion&promotionID=${promo.promotionID}" class="btn btn--secondary btn--sm">
                                            Edit
                                        </a>

                                        <form action="PromotionManagementController?action=deletePromotion" method="POST" style="display:inline;">
                                            <input type="hidden" name="promotionID" value="${promo.promotionID}">
                                            <button type="submit" class="btn btn--danger btn--sm"
                                                    onclick="return confirm('Delete promotion \u00ab${promo.promotionName}\u00bb? This cannot be undone.');">
                                                Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>
                </div>
            </section>

            <!-- ===== LOW ENGAGEMENT CUSTOMERS ===== -->
            <div style="margin-bottom:var(--spacing-md);">
                <h3 style="font-size:1.2rem;">Low Engagement Customers</h3>
                <p style="font-size:0.85rem; color:var(--color-text-tertiary);">
                    Customers with no booking in the last 3 months (or who have never booked).
                    Review each one and optionally grant a promotion.
                </p>
            </div>

            <section class="glass-panel" style="border-radius: var(--radius-xl); overflow: hidden; margin-bottom: var(--spacing-xl);">
                <div class="data-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Customer</th>
                                <th>Last Booking</th>
                                <th style="text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>

                            <c:if test="${empty lowEngagementCustomer}">
                                <tr>
                                    <td colspan="3" style="text-align:center; padding: var(--spacing-xl); color: var(--color-text-tertiary); font-style:italic;">
                                        &#127881; No low engagement customers right now!
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="lowEngCust" items="${lowEngagementCustomer}">
                                <tr>
                                    <td style="font-weight:600;">${lowEngCust.customerName}</td>

                                    <td style="font-size:0.85rem;">
                                        <c:choose>
                                            <c:when test="${empty lowEngCust.lastBookingDate}">
                                                <span style="font-style:italic; color:var(--color-text-tertiary);">Never Booked</span>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatDate value="${lowEngCust.lastBookingDate}" pattern="dd/MM/yyyy"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td style="text-align: right;">
                                        <a href="MainController?action=showAssignPromotion&customerID=${lowEngCust.customerID}" class="btn btn--gold btn--sm">
                                            Review &amp; Grant
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>
                </div>
            </section>
            <!-- ===== TOP CUSTOMERS BY POINTS ===== -->
            <div style="margin-bottom:var(--spacing-md);">
                <h3 style="font-size:1.2rem;">Top Customers by Points</h3>
                <p style="font-size:0.85rem; color:var(--color-text-tertiary);">
                    Customers with the highest current points. Consider rewarding loyalty with a promotion.
                </p>
            </div>

            <section class="glass-panel" style="border-radius: var(--radius-xl); overflow: hidden; margin-bottom: var(--spacing-xl);">
                <div class="data-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Customer</th>
                                <th>Tier</th>
                                <th>Current Points</th>
                                <th style="text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>

                            <c:if test="${empty topCustomersByPoints}">
                                <tr>
                                    <td colspan="4" style="text-align:center; padding: var(--spacing-xl); color: var(--color-text-tertiary); font-style:italic;">
                                        No customer data found.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="topCust" items="${topCustomersByPoints}">
                                <tr>
                                    <td style="font-weight:600;">${topCust.fullName}</td>
                                    <td>
                                        <span class="status-badge status-badge--${fn:toLowerCase(topCust.tierId.tierName)}">${topCust.tierId.tierName}</span>
                                    </td>
                                    <td style="font-weight:700; color:var(--color-accent-gold);">${topCust.currentPoint} pts</td>
                                    <td style="text-align: right;">
                                        <a href="MainController?action=showAssignPromotion&customerID=${topCust.cusId}" class="btn btn--gold btn--sm">
                                            Grant Promotion
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>
                </div>
            </section>

            <!-- ===== ASSIGNMENT LOG ===== -->
            <section class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl); margin-bottom: var(--spacing-xl);">
                <h2 style="font-size:1.25rem; margin-bottom:var(--spacing-lg);">Promotion Assignment Log</h2>

                <div class="data-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Assigned Date</th>
                                <th>Customer</th>
                                <th>Promotion</th>
                                <th>Discount</th>
                                <th>Notes</th>
                                <th>Status</th>
                                <th>Used Date</th>
                                <th style="text-align:right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>

                            <c:if test="${empty assignedPromotions}">
                                <tr>
                                    <td colspan="8" style="text-align:center; padding: var(--spacing-xl); color: var(--color-text-tertiary); font-style:italic;">
                                        No promotions have been assigned yet.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="assignment" items="${assignedPromotions}">
                                <tr>
                                    <td><fmt:formatDate value="${assignment.assignedDate}" pattern="dd/MM/yyyy"/></td>
                                    <td style="font-weight:600;">${assignment.customerName}</td>
                                    <td>${assignment.promotionName}</td>
                                    <td style="font-weight:600;"><fmt:formatNumber value="${assignment.discountPercent}" maxFractionDigits="1"/>%</td>
                                    <td style="font-size:0.85rem; color:var(--color-text-tertiary);">${assignment.notes}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${assignment.used}">
                                                <span class="status-badge status-badge--completed">Used</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-badge--pending">Pending</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td style="font-size:0.85rem;">
                                        <c:choose>
                                            <c:when test="${empty assignment.usedDate}">&mdash;</c:when>
                                            <c:otherwise><fmt:formatDate value="${assignment.usedDate}" pattern="dd/MM/yyyy"/></c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td style="text-align:right;">
                                        <c:if test="${!assignment.used}">
                                            <form action="PromotionManagementController?action=removeAssignedPromotion" method="POST" style="display:inline;">
                                                <input type="hidden" name="customerPromotionID" value="${assignment.customerPromotionID}">
                                                <button type="submit" class="btn btn--danger btn--sm"
                                                        onclick="return confirm('Remove this promotion assignment?');">
                                                    Revoke
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>
                </div>
            </section>

        </main>

        <!-- ===== FOOTER ===== -->
        <footer class="site-footer" style="margin-top: var(--spacing-xxl);">
            <div class="site-footer__container main-wrapper">
                <div class="site-footer__bottom">
                    <p>&copy; 2026 AutoWashPro Operations Desk. Restricted Access.</p>
                    <a href="MainController?action=logout" class="site-footer__staff-link">Return to Customer Landing</a>
                </div>
            </div>
        </footer>

        <!-- Popup flash message -->
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
