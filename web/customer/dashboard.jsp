<%-- 
    Document   : dashboard
    Created on : May 30, 2026, 2:25:12 PM
    Author     : Asus
--%>

<%@page import="dto.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Customer user = (Customer) session.getAttribute("USER");
    if (user == null) {
        response.sendRedirect("customer/landing-page.jsp");
    }

    // Next Reward
    String nextTierName = "";
    int remainingBookings = 0;
    double remainingSpend = 0;

    String tierName = user.getTierId().getTierName();

    int currentBookings = user.getTotalBooking();
    double currentSpend = user.getTotalSpend();

    switch (tierName) {

        case "Member":

            nextTierName = "Silver";

            remainingBookings = 5 - currentBookings;

            remainingSpend = 2000000 - currentSpend;

            break;

        case "Silver":

            nextTierName = "Gold";

            remainingBookings = 15 - currentBookings;

            remainingSpend = 6000000 - currentSpend;

            break;

        case "Gold":

            nextTierName = "Platinum";

            remainingBookings = 30 - currentBookings;

            remainingSpend = 15000000 - currentSpend;

            break;

        case "Platinum":

            nextTierName = "MAX";

            remainingBookings = 0;
            remainingSpend = 0;

            break;
    }

// Tranh negative number
    if (remainingBookings < 0) {
        remainingBookings = 0;
    }

    if (remainingSpend < 0) {
        remainingSpend = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Dashboard | AutoWashPro</title>
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <!-- NAVIGATION -->
        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="#" class="site-header__logo">
                    <div class="site-header__logo-icon"></div>
                    <div class="site-header__logo-text">AUTOWASH<span>PRO</span></div>
                </a>
                <nav class="site-header__navigation">
                    <a href="#dashboard" class="site-header__nav-link">Dashboard</a>
                    <a href="#vehicles" class="site-header__nav-link">Vehicles</a>
                    <a href="#bookings" class="site-header__nav-link">Bookings</a>
                    <a href="#profile" class="site-header__nav-link">Profile</a>
                </nav>
                <div class="site-header__actions">
                    <div class="status-badge status-badge--vip">VIP Member</div>
                    <a href="index.html" class="btn btn--secondary btn--sm">Logout</a>
                </div>
            </div>
        </header>

        <!-- UNIFIED DASHBOARD GRID -->
        <main class="main-wrapper">

            <!-- SECTION 1: DASHBOARD OVERVIEW & HERO -->
            <section class="dashboard-section" id="dashboard">
                <div class="dashboard-section__header">
                    <h2 class="dashboard-section__title">Overview</h2>
                    <span class="status-badge status-badge--completed">Account Active</span>
                </div>

                <div class="grid-cols-2">
                    <!-- MEMBERSHIP HERO CARD (VIP Gold) -->
                    <div class="membership-card membership-card--vip glass-panel">
                        <div class="membership-card__header">
                            <span class="membership-card__brand">AUTOWASH<span>PRO</span> CLUB</span>
                            <span class="membership-card__vip-badge">
                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24" style="margin-right:4px;"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path></svg>
                                VIP Shogun
                            </span>
                        </div>

                        <div class="membership-card__holder">
                            <span class="membership-card__holder-label">Cardholder Identity</span>
                            <h3 class="membership-card__holder-name">Kenji Takahashi</h3>
                            <span class="membership-card__tier">Rank: Ultimate Tier VIP</span>
                        </div>

                        <div class="membership-card__body">
                            <div class="membership-card__points">
                                <span class="membership-card__points-val">4,850</span>
                                <span class="membership-card__points-label">Loyalty Points</span>
                            </div>
                            <div class="membership-card__progress-bar">
                                <div class="membership-card__progress-fill" style="width: 85%;"></div>
                            </div>
                            <div class="membership-card__goal-progress">
                                <span>Goal: 5,000 pts (Shogun Lord)</span>
                                <span>150 pts remaining</span>
                            </div>
                        </div>

                        <div class="membership-card__footer">
                            <div class="membership-card__stat-item">
                                <span class="membership-card__stat-label">Remaining Washes</span>
                                <span class="membership-card__stat-val">12 Washes / Month</span>
                            </div>
                            <div class="membership-card__stat-item">
                                <span class="membership-card__stat-label">Remaining Spend</span>
                                <span class="membership-card__stat-val">$140.00 Limit</span>
                            </div>
                        </div>
                    </div>

                    <!-- QUICK STATS -->
                    <div style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                        <!-- Stat 1: Vehicles -->
                        <div class="stat-card glass-panel">
                            <div class="stat-card__header">
                                <span class="stat-card__label">Total Registered Vehicles</span>
                                <div class="stat-card__icon">
                                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 001 13v3c0 .6.4 1 1 1h2m10 0a3 3 0 11-6 0m6 0a3 3 0 11-6 0m0 0H5"></path></svg>
                                </div>
                            </div>
                            <div class="stat-card__body">
                                <span class="stat-card__value">3</span>
                                <span class="stat-card__change stat-card__change--up">+1 this month</span>
                            </div>
                        </div>

                        <!-- Stat 2: Bookings -->
                        <div class="stat-card glass-panel">
                            <div class="stat-card__header">
                                <span class="stat-card__label">Total Service Bookings</span>
                                <div class="stat-card__icon">
                                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                                </div>
                            </div>
                            <div class="stat-card__body">
                                <span class="stat-card__value">24 Bookings</span>
                                <span class="stat-card__change stat-card__change--up">1 Upcoming</span>
                            </div>
                        </div>

                        <!-- Stat 3: Total Spend -->
                        <div class="stat-card glass-panel">
                            <div class="stat-card__header">
                                <span class="stat-card__label">Total Detailing Spend</span>
                                <div class="stat-card__icon">
                                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="2" y="5" width="20" height="14" rx="2" ry="2"></rect><line x1="2" y1="10" x2="22" y2="10"></line></svg>
                                </div>
                            </div>
                            <div class="stat-card__body">
                                <span class="stat-card__value">$1,180.00</span>
                                <span class="stat-card__change stat-card__change--up">Lifetime loyalty</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- SECTION 2: VEHICLES OVERVIEW -->
            <section class="dashboard-section" id="vehicles">
                <div class="dashboard-section__header">
                    <h2 class="dashboard-section__title">Vehicles</h2>
                    <a href="#" class="btn btn--secondary btn--sm">Manage Fleet</a>
                </div>

                <div class="grid-cols-3">
                    <!-- Vehicle 1 -->
                    <div class="vehicle-card glass-panel">
                        <div class="vehicle-card__header">
                            <div>
                                <span class="vehicle-card__type">Primary Coupe</span>
                                <h3 class="vehicle-card__name">Nissan GT-R Nismo</h3>
                            </div>
                            <span class="status-badge status-badge--completed">Active</span>
                        </div>
                        <span class="vehicle-card__plate">品川 300 輪 23-45</span>
                        <div class="vehicle-card__actions">
                            <a href="#" class="btn btn--secondary btn--sm">Detail Log</a>
                            <a href="#" class="btn btn--primary btn--sm">Book Wash</a>
                        </div>
                    </div>
                    <!-- Vehicle 2 -->
                    <div class="vehicle-card glass-panel">
                        <div class="vehicle-card__header">
                            <div>
                                <span class="vehicle-card__type">Executive Sedan</span>
                                <h3 class="vehicle-card__name">Lexus LS 500h</h3>
                            </div>
                            <span class="status-badge status-badge--completed">Active</span>
                        </div>
                        <span class="vehicle-card__plate">足立 330 す 78-90</span>
                        <div class="vehicle-card__actions">
                            <a href="#" class="btn btn--secondary btn--sm">Detail Log</a>
                            <a href="#" class="btn btn--primary btn--sm">Book Wash</a>
                        </div>
                    </div>
                    <!-- Add New Vehicle Card -->
                    <div class="vehicle-card vehicle-card--add-new glass-panel">
                        <div class="vehicle-card__add-icon">+</div>
                        <span style="font-weight:600; color:var(--color-text-primary);">Add New Vehicle</span>
                        <span style="font-size:0.8rem; color:var(--color-text-tertiary);">Register vehicle plate & model</span>
                    </div>
                </div>
            </section>

            <!-- SECTION 3: BOOKINGS MANAGEMENT -->
            <section class="dashboard-section" id="bookings">
                <div class="dashboard-section__header">
                    <h2 class="dashboard-section__title">Bookings</h2>
                    <a href="#" class="btn btn--primary btn--sm">Schedule Detailing</a>
                </div>

                <div class="grid-cols-2">
                    <!-- Upcoming Booking -->
                    <div>
                        <h3 style="font-size:1.15rem; margin-bottom:var(--spacing-md); color:var(--color-text-primary);">Upcoming Schedule</h3>
                        <div class="booking-card glass-panel">
                            <div class="booking-card__datetime">
                                <span class="booking-card__month">Jun</span>
                                <span class="booking-card__day">04</span>
                                <span class="booking-card__time">10:30 AM</span>
                            </div>
                            <div class="booking-card__details">
                                <span class="booking-card__service">Signature Graphene Coating</span>
                                <span class="booking-card__vehicle">Nissan GT-R Nismo</span>
                                <span style="font-size:0.8rem; color:var(--color-text-tertiary);">Wash Bay 3 | Operator: Saito Y.</span>
                            </div>
                            <div class="booking-card__meta">
                                <span class="status-badge status-badge--pending">Confirmed</span>
                                <a href="#" class="btn btn--danger btn--sm">Reschedule</a>
                            </div>
                        </div>
                    </div>

                    <!-- Booking Summary list -->
                    <div>
                        <h3 style="font-size:1.15rem; margin-bottom:var(--spacing-md); color:var(--color-text-primary);">Wash History</h3>

                        <div class="booking-card glass-panel">
                            <div class="booking-card__datetime">
                                <span class="booking-card__month">May</span>
                                <span class="booking-card__day">18</span>
                                <span class="booking-card__time">02:00 PM</span>
                            </div>
                            <div class="booking-card__details">
                                <span class="booking-card__service">Express Clean Wash</span>
                                <span class="booking-card__vehicle">Lexus LS 500h</span>
                            </div>
                            <div class="booking-card__meta">
                                <span class="status-badge status-badge--completed">Completed</span>
                            </div>
                        </div>

                        <div class="booking-card glass-panel">
                            <div class="booking-card__datetime">
                                <span class="booking-card__month">Apr</span>
                                <span class="booking-card__day">30</span>
                                <span class="booking-card__time">09:00 AM</span>
                            </div>
                            <div class="booking-card__details">
                                <span class="booking-card__service">Interior Steam Detailing</span>
                                <span class="booking-card__vehicle">Nissan GT-R Nismo</span>
                            </div>
                            <div class="booking-card__meta">
                                <span class="status-badge status-badge--completed">Completed</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- SECTION 4: RECENT ACTIVITY TIMELINE -->
            <section class="dashboard-section">
                <div class="dashboard-section__header">
                    <h2 class="dashboard-section__title">Recent Activity</h2>
                </div>

                <div class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl);">
                    <div class="activity-timeline">
                        <!-- Timeline Item 1 -->
                        <div class="activity-timeline__item">
                            <div class="activity-timeline__dot activity-timeline__dot--booking"></div>
                            <div class="activity-timeline__content">
                                <span class="activity-timeline__time">May 28, 2026 - 14:32</span>
                                <span class="activity-timeline__title">Scheduled Signature Graphene Wash</span>
                                <span class="activity-timeline__desc">Booked detailing appointment for Nissan GT-R Nismo on June 04.</span>
                            </div>
                        </div>
                        <!-- Timeline Item 2 -->
                        <div class="activity-timeline__item">
                            <div class="activity-timeline__dot activity-timeline__dot--loyalty"></div>
                            <div class="activity-timeline__content">
                                <span class="activity-timeline__time">May 18, 2026 - 15:10</span>
                                <span class="activity-timeline__title">Earned +150 Loyalty Points</span>
                                <span class="activity-timeline__desc">Express Clean Wash completed on Lexus LS 500h. Points updated to 4,850.</span>
                            </div>
                        </div>
                        <!-- Timeline Item 3 -->
                        <div class="activity-timeline__item">
                            <div class="activity-timeline__dot activity-timeline__dot--loyalty"></div>
                            <div class="activity-timeline__content">
                                <span class="activity-timeline__time">May 01, 2026 - 00:00</span>
                                <span class="activity-timeline__title">Membership Renewed</span>
                                <span class="activity-timeline__desc">Monthly VIP Shogun membership renewed. 12 wash credits added for May.</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- SECTION 5: PROFILE & SETTINGS -->
            <section class="dashboard-section" id="profile">
                <div class="dashboard-section__header">
                    <h2 class="dashboard-section__title">Profile & Settings</h2>
                </div>

                <div class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl);">
                    <div class="grid-cols-2">
                        <!-- Account Information Form -->
                        <div>
                            <h3 style="font-size:1.15rem; margin-bottom:var(--spacing-md); color:var(--color-text-primary);">Account Information</h3>
                            <form action="#" method="POST" onsubmit="return false;">
                                <div class="form-group">
                                    <label class="form-group__label">Full Name</label>
                                    <input type="text" class="form-group__input" value="Kenji Takahashi">
                                </div>
                                <div class="form-group">
                                    <label class="form-group__label">Phone Number</label>
                                    <input type="tel" class="form-group__input" value="+81 90-1234-5678">
                                </div>
                                <div class="form-group">
                                    <label class="form-group__label">Email Address</label>
                                    <input type="email" class="form-group__input" value="kenji@takahashi.co.jp" disabled>
                                    <span style="font-size:0.75rem; color:var(--color-text-tertiary);">Contact support to modify email credentials.</span>
                                </div>
                                <div class="form-group">
                                    <label class="form-group__label">Billing Address</label>
                                    <input type="text" class="form-group__input" value="3-5-1 Ginza, Chuo-ku, Tokyo">
                                </div>
                                <button class="btn btn--primary">Update Profile</button>
                            </form>
                        </div>

                        <!-- Preferences Placeholder & Security Settings -->
                        <div style="border-left: 1px solid var(--color-border); padding-left: var(--spacing-xl);">
                            <h3 style="font-size:1.15rem; margin-bottom:var(--spacing-md); color:var(--color-text-primary);">Preferences & Safety</h3>

                            <div class="form-group">
                                <label class="form-group__label" style="margin-bottom: var(--spacing-md);">Alert Settings</label>
                                <label class="form-group__checkbox" style="margin-bottom: var(--spacing-sm);">
                                    <input type="checkbox" class="form-group__checkbox-input" checked>
                                    <span class="form-group__checkbox-label">Receive booking confirmations via SMS</span>
                                </label>
                                <label class="form-group__checkbox" style="margin-bottom: var(--spacing-sm);">
                                    <input type="checkbox" class="form-group__checkbox-input" checked>
                                    <span class="form-group__checkbox-label">Receive loyalty tier upgrade alerts</span>
                                </label>
                                <label class="form-group__checkbox">
                                    <input type="checkbox" class="form-group__checkbox-input">
                                    <span class="form-group__checkbox-label">Subscribe to seasonal detailing promotions</span>
                                </label>
                            </div>

                            <div style="margin-top: var(--spacing-xl); padding-top: var(--spacing-lg); border-top:1px solid var(--color-border);">
                                <h4 style="font-size:1.0rem; color:var(--color-text-primary); margin-bottom:var(--spacing-md);">Security Credentials</h4>
                                <form action="#" method="POST" onsubmit="return false;">
                                    <div class="form-group">
                                        <label class="form-group__label">Current Password</label>
                                        <input type="password" class="form-group__input" placeholder="••••••••">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-group__label">New Password</label>
                                        <input type="password" class="form-group__input" placeholder="••••••••">
                                    </div>
                                    <button class="btn btn--secondary">Modify Password</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

        </main>

        <!-- FOOTER -->
        <footer class="site-footer" style="margin-top: var(--spacing-xxl);">
            <div class="site-footer__container main-wrapper">
                <div class="site-footer__bottom">
                    <p>&copy; 2026 AutoWashPro Inc. All rights reserved.</p>
                    <a href="index.html" class="site-footer__staff-link">Return to Landing Page</a>
                </div>
            </div>
        </footer>

    </body>
</html>

