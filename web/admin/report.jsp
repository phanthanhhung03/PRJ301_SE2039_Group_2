<%-- 
    Document   : report
    Created on : May 30, 2026, 2:26:42 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Analytics & Reports | AutoWashPro Staff</title>
        <link rel="stylesheet" href="css/style.css">
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
                    <a href="admin-dashboard.html" class="site-header__nav-link">Dashboard</a>
                    <a href="customer-management.html" class="site-header__nav-link">Customers</a>
                    <a href="booking-management.html" class="site-header__nav-link">Bookings</a>
                    <a href="loyalty-management.html" class="site-header__nav-link">Loyalty</a>
                    <a href="reports.html" class="site-header__nav-link site-header__nav-link--active">Reports</a>
                </nav>
                <div class="site-header__actions">
                    <span class="status-badge status-badge--completed">Staff Portal</span>
                    <a href="admin-login.html" class="btn btn--secondary btn--sm">Logout</a>
                </div>
            </div>
        </header>

        <!-- CONTENT -->
        <main class="main-wrapper" style="margin-top: var(--spacing-xl);">

            <!-- HEADER BLOCK -->
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-xl);">
                <div>
                    <span style="font-size:0.75rem; font-weight:700; color:var(--color-accent-cyan); text-transform:uppercase; letter-spacing:0.1em;">Business Intelligence</span>
                    <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Operational Performance</h1>
                </div>
                <div style="display:flex; gap:var(--spacing-sm);">
                    <a href="#" class="btn btn--secondary btn--sm">Download PDF Report</a>
                    <a href="#" class="btn btn--primary btn--sm">Export CSV Data</a>
                </div>
            </div>

            <!-- REVENUE & TREND METRIC CARDS -->
            <section style="margin-bottom: var(--spacing-xl);">
                <div class="grid-cols-3">
                    <!-- Monthly Revenue -->
                    <div class="stat-card glass-panel">
                        <div class="stat-card__header">
                            <span class="stat-card__label">Monthly Recurring Revenue</span>
                            <div class="stat-card__icon" style="color:var(--color-accent-cyan);">
                                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 1v22M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"></path></svg>
                            </div>
                        </div>
                        <div class="stat-card__body">
                            <span class="stat-card__value">$124,800</span>
                            <span class="stat-card__change stat-card__change--up">
                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24" style="margin-right:2px;"><path d="M4 12l1.41 1.41L11 7.83V20h2V7.83l5.58 5.59L20 12l-8-8-8 8z"></path></svg>
                                +14.2% MoM
                            </span>
                        </div>
                    </div>

                    <!-- Average Booking Value -->
                    <div class="stat-card glass-panel">
                        <div class="stat-card__header">
                            <span class="stat-card__label">Avg Booking Detailing Value</span>
                            <div class="stat-card__icon" style="color:var(--color-accent-blue);">
                                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            </div>
                        </div>
                        <div class="stat-card__body">
                            <span class="stat-card__value">$112.50</span>
                            <span class="stat-card__change stat-card__change--up">
                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24" style="margin-right:2px;"><path d="M4 12l1.41 1.41L11 7.83V20h2V7.83l5.58 5.59L20 12l-8-8-8 8z"></path></svg>
                                +$8.40 MoM
                            </span>
                        </div>
                    </div>

                    <!-- Loyalty Conversion -->
                    <div class="stat-card glass-panel">
                        <div class="stat-card__header">
                            <span class="stat-card__label">New VIP Upgrade Ratio</span>
                            <div class="stat-card__icon" style="color:var(--color-accent-gold);">
                                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            </div>
                        </div>
                        <div class="stat-card__body">
                            <span class="stat-card__value">18.4% Upgrades</span>
                            <span class="stat-card__change stat-card__change--down" style="color:var(--color-accent-orange);">
                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24" style="margin-right:2px; transform: rotate(180deg);"><path d="M4 12l1.41 1.41L11 7.83V20h2V7.83l5.58 5.59L20 12l-8-8-8 8z"></path></svg>
                                -1.2% MoM
                            </span>
                        </div>
                    </div>
                </div>
            </section>

            <!-- CHARTS GRID -->
            <div class="grid-cols-2" style="margin-bottom:var(--spacing-xl);">

                <!-- Chart 1: Revenue Trends (CSS Line Chart Representation) -->
                <div class="glass-panel" style="padding:var(--spacing-lg); border-radius:var(--radius-xl);">
                    <h3 style="font-size:1.2rem; margin-bottom:var(--spacing-md);">Monthly Revenue Trend (12 Months)</h3>

                    <div class="chart-line-placeholder">
                        <!-- Horizontal grid lines -->
                        <div class="chart-line-placeholder__grid-line" style="bottom: 75%;"></div>
                        <div class="chart-line-placeholder__grid-line" style="bottom: 50%;"></div>
                        <div class="chart-line-placeholder__grid-line" style="bottom: 25%;"></div>

                        <!-- Month bars acting as a line gradient chart -->
                        <div class="chart-line-placeholder__bar" style="height: 35%;">Jun</div>
                        <div class="chart-line-placeholder__bar" style="height: 42%;">Jul</div>
                        <div class="chart-line-placeholder__bar" style="height: 40%;">Aug</div>
                        <div class="chart-line-placeholder__bar" style="height: 52%;">Sep</div>
                        <div class="chart-line-placeholder__bar" style="height: 60%;">Oct</div>
                        <div class="chart-line-placeholder__bar" style="height: 58%;">Nov</div>
                        <div class="chart-line-placeholder__bar" style="height: 65%;">Dec</div>
                        <div class="chart-line-placeholder__bar" style="height: 72%;">Jan</div>
                        <div class="chart-line-placeholder__bar" style="height: 78%;">Feb</div>
                        <div class="chart-line-placeholder__bar" style="height: 85%;">Mar</div>
                        <div class="chart-line-placeholder__bar" style="height: 90%;">Apr</div>
                        <div class="chart-line-placeholder__bar" style="height: 96%; background:linear-gradient(180deg, var(--color-accent-gold) 0%, rgba(226, 184, 61, 0.1) 100%)">May</div>
                    </div>

                    <div style="display:flex; justify-content:space-between; margin-top:var(--spacing-sm); font-size:0.75rem; color:var(--color-text-tertiary);">
                        <span>FY26 H1 (Jun - Nov)</span>
                        <span>FY26 H2 (Dec - May)</span>
                    </div>
                </div>

                <!-- Chart 2: Popular Detailing Tiers (CSS Horizontal Bars) -->
                <div class="glass-panel" style="padding:var(--spacing-lg); border-radius:var(--radius-xl);">
                    <h3 style="font-size:1.2rem; margin-bottom:var(--spacing-md);">Popular Detailing Bookings</h3>

                    <div class="chart-bar-container">
                        <!-- Row 1 -->
                        <div class="chart-bar-row">
                            <span class="chart-bar-label">Graphene Coat</span>
                            <div class="chart-bar-track">
                                <div class="chart-bar-fill chart-bar-fill--gold" style="width: 88%;"></div>
                            </div>
                            <span class="chart-bar-value">88%</span>
                        </div>

                        <!-- Row 2 -->
                        <div class="chart-bar-row">
                            <span class="chart-bar-label">Ceramic Wash</span>
                            <div class="chart-bar-track">
                                <div class="chart-bar-fill" style="width: 72%;"></div>
                            </div>
                            <span class="chart-bar-value">72%</span>
                        </div>

                        <!-- Row 3 -->
                        <div class="chart-bar-row">
                            <span class="chart-bar-label">Interior Steam</span>
                            <div class="chart-bar-track">
                                <div class="chart-bar-fill" style="width: 58%; background:linear-gradient(90deg, var(--color-accent-cyan), var(--color-accent-blue));"></div>
                            </div>
                            <span class="chart-bar-value">58%</span>
                        </div>

                        <!-- Row 4 -->
                        <div class="chart-bar-row">
                            <span class="chart-bar-label">Express Polish</span>
                            <div class="chart-bar-track">
                                <div class="chart-bar-fill" style="width: 38%; background:var(--color-text-secondary);"></div>
                            </div>
                            <span class="chart-bar-value">38%</span>
                        </div>

                        <!-- Row 5 -->
                        <div class="chart-bar-row">
                            <span class="chart-bar-label">Engine Clean</span>
                            <div class="chart-bar-track">
                                <div class="chart-bar-fill" style="width: 25%; background:var(--color-accent-red);"></div>
                            </div>
                            <span class="chart-bar-value">25%</span>
                        </div>
                    </div>
                </div>

            </div>

            <!-- MEMBERSHIP CONVERSION & RECENT LOGS -->
            <div class="grid-cols-3" style="margin-bottom:var(--spacing-xl);">

                <!-- Donut Chart representation -->
                <div class="glass-panel" style="padding:var(--spacing-lg); border-radius:var(--radius-xl); text-align:center;">
                    <h3 style="font-size:1.1rem; margin-bottom:var(--spacing-lg);">Member Club Split</h3>

                    <!-- CSS conic gradient donut -->
                    <div class="chart-donut">
                        <div class="chart-donut__inner">
                            <span class="chart-donut__val">1,482</span>
                            <span class="chart-donut__lbl">Members</span>
                        </div>
                    </div>

                    <div style="display:flex; justify-content:center; gap:var(--spacing-md); margin-top:var(--spacing-lg); font-size:0.75rem;">
                        <div style="display:flex; align-items:center; gap:4px;">
                            <div style="width:10px; height:10px; border-radius:50%; background-color:var(--color-accent-blue);"></div>
                            <span>Elite (55%)</span>
                        </div>
                        <div style="display:flex; align-items:center; gap:4px;">
                            <div style="width:10px; height:10px; border-radius:50%; background-color:var(--color-accent-cyan);"></div>
                            <span>Signature (30%)</span>
                        </div>
                        <div style="display:flex; align-items:center; gap:4px;">
                            <div style="width:10px; height:10px; border-radius:50%; background-color:var(--color-accent-gold);"></div>
                            <span>VIP (15%)</span>
                        </div>
                    </div>
                </div>

                <!-- Detail reports listings table -->
                <div class="glass-panel" style="grid-column: span 2; padding:var(--spacing-lg); border-radius:var(--radius-xl);">
                    <h3 style="font-size:1.1rem; margin-bottom:var(--spacing-md);">Top Detailing Operators this Shift</h3>

                    <div class="data-table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Operator Name</th>
                                    <th>Assigned Station</th>
                                    <th>Washes Handled</th>
                                    <th>Customer Satisfaction</th>
                                    <th>Shift Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Saito Yamada</td>
                                    <td>Bay 3 (VIP Detail)</td>
                                    <td>8 cars</td>
                                    <td><span style="color:var(--color-accent-gold);">★★★★★ 5.0</span></td>
                                    <td>$1,560.00</td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Takeshi Kurosawa</td>
                                    <td>Bay 2 (Cabin Clean)</td>
                                    <td>12 cars</td>
                                    <td><span style="color:var(--color-accent-gold);">★★★★☆ 4.8</span></td>
                                    <td>$980.00</td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Hiroshi Tanaka</td>
                                    <td>Bay 1 (Auto-Coating)</td>
                                    <td>18 cars</td>
                                    <td><span style="color:var(--color-accent-gold);">★★★★☆ 4.6</span></td>
                                    <td>$1,260.00</td>
                                </tr>
                            </tbody>
                        </table>
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
