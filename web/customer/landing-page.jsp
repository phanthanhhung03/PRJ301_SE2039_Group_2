<%-- 
    Document   : landing-page
    Created on : May 30, 2026, 2:16:01 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AutoWashPro | Premium Car Wash & Membership Platform</title>
        <meta name="description" content="Experience dark luxury and high-end automotive care. Join AutoWashPro membership for priority bookings, VIP loyalty rewards, and elite detailing.">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <!-- 1. NAVIGATION -->
        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="#" class="site-header__logo">
                    <div class="site-header__logo-icon"></div>
                    <div class="site-header__logo-text">AUTOWASH<span>PRO</span></div>
                </a>
                <nav class="site-header__navigation">
                    <a href="#features" class="site-header__nav-link">Features</a>
                    <a href="#workflow" class="site-header__nav-link">How It Works</a>
                    <a href="#membership" class="site-header__nav-link">Membership</a>
                    <a href="#testimonials" class="site-header__nav-link">Feedback</a>
                </nav>
                <div class="site-header__actions">
                    <a href="${pageContext.request.contextPath}/MainController?action=viewSignIn" class="btn btn--secondary btn--sm">Sign In</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewSignUp" class="btn btn--primary btn--sm">Sign Up</a>
                </div>
            </div>
        </header>

        <!-- 2. HERO SECTION -->
        <section class="hero-section">
            <div class="hero-section__content main-wrapper">
                <div class="hero-section__badge">Premium Detailing System</div>
                <h1 class="hero-section__title">
                    The Ultimate Care for<br>Your <span>Luxury Machine</span>
                </h1>
                <p class="hero-section__desc">
                    Experience a high-end car wash platform with smart vehicle scheduling, interactive loyalty point tier rewards, and precision cleaning techniques.
                </p>
                <div class="hero-section__actions">
                    <a href="${pageContext.request.contextPath}/MainController?action=viewSignUp" class="btn btn--gold">Explore Memberships</a>
                    <a href="#features" class="btn btn--secondary">Learn More</a>
                </div>
            </div>
        </section>

        <!-- 3. FEATURES SECTION -->
        <section class="features-section" id="features">
            <div class="main-wrapper">
                <div class="section-header">
                    <span class="section-header__tag">Elite Standards</span>
                    <h2 class="section-header__title">Why AutoWashPro Stands Out</h2>
                    <p class="section-header__desc">We combine advanced telemetry styling, premium coatings, and high-efficiency detailing systems to deliver unmatched results.</p>
                </div>
                <div class="grid-cols-3">
                    <!-- Feature 1 -->
                    <div class="feature-card glass-panel">
                        <div class="feature-card__icon-wrapper">
                            <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"></path></svg>
                        </div>
                        <h3 class="feature-card__title">Smart Scheduling</h3>
                        <p class="feature-card__desc">Skip the line completely. Book specific bays, select detailer specialists, and schedule washes in a matter of seconds.</p>
                    </div>
                    <!-- Feature 2 -->
                    <div class="feature-card glass-panel">
                        <div class="feature-card__icon-wrapper">
                            <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"></path></svg>
                        </div>
                        <h3 class="feature-card__title">Tier-Based Loyalty</h3>
                        <p class="feature-card__desc">Accumulate loyalty points with every wash. Progress from Elite status to VIP Gold and unlock exclusive member washes.</p>
                    </div>
                    <!-- Feature 3 -->
                    <div class="feature-card glass-panel">
                        <div class="feature-card__icon-wrapper">
                            <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M5 17h14l1-5-2-4H6L4 12l1 5z"/>
                            <circle cx="7" cy="17" r="2"/>
                            <circle cx="17" cy="17" r="2"/>
                            </svg>
                        </div>
                        <h3 class="feature-card__title">Vehicle Management</h3>
                        <p class="feature-card__desc">Keep all your vehicles organized in one place. Manage vehicle information, booking records, and service history effortlessly.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <!-- 4. HOW IT WORKS -->
        <section class="steps-section" id="workflow">
            <div class="main-wrapper">
                <div class="section-header">
                    <span class="section-header__tag">Process Flow</span>
                    <h2 class="section-header__title">Sleek, Frictionless Scheduling</h2>
                    <p class="section-header__desc">Get your machine Detailed and protected in three simple operations.</p>
                </div>
                <div class="grid-cols-3">
                    <!-- Step 1 -->
                    <div class="step-card glass-panel">
                        <div class="step-card__number">01</div>
                        <h3 class="step-card__title">Register Vehicle</h3>
                        <p class="step-card__desc">Sign up and configure your fleet of personal or commercial vehicles with plate and model tracking.</p>
                    </div>
                    <!-- Step 2 -->
                    <div class="step-card glass-panel">
                        <div class="step-card__number">02</div>
                        <h3 class="step-card__title">Book a Premium Bay</h3>
                        <p class="step-card__desc">Choose a service tier, select a preferred wash date and time slot, and confirm instantly online.</p>
                    </div>
                    <!-- Step 3 -->
                    <div class="step-card glass-panel">
                        <div class="step-card__number">03</div>
                        <h3 class="step-card__title">Arrive & Enjoy VIP Care</h3>
                        <p class="step-card__desc">Our RFID gates scan your plate, checking you in instantly for your premium treatment.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- 5. MEMBERSHIP BENEFITS -->
        <section class="benefits-section" id="membership">
            <div class="main-wrapper">
                <div class="section-header">
                    <span class="section-header__tag">Club Tiers</span>
                    <h2 class="section-header__title">Select Your Membership Level</h2>
                    <p class="section-header__desc">Unlock high-end benefits, points-multipliers, and dedicated service bays.</p>
                </div>
                <div class="grid-cols-4">

                    <!-- Member -->
                    <div class="tier-card glass-panel">
                        <div class="tier-card__header">
                            <h3 class="tier-card__name">Member</h3>
                            <div class="tier-card__price">Starter<span> Tier</span></div>
                        </div>

                        <ul class="tier-card__list">
                            <li class="tier-card__item">Earn loyalty points on every wash</li>
                            <li class="tier-card__item">Access online booking system</li>
                            <li class="tier-card__item">Manage vehicles in one place</li>
                            <li class="tier-card__item">Track booking history</li>
                        </ul>

                        <a href="${pageContext.request.contextPath}/MainController?action=viewSignUp"
                           class="btn btn--secondary btn--block">
                            Get Started
                        </a>
                    </div>

                    <!-- Silver -->
                    <div class="tier-card glass-panel">
                        <div class="tier-card__header">
                            <h3 class="tier-card__name">Silver</h3>
                            <div class="tier-card__price">5 Washes<span> / 2M VND</span></div>
                        </div>

                        <ul class="tier-card__list">
                            <li class="tier-card__item">+10% Loyalty Point Bonus</li>
                            <li class="tier-card__item">Priority Booking Access</li>
                            <li class="tier-card__item">Exclusive Member Promotions</li>
                            <li class="tier-card__item">Faster Service Queue</li>
                        </ul>

                        <a href="${pageContext.request.contextPath}/MainController?action=viewSignUp"
                           class="btn btn--secondary btn--block">
                            Join Silver
                        </a>
                    </div>

                    <!-- Gold -->
                    <div class="tier-card tier-card--popular glass-panel">
                        <div class="tier-card__header">
                            <h3 class="tier-card__name">Gold</h3>
                            <div class="tier-card__price">15 Washes<span> / 6M VND</span></div>
                        </div>

                        <ul class="tier-card__list">
                            <li class="tier-card__item">+20% Loyalty Point Bonus</li>
                            <li class="tier-card__item">Higher Booking Priority</li>
                            <li class="tier-card__item">Monthly Service Upgrade</li>
                            <li class="tier-card__item">Exclusive Gold Rewards</li>
                        </ul>

                        <a href="${pageContext.request.contextPath}/MainController?action=viewSignUp"
                           class="btn btn--primary btn--block">
                            Join Gold
                        </a>
                    </div>

                    <!-- Platinum -->
                    <div class="tier-card tier-card--vip glass-panel">
                        <div class="tier-card__header">
                            <h3 class="tier-card__name">Platinum</h3>
                            <div class="tier-card__price">30 Washes<span> / 15M VND</span></div>
                        </div>

                        <ul class="tier-card__list">
                            <li class="tier-card__item">+30% Loyalty Point Bonus</li>
                            <li class="tier-card__item">Highest Booking Priority</li>
                            <li class="tier-card__item">Free Monthly Wash</li>
                            <li class="tier-card__item">Premium VIP Benefits</li>
                            <li class="tier-card__item">Exclusive Promotions & Rewards</li>
                        </ul>

                        <a href="${pageContext.request.contextPath}/MainController?action=viewSignUp"
                           class="btn btn--gold btn--block">
                            Join Platinum
                        </a>
                    </div>

                </div>
            </div>
        </section>

        <!-- 6. TESTIMONIALS -->
        <section class="testimonials-section" id="testimonials">
            <div class="main-wrapper">
                <div class="section-header">
                    <span class="section-header__tag">Reviews</span>
                    <h2 class="section-header__title">What Detailing Enthusiasts Say</h2>
                    <p class="section-header__desc">Trusted by collectors, daily drivers, and luxury automobile connoisseurs.</p>
                </div>
                <div class="grid-cols-3">
                    <!-- Testimonial 1 -->
                    <div class="testimonial-card glass-panel">
                        <p class="testimonial-card__quote">
                            "The Platinum Member lounge is top-tier. I can get work done while my Porsche receives pristine ceramic coat treatment. Pure efficiency."
                        </p>
                        <div class="testimonial-card__author">
                            <div class="testimonial-card__avatar testimonial-card__avatar--vip">TK</div>
                            <div class="testimonial-card__meta">
                                <span class="testimonial-card__name">Takahiro K.</span>
                                <span class="testimonial-card__tier">Platinum Member</span>
                            </div>
                        </div>
                    </div>
                    <!-- Testimonial 2 -->
                    <div class="testimonial-card glass-panel">
                        <p class="testimonial-card__quote">
                            "AutoWashPro has saved me hours of waiting in line. The license plate RFID system opens the bay instantly, and the detailing is flawless."
                        </p>
                        <div class="testimonial-card__author">
                            <div class="testimonial-card__avatar">SM</div>
                            <div class="testimonial-card__meta">
                                <span class="testimonial-card__name">Sarah M.</span>
                                <span class="testimonial-card__tier testimonial-card__tier--standard">Gold Member</span>
                            </div>
                        </div>
                    </div>
                    <!-- Testimonial 3 -->
                    <div class="testimonial-card glass-panel">
                        <p class="testimonial-card__quote">
                            "I love the loyalty points! I was able to redeem a free internal sanitization package. Highly recommended for automobile enthusiasts."
                        </p>
                        <div class="testimonial-card__author">
                            <div class="testimonial-card__avatar">DL</div>
                            <div class="testimonial-card__meta">
                                <span class="testimonial-card__name">David L.</span>
                                <span class="testimonial-card__tier testimonial-card__tier--standard">Silver Member</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 7. CALL TO ACTION -->
        <section class="cta-section">
            <div class="main-wrapper">
                <div class="cta-card glass-panel">
                    <h2 class="cta-card__title">Elevate Your Automotive Care</h2>
                    <p class="cta-card__desc">Join thousands of members who enjoy premium, hassle-free detailing services on demand.</p>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewSignUp" class="btn btn--primary">Get Started Now</a>
                </div>
            </div>
        </section>

        <!-- 8. FOOTER -->
        <footer class="site-footer">
            <div class="site-footer__container main-wrapper">
                <div class="site-footer__grid">
                    <div class="site-footer__brand">
                        <div class="site-footer__logo">AUTOWASH<span>PRO</span></div>
                        <p class="site-footer__desc">Premium car wash service platform focusing on tech-driven luxury, scheduling comfort, and elite detailing care.</p>
                    </div>
                    <div>
                        <h4 class="site-footer__section-title">Navigation</h4>
                        <ul class="site-footer__list">
                            <li><a href="#features" class="site-footer__link">Features</a></li>
                            <li><a href="#workflow" class="site-footer__link">How It Works</a></li>
                            <li><a href="#membership" class="site-footer__link">Memberships</a></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="site-footer__section-title">Customer Care</h4>
                        <ul class="site-footer__list">
                            <li><a href="${pageContext.request.contextPath}/MainController?action=viewSignIn" class="site-footer__link">Sign In</a></li>
                            <li><a href="${pageContext.request.contextPath}/MainController?action=viewSignUp" class="site-footer__link">Sign Up</a></li>
                            <li><a href="#" class="site-footer__link">Support Portal</a></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="site-footer__section-title">Contact</h4>
                        <div class="site-footer__info">
                            <p>108 Ginza District, Tokyo, JP</p>
                            <p>support@autowashpro.jp</p>
                            <p>+81 (3) 5555-0199</p>
                        </div>
                    </div>
                </div>
                <div class="site-footer__bottom">
                    <p>&copy; 2026 AutoWashPro Inc. All rights reserved.</p>
                    <a href="admin/admin-login.jsp" class="site-footer__staff-link">Staff Portal</a>
                </div>
            </div>
        </footer>

    </body>
</html>

