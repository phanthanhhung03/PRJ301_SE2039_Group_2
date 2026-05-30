<%-- 
    Document   : admin-login
    Created on : May 30, 2026, 2:22:16 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff Portal Login | AutoWashPro</title>
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/style.css">
        <style>
            body {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                background-attachment: fixed;
            }
        </style>
    </head>
    <body>

        <main class="main-wrapper main-wrapper--narrow">
            <div class="auth-card glass-panel" style="border-color: var(--color-accent-cyan);">

                <a href="index.html" class="auth-card__logo">
                    <div class="site-header__logo-icon" style="background: linear-gradient(135deg, var(--color-accent-blue), var(--color-accent-cyan));"></div>
                </a>

                <h1 class="auth-card__title" style="font-size: 1.5rem;">AUTOWASHPRO STAFF</h1>
                <p class="auth-card__desc" style="color: var(--color-accent-cyan); font-size: 0.8rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase;">
                    Authorized Personnel Only
                </p>

                <form action="admin-dashboard.html" method="GET">
                    <!-- Email field -->
                    <div class="form-group">
                        <label for="admin-email" class="form-group__label">Staff Email</label>
                        <input type="email" id="admin-email" class="form-group__input" placeholder="id@autowashpro.jp" required autocomplete="email">
                    </div>

                    <!-- Password field -->
                    <div class="form-group">
                        <label for="admin-password" class="form-group__label">Password</label>
                        <input type="password" id="admin-password" class="form-group__input" placeholder="••••••••" required autocomplete="current-password">
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn--primary btn--block" style="background-color: var(--color-accent-blue); box-shadow: var(--glow-blue);">
                        Sign In to Ops Desk
                    </button>
                </form>

                <div class="auth-card__footer" style="margin-top: var(--spacing-xl); font-size: 0.75rem; color: var(--color-text-tertiary);">
                    If you have forgotten your administrator credentials or your terminal is locked, please contact the System Administrator.
                </div>

            </div>
        </main>

    </body>
</html>

