<%-- 
    Document   : admin-dashboard
    Created on : May 30, 2026, 2:19:48 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard | AutoWashPro Staff</title>
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
                    <a href="admin-dashboard.html" class="site-header__nav-link site-header__nav-link--active">Dashboard</a>
                    <a href="customer-management.html" class="site-header__nav-link">Customers</a>
                    <a href="booking-management.html" class="site-header__nav-link">Bookings</a>
                    <a href="loyalty-management.html" class="site-header__nav-link">Loyalty</a>
                    <a href="reports.html" class="site-header__nav-link">Reports</a>
                </nav>
                <div class="site-header__actions">
                    <span class="status-badge status-badge--completed">Staff Portal</span>
                    <a href="admin-login.html" class="btn btn--secondary btn--sm">Logout</a>
                </div>
            </div>
        </header>

        <!-- ADMIN CONTENT -->
        <main class="main-wrapper" style="margin-top: var(--spacing-xl);">

            <!-- OPERATIONS OVERVIEW HERO -->
            <section class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl); margin-bottom: var(--spacing-xl); position: relative; overflow: hidden;">
                <div style="position: absolute; top:0; right:0; width: 300px; height: 100%; background: radial-gradient(circle, var(--color-accent-cyan-glow) 0%, transparent 70%); pointer-events: none;"></div>
                <span style="font-size: 0.75rem; font-weight: 700; color: var(--color-accent-cyan); text-transform: uppercase; letter-spacing: 0.1em;">Operations Control</span>
                <h1 style="font-size: 2.0rem; margin-top: var(--spacing-xs); margin-bottom: var(--spacing-sm);">Welcome back to Operations Console</h1>
                <p style="max-width: 700px; color: var(--color-text-secondary); font-size: 0.95rem;">System status is nominal. RFID gate scanning is online, 4 wash bays are currently active, and premium detaiil logs are synced.</p>
                <div style="display: flex; gap: var(--spacing-md); margin-top: var(--spacing-lg);">
                    <a href="booking-management.html" class="btn btn--primary btn--sm">View Today's Bookings</a>
                    <a href="reports.html" class="btn btn--secondary btn--sm">Generate Shift Report</a>
                </div>
            </section>

            <!-- QUICK STATS -->
            <section style="margin-bottom: var(--spacing-xl);">
                <div class="grid-cols-4">
                    <!-- Stat 1: Customers -->
                    <div class="stat-card glass-panel">
                        <div class="stat-card__header">
                            <span class="stat-card__label">Total Customers</span>
                            <div class="stat-card__icon" style="color: var(--color-accent-blue);">
                                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z"></path></svg>
                            </div>
                        </div>
                        <div class="stat-card__body">
                            <span class="stat-card__value">1,482</span>
                            <span class="stat-card__change stat-card__change--up">+12 today</span>
                        </div>
                    </div>

                    <!-- Stat 2: Active Bookings -->
                    <div class="stat-card glass-panel">
                        <div class="stat-card__header">
                            <span class="stat-card__label">Active Bookings</span>
                            <div class="stat-card__icon" style="color: var(--color-accent-cyan);">
                                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                        </div>
                        <div class="stat-card__body">
                            <span class="stat-card__value">38 Active</span>
                            <span class="stat-card__change stat-card__change--up">12 in progress</span>
                        </div>
                    </div>

                    <!-- Stat 3: Revenue -->
                    <div class="stat-card glass-panel">
                        <div class="stat-card__header">
                            <span class="stat-card__label">Today's Revenue</span>
                            <div class="stat-card__icon" style="color: var(--color-accent-gold);">
                                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="2" y="5" width="20" height="14" rx="2" ry="2"></rect><line x1="2" y1="10" x2="22" y2="10"></line></svg>
                            </div>
                        </div>
                        <div class="stat-card__body">
                            <span class="stat-card__value">$4,290.00</span>
                            <span class="stat-card__change stat-card__change--up">+18.5% shift avg</span>
                        </div>
                    </div>

                    <!-- Stat 4: Loyalty Transactions -->
                    <div class="stat-card glass-panel">
                        <div class="stat-card__header">
                            <span class="stat-card__label">Loyalty Actions</span>
                            <div class="stat-card__icon" style="color: var(--color-accent-orange);">
                                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            </div>
                        </div>
                        <div class="stat-card__body">
                            <span class="stat-card__value">142 Trans</span>
                            <span class="stat-card__change stat-card__change--up">18 redemptions</span>
                        </div>
                    </div>
                </div>
            </section>

            <!-- LIVE DATA VIEWS -->
            <div class="grid-cols-2" style="margin-bottom: var(--spacing-xl);">

                <!-- Left Column: Booking Overview -->
                <div class="glass-panel" style="padding: var(--spacing-lg); border-radius: var(--radius-xl);">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-md);">
                        <h2 style="font-size:1.25rem;">Live Booking Desk</h2>
                        <a href="booking-management.html" class="btn btn--secondary btn--sm">View All</a>
                    </div>

                    <div class="data-table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Customer</th>
                                    <th>Bay / Time</th>
                                    <th>Service</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Kenji T.</td>
                                    <td>Bay 3 @ 10:30 AM</td>
                                    <td>Graphene Coating</td>
                                    <td><span class="status-badge status-badge--pending">Confirmed</span></td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Keiko M.</td>
                                    <td>Bay 1 @ 11:00 AM</td>
                                    <td>Ceramic Wash</td>
                                    <td><span class="status-badge status-badge--pending">Pending</span></td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Satoshi K.</td>
                                    <td>Bay 2 @ 09:15 AM</td>
                                    <td>Interior Detailing</td>
                                    <td><span class="status-badge status-badge--completed">Active</span></td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Yukiko H.</td>
                                    <td>Bay 4 @ 08:30 AM</td>
                                    <td>Express Wash</td>
                                    <td><span class="status-badge status-badge--completed">Completed</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Right Column: Customer Overview -->
                <div class="glass-panel" style="padding: var(--spacing-lg); border-radius: var(--radius-xl);">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-md);">
                        <h2 style="font-size:1.25rem;">VIP & High-Tier Customers</h2>
                        <a href="customer-management.html" class="btn btn--secondary btn--sm">Manage Users</a>
                    </div>

                    <div class="data-table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Customer Name</th>
                                    <th>Membership Tier</th>
                                    <th>Points Balance</th>
                                    <th>Washes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Kenji Takahashi</td>
                                    <td><span class="status-badge status-badge--vip">VIP Shogun</span></td>
                                    <td>4,850 pts</td>
                                    <td>24 Washes</td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Nobuhiro Sato</td>
                                    <td><span class="status-badge status-badge--vip">VIP Shogun</span></td>
                                    <td>5,120 pts</td>
                                    <td>32 Washes</td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Akira Tanaka</td>
                                    <td><span class="status-badge status-badge--completed" style="border-color:var(--color-accent-blue); color:var(--color-accent-blue);">Signature</span></td>
                                    <td>2,910 pts</td>
                                    <td>14 Washes</td>
                                </tr>
                                <tr>
                                    <td style="font-weight:600; color:var(--color-text-primary);">Miyu Watanabe</td>
                                    <td><span class="status-badge status-badge--completed" style="border-color:var(--color-accent-blue); color:var(--color-accent-blue);">Signature</span></td>
                                    <td>1,850 pts</td>
                                    <td>8 Washes</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

            <!-- RECENT ACTIVITY FEED -->
            <section class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl); margin-bottom: var(--spacing-xl);">
                <h2 style="font-size:1.25rem; margin-bottom:var(--spacing-lg);">Live Operations Log</h2>

                <div class="activity-timeline">
                    <div class="activity-timeline__item">
                        <div class="activity-timeline__dot activity-timeline__dot--booking"></div>
                        <div class="activity-timeline__content">
                            <span class="activity-timeline__time">Just Now</span>
                            <span class="activity-timeline__title">Vehicle Checked In (RFID Gate 1)</span>
                            <span class="activity-timeline__desc">Lexus LS 500h (Plate: 足立 330 す 78-90) scanned. System checked in booking ID #4928.</span>
                        </div>
                    </div>

                    <div class="activity-timeline__item">
                        <div class="activity-timeline__dot activity-timeline__dot--loyalty"></div>
                        <div class="activity-timeline__content">
                            <span class="activity-timeline__time">12 minutes ago</span>
                            <span class="activity-timeline__title">Loyalty Reward Redeemed</span>
                            <span class="activity-timeline__desc">Akira Tanaka redeemed 1,000 points for a free cabin sanitizer upgrade.</span>
                        </div>
                    </div>

                    <div class="activity-timeline__item">
                        <div class="activity-timeline__dot activity-timeline__dot--booking"></div>
                        <div class="activity-timeline__content">
                            <span class="activity-timeline__time">45 minutes ago</span>
                            <span class="activity-timeline__title">New Booking Scheduled</span>
                            <span class="activity-timeline__desc">Customer Kenji Takahashi booked a Signature Graphene detailing wash for June 04.</span>
                        </div>
                    </div>
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

    </body>
</html>

