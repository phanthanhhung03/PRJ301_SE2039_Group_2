<%-- 
    Document   : signup
    Created on : May 30, 2026, 2:27:18 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign Up | AutoWashPro Customer Portal</title>
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
            <div class="auth-card glass-panel">

                <a href="customer/landing-page.jsp" class="auth-card__logo">
                    <div class="site-header__logo-icon"></div>
                </a>

                <h1 class="auth-card__title">Create Account</h1>
                <p class="auth-card__desc">Register to join the membership club, gain loyalty points, and book services.</p>

                <form action="signin.jsp" method="GET">
                    <!-- Full Name -->
                    <div class="form-group">
                        <label for="fullname" class="form-group__label">Full Name</label>
                        <input type="text" id="fullname" class="form-group__input" placeholder="Minato Namikaze" required autocomplete="name">
                    </div>

                    <!-- Phone Number -->
                    <div class="form-group">
                        <label for="phone" class="form-group__label">Phone Number</label>
                        <input type="tel" id="phone" class="form-group__input" placeholder="+81 90-1234-5678" required autocomplete="tel">
                    </div>

                    <!-- Email Address -->
                    <div class="form-group">
                        <label for="email" class="form-group__label">Email Address</label>
                        <input type="email" id="email" class="form-group__input" placeholder="minato@konoha.gov" required autocomplete="email">
                    </div>

                    <!-- Address -->
                    <div class="form-group">
                        <label for="address" class="form-group__label">Address</label>
                        <input type="text" id="address" class="form-group__input" placeholder="4F Hokage Tower, Konoha" required autocomplete="street-address">
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <label for="password" class="form-group__label">Password</label>
                        <input type="password" id="password" class="form-group__input" placeholder="••••••••" required autocomplete="new-password">
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <label for="confirm-password" class="form-group__label">Confirm Password</label>
                        <input type="password" id="confirm-password" class="form-group__input" placeholder="••••••••" required autocomplete="new-password">
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn--primary btn--block">Create Account</button>
                </form>

                <!-- Footer signin link -->
                <div class="auth-card__footer">
                    Already have an account? <a href="${pageContext.request.contextPath}/MainController?action=viewSignIn" class="auth-card__footer-link">Sign In</a>
                </div>

            </div>
        </main>

    </body>
</html>

