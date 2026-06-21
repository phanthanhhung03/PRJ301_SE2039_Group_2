<%-- 
    Document   : edit-customer
    Created on : Jun 21, 2026, 8:13:01 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty ADMIN_USER}">
    <c:redirect url="/MainController?action=viewAdminSignIn"/>
</c:if>

<c
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Edit Customer | AutoWashPro Staff</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>
        <body>

            <!-- STAFF TOP NAVIGATION -->
            <header class="site-header">
                <div class="site-header__container main-wrapper">
                    <a href="${pageContext.request.contextPath}/MainController?action=viewAdminDashboard" class="site-header__logo">
                        <div class="site-header__logo-icon"></div>
                        <div class="site-header__logo-text">ADMIN<span>PANEL</span></div>
                    </a>
                    <nav class="site-header__navigation">
                        <a href="${pageContext.request.contextPath}/MainController?action=viewAdminDashboard" class="site-header__nav-link">
                            Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerManagement" class="site-header__nav-link site-header__nav-link--active">
                            Customers
                        </a>
                        <a href="${pageContext.request.contextPath}/MainController?action=viewAdminBookings" class="site-header__nav-link">
                            Bookings
                        </a>
                        <a href="${pageContext.request.contextPath}/MainController?action=viewLoyaltyManagement" class="site-header__nav-link">
                            Loyalty
                        </a>
                        <a href="${pageContext.request.contextPath}/MainController?action=viewPromotionManagement" class="site-header__nav-link"> 
                            Promotions
                        </a>
                    </nav>
                    <div class="site-header__actions">
                        <span class="status-badge status-badge--completed">Staff Portal</span>
                        <a href="MainController?action=logout" class="btn btn--secondary btn--sm">Logout</a>
                    </div>
                </div>
            </header>

            <!-- CONTENT -->
            <main class="main-wrapper main-wrapper--customer-form">

                <!-- HEADER BLOCK -->
                <div class="admin-page-header">
                    <div>
                        <span class="admin-page-header__subtitle">Customer Registry</span>
                        <h1 class="admin-page-header__title">Edit Customer Profile</h1>
                    </div>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerManagement"
                       class="btn btn--secondary btn--sm">
                        Back to Customers
                    </a>
                </div>



                <!-- TWO COLUMN LAYOUT -->
                <div class="customer-detail-grid">

                    <!-- LEFT COLUMN: Profile & Stats Overview -->
                    <aside class="customer-aside">

                        <!-- Account Details Card -->
                        <div class="glass-panel customer-overview-panel">

                            <div class="customer-overview-header">
                                <div class="testimonial-card__avatar testimonial-card__avatar--vip customer-overview-avatar">
                                    ${customer.initials}
                                </div>
                                <h3 class="customer-overview-name">${customer.fullName}</h3>

                                <c:choose>
                                    <c:when test="${customer.tierId.tierName eq 'Member'}">
                                        <span class="status-badge status-badge--member">MEMBER</span>
                                    </c:when>
                                    <c:when test="${customer.tierId.tierName eq 'Silver'}">
                                        <span class="status-badge status-badge--silver">SILVER</span>
                                    </c:when>
                                    <c:when test="${customer.tierId.tierName eq 'Gold'}">
                                        <span class="status-badge status-badge--gold">GOLD</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-badge--platinum">PLATINUM</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="customer-overview-stats">
                                <div>
                                    <span class="customer-overview-label">Customer ID</span>
                                    <span class="customer-overview-val">#${customer.cusId}</span>
                                </div>
                                <div>
                                    <span class="customer-overview-label">Total Bookings</span>
                                    <span class="customer-overview-val--medium">${customer.totalBooking} bookings</span>
                                </div>
                                <div>
                                    <span class="customer-overview-label">Loyalty Balance</span>
                                    <span class="customer-overview-val--gold">${customer.currentPoint} pts</span>
                                </div>
                                <div>
                                    <span class="customer-overview-label">Total Spend</span>
                                    <span class="customer-overview-val">$ ${customer.totalSpend}</span>
                                </div>
                                <div>
                                    <span class="customer-overview-label">Fleet Vehicles</span>
                                    <span class="customer-overview-val--cyan">${customer.vehicleCount} vehicles</span>
                                </div>
                            </div>
                        </div>

                    </aside>

                    <!-- RIGHT COLUMN: Editing Form Fields -->
                    <form action="${pageContext.request.contextPath}/MainController" method="post">
                        <input type="hidden" name="action" value="updateCustomer">
                        <input type="hidden" name="cusId" value="${customer.cusId}">
                        <div class="glass-panel customer-form-panel">

                            <h3 class="customer-form-title">Account Credentials & Settings</h3>

                            <!-- Grid Row 1 -->
                            <div class="form-row form-row--sm-margin">

                                <!-- FULL NAME -->
                                <div class="form-group">
                                    <label class="form-group__label">Full Name</label>
                                    <input 
                                        type="text" 
                                        name="fullName" 
                                        value="${customer.fullName}" 
                                        class="form-group__input" 
                                        pattern="^[A-Za-z\u00C0-\u024F\s]{2,100}$"
                                        required 
                                        placeholder="Enter full name">
                                </div>

                                <!-- PHONE -->
                                <div class="form-group">
                                    <label class="form-group__label">Phone Number</label>
                                    <input type="text" 
                                           name="phoneNumber" 
                                           value="${customer.phoneNumber}" 
                                           class="form-group__input" 
                                           pattern="^(0[35789])\d{8}$"
                                           required 
                                           placeholder="Enter phone number">
                                </div>

                            </div>

                            <!-- Grid Row 2 -->
                            <div class="form-row form-row--sm-margin">

                                <!-- EMAIL -->
                                <div class="form-group">
                                    <label class="form-group__label">Email Address</label>
                                    <input type="email" 
                                           name="email" 
                                           value="${customer.email}" 
                                           class="form-group__input"
                                           autocomplete="email"
                                           required 
                                           placeholder="Enter email address">
                                </div>

                                <!-- TIER -->
                                <div class="form-group">
                                    <label class="form-group__label">Membership Tier</label>
                                    <select name="tierId" class="form-group__input form-group__select">
                                        <option value="1" ${customer.tierId.tierID == 1 ? 'selected' : ''}>MEMBER</option>
                                        <option value="2" ${customer.tierId.tierID == 2 ? 'selected' : ''}>SILVER</option>
                                        <option value="3" ${customer.tierId.tierID == 3 ? 'selected' : ''}>GOLD</option>
                                        <option value="4" ${customer.tierId.tierID == 4 ? 'selected' : ''}>PLATINUM</option>
                                    </select>
                                </div>

                            </div>

                            <!-- ADDRESS -->
                            <div class="form-group">
                                <label class="form-group__label">Address</label>
                                <textarea name="address" 
                                          rows="3" 
                                          class="form-group__input form-group__textarea"
                                          pattern="^.{5,255}$"
                                          placeholder="Enter customer street address">${customer.address}</textarea>
                            </div>

                            <!-- STATUS -->
                            <div class="form-group form-group--half-width">
                                <label class="form-group__label">Account Status</label>
                                <select name="status" class="form-group__input form-group__select">
                                    <option value="true" ${customer.status ? 'selected' : ''}>Active</option>
                                    <option value="false" ${!customer.status ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>

                            <!-- ACTION BUTTONS -->
                            <div class="customer-form-actions">
                                <a href="${pageContext.request.contextPath}/MainController?action=viewCustomerManagement" class="btn btn--secondary">
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn--primary">
                                    Save Changes
                                </button>
                            </div>
                        </div>
                    </form>


                </div>

            </main>

            <!-- STAFF FOOTER -->
            <footer class="site-footer site-footer--admin">
                <div class="site-footer__container main-wrapper">
                    <div class="site-footer__bottom">
                        <p>&copy; 2026 AutoWashPro Operations Desk. Restricted Access.</p>
                        <a href="index.html" class="site-footer__staff-link">Return to Customer Landing</a>
                    </div>
                </div>
            </footer>

        </body>
    </html>
