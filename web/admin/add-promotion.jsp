<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Promotion | AutoWashPro Admin</title>
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
                <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Add New Promotion</h1>
            </div>

            <section class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl);">

                <form action="PromotionManagementController?action=addPromotion" method="POST">

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
                            <input type="date" name="startDate" required>
                        </div>
                        <div class="tier-form-group">
                            <label>End Date *</label>
                            <input type="date" name="endDate" required>
                        </div>
                    </div>

                    <div class="tier-form-group">
                        <label>Target Type *</label>
                        <select name="targetType" id="targetType" class="form-group__select form-group__input" required>
                            <option value="ALL">All Customers</option>
                            <option value="TIER_ONLY">Specific Tiers</option>
                            <option value="LOW_ENGAGEMENT">Low Engagement</option>
                        </select>
                    </div>

                    <div class="tier-form-group" id="tierSelectionBox">
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

                    <div style="display:flex; gap: var(--spacing-md); margin-top: var(--spacing-lg);">
                        <a href="MainController?action=viewPromotionManagement" class="btn btn--secondary btn--block">Cancel</a>
                        <button type="submit" class="btn btn--gold btn--block">Save Promotion</button>
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