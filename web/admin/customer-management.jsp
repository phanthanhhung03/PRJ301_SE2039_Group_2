<%-- 
    Document   : customer-management
    Created on : May 30, 2026, 2:24:52 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Management | AutoWashPro Staff</title>
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
                    <a href="MainController?action=viewAdminDashboard" class="site-header__nav-link">Dashboard</a>
                    <a href="#" class="site-header__nav-link site-header__nav-link--active">Customers</a>
                    <a href="booking-management.html" class="site-header__nav-link">Bookings</a>
                    <a href="MainController?action=viewLoyaltyManagement" class="site-header__nav-link">Loyalty</a>
                    <a href="MainController?action=viewPromotionManagement" class="site-header__nav-link"> Promotions</a>
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
                    <span style="font-size:0.75rem; font-weight:700; color:var(--color-accent-cyan); text-transform:uppercase; letter-spacing:0.1em;">Customer Registry</span>
                    <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Manage Members</h1>
                </div>
                <a href="#" class="btn btn--primary btn--sm">+ Add New Customer</a>
            </div>

            <!-- SEARCH & FILTER TOOLBAR -->
            <section class="glass-panel" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); display: flex; align-items: center; justify-content: space-between; gap: var(--spacing-md); flex-wrap: wrap;">

                <!-- Search Form -->
                <form action="#" method="GET" style="display:flex; gap:var(--spacing-sm); flex-grow:1; max-width: 500px;" onsubmit="return false;">
                    <input type="text" class="form-group__input" placeholder="Search by name, email, phone or plate..." style="padding: 0.6rem 1.0rem; font-size: 0.85rem;">
                    <button class="btn btn--primary btn--sm" style="padding:0.6rem 1.2rem;">Search</button>
                </form>

                <!-- Filters Selects -->
                <div style="display:flex; gap:var(--spacing-md); align-items:center;">
                    <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                        <span style="font-size:0.8rem; font-weight:600; text-transform:uppercase; color:var(--color-text-tertiary);">Tier:</span>
                        <select class="form-group__input" style="padding: 0.5rem 2.0rem 0.5rem 1.0rem; font-size:0.85rem; width: auto; background-color: var(--color-surface-hover); cursor: pointer;">
                            <option value="all">All Tiers</option>
                            <option value="vip">VIP Shogun</option>
                            <option value="signature">Signature</option>
                            <option value="elite">Elite Club</option>
                            <option value="none">Standard / Guest</option>
                        </select>
                    </div>

                    <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                        <span style="font-size:0.8rem; font-weight:600; text-transform:uppercase; color:var(--color-text-tertiary);">Status:</span>
                        <select class="form-group__input" style="padding: 0.5rem 2.0rem 0.5rem 1.0rem; font-size:0.85rem; width: auto; background-color: var(--color-surface-hover); cursor: pointer;">
                            <option value="all">All Statuses</option>
                            <option value="active">Active Members</option>
                            <option value="suspended">Suspended</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>
                </div>
            </section>

            <!-- CUSTOMERS DATA TABLE -->
            <section class="glass-panel" style="border-radius: var(--radius-xl); overflow: hidden;">
                <div class="data-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Customer</th>
                                <th>Contact Details</th>
                                <th>Membership Tier</th>
                                <th>Loyalty Points</th>
                                <th>Fleet size</th>
                                <th>Registered Address</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Row 1 -->
                            <tr>
                                <td style="font-weight:600; color:var(--color-text-primary);">
                                    <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                                        <div class="testimonial-card__avatar testimonial-card__avatar--vip" style="width:32px; height:32px; font-size:0.75rem;">KT</div>
                                        Kenji Takahashi
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size:0.85rem;">kenji@takahashi.co.jp</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">+81 90-1234-5678</div>
                                </td>
                                <td><span class="status-badge status-badge--vip">VIP Shogun</span></td>
                                <td style="font-weight:600; color:var(--color-text-primary);">4,850 pts</td>
                                <td>3 vehicles</td>
                                <td style="font-size:0.85rem;">3-5-1 Ginza, Chuo-ku, Tokyo</td>
                                <td style="text-align: right;">
                                    <div style="display:inline-flex; gap:var(--spacing-xs);">
                                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Edit</a>
                                        <a href="booking-management.html" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Bookings</a>
                                    </div>
                                </td>
                            </tr>
                            <!-- Row 2 -->
                            <tr>
                                <td style="font-weight:600; color:var(--color-text-primary);">
                                    <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                                        <div class="testimonial-card__avatar testimonial-card__avatar--vip" style="width:32px; height:32px; font-size:0.75rem;">NS</div>
                                        Nobuhiro Sato
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size:0.85rem;">sato@corporate.jp</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">+81 80-9876-5432</div>
                                </td>
                                <td><span class="status-badge status-badge--vip">VIP Shogun</span></td>
                                <td style="font-weight:600; color:var(--color-text-primary);">5,120 pts</td>
                                <td>2 vehicles</td>
                                <td style="font-size:0.85rem;">1-1 Roppongi, Minato-ku, Tokyo</td>
                                <td style="text-align: right;">
                                    <div style="display:inline-flex; gap:var(--spacing-xs);">
                                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Edit</a>
                                        <a href="booking-management.html" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Bookings</a>
                                    </div>
                                </td>
                            </tr>
                            <!-- Row 3 -->
                            <tr>
                                <td style="font-weight:600; color:var(--color-text-primary);">
                                    <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                                        <div class="testimonial-card__avatar" style="width:32px; height:32px; font-size:0.75rem; background:linear-gradient(135deg, var(--color-accent-blue), var(--color-accent-cyan));">AT</div>
                                        Akira Tanaka
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size:0.85rem;">tanaka@gmail.com</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">+81 90-8888-9999</div>
                                </td>
                                <td><span class="status-badge status-badge--completed" style="border-color:var(--color-accent-blue); color:var(--color-accent-blue);">Signature</span></td>
                                <td style="font-weight:600; color:var(--color-text-primary);">2,910 pts</td>
                                <td>1 vehicle</td>
                                <td style="font-size:0.85rem;">5-12 Shibuya, Chuo-ku, Tokyo</td>
                                <td style="text-align: right;">
                                    <div style="display:inline-flex; gap:var(--spacing-xs);">
                                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Edit</a>
                                        <a href="booking-management.html" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Bookings</a>
                                    </div>
                                </td>
                            </tr>
                            <!-- Row 4 -->
                            <tr>
                                <td style="font-weight:600; color:var(--color-text-primary);">
                                    <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                                        <div class="testimonial-card__avatar" style="width:32px; height:32px; font-size:0.75rem; background:linear-gradient(135deg, var(--color-accent-blue), var(--color-accent-cyan));">MW</div>
                                        Miyu Watanabe
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size:0.85rem;">watanabe.m@yahoo.co.jp</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">+81 70-4444-2222</div>
                                </td>
                                <td><span class="status-badge status-badge--completed" style="border-color:var(--color-accent-blue); color:var(--color-accent-blue);">Signature</span></td>
                                <td style="font-weight:600; color:var(--color-text-primary);">1,850 pts</td>
                                <td>2 vehicles</td>
                                <td style="font-size:0.85rem;">2-8 Shinjuku, Tokyo</td>
                                <td style="text-align: right;">
                                    <div style="display:inline-flex; gap:var(--spacing-xs);">
                                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Edit</a>
                                        <a href="booking-management.html" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Bookings</a>
                                    </div>
                                </td>
                            </tr>
                            <!-- Row 5 -->
                            <tr>
                                <td style="font-weight:600; color:var(--color-text-primary);">
                                    <div style="display:flex; align-items:center; gap:var(--spacing-sm);">
                                        <div class="testimonial-card__avatar" style="width:32px; height:32px; font-size:0.75rem; background:rgba(255,255,255,0.05); color:var(--color-text-secondary); border:1px solid var(--color-border)">YI</div>
                                        Yoshio Ito
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size:0.85rem;">ito.y@gmail.com</div>
                                    <div style="font-size:0.75rem; color:var(--color-text-tertiary);">+81 90-3333-1111</div>
                                </td>
                                <td><span class="status-badge status-badge--completed" style="border-color:var(--color-text-secondary); color:var(--color-text-secondary);">Elite Club</span></td>
                                <td style="font-weight:600; color:var(--color-text-primary);">820 pts</td>
                                <td>1 vehicle</td>
                                <td style="font-size:0.85rem;">1-4 Ueno, Taito-ku, Tokyo</td>
                                <td style="text-align: right;">
                                    <div style="display:inline-flex; gap:var(--spacing-xs);">
                                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Edit</a>
                                        <a href="booking-management.html" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem; font-size:0.8rem;">Bookings</a>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Table Pagination (Pure HTML/CSS layout) -->
                <div style="display:flex; justify-content:space-between; align-items:center; padding:var(--spacing-md) var(--spacing-lg); background-color:rgba(255,255,255,0.01); border-top:1px solid var(--color-border); font-size:0.85rem;">
                    <span style="color:var(--color-text-tertiary);">Showing 1 to 5 of 1482 customers</span>
                    <div style="display:flex; gap:var(--spacing-xs);">
                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem; pointer-events:none; opacity:0.5;">Previous</a>
                        <a href="#" class="btn btn--primary btn--sm" style="padding: 0.35rem 0.65rem;">1</a>
                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem;">2</a>
                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem;">3</a>
                        <a href="#" class="btn btn--secondary btn--sm" style="padding: 0.35rem 0.65rem;">Next</a>
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

