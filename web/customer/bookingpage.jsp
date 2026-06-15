<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Booking | AutoWashPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=4">
</head>
<body>

    <header class="site-header">
        <div class="site-header__container main-wrapper">
            <a href="${pageContext.request.contextPath}/MainController?action=landing" class="site-header__logo">
                <div class="site-header__logo-icon"></div>
                <div class="site-header__logo-text">AUTOWASH<span>PRO</span></div>
            </a>
            
            <div class="site-header__center-title">
                NEW BOOKING
            </div>

            <div class="site-header__actions">
                <span class="status-badge status-badge--tier">Tier: Gold</span>
            </div>
        </div>
    </header>

    <main class="main-wrapper booking-page">
        
        <div class="booking-page__intro glass-panel">
            <h1 class="booking-page__title">SCHEDULE A PREMIUM WASH</h1>
            <p class="booking-page__desc">Select your vehicle, preferred time, and service package below.</p>
        </div>

        <div class="booking-page__grid">
            
            <div class="booking-page__form-section glass-panel">
                
                <form id="bookingForm" action="${pageContext.request.contextPath}/MainController" method="POST">
                    <input type="hidden" name="action" value="createBookingProcess">

                    <h2 class="booking-page__step-title">Step 1: Vehicle & Schedule</h2>
                    
                    <div class="form-group">
                        <label for="vehicleSelect" class="form-group__label">Select Your Vehicle</label>
                        <div class="form-group__input-wrapper">
                            <select id="vehicleSelect" name="vehicleID" class="form-group__input" required>
                                <option value="" disabled selected>-- Choose a registered vehicle --</option>
                                <option value="1" data-name="59A-123.45">59A-123.45 - Toyota Vios (White)</option>
                                <option value="2" data-name="51G-888.88">51G-888.88 - Honda City (Black)</option>
                            </select>
                        </div>
                        <a href="#" class="booking-page__add-link">+ Register a new vehicle</a>
                    </div>

                    <div class="grid-cols-2">
                        <div class="form-group">
                            <label for="bookingDate" class="form-group__label">Date</label>
                            <div class="form-group__input-wrapper">
                                <input type="date" id="bookingDate" name="bookingDate" class="form-group__input" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="bookingTime" class="form-group__label">Arrival Time</label>
                            <div class="form-group__input-wrapper">
                                <input type="time" id="bookingTime" name="bookingTime" class="form-group__input" required>
                            </div>
                        </div>
                    </div>

                    <h2 class="booking-page__step-title">Step 2: Service Packages</h2>
                    
                    <div class="service-grid">
                        <label class="service-card glass-panel">
                            <input type="radio" name="serviceType" value="Basic Wash" class="service-card__radio" data-price="150000" data-points="15" required>
                            <div class="service-card__content">
                                <h3 class="service-card__name">Basic Wash</h3>
                                <p class="service-card__desc">Snow foam wash, basic vacuum, and glass wipe down.</p>
                                <span class="service-card__price">150,000 đ</span>
                            </div>
                        </label>

                        <label class="service-card glass-panel">
                            <input type="radio" name="serviceType" value="Premium Wash" class="service-card__radio" data-price="300000" data-points="30" required>
                            <div class="service-card__content">
                                <h3 class="service-card__name service-card__name--premium">Premium Wash</h3>
                                <p class="service-card__desc">Includes Basic Wash + undercarriage spray & tire dressing.</p>
                                <span class="service-card__price">300,000 đ</span>
                            </div>
                        </label>

                        <label class="service-card service-card--full glass-panel">
                            <input type="radio" name="serviceType" value="Ceramic Coating" class="service-card__radio" data-price="2000000" data-points="200" required>
                            <div class="service-card__content service-card__content--flex">
                                <div>
                                    <h3 class="service-card__name service-card__name--cyan">Ceramic Coating (Premium)</h3>
                                    <p class="service-card__desc">High-gloss paint protection, anti-scratch coating.</p>
                                </div>
                                <span class="service-card__price service-card__price--cyan">2,000,000 đ</span>
                            </div>
                        </label>
                    </div>

                    <h2 class="booking-page__step-title">Step 3: Special Requests / Notes</h2>
                    <div class="form-group">
                        <div class="form-group__input-wrapper">
                            <textarea id="notes" name="notes" class="form-group__input" rows="3" placeholder="E.g., heavy mud on the undercarriage..."></textarea>
                        </div>
                    </div>

                </form>
            </div>

            <aside class="booking-page__summary-section">
                <div class="order-summary glass-panel">
                    <h2 class="order-summary__title">ORDER SUMMARY</h2>
                    
                    <div class="order-summary__row">
                        <span class="order-summary__label">SELECTED VEHICLE</span>
                        <strong id="summaryVehicle" class="order-summary__value">-- Not selected --</strong>
                    </div>

                    <div class="order-summary__row">
                        <span class="order-summary__label">SERVICE TYPE</span>
                        <strong id="summaryService" class="order-summary__value">-- Not selected --</strong>
                    </div>

                    <div class="order-summary__total-row">
                        <span class="order-summary__label">TOTAL AMOUNT</span>
                        <strong id="summaryTotal" class="order-summary__total">0 đ</strong>
                    </div>

                    <div class="order-summary__points">
                        Loyalty Reward: <strong id="summaryPoints">+0 pts</strong>
                    </div>

                    <button type="submit" form="bookingForm" class="btn btn--primary btn--block order-summary__btn">
                        CONFIRM BOOKING
                    </button>
                </div>
            </aside>

        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/booking.js"></script>
</body>
</html>