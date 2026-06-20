<%-- 
    Document   : booking-management
    Created on : May 30, 2026, 2:22:53 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Management | AutoWashPro Staff</title>
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
                    <a href="booking-management.html" class="site-header__nav-link site-header__nav-link--active">Bookings</a>
                    <a href="loyalty-management.html" class="site-header__nav-link">Loyalty</a>
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
                    <span style="font-size:0.75rem; font-weight:700; color:var(--color-accent-cyan); text-transform:uppercase; letter-spacing:0.1em;">Operations Desk</span>
                    <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Service Schedule</h1>
                </div>
                <a href="#" class="btn btn--primary btn--sm">+ Create Custom Booking</a>
            </div>

            <!-- BAY STATUS CARDS -->
            <section style="margin-bottom: var(--spacing-xl);">
                <h3 style="font-size:1.15rem; margin-bottom:var(--spacing-md); color:var(--color-text-primary);">Active Detailing Bays</h3>
                <div class="grid-cols-4">
                    <!-- Bay 1 -->
                    <div class="glass-panel" style="padding:var(--spacing-md); border-radius:var(--radius-lg); text-align:center; border-color:var(--color-accent-cyan);">
                        <div style="font-size:0.8rem; font-weight:700; color:var(--color-accent-cyan);">BAY 01 - AUTOMATED</div>
                        <div style="font-size:1.25rem; font-weight:600; color:var(--color-text-primary); margin:var(--spacing-xs) 0;">Satoshi K.</div>
                        <div style="font-size:0.8rem; color:var(--color-text-secondary); margin-bottom:var(--spacing-sm);">Toyota Crown</div>
                        <span class="status-badge status-badge--completed">In Progress</span>
                    </div>
                    <!-- Bay 2 -->
                    <div class="glass-panel" style="padding:var(--spacing-md); border-radius:var(--radius-lg); text-align:center;">
                        <div style="font-size:0.8rem; font-weight:700; color:var(--color-text-tertiary);">BAY 02 - DETAIL STAGE</div>
                        <div style="font-size:1.25rem; font-weight:600; color:var(--color-text-primary); margin:var(--spacing-xs) 0;">Yoshio I.</div>
                        <div style="font-size:0.8rem; color:var(--color-text-secondary); margin-bottom:var(--spacing-sm);">Honda Civic Type R</div>
                        <span class="status-badge status-badge--completed">In Progress</span>
                    </div>
                    <!-- Bay 3 -->
                    <div class="glass-panel" style="padding:var(--spacing-md); border-radius:var(--radius-lg); text-align:center; border-color:var(--color-accent-gold); box-shadow: var(--glow-gold);">
                        <div style="font-size:0.8rem; font-weight:700; color:var(--color-accent-gold);">BAY 03 - VIP SHOGUN</div>
                        <div style="font-size:1.25rem; font-weight:600; color:var(--color-text-primary); margin:var(--spacing-xs) 0;">Kenji T.</div>
                        <div style="font-size:0.8rem; color:var(--color-text-secondary); margin-bottom:var(--spacing-sm);">Nissan GT-R Nismo</div>
                        <span class="status-badge status-badge--pending">Scheduled</span>
                    </div>
                    <!-- Bay 4 -->
                    <div class="glass-panel" style="padding:var(--spacing-md); border-radius:var(--radius-lg); text-align:center; opacity:0.6;">
                        <div style="font-size:0.8rem; font-weight:700; color:var(--color-text-tertiary);">BAY 04 - EXPRESS</div>
                        <div style="font-size:1.25rem; font-weight:600; color:var(--color-text-primary); margin:var(--spacing-xs) 0;">Empty</div>
                        <div style="font-size:0.8rem; color:var(--color-text-secondary); margin-bottom:var(--spacing-sm);">Clean & Clear</div>
                        <span class="status-badge status-badge--completed" style="border-color:var(--color-text-tertiary); color:var(--color-text-tertiary);">Idle</span>
                    </div>
                </div>
            </section>

            <!-- BOOKINGS FILTERS -->
            <section class="glass-panel" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); display: flex; align-items: center; justify-content: space-between; gap: var(--spacing-md); flex-wrap: wrap;">

                <!-- Filter Tabs -->
                <div style="display:flex; gap:var(--spacing-sm);">
                    <a href="#" class="btn btn--primary btn--sm" style="padding: 0.5rem 1.0rem; font-size:0.85rem;">All Bookings</a>
                    <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.5rem 1.0rem; font-size:0.85rem;">Active Queue</a>
                    <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.5rem 1.0rem; font-size:0.85rem;">Upcoming</a>
                    <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.5rem 1.0rem; font-size:0.85rem;">Completed</a>
                </div>

                <!-- Bay Selection -->
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

            <!-- BOOKING TABLE -->
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
                            <!-- Row 1 -->
                            <tr>
                                <td style="font-family:monospace; font-weight:600; color:var(--color-text-primary);">#AWP-4981</td>
                                <td style="font-weight:600; color:var(--color-text-primary);">Kenji Takahashi</td>
                                <td>
                                    <div>Nissan GT-R Nismo</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">品川 300 輪 23-45</div>
                                </td>
                                <td>
                                    <span class="status-badge status-badge--vip" style="font-size:0.7rem;">Signature Graphene</span>
                                </td>
                                <td>
                                    <div>Jun 04, 2026</div>
                                    <div style="font-size:0.75rem; color:var(--color-accent-blue);">10:30 AM</div>
                                </td>
                                <td>Bay 3 (VIP)</td>
                                <td><span class="status-badge status-badge--pending">Confirmed</span></td>
                                <td style="text-align: right;">
                                    <div style="display:inline-flex; gap:var(--spacing-xs);">
                                        <a href="#" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">RFID Check-In</a>
                                        <a href="#" class="btn btn--danger btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Cancel</a>
                                    </div>
                                </td>
                            </tr>
                            <!-- Row 2 -->
                            <tr>
                                <td style="font-family:monospace; font-weight:600; color:var(--color-text-primary);">#AWP-4980</td>
                                <td style="font-weight:600; color:var(--color-text-primary);">Keiko Matsui</td>
                                <td>
                                    <div>Lexus RX 450h</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">練馬 330 ち 45-67</div>
                                </td>
                                <td>
                                    <span class="status-badge status-badge--completed" style="border-color:var(--color-accent-blue); color:var(--color-accent-blue); font-size:0.7rem;">Ceramic Wash</span>
                                </td>
                                <td>
                                    <div>Jun 04, 2026</div>
                                    <div style="font-size:0.75rem; color:var(--color-accent-blue);">11:00 AM</div>
                                </td>
                                <td>Bay 1 (Auto)</td>
                                <td><span class="status-badge status-badge--pending" style="border-color:var(--color-accent-orange); color:var(--color-accent-orange);">Pending</span></td>
                                <td style="text-align: right;">
                                    <div style="display:inline-flex; gap:var(--spacing-xs);">
                                        <a href="#" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem; background-color: var(--color-accent-cyan); border-color: var(--color-accent-cyan);">Approve</a>
                                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Edit</a>
                                    </div>
                                </td>
                            </tr>
                            <!-- Row 3 -->
                            <tr>
                                <td style="font-family:monospace; font-weight:600; color:var(--color-text-primary);">#AWP-4979</td>
                                <td style="font-weight:600; color:var(--color-text-primary);">Satoshi Kojima</td>
                                <td>
                                    <div>Toyota Crown</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">足立 300 な 12-34</div>
                                </td>
                                <td>
                                    <span class="status-badge status-badge--completed" style="border-color:var(--color-text-secondary); color:var(--color-text-secondary); font-size:0.7rem;">Interior Detailing</span>
                                </td>
                                <td>
                                    <div>Today</div>
                                    <div style="font-size:0.75rem; color:var(--color-accent-cyan);">Active (09:15 AM)</div>
                                </td>
                                <td>Bay 2 (Detail)</td>
                                <td><span class="status-badge status-badge--completed" style="border-color:var(--color-accent-cyan); color:var(--color-accent-cyan);">In Progress</span></td>
                                <td style="text-align: right;">
                                    <div style="display:inline-flex; gap:var(--spacing-xs);">
                                        <a href="#" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem; background-color:var(--color-accent-cyan); border-color:var(--color-accent-cyan)">Complete</a>
                                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Detail Log</a>
                                    </div>
                                </td>
                            </tr>
                            <!-- Row 4 -->
                            <tr>
                                <td style="font-family:monospace; font-weight:600; color:var(--color-text-primary);">#AWP-4978</td>
                                <td style="font-weight:600; color:var(--color-text-primary);">Yukiko Hino</td>
                                <td>
                                    <div>Mazda CX-60</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">多摩 300 ぬ 56-78</div>
                                </td>
                                <td>
                                    <span class="status-badge status-badge--completed" style="border-color:var(--color-text-secondary); color:var(--color-text-secondary); font-size:0.7rem;">Express Wash</span>
                                </td>
                                <td>
                                    <div>Today</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">08:30 AM</div>
                                </td>
                                <td>Bay 4 (Express)</td>
                                <td><span class="status-badge status-badge--completed">Completed</span></td>
                                <td style="text-align: right;">
                                    <div style="display:inline-flex; gap:var(--spacing-xs);">
                                        <span style="font-size:0.85rem; color:var(--color-text-tertiary); padding-right:var(--spacing-md);">Gate Log Sync</span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div style="display:flex; justify-content:space-between; align-items:center; padding:var(--spacing-md) var(--spacing-lg); background-color:rgba(255,255,255,0.01); border-top:1px solid var(--color-border); font-size:0.85rem;">
                    <span style="color:var(--color-text-tertiary);">Showing 1 to 4 of 4 active shifts</span>
                    <div style="display:flex; gap:var(--spacing-xs);">
                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; pointer-events:none; opacity:0.5;">Previous</a>
                        <a href="#" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem;">1</a>
                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; pointer-events:none; opacity:0.5;">Next</a>
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

