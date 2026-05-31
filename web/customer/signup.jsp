<%-- Document : signup Created on : May 30, 2026, 2:27:18 PM Author : Asus --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sign Up | AutoWashPro Customer Portal</title>
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

                    <a href="${pageContext.request.contextPath}customer/landing-page.jsp" class="auth-card__logo">
                        <div class="site-header__logo-icon"></div>
                    </a>

                    <h1 class="auth-card__title">Create Account</h1>
                    <p class="auth-card__desc">Register to join the membership club, gain loyalty points, and book
                        services.</p>

                    <%-- Show backend error (duplicate email/phone) --%>
                    <%
                        String errEmail = (String) request.getAttribute("SIGNUP_ERROR_EMAIL");
                        String errPhone = (String) request.getAttribute("SIGNUP_ERROR_PHONE");
                        String errSystem = (String) request.getAttribute("SIGNUP_ERROR");
                        String displayErr = errEmail != null ? errEmail
                                         : errPhone != null ? errPhone
                                         : (errSystem != null && !"true".equals(errSystem)) ? errSystem : null;
                    %>
                    <% if (displayErr != null) { %>
                    <div style="background:rgba(239,68,68,0.12);border:1px solid rgba(239,68,68,0.35);color:#f87171;
                                border-radius:10px;padding:12px 16px;margin-bottom:18px;font-size:0.875rem;">
                        &#9888; <%= displayErr %>
                    </div>
                    <% } %>

                    <%
                        String oldFullName = request.getAttribute("oldFullName") != null ? (String) request.getAttribute("oldFullName") : "";
                        String oldPhone    = request.getAttribute("oldPhone")    != null ? (String) request.getAttribute("oldPhone")    : "";
                        String oldEmail    = request.getAttribute("oldEmail")    != null ? (String) request.getAttribute("oldEmail")    : "";
                        String oldAddress  = request.getAttribute("oldAddress")  != null ? (String) request.getAttribute("oldAddress")  : "";
                    %>

                    <form action="${pageContext.request.contextPath}/MainController"
                          method="POST" novalidate id="signupForm">
                        <input type="hidden" name="action" value="signUp">

                        <!-- Full Name -->
                        <div class="form-group">
                            <label for="fullname" class="form-group__label">Full Name</label>
                            <input type="text" id="fullname" class="form-group__input" placeholder="Minato Namikaze"
                                required autocomplete="name" name="fullname"
                                pattern="^[A-Za-z\u00C0-\u024F\s]{2,100}$"
                                value="<%= oldFullName %>">
                        </div>

                        <!-- Phone Number -->
                        <div class="form-group">
                            <label for="phone" class="form-group__label">Phone Number</label>
                            <input type="tel" id="phone" class="form-group__input" placeholder="0901234567"
                                required autocomplete="tel" name="phone"
                                pattern="^(0[35789])\d{8}$"
                                value="<%= oldPhone %>">
                        </div>

                        <!-- Email Address -->
                        <div class="form-group">
                            <label for="email" class="form-group__label">Email Address</label>
                            <input type="email" id="email" class="form-group__input" placeholder="minato@konoha.gov"
                                   required autocomplete="email" name="email"
                                   value="<%= oldEmail %>">
                        </div>

                        <!-- Address -->
                        <div class="form-group">
                            <label for="address" class="form-group__label">Address</label>
                            <input type="text" id="address" class="form-group__input" placeholder="4F Hokage Tower, Konoha"
                                   required autocomplete="street-address" name="address"
                                   pattern="^.{5,255}$"
                                   value="<%= oldAddress %>">  
                        </div>

                        <!-- Password -->
                        <div class="form-group">
                            <label for="password" class="form-group__label">Password</label>
                            <input type="password" id="password" class="form-group__input" placeholder="••••••••"
                                   required autocomplete="new-password" name="password" pattern="^.{6,}$">
                        </div>

                        <!-- Confirm Password -->
                        <div class="form-group">
                            <label for="confirm-password" class="form-group__label">Confirm Password</label>
                            <input type="password" id="confirm-password" class="form-group__input" placeholder="••••••••" 
                                   required autocomplete="new-password" name="confirm-password">
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn--primary btn--block">Create Account</button>
                    </form>

                    <!-- Footer signin link -->
                    <div class="auth-card__footer">
                        Already have an account? 
                        <form action="${pageContext.request.contextPath}/MainController" 
                            method="POST" style="display:inline;">
                            <input type="hidden" name="action" value="viewSignIn">
                            <button type="submit" class="auth-card__footer-link">Sign In</button>
                        </form>
                    </div>

                </div>
            </main>
            <script src="${pageContext.request.contextPath}/js/main.js"></script>
    
        </body>

        </html>