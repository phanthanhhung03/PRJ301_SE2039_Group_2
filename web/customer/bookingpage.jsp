<%@page import="dto.Promotion"%>
<%@page import="dao.PromotionDAO"%>
<%@page import="java.util.List"%>
<%@page import="dto.Vehicle"%>
<%@page import="dao.VehicleDAO"%>
<%@page import="dto.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Lấy thông tin khách hàng đang đăng nhập từ Session
    Customer currentUser = (Customer) session.getAttribute("USER");
    int maxAdvanceDays = 7; // Mặc định cho hạng Member
    if (currentUser != null) {
        // Gọi thẳng VehicleDAO ngay trong JSP
        VehicleDAO vDao = new VehicleDAO();

        // Gọi hàm lấy danh sách xe (Bạn nhớ kiểm tra lại tên hàm này trong VehicleDAO của bạn cho đúng nhé)
        List<Vehicle> myCars = vDao.getVehiclesByCustomerId(currentUser.getCusId());

        // Nhét danh sách này vào request để JSTL bên dưới có thể in ra
        request.setAttribute("VEHICLE_LIST", myCars);

        String tierName = currentUser.getTierId().getTierName();
        if ("Silver".equalsIgnoreCase(tierName)) {
            maxAdvanceDays = 10;
        } else if ("Gold".equalsIgnoreCase(tierName)) {
            maxAdvanceDays = 12;
        } else if ("Platinum".equalsIgnoreCase(tierName)) {
            maxAdvanceDays = 14;
        }
    }
    // Gọi DAO để lấy danh sách voucher hợp lệ của Tier này
    // Giả sử em có PromotionDAO và hàm getVouchersByTier
    PromotionDAO pDao = new PromotionDAO();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>New Booking | AutoWashPro</title>
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/style.css">
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
                    <span class="status-badge status-badge--tier">
                        Tier: <c:out value="${sessionScope.USER.tierId.tierName}" default="Member"/>
                    </span>
                </div>
            </div>
        </header>

        <main class="main-wrapper booking-page">
            <div class="booking-page__grid">
                <div class="booking-page__form-section glass-panel">
                    <form id="bookingForm" action="${pageContext.request.contextPath}/BookingController" method="POST">
                        <input type="hidden" name="action" value="createBookingProcess">
                        <input type="hidden" id="tierDiscountPercent" value="${sessionScope.USER.tierId.discountPercent}">
                        <h2 class="booking-page__step-title">Step 1: Vehicle & Schedule</h2>

                        <div class="form-group">
                            <label for="vehicleSelect" class="form-group__label">Select Your Vehicle</label>
                            <div class="form-group__input-wrapper">
                                <select id="vehicleSelect"
                                        name="vehicleID"
                                        class="form-group__input form-group__select"
                                        required>

                                    <option value="" disabled>
                                        -- Choose a registered vehicle --
                                    </option>

                                    <c:forEach items="${VEHICLE_LIST}" var="car">

                                        <option value="${car.vehicleID}"
                                                ${not empty VEHICLE && car.vehicleID == VEHICLE.vehicleID ? 'selected' : ''}>

                                            ${car.licensePlate} - ${car.brand} ${car.model} (${car.color})

                                        </option>

                                    </c:forEach>
                                </select>
                            </div>
                            <a href="${pageContext.request.contextPath}/MainController?action=viewAddVehicle" class="booking-page__add-link">+ Register a new vehicle</a>
                        </div>

                        <div class="grid-cols-2">
                            <div class="form-group">
                                <label for="bookingDate" class="form-group__label">Date</label>
                                <div class="form-group__input-wrapper">
                                    <%-- Khai báo biến todayStr ở đây trước khi sử dụng ở dưới --%>
                                    <%
                                        String todayStr = java.time.LocalDate.now().toString();
                                        String maxDateStr = java.time.LocalDate.now().plusDays(maxAdvanceDays).toString();
                                    %>
                                    <input type="date" id="bookingDate" name="bookingDate" class="form-group__input" min="<%= todayStr%>" max="<%= maxDateStr%>" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="bookingTime" class="form-group__label">Arrival Time (30-min Slot)</label>
                                <div class="form-group__input-wrapper">
                                    <select id="bookingTime" name="bookingTime" class="form-group__input form-group__select" required>
                                        <option value="" disabled selected>-- Select a slot --</option>
                                        <option value="08:00">08:00 AM - 08:30 AM</option>
                                        <option value="08:30">08:30 AM - 09:00 AM</option>
                                        <option value="09:00">09:00 AM - 09:30 AM</option>
                                        <option value="09:30">09:30 AM - 10:00 AM</option>
                                        <option value="10:00">10:00 AM - 10:30 AM</option>
                                        <option value="10:30">10:30 AM - 11:00 AM</option>
                                        <option value="11:00">11:00 AM - 11:30 AM</option>
                                        <option value="11:30">11:30 AM - 12:00 PM</option>
                                        <option value="12:00">12:00 PM - 12:30 PM</option>
                                        <option value="12:30">12:30 PM - 01:00 PM</option>
                                        <option value="13:00">01:00 PM - 01:30 PM</option>
                                        <option value="13:30">01:30 PM - 02:00 PM</option>
                                        <option value="14:00">02:00 PM - 02:30 PM</option>
                                        <option value="14:30">02:30 PM - 03:00 PM</option>
                                        <option value="15:00">03:00 PM - 03:30 PM</option>
                                        <option value="15:30">03:30 PM - 04:00 PM</option>
                                        <option value="16:00">04:00 PM - 04:30 PM</option>
                                        <option value="16:30">04:30 PM - 05:00 PM</option>
                                        <option value="17:00">05:00 PM - 05:30 PM</option>
                                        <option value="17:30">05:30 PM - 06:00 PM</option>
                                        <option value="18:00">06:00 PM - 06:30 PM</option>
                                        <option value="18:30">06:30 PM - 07:00 PM</option>
                                        <option value="19:00">07:00 PM - 07:30 PM</option>
                                        <option value="19:30">07:30 PM - 08:00 PM</option>
                                        <option value="20:00">08:00 PM - 08:30 PM</option>
                                        <option value="20:30">08:30 PM - 09:00 PM</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <% if (request.getAttribute("BOOKING_ERROR") != null) {%>
                        <div class="auth-card__alert auth-card__alert--error">
                            &#9888; <%= request.getAttribute("BOOKING_ERROR")%>
                        </div>
                        <% }%>
                        <h2 class="booking-page__step-title">Step 2: Service Packages</h2>
                        <div class="service-grid">
                            <label class="service-card glass-panel">
                                <input type="radio" name="serviceType" value="Normal Wash" class="service-card__radio" data-price="150000" required>
                                <div class="service-card__content">
                                    <h3 class="service-card__name">Normal Wash</h3>
                                    <p class="service-card__desc">Snow foam wash, basic vacuum, and glass wipe down.</p>
                                    <span class="service-card__price">150,000 đ</span>
                                </div>
                            </label>

                            <label class="service-card glass-panel">
                                <input type="radio" name="serviceType" value="Premium Wash" class="service-card__radio" data-price="300000" required>
                                <div class="service-card__content">
                                    <h3 class="service-card__name service-card__name--premium">Premium Wash</h3>
                                    <p class="service-card__desc">Includes Normal Wash + undercarriage spray & tire dressing.</p>
                                    <span class="service-card__price">300,000 đ</span>
                                </div>
                            </label>
                        </div>

                        <h2 class="booking-page__step-title">Step 3: Choose Your Promotion</h2>
                    <div class="form-group">
                        <label for="voucherSelect" class="form-group__label">Available Vouchers for your ${sessionScope.USER.tierId.tierName} Tier</label>
                        <div class="form-group__input-wrapper">
                           <select id="voucherSelect" name="promoCode" class="form-group__input form-group__select">
                                <option value="0" data-discount="0">-- No voucher selected --</option>
                                <c:forEach items="${VOUCHER_LIST}" var="voucher">
                                    <option value="${voucher.promotionID}" data-discount="${voucher.discountPercent}">
                                            ${voucher.promotionName} - Giảm ${voucher.discountPercent}%                                        
                                        </option>
                                </c:forEach>
                            </select>
                        </div>
                        <span id="voucherStatusMessage" style="font-size: 0.85rem; color: var(--color-text-tertiary); display: block; margin-top: var(--spacing-sm);">
                            Select a voucher to see your savings.
                        </span>
                    </div>

                    <h2 class="booking-page__step-title">Step 4: Special Requests / Notes</h2>
                    <div class="form-group">
                        <div class="form-group__input-wrapper">
                            <textarea id="notes" name="notes" class="form-group__input" rows="3" placeholder="E.g., heavy mud on the undercarriage... Note: Arriving 5+ mins late will result in cancellation."></textarea>
                        </div>
                    </div>
                </form>
                </div>

                <aside class="booking-page__summary-section">
                    <div class="order-summary glass-panel">
                        <h2 class="order-summary__title">ORDER SUMMARY</h2>

                        <div class="order-summary__row">
                            <span class="order-summary__label">VEHICLE</span>
                            <strong id="summaryVehicle" class="order-summary__value">-- Not selected --</strong>
                        </div>

                        <div class="order-summary__row" style="border-bottom: none;">
                            <span class="order-summary__label">SERVICE</span>
                            <strong id="summaryService" class="order-summary__value">-- Not selected --</strong>
                        </div>

                        <div class="order-summary__row" id="summaryDiscountRow" style="display: none; border-bottom: none;">
                            <span class="order-summary__label">VOUCHER</span>
                            <strong id="summaryDiscount" class="order-summary__value" style="color: var(--color-accent-red);">-0 đ</strong>
                        </div>

                        <div class="order-summary__total-row">
                            <span class="order-summary__label">TOTAL</span>
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