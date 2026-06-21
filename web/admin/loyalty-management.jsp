<%-- 
    Document   : loyalty-management
    Created on : May 30, 2026, 2:26:12 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Loyalty Management | AutoWashPro Staff</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/loyalty-management.js"></script>
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

                            <button
                                class="btn btn--secondary btn--sm btn--block"

                                data-tier-id="${tier.tierID}"
                                data-tier-name="${tier.tierName}"
                                data-min-bookings="${tier.minBookings}"
                                data-min-spend="${tier.minSpend}"
                                data-point-multiplier="${tier.pointMultiplier}"
                                data-discount-percent="${tier.discountPercent}"

                                onclick="openTierModal(this)">

                                Configure Tier

                            </button>

                        </div>

                    </c:forEach>

                </div>

            </section>
            <!-- LOYALTY INSIGHTS -->
            <div class="grid-cols-2" style="margin-bottom:var(--spacing-xl);">

                <!-- Points Trend Chart -->
                <div class="glass-panel" style="padding:var(--spacing-lg); border-radius:var(--radius-xl);">
                    <h3 style="font-size:1.2rem; margin-bottom:var(--spacing-md);">Points Trend (6 Months)</h3>
                    <canvas id="pointsTrendChart" height="220"></canvas>
                </div>

                <!-- Average Points per Booking by Tier -->
                <div class="glass-panel" style="padding:var(--spacing-lg); border-radius:var(--radius-xl);">
                    <h3 style="font-size:1.2rem; margin-bottom:var(--spacing-md);">Avg. Points Earned per Booking by Tier</h3>

                    <c:if test="${empty tierPointsAvgMap}">
                        <p style="color:var(--color-text-tertiary); font-style:italic;">No EARN transactions yet.</p>
                    </c:if>

                    <c:set var="maxAvg" value="0"/>
                    <c:forEach var="entry" items="${tierPointsAvgMap}">
                        <c:if test="${entry.value > maxAvg}">
                            <c:set var="maxAvg" value="${entry.value}"/>
                        </c:if>
                    </c:forEach>

                    <c:forEach var="entry" items="${tierPointsAvgMap}">
                        <div style="margin-bottom:var(--spacing-md);">
                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-xs);">
                                <span class="status-badge status-badge--${fn:toLowerCase(entry.key)}">${entry.key}</span>
                                <span style="font-weight:600; color:var(--color-text-primary);">
                                    <fmt:formatNumber value="${entry.value}" maxFractionDigits="1"/> pts/booking
                                </span>
                            </div>
                            <div style="background:rgba(255,255,255,0.08); border-radius:var(--radius-sm); height:8px; overflow:hidden;">
                                <div style="background:var(--color-accent-gold); height:100%;
                                     width:${maxAvg > 0 ? (entry.value / maxAvg * 100) : 0}%;"></div>
                            </div>
                        </div>
                    </c:forEach>
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

        <!-- Modal for Configure Button -->
        <div id="tierModal" class="tier-modal-overlay">

            <div class="glass-panel tier-modal-box">

                <div class="tier-modal-header">

                    <h3>Configure Tier</h3>

                    <button type="button"
                            class="tier-modal-close"
                            onclick="closeTierModal()">
                        ✕
                    </button>

                </div>

                <form action="MainController?action=updateTier" method="POST">

                    <input type="hidden"
                           id="modalTierID"
                           name="tierID">

                    <div class="tier-form-group">
                        <label>Tier Name</label>
                        <input type="text"
                               id="tierName"
                               readonly>
                    </div>

                    <div class="tier-form-group">
                        <label>Minimum Bookings</label>
                        <input type="number"
                               id="minBookings"
                               name="minBookings">
                    </div>

                    <div class="tier-form-group">
                        <label>Minimum Spend</label>
                        <input type="number"
                               id="minSpend"
                               name="minSpend">
                    </div>

                    <div class="tier-form-group">
                        <label>Point Multiplier</label>
                        <input type="number"
                               step="0.1"
                               id="pointMultiplier"
                               name="pointMultiplier">
                    </div>

                    <div class="tier-form-group">
                        <label>Discount Percent</label>
                        <input type="number"
                               step="0.1"
                               id="discountPercent"
                               name="discountPercent">
                    </div>

                    <button class="btn btn--gold btn--block">
                        Save Changes
                    </button>

                </form>

            </div>

        </div>

        <!-- Chart for showcase -->
        <script>
            const ptMonths = [
            <c:forEach var="entry" items="${monthlySummary}" varStatus="st">"${entry.key}"<c:if test="${!st.last}">,</c:if></c:forEach>
            ];
            const ptEarned = [
            <c:forEach var="entry" items="${monthlySummary}" varStatus="st">${entry.value[0]}<c:if test="${!st.last}">,</c:if></c:forEach>
            ];
            const ptDeducted = [
            <c:forEach var="entry" items="${monthlySummary}" varStatus="st">${entry.value[1]}<c:if test="${!st.last}">,</c:if></c:forEach>
            ];

            const cssVar = (name, fallback) => {
                const v = getComputedStyle(document.documentElement).getPropertyValue(name).trim();
                return v || fallback;
            };

            new Chart(document.getElementById('pointsTrendChart'), {
                type: 'bar',
                data: {
                    labels: ptMonths,
                    datasets: [
                        {label: 'Points Earned', data: ptEarned, backgroundColor: cssVar('--color-accent-cyan', '#22d3ee')},
                        {label: 'Points Deducted', data: ptDeducted, backgroundColor: cssVar('--color-accent-red', '#ef4444')}
                    ]
                },
                options: {
                    responsive: true,
                    plugins: {legend: {position: 'bottom', labels: {color: '#94a3b8'}}},
                    scales: {
                        x: {ticks: {color: '#94a3b8'}, grid: {display: false}},
                        y: {ticks: {color: '#94a3b8'}, grid: {color: 'rgba(255,255,255,0.05)'}}
                    }
                }
            });
        </script>
    </body>
</html>