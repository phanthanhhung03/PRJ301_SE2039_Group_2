<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.CustomerTier"%>
<!DOCTYPE html>
<%
    CustomerTier tier = (CustomerTier) request.getAttribute("tier");
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Configure Tier | AutoWashPro Admin</title>
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
                    <a href="MainController?action=viewLoyaltyManagement" class="site-header__nav-link site-header__nav-link--active">Loyalty</a>
                </nav>
            </div>
        </header>

        <main class="main-wrapper" style="margin-top: var(--spacing-xl); max-width: 600px;">

            <div style="margin-bottom: var(--spacing-xl);">
                <span style="font-size:0.75rem; font-weight:700; color:var(--color-accent-cyan); text-transform:uppercase; letter-spacing:0.1em;">
                    Loyalty Management
                </span>
                <h1 style="font-size:2.0rem; margin-top:var(--spacing-xs);">Configure Tier</h1>
            </div>

            <section class="glass-panel" style="padding: var(--spacing-xl); border-radius: var(--radius-xl);">

                <form action="MainController?action=updateTier" method="POST">
                    <input type="hidden" name="tierID" value="<%= tier.getTierID()%>">

                    <div class="tier-form-group">
                        <label>Tier Name</label>
                        <input type="text" value="<%= tier.getTierName()%>" readonly>
                    </div>

                    <div class="tier-form-group">
                        <label>Minimum Bookings</label>
                        <input type="number" name="minBookings" min="0" value="<%= tier.getMinBookings()%>" required>
                    </div>

                    <div class="tier-form-group">
                        <label>Minimum Spend (VND)</label>
                        <input type="number" name="minSpend" min="0" step="1000"
                               value="<%= (long) tier.getMinSpend()%>" required>
                    </div>

                    <div class="tier-form-group">
                        <label>Point Multiplier</label>
                        <input type="number" name="pointMultiplier" min="0" step="0.1" value="<%= tier.getPointMultiplier()%>" required>
                    </div>

                    <div class="tier-form-group">
                        <label>Discount Percent</label>
                        <input type="number" name="discountPercent" min="0" max="100" step="0.1" value="<%= tier.getDiscountPercent()%>" required>
                    </div>

                    <div style="display:flex; gap: var(--spacing-md); margin-top: var(--spacing-lg);">
                        <a href="MainController?action=viewLoyaltyManagement" class="btn btn--secondary btn--block">Cancel</a>
                        <button type="submit" class="btn btn--gold btn--block">Save Changes</button>
                    </div>

                </form>
            </section>

        </main>

    </body>
</html>