<%-- 
    Document   : dashboard
    Created on : May 30, 2026, 2:25:12 PM
    Author     : Asus
--%>

<%@page import="dto.Booking"%>
<%@page import="dao.BookingDAO"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Vehicle"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    Customer user = (Customer) session.getAttribute("USER");
    List<Vehicle> vehiclesList = (List<Vehicle>) session.getAttribute("vehicleList");
    boolean isMaxTier
            = (Boolean) request.getAttribute("isMaxTier");

    String successMessage
            = (String) session.getAttribute(
                    "SUCCESS_MESSAGE");

    request.setAttribute(
            "SUCCESS_MESSAGE",
            successMessage);

    session.removeAttribute(
            "SUCCESS_MESSAGE");
    if (user != null) {
        BookingDAO bookingDao = new BookingDAO();

        // Gọi hàm từ DAO (Lưu ý: đổi user.getCusId() thành hàm lấy ID thật của bạn nếu tên khác nhé)
        List<Booking> upcoming = bookingDao.getUpcomingBookings(user.getCusId());
        List<Booking> past = bookingDao.getPastBookings(user.getCusId());

        // Đẩy thẳng vào request để các thẻ JSTL phía dưới tự động bắt được data
        request.setAttribute("UPCOMING_BOOKINGS", upcoming);
        request.setAttribute("PAST_BOOKINGS", past);
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

        <% if (request.getAttribute("SUCCESS_MESSAGE") != null) {%>

        <div id="success-toast"
             class="toast toast--success">

            <span class="toast__icon">✓</span>

            <span class="toast__message">
                <%= request.getAttribute("SUCCESS_MESSAGE")%>
            </span>

        </div>

        <% }%>


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
                    <div class="status-badge status-badge--vip"><%= user.getTierId().getTierName()%> Tier</div>
                    <a href="MainController?action=logout" class="btn btn--secondary btn--sm">Logout</a>
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
                            <span class="membership-card__brand">AUTOWASH<span>PRO</span></span>
                            <span class="membership-card__vip-badge">
                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24" style="margin-right:4px;"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path></svg>
                                <%= user.getTierId().getTierName()%>
                            </span>
                        </div>

                        <div class="membership-card__holder">
                            <span class="membership-card__holder-label">Current Status</span>
                            <h3 class="membership-card__holder-name"><%= user.getFullName()%></h3>
                            <span class="membership-card__tier">Tier: <%= user.getTierId().getTierName()%></span>
                        </div>

                        <div class="membership-card__body">
                            <div class="membership-card__points">
                                <span class="membership-card__points-val">${formattedCurrentPoints}</span>
                                <span class="membership-card__points-label">Loyalty Points</span>
                            </div>
                            <div class="membership-card__progress-bar">
                                <div class="membership-card__progress-fill"  style="width:${progressPercent}%;"></div>
                            </div>
                            <div class="membership-card__goal-progress">
                                <span>${tierMessage}</span>
                                <span>${progressMessage}</span>
                            </div>

                        </div>

                        <span>
                            <%= isMaxTier
                                    ? "You have achieved Platinum status, the highest loyalty tier at AutoWash Pro. Enjoy your premium perks and priority lane accesses!"
                                    : "Complete either requirement below"%>
                        </span>

                        <% if (!isMaxTier) {%>
                        <div class="membership-card__footer">
                            <div class="membership-card__stat-item">
                                <span class="membership-card__stat-label">Washes needed</span>
                                <span class="membership-card__stat-val">${remainingWashes} Washes</span>
                            </div>
                            <div class="membership-card__stat-item">
                                <span class="membership-card__stat-label">Spend needed</span>
                                <span class="membership-card__stat-val">${formattedRemainingSpend} VND</span>
                            </div>
                        </div>
                        <% }%>

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
                                <span class="stat-card__value">${totalVehicles}</span>
                                <span class="stat-card__change stat-card__change--up"></span> <!<!-- View thang nay add them bao nhieu xe (Comming Soon) -->
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
                                <span class="stat-card__value"><%= user.getTotalBooking()%></span>
                                <span class="stat-card__change stat-card__change--up"></span> <!<!-- View booking trong tuong lai (Comming Soon) -->
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
                                <span class="stat-card__value"><%= String.format("%,.0f", user.getTotalSpend())%> VND</span>
                                <span class="stat-card__change stat-card__change--up"></span>
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

                    <c:if test="${empty vehicleList}">
                        <div class="vehicle-empty glass-panel">

                            <div class="vehicle-empty__icon">
                                🚗
                            </div>

                            <h3 class="vehicle-empty__title">
                                No Vehicles Registered
                            </h3>

                            <p class="vehicle-empty__description">
                                Add your first vehicle to start booking premium wash services.
                            </p>

                        </div>
                    </c:if>

                    <c:forEach var="vehicle" items="${vehicleList}">
                        <div class="vehicle-card glass-panel">
                            <div class="vehicle-card__header">
                                <div>
                                    <span class="vehicle-card__type">
                                        ${vehicle.brand}
                                    </span>
                                    <h3 class="vehicle-card__name">
                                        ${vehicle.model}
                                    </h3>
                                    <span class="vehicle-card__color">
                                        ${vehicle.color}
                                    </span>
                                </div>
                                <div class="vehicle-card__header-actions">
                                    <span class="status-badge status-badge--completed" style="margin-right: var(--spacing-sm);">Active</span>
                                    <a href="${pageContext.request.contextPath}/MainController?action=viewUpdateVehicle&vehicleID=${vehicle.vehicleID}"
                                       class="vehicle-card__action-icon vehicle-card__action-icon--edit"
                                       title="Edit Vehicle">
                                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                                    </a>
                                    <button type="button"
                                            class="vehicle-card__action-icon vehicle-card__action-icon--delete"
                                            title="Remove Vehicle"
                                            onclick="openRemoveModal(
                                            ${vehicle.vehicleID},
                                                            '${vehicle.brand} ${vehicle.model} (${vehicle.licensePlate})'
                                                            )">

                                        <svg width="14"
                                             height="14"
                                             fill="currentColor"
                                             viewBox="0 0 24 24">

                                        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>

                                        </svg>

                                    </button>
                                </div>
                            </div>
                            <span class="vehicle-card__plate">${vehicle.licensePlate}</span>
                            <div class="vehicle-card__actions">
                                <a href="#" class="btn btn--secondary btn--sm">Detail Log</a>
                                <a href="#" class="btn btn--primary btn--sm">Book Wash</a>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Add New Vehicle Card -->
                    <a href="${pageContext.request.contextPath}/MainController?action=viewAddVehicle"
                       class="vehicle-card vehicle-card--add-new glass-panel">

                        <span class="vehicle-card__add-icon">+</span>

                        <span class="vehicle-card__add-title">
                            Add New Vehicle
                        </span>

                        <span class="vehicle-card__add-description">
                            Register vehicle plate & model
                        </span>

                    </a>
                </div>
            </section>

            <!-- SECTION 3: BOOKINGS MANAGEMENT -->
            <section class="dashboard-section" id="bookings">
                <div class="dashboard-section__header">
                    <h2 class="dashboard-section__title">Bookings</h2>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewNewBooking" class="btn btn--primary btn--sm">BOOKING HERE</a>
                </div>

                <div class="grid-cols-2">
                    <div>
                        <h3 style="font-size:1.15rem; margin-bottom:var(--spacing-md); color:var(--color-text-primary);">Upcoming Schedule</h3>

                        <c:choose>
                            <c:when test="${empty UPCOMING_BOOKINGS}">
                                <div class="empty-state-panel glass-panel" style="padding: 2rem; text-align: center; border: 1px dashed var(--color-border);">
                                    <span style="color: var(--color-text-tertiary);">You have no upcoming appointments.</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${UPCOMING_BOOKINGS}" var="booking">
                                    <div class="booking-card glass-panel">
                                        <div class="booking-card__datetime">
                                            <span class="booking-card__month"><fmt:formatDate value="${booking.bookingDate}" pattern="MMM"/></span>
                                            <span class="booking-card__day"><fmt:formatDate value="${booking.bookingDate}" pattern="dd"/></span>
                                            <span class="booking-card__time"><fmt:formatDate value="${booking.bookingDate}" pattern="hh:mm a"/></span>
                                        </div>
                                        <div class="booking-card__details">
                                            <span class="booking-card__service">${booking.serviceType}</span>
                                            <span class="booking-card__vehicle">${booking.vehicleName}</span>
                                            <span style="font-size:0.8rem; color:var(--color-text-tertiary);">Notes: ${empty booking.notes ? 'None' : booking.notes}</span>
                                        </div>
                                        <div class="booking-card__meta">
                                            <span class="status-badge status-badge--pending">${booking.bookingStatus}</span>

                                            <c:if test="${booking.bookingStatus == 'Pending'}">
                                                <form action="${pageContext.request.contextPath}/BookingController" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="cancelBooking">
                                                    <input type="hidden" name="bookingID" value="${booking.bookingID}">

                                                    <button type="submit" class="btn btn--danger btn--sm" 
                                                            style="background: transparent; border: 1px solid #ef4444; color: #ef4444; cursor: pointer;"
                                                            onclick="return confirm('Are you sure you want to cancel this booking?');">
                                                        Cancel
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div>
                        <h3 style="font-size:1.15rem; margin-bottom:var(--spacing-md); color:var(--color-text-primary);">Wash History</h3>

                        <c:choose>
                            <c:when test="${empty PAST_BOOKINGS}">
                                <div class="empty-state-panel glass-panel" style="padding: 2rem; text-align: center; border: 1px dashed var(--color-border);">
                                    <span style="color: var(--color-text-tertiary);">No wash history available.</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${PAST_BOOKINGS}" var="history">
                                    <div class="booking-card glass-panel">
                                        <div class="booking-card__datetime">
                                            <span class="booking-card__month"><fmt:formatDate value="${history.bookingDate}" pattern="MMM"/></span>
                                            <span class="booking-card__day"><fmt:formatDate value="${history.bookingDate}" pattern="dd"/></span>
                                            <span class="booking-card__time"><fmt:formatDate value="${history.bookingDate}" pattern="hh:mm a"/></span>
                                        </div>
                                        <div class="booking-card__details">
                                            <span class="booking-card__service">${history.serviceType}</span>
                                            <span class="booking-card__vehicle">${history.vehicleName}</span>
                                        </div>
                                        <div class="booking-card__meta">
                                            <span class="status-badge ${history.bookingStatus == 'Cancelled' ? 'status-badge--cancelled' : 'status-badge--completed'}">
                                                ${history.bookingStatus}
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
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
                            <form action="MainController" method="POST">
                                <div class="form-group">
                                    <label class="form-group__label">Full Name</label>
                                    <input type="text"
                                           class="form-group__input"
                                           value="${USER.fullName}"
                                           name="newName"
                                           placeholder="Enter your full name"
                                           required
                                           pattern="^[A-Za-z\u00C0-\u024F\s]{2,100}$">
                                </div>
                                <div class="form-group">
                                    <label class="form-group__label">Phone Number</label>
                                    <input type="tel"
                                           class="form-group__input"
                                           value="${USER.phoneNumber}"
                                           name="newPhoneNumber"
                                           placeholder="Enter your phone number"
                                           pattern="^(0[35789])\d{8}$"
                                           required>
                                </div>
                                <div class="form-group">
                                    <label class="form-group__label">Email Address</label>
                                    <input type="email" class="form-group__input" value="${USER.email}" disabled>
                                    <span style="font-size:0.75rem; color:var(--color-text-tertiary);">Contact support to modify email credentials.</span>
                                </div>
                                <div class="form-group">
                                    <label class="form-group__label">Billing Address</label>
                                    <input type="text"
                                           class="form-group__input"
                                           value="${USER.address}"
                                           name="newAddress"
                                           placeholder="Enter your address"
                                           required
                                           pattern="^.{5,255}$">
                                </div>
                                <input type="hidden" name="action" value="updateProfile" />
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
                    <a href="${pageContext.request.contextPath}/MainController?action=landing-page" class="site-footer__staff-link">Return to Landing Page</a>
                </div>
            </div>
        </footer>


        <!-- REMOVE VEHICLE CONFIRMATION MODAL -->
        <div id="remove-vehicle-modal" class="modal-overlay">
            <div class="modal-content glass-panel">
                <h3 class="modal-title">Remove Vehicle</h3>
                <p class="modal-desc">
                    Are you sure you want to remove 
                    <strong id="remove-vehicle-name"></strong> 
                    from your account? This vehicle will no longer appear in your dashboard. Your booking history will be preserved.
                </p>

                <form action="MainController" method="POST" id="remove-vehicle-form">
                    <input type="hidden" name="action" value="removeVehicle">
                    <input type="hidden" name="vehicleID" id="remove-vehicle-id" value="">

                    <div class="modal-actions">
                        <button type="button" class="btn btn--secondary btn--sm" onclick="closeRemoveModal()">Cancel</button>
                        <button type="submit" class="btn btn--danger btn--sm">Remove Vehicle</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {

                const toast =
                        document.getElementById("success-toast");

                if (!toast) {
                    return;
                }

                setTimeout(() => {

                    toast.classList.add(
                            "toast--hide");

                    setTimeout(() => {
                        toast.remove();
                    }, 500);

                }, 3000);

            });

            function openRemoveModal(vehicleId, vehicleName) {
                document.getElementById("remove-vehicle-id").value = vehicleId;
                document.getElementById("remove-vehicle-name").textContent = vehicleName;
                const modal = document.getElementById("remove-vehicle-modal");
                modal.classList.add("modal-overlay--show");
            }

            function closeRemoveModal() {
                const modal = document.getElementById("remove-vehicle-modal");
                modal.classList.remove("modal-overlay--show");
            }

            window.addEventListener("click", function (event) {
                const modal = document.getElementById("remove-vehicle-modal");
                if (event.target === modal) {
                    closeRemoveModal();
                }
            });
        </script>
    </body>
</html>

