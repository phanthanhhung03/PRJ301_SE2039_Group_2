<%-- 
    Document   : loyalty-management
    Created on : May 30, 2026, 2:26:12 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Loyalty Management | AutoWashPro Staff</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <script src="${pageContext.request.contextPath}/js/loyalty-management.js"></script> 
    </head>

    <body>

        <!-- STAFF TOP NAVIGATION -->
        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="admin-dashboard.html" class="site-header__logo">
                    <div class="site-header__logo-icon" style="background: linear-gradient(135deg, var(--color-accent-blue), var(--color-accent-cyan));"></div>
                    <div class="site-header__logo-text">ADMIN<span>PANEL</span></div>
                </a>
                <nav class="site-header__navigation">
                    <a href="MainController?action=viewAdminDashboard" class="site-header__nav-link">Dashboard</a>
                    <a href="MainController?action=viewCustomerManagement" class="site-header__nav-link">Customers</a>
                    <a href="booking-management.html" class="site-header__nav-link">Bookings</a>
                    <a href="#" class="site-header__nav-link site-header__nav-link--active">Loyalty</a>
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

                            <!-- Tier Name -->
                            <h4 style="font-size:1.1rem; color:var(--color-text-primary);">
                                ${tier.tierName}
                            </h4>

                            <p style="
                               font-size:0.8rem;
                               color:var(--color-text-tertiary);
                               margin:var(--spacing-xs) 0 var(--spacing-md);">

                                Tier Level ${tier.priorityLevel}
                            </p>

                            <!-- Requirement -->
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

                            <!-- Benefits -->
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

                            <!-- Button -->
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

            <!-- POINT RULES & REDEMPTIONS -->
            <div class="grid-cols-2" style="margin-bottom:var(--spacing-xl);">

                <!-- Point Earning Rules -->
                <div class="glass-panel" style="padding:var(--spacing-lg); border-radius:var(--radius-xl);">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-md);">
                        <h3 style="font-size:1.2rem;">Point Earning Rules</h3>
                        <a href="#" class="btn btn--secondary btn--sm">Add Rule</a>
                    </div>
                    <div class="data-table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Customer Action</th>
                                    <th>Base Points</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Express Wash Booking</td>
                                    <td>100 pts</td>
                                    <td><span class="status-badge status-badge--completed">Active</span></td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Ceramic Coat Coating</td>
                                    <td>350 pts</td>
                                    <td><span class="status-badge status-badge--completed">Active</span></td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Signature Detailing Wash</td>
                                    <td>250 pts</td>
                                    <td><span class="status-badge status-badge--completed">Active</span></td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Refer a New Friend</td>
                                    <td>500 pts</td>
                                    <td><span class="status-badge status-badge--completed">Active</span></td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Leave Google Review</td>
                                    <td>150 pts</td>
                                    <td><span class="status-badge status-badge--completed" style="border-color:var(--color-accent-orange); color:var(--color-accent-orange);">Paused</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Point Redemption Catalog -->
                <div class="glass-panel" style="padding:var(--spacing-lg); border-radius:var(--radius-xl);">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-md);">
                        <h3 style="font-size:1.2rem;">Redemption Catalog</h3>
                        <a href="#" class="btn btn--secondary btn--sm">Add Reward</a>
                    </div>
                    <div class="data-table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Reward Detail</th>
                                    <th>Points Cost</th>
                                    <th>Remaining Stock</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Free Cabin Odor Sanitization</td>
                                    <td>1,000 pts</td>
                                    <td>48 vouchers</td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Free Rain-X Shield Coating</td>
                                    <td>800 pts</td>
                                    <td>12 vouchers</td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Complimentary Coffee & Shogun Lounge</td>
                                    <td>300 pts</td>
                                    <td>Unlimited</td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">1 Free Express Outer Wash</td>
                                    <td>2,000 pts</td>
                                    <td>150 vouchers</td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Leather Seat Moisturizer Treatment</td>
                                    <td>1,500 pts</td>
                                    <td>8 vouchers</td>
                                </tr>
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
                                <th>Action / Description</th>
                                <th>Points Flow</th>
                                <th>Final Balance</th>
                                <th>Operator</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>2026-05-30 14:20</td>
                                <td style="font-weight:600; color:var(--color-text-primary);">Kenji Takahashi</td>
                                <td>Ceramic Wash Completed (Lexus LS 500h)</td>
                                <td style="font-weight:600; color:var(--color-accent-cyan);">+525 pts <span style="font-size:0.75rem; font-weight:400; color:var(--color-text-tertiary);">(1.5x multi)</span></td>
                                <td style="font-weight:600; color:var(--color-text-primary);">4,850 pts</td>
                                <td>RFID Autogate</td>
                            </tr>
                            <tr>
                                <td>2026-05-30 13:50</td>
                                <td style="font-weight:600; color:var(--color-text-primary);">Akira Tanaka</td>
                                <td>Redeemed Free Cabin Odor Sanitization</td>
                                <td style="font-weight:600; color:var(--color-accent-red);">-1,000 pts</td>
                                <td style="font-weight:600; color:var(--color-text-primary);">2,910 pts</td>
                                <td>Counter Desk (Saito Y.)</td>
                            </tr>
                            <tr>
                                <td>2026-05-29 11:15</td>
                                <td style="font-weight:600; color:var(--color-text-primary);">Nobuhiro Sato</td>
                                <td>Signature Graphene Detailing (Nissan Z)</td>
                                <td style="font-weight:600; color:var(--color-accent-cyan);">+700 pts <span style="font-size:0.75rem; font-weight:400; color:var(--color-text-tertiary);">(2.0x multi)</span></td>
                                <td style="font-weight:600; color:var(--color-text-primary);">5,120 pts</td>
                                <td>RFID Autogate</td>
                            </tr>
                            <tr>
                                <td>2026-05-28 16:30</td>
                                <td style="font-weight:600; color:var(--color-text-primary);">Miyu Watanabe</td>
                                <td>Express Wash Completed (Toyota Prius)</td>
                                <td style="font-weight:600; color:var(--color-accent-cyan);">+150 pts <span style="font-size:0.75rem; font-weight:400; color:var(--color-text-tertiary);">(1.5x multi)</span></td>
                                <td style="font-weight:600; color:var(--color-text-primary);">1,850 pts</td>
                                <td>RFID Autogate</td>
                            </tr>
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

    </body>
</html>

