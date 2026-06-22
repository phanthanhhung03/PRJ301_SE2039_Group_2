<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Promotion"%>
<!DOCTYPE html>
<%
    Promotion promo = (Promotion) request.getAttribute("promo");
    Integer curMinTier = (Integer) request.getAttribute("curMinTier");
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Promotion | AutoWashPro Admin</title>
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
                <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Edit Promotion</h1>
            </div>

            <section class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl);">

                <form action="PromotionManagementController?action=editPromotion" method="POST">
                    <input type="hidden" name="promotionID" value="<%= promo.getPromotionID() %>">

                    <div class="tier-form-group">
                        <label>Promotion Name *</label>
                        <input type="text" name="promotionName" value="<%= promo.getPromotionName() %>" required maxlength="100">
                    </div>

                    <div class="tier-form-group">
                        <label>Description</label>
                        <input type="text" name="description" value="<%= promo.getDescription() != null ? promo.getDescription() : "" %>" maxlength="255">
                    </div>

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:var(--spacing-md);">
                        <div class="tier-form-group">
                            <label>Discount Percent (%)</label>
                            <input type="number" name="discountPercent" min="0" max="100" step="0.1" value="<%= promo.getDiscountPercent() %>">
                        </div>
                        <div class="tier-form-group">
                            <label>Bonus Points</label>
                            <input type="number" name="bonusPoints" min="0" step="1" value="<%= promo.getBonusPoints() %>">
                        </div>
                    </div>

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:var(--spacing-md);">
                        <div class="tier-form-group">
                            <label>Start Date *</label>
                            <input type="date" name="startDate" value="<%= promo.getStartDate() %>" required>
                        </div>
                        <div class="tier-form-group">
                            <label>End Date *</label>
                            <input type="date" name="endDate" value="<%= promo.getEndDate() %>" required>
                        </div>
                    </div>

                    <div class="tier-form-group">
                        <label>Target Type</label>
                        <select name="targetType" id="targetType" class="form-group__select form-group__input">
                            <option value="ALL" <%= "ALL".equals(promo.getTargetType()) ? "selected" : "" %>>All Customers</option>
                            <option value="TIER_ONLY" <%= "TIER_ONLY".equals(promo.getTargetType()) ? "selected" : "" %>>Specific Tiers</option>
                            <option value="LOW_ENGAGEMENT" <%= "LOW_ENGAGEMENT".equals(promo.getTargetType()) ? "selected" : "" %>>Low Engagement</option>
                        </select>
                    </div>

                    <div class="tier-form-group" id="tierSelectionBox">
                        <label>Minimum Tier Required</label>
                        <select name="minTierID" class="form-group__select form-group__input">
                            <option value="1" <%= (curMinTier != null && curMinTier == 1) ? "selected" : "" %>>Member</option>
                            <option value="2" <%= (curMinTier != null && curMinTier == 2) ? "selected" : "" %>>Silver</option>
                            <option value="3" <%= (curMinTier != null && curMinTier == 3) ? "selected" : "" %>>Gold</option>
                            <option value="4" <%= (curMinTier != null && curMinTier == 4) ? "selected" : "" %>>Platinum</option>
                        </select>
                        <p style="font-size:0.75rem; color:var(--color-text-tertiary); margin-top:4px;">
                            Customers at this tier or higher will be eligible.
                        </p>
                    </div>

                    <div class="tier-form-group">
                        <label>Status</label>
                        <select name="status" class="form-group__select form-group__input">
                            <option value="on" <%= promo.isStatus() ? "selected" : "" %>>Active</option>
                            <option value="off" <%= !promo.isStatus() ? "selected" : "" %>>Inactive</option>
                        </select>
                    </div>

                    <div style="display:flex; gap: var(--spacing-md); margin-top: var(--spacing-lg);">
                        <a href="MainController?action=viewPromotionManagement" class="btn btn--secondary btn--block">Cancel</a>
                        <button type="submit" class="btn btn--gold btn--block">Save Changes</button>
                    </div>

                </form>
            </section>

        </main>

        <script>
            const targetType = document.getElementById('targetType');
            const tierBox = document.getElementById('tierSelectionBox');
            function syncTierBox() {
                tierBox.style.display = (targetType.value === 'TIER_ONLY') ? 'block' : 'none';
            }
            targetType.addEventListener('change', syncTierBox);
            syncTierBox();
        </script>

    </body>
</html>