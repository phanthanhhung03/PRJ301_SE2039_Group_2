<%-- Document : siignin Created on : May 30, 2026, 2:26:57 PM Author : Asus --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sign In | AutoWashPro Customer Portal</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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

                    <a href="${pageContext.request.contextPath}/customer/landing-page.jsp" class="auth-card__logo">
                        <div class="site-header__logo-icon"></div>
                    </a>

                    <h1 class="auth-card__title">Welcome Back</h1>
                    <p class="auth-card__desc">Sign in to manage bookings, track loyalty points, and review premium
                        washes.</p>

                    <%-- Hiển thị thông báo đăng ký thành công --%>
                    <%
                        String registered = request.getParameter("registered");
                        if ("true".equals(registered)) {
                    %>
                    <div style="background:rgba(16,185,129,0.12);border:1px solid rgba(16,185,129,0.35);color:#34d399;
                                border-radius:10px;padding:12px 16px;margin-bottom:18px;font-size:0.875rem;">
                        &#10004; Đăng ký thành công! Vui lòng đăng nhập.
                    </div>
                    <% } %>

                    <form action="MainController" method="POST">
                        <!-- Email field -->
                        <div class="form-group">
                            <label for="email" class="form-group__label">Email Address</label>
                            <div class="form-group__input-wrapper">
                                <input type="email" id="email" class="form-group__input" placeholder="name@domain.com"
                                    required autocomplete="email" name="email">
                            </div>
                        </div>

                        <!-- Password field -->
                        <div class="form-group">
                            <label for="password" class="form-group__label">Password</label>
                            <div class="form-group__input-wrapper">
                                <input type="password" id="password" class="form-group__input" placeholder="••••••••"
                                    required autocomplete="current-password" name="password">
                            </div>
                        </div>

                        <!-- Actions: Remember Me & Forgot Password -->
                        <div class="auth-card__actions">
                            <label class="form-group__checkbox">
                                <input type="checkbox" class="form-group__checkbox-input">
                                <span class="form-group__checkbox-label">Remember Me</span>
                            </label>
                            <a href="#" class="auth-card__link">Forgot Password?</a>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn--primary btn--block" name="action" value="signIn">Sign
                            In</button>
                    </form>

                    <!-- Footer signup link -->
                    <div class="auth-card__footer">
                        Don't have an account? <a href="${pageContext.request.contextPath}/MainController?action=viewSignUp" class="auth-card__footer-link">Create Account</a>
                    </div>

                </div>
            </main>

        </body>

        </html>