<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Grant Promotion | AutoWashPro Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="MainController?action=viewAdminDashboard" class="site-header__logo">
                    <div class="site-header__logo-icon" style="background: linear-gradient(135deg, var(--color-accent-blue), var(--color-accent-cyan));"></div>
                    <div class="site-header__logo-text">ADMIN<span>PANEL</span></div>
                </a>
                <nav class="site-header__navigation">
                    <a href="MainController?action=viewAdminDashboard" class="site-header__nav-link">Dashboard</a>
                    <a href="MainController?action=viewPromotionManagement" class="site-header__nav-link site-header__nav-link--active">Promotions</a>
                </nav>
            </div>
        </header>

        <main class="main-wrapper" style="margin-top: var(--spacing-xl); max-width: 600px;">

            <div style="margin-bottom: var(--spacing-xl);">
                <span style="font-size:0.75rem; font-weight:700; color:var(--color-accent-cyan); text-transform:uppercase; letter-spacing:0.1em;">
                    Promotion Management
                </span>
                <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Grant Promotion to Customer</h1>
            </div>

            <section class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl);">

                <div style="margin-bottom: var(--spacing-lg); padding: var(--spacing-md); border-radius: var(--radius-md); background: rgba(255,255,255,0.03); border: 1px solid var(--color-border);">
                    <div style="font-size:0.75rem; color:var(--color-text-tertiary); text-transform:uppercase;">Customer</div>
                    <div style="font-weight:600; margin-top:2px;">${targetCust.fullName}</div>
                    <div style="font-size:0.85rem; color:var(--color-accent-gold); margin-top:4px;">
                        Tier: ${targetCust.tierId.tierName} &middot; Current Points: ${targetCust.currentPoint} pts
                    </div>
                </div>

                <form action="PromotionManagementController?action=assignPromotion" method="POST">
                    <input type="hidden" name="customerID" value="${targetCust.cusId}">

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

                    <div style="display:flex; gap: var(--spacing-md); margin-top: var(--spacing-lg);">
                        <a href="MainController?action=viewPromotionManagement" class="btn btn--secondary btn--block">Cancel</a>
                        <button type="submit" class="btn btn--gold btn--block">Grant Promotion</button>
                    </div>

                </form>
            </section>

        </main>

    </body>
</html>