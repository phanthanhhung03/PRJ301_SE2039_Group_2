<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Promotion Management | AutoWashPro Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <script src="${pageContext.request.contextPath}/js/promotion-management.js" defer></script>
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
                <button type="button" class="btn btn--primary btn--sm" onclick="openAddPromotionModal()">
                    + New Promotion
                </button>
            </div>

            <!-- ===== FLASH MESSAGES ===== -->
            <c:if test="${not empty sessionScope.PROMO_MSG}">
                <div class="glass-panel" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); border-left: 3px solid var(--color-accent-cyan); color: var(--color-accent-cyan); font-weight:600;">
                    &#10003; ${sessionScope.PROMO_MSG}
                </div>
                <c:remove var="PROMO_MSG" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.PROMO_ERR}">
                <div class="glass-panel" style="padding: var(--spacing-md) var(--spacing-lg); border-radius: var(--radius-lg); margin-bottom: var(--spacing-lg); border-left: 3px solid var(--color-accent-red); color: var(--color-accent-red); font-weight:600;">
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
                                        <button type="button" class="btn btn--secondary btn--sm"
                                                onclick="document.getElementById('editModal_${promo.promotionID}').style.display = 'flex';">
                                            Edit
                                        </button>

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
                                        <button type="button" class="btn btn--gold btn--sm"
                                                onclick="document.getElementById('assignModal_${lowEngCust.customerID}').style.display = 'flex';">
                                            Review &amp; Grant
                                        </button>
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


        <!-- =================================================================== -->
        <!-- MODAL: ADD NEW PROMOTION                                            -->
        <!-- =================================================================== -->
        <div id="addPromotionModal" class="tier-modal-overlay">
            <div class="glass-panel tier-modal-box">

                <div class="tier-modal-header">
                    <h3>Add New Promotion</h3>
                    <button type="button" class="tier-modal-close" onclick="closeAddPromotionModal()">&#10005;</button>
                </div>

                <form id="addPromotionForm" action="PromotionManagementController?action=addPromotion" method="POST"
                      onsubmit="return validatePromotionForm(this);">

                    <div class="tier-form-group">
                        <label>Promotion Name *</label>
                        <input type="text" name="promotionName" required maxlength="100" placeholder="e.g. Summer Win-Back">
                    </div>

                    <div class="tier-form-group">
                        <label>Description</label>
                        <input type="text" name="description" maxlength="255" placeholder="Brief description">
                    </div>

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:var(--spacing-md);">
                        <div class="tier-form-group">
                            <label>Discount Percent (%)</label>
                            <input type="number" name="discountPercent" min="0" max="100" step="0.1" value="0">
                        </div>
                        <div class="tier-form-group">
                            <label>Bonus Points</label>
                            <input type="number" name="bonusPoints" min="0" step="1" value="0">
                        </div>
                    </div>

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:var(--spacing-md);">
                        <div class="tier-form-group">
                            <label>Start Date *</label>
                            <input type="date" class="add-start-date" name="startDate" required>
                        </div>
                        <div class="tier-form-group">
                            <label>End Date *</label>
                            <input type="date" class="add-end-date" name="endDate" required>
                        </div>
                    </div>

                    <div class="tier-form-group">
                        <label>Target Type *</label>
                        <select name="targetType" class="form-group__select form-group__input" required
                                onchange="toggleTierSelection(this.value)">
                            <option value="ALL">All Customers</option>
                            <option value="TIER_ONLY">Specific Tiers</option>
                            <option value="LOW_ENGAGEMENT">Low Engagement</option>
                        </select>
                    </div>

                    <div class="tier-form-group" id="tierSelectionBox" style="display:none;">
                        <label>Minimum Tier Required</label>
                        <select name="minTierID" class="form-group__select form-group__input">
                            <option value="1">Member</option>
                            <option value="2">Silver</option>
                            <option value="3">Gold</option>
                            <option value="4">Platinum</option>
                        </select>
                        <p style="font-size:0.75rem; color:var(--color-text-tertiary); margin-top:4px;">
                            Customers at this tier or higher will be eligible.
                        </p>
                    </div>

                    <button type="submit" class="btn btn--gold btn--block">Save Promotion</button>

                </form>
            </div>
        </div>


        <!-- =================================================================== -->
        <!-- MODALS: EDIT PROMOTION (one per promotion)                          -->
        <!-- =================================================================== -->
        <c:forEach var="promo" items="${promotionList}">
            <div id="editModal_${promo.promotionID}" class="tier-modal-overlay">
                <div class="glass-panel tier-modal-box">

                    <div class="tier-modal-header">
                        <h3>Edit Promotion</h3>
                        <button type="button" class="tier-modal-close"
                                onclick="document.getElementById('editModal_${promo.promotionID}').style.display = 'none';">&#10005;</button>
                    </div>

                    <form action="PromotionManagementController?action=editPromotion" method="POST">
                        <input type="hidden" name="promotionID" value="${promo.promotionID}">

                        <div class="tier-form-group">
                            <label>Promotion Name *</label>
                            <input type="text" name="promotionName" value="${promo.promotionName}" required maxlength="100">
                        </div>

                        <div class="tier-form-group">
                            <label>Description</label>
                            <input type="text" name="description" value="${promo.description}" maxlength="255">
                        </div>

                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:var(--spacing-md);">
                            <div class="tier-form-group">
                                <label>Discount Percent (%)</label>
                                <input type="number" name="discountPercent" min="0" max="100" step="0.1" value="${promo.discountPercent}">
                            </div>
                            <div class="tier-form-group">
                                <label>Bonus Points</label>
                                <input type="number" name="bonusPoints" min="0" step="1" value="${promo.bonusPoints}">
                            </div>
                        </div>

                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:var(--spacing-md);">
                            <div class="tier-form-group">
                                <label>Start Date *</label>
                                <input type="date" name="startDate" value="${promo.startDate}" required>
                            </div>
                            <div class="tier-form-group">
                                <label>End Date *</label>
                                <input type="date" name="endDate" value="${promo.endDate}" required>
                            </div>
                        </div>

                        <div class="tier-form-group">
                            <label>Target Type</label>
                            <select name="targetType" class="form-group__select form-group__input"
                                    onchange="toggleTierSelection(this.value, 'tierSelectionBox_${promo.promotionID}')">
                                <option value="ALL" <c:if test="${promo.targetType == 'ALL'}">selected</c:if>>All Customers</option>
                                <option value="TIER_ONLY" <c:if test="${promo.targetType == 'TIER_ONLY'}">selected</c:if>>Specific Tiers</option>
                                <option value="LOW_ENGAGEMENT" <c:if test="${promo.targetType == 'LOW_ENGAGEMENT'}">selected</c:if>>Low Engagement</option>
                                </select>
                            </div>

                        <c:set var="curMinTier" value="${promotionMinTierMap[promo.promotionID]}"/>
                        <div class="tier-form-group" id="tierSelectionBox_${promo.promotionID}"
                             style="display: ${promo.targetType == 'TIER_ONLY' ? 'block' : 'none'};">
                            <label>Minimum Tier Required</label>
                            <select name="minTierID" class="form-group__select form-group__input">
                                <option value="1" <c:if test="${curMinTier == 1}">selected</c:if>>Member</option>
                                <option value="2" <c:if test="${curMinTier == 2}">selected</c:if>>Silver</option>
                                <option value="3" <c:if test="${curMinTier == 3}">selected</c:if>>Gold</option>
                                <option value="4" <c:if test="${curMinTier == 4}">selected</c:if>>Platinum</option>
                                </select>
                                <p style="font-size:0.75rem; color:var(--color-text-tertiary); margin-top:4px;">
                                    Customers at this tier or higher will be eligible.
                                </p>
                            </div>

                            <div class="tier-form-group">
                                <label>Status</label>
                                <select name="status" class="form-group__select form-group__input">
                                    <option value="on" <c:if test="${promo.status}">selected</c:if>>Active</option>
                                <option value="off" <c:if test="${!promo.status}">selected</c:if>>Inactive</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn--gold btn--block">Save Changes</button>

                        </form>
                    </div>
                </div>
        </c:forEach>


        <!-- =================================================================== -->
        <!-- MODALS: GRANT PROMOTION (one per low-engagement customer)           -->
        <!-- =================================================================== -->
        <c:forEach var="targetCust" items="${lowEngagementCustomer}">
            <div id="assignModal_${targetCust.customerID}" class="tier-modal-overlay">
                <div class="glass-panel tier-modal-box">

                    <div class="tier-modal-header">
                        <h3>Grant Promotion to Customer</h3>
                        <button type="button" class="tier-modal-close"
                                onclick="document.getElementById('assignModal_${targetCust.customerID}').style.display = 'none';">&#10005;</button>
                    </div>

                    <div style="margin-bottom: var(--spacing-lg); padding: var(--spacing-md); border-radius: var(--radius-md); background: rgba(255,255,255,0.03); border: 1px solid var(--color-border);">
                        <div style="font-size:0.75rem; color:var(--color-text-tertiary); text-transform:uppercase;">Customer</div>
                        <div style="font-weight:600; margin-top:2px;">${targetCust.customerName}</div>
                        <div style="font-size:0.85rem; color:var(--color-accent-orange); margin-top:4px;">
                            Last booking:
                            <c:choose>
                                <c:when test="${empty targetCust.lastBookingDate}">Never booked</c:when>
                                <c:otherwise><fmt:formatDate value="${targetCust.lastBookingDate}" pattern="dd/MM/yyyy"/></c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <form action="PromotionManagementController?action=assignPromotion" method="POST">
                        <input type="hidden" name="customerID" value="${targetCust.customerID}">

                        <div class="tier-form-group">
                            <label>Promotion to Grant *</label>
                            <select name="promotionID" class="form-group__select form-group__input" required>
                                <option value="" disabled selected>-- Select a promotion --</option>
                                <c:forEach var="promo" items="${promotionList}">
                                    <c:if test="${promo.status}">
                                        <option value="${promo.promotionID}">
                                            ${promo.promotionName} (<fmt:formatNumber value="${promo.discountPercent}" maxFractionDigits="1"/>% off)
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="tier-form-group">
                            <label>Reason / Notes</label>
                            <input type="text" name="notes" maxlength="255" value="Win-back offer !">
                        </div>

                        <button type="submit" class="btn btn--gold btn--block">Grant Promotion</button>

                    </form>
                </div>
            </div>
        </c:forEach>

    </body>
</html>
