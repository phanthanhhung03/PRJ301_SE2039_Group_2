<%-- 
    Document   : payment
    Created on : Jun 25, 2026, 6:37:31 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty USER}">
    <c:redirect url="MainController?action=viewAdminSignIn"/>
</c:if>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PAYMENT | AutoWashPro</title>
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        <!-- NAVIGATION -->
        <header class="site-header">
            <div class="site-header__container main-wrapper">
                <a href="${pageContext.request.contextPath}/MainController?action=viewDashborad" class="site-header__logo">
                    <div class="site-header__logo-icon"></div>
                    <div class="site-header__logo-text">AUTOWASH<span>PRO</span></div>
                </a>

                <div class="site-header__actions">
                    <c:choose>
                        <c:when test="${USER.tierId.tierName eq 'Member'}">
                            <span class="status-badge status-badge--member">
                                MEMBER
                            </span>
                        </c:when>

                        <c:when test="${USER.tierId.tierName eq 'Silver'}">
                            <span class="status-badge status-badge--silver">
                                SILVER
                            </span>
                        </c:when>

                        <c:when test="${USER.tierId.tierName eq 'Gold'}">
                            <span class="status-badge status-badge--gold">
                                GOLD
                            </span>
                        </c:when>

                        <c:otherwise>
                            <span class="status-badge status-badge--platinum">
                                PLATINUM
                            </span>
                        </c:otherwise>
                    </c:choose>
                    <a href="MainController?action=logout" class="btn btn--secondary btn--sm">Logout</a>
                </div>
            </div>
        </header>
        <main class="main-wrapper" style="margin-top: var(--spacing-xl);">

            <!-- PAYMENT HEADER -->
            <div style="display:flex;
                 justify-content:space-between;
                 align-items:center;
                 margin-bottom:var(--spacing-xl);">

                <div>

                    <span style="
                          font-size:0.75rem;
                          font-weight:700;
                          color:var(--color-accent-cyan);
                          text-transform:uppercase;
                          letter-spacing:.1em;">

                        Secure Payment

                    </span>

                    <h1 style="
                        font-size:2rem;
                        margin-top:var(--spacing-xs);">

                        Complete Payment

                    </h1>

                    <p style="
                       color:var(--color-text-secondary);
                       margin-top:var(--spacing-sm);">

                        Scan the QR code below to complete your booking.
                        Your booking will be confirmed automatically after payment.

                    </p>

                </div>

                <a href="${pageContext.request.contextPath}/MainController?action=viewNewBooking"
                   class="btn btn--secondary btn--sm">

                    ← Back to Booking

                </a>

            </div>


            <!-- PAYMENT CONTENT -->

            <section style="
                     display:grid;
                     grid-template-columns:minmax(650px, 2fr) 380px;
                     gap:var(--spacing-xl);">


                <!-- LEFT -->

                <div class="glass-panel"
                     style="
                     padding:var(--spacing-xl);
                     border-radius:var(--radius-lg);">


                    <h2 style="
                        text-align:center;
                        margin-bottom:var(--spacing-lg);">

                        Scan QR Code

                    </h2>


                    <!-- QR -->

                    <div style="
                         display:flex;
                         justify-content:center;
                         margin-bottom:var(--spacing-xl);">

                        <img src="https://img.vietqr.io/image/bidv-V3CASSHUNGPHAN-print.png?amount=${total/10}&addInfo=${BOOKING_DRAFT.bookingCode}"
                             alt="QR Payment"
                             style="
                             width:400px;
                             background:white;
                             padding:18px;
                             border-radius:18px;">

                    </div>


                    <!-- TIMER -->

                    <div style="
                         text-align:center;
                         margin-bottom:var(--spacing-xl);">

                        <small
                            style="color:var(--color-text-secondary);">
                            Remaining Time
                        </small>

                        <h2 id="countdown"
                            style="
                            color:var(--color-accent-red);
                            margin-top:var(--spacing-xs);">

                            10:00

                        </h2>

                    </div>

                    <!-- STATUS -->

                    <div style="
                         display:flex;
                         justify-content:center;
                         align-items:center;
                         gap:.6rem;
                         margin-bottom:var(--spacing-xl);">

                        <span id="paymentStatusDot"
                              style="
                              width:10px;
                              height:10px;
                              background:#00d26a;
                              border-radius:50%;"></span>

                        <span id="paymentStatus">
                            Waiting for payment...
                        </span>

                    </div>

                    <div style="margin-top:var(--spacing-xl);">

                        <a id="cancelPaymentBtn"
                           href="${pageContext.request.contextPath}/MainController?action=viewNewBooking"
                           class="btn btn--outline btn--block">

                            Cancel Payment

                        </a>

                    </div>

                </div>



                <!-- ORDER SUMMARY -->

                <aside>

                    <div class="order-summary glass-panel">

                        <h2 class="order-summary__title">

                            ORDER SUMMARY

                        </h2>

                        <div class="order-summary__row">

                            <span class="order-summary__label">

                                VEHICLE

                            </span>

                            <strong class="order-summary__value">

                                ${requestScope.vehicleInfo}
                            </strong>

                        </div>

                        <div class="order-summary__row">

                            <span class="order-summary__label">

                                SERVICE

                            </span>

                            <strong class="order-summary__value">

                                ${requestScope.serviceType}

                            </strong>

                        </div>

                        <div class="order-summary__row">

                            <span class="order-summary__label">

                                VOUCHER

                            </span>

                            <strong class="order-summary__value">

                                ${promotion.promotionName} (-${voucherDiscount}đ)

                            </strong>

                        </div>

                        <div class="order-summary__row">

                            <span class="order-summary__label">

                                ${fn:toUpperCase(sessionScope.USER.tierId.tierName)} DISCOUNT 

                            </span>

                            <strong class="order-summary__value">

                                -${tierDiscount}đ

                            </strong>

                        </div>

                        <div class="order-summary__total-row">

                            <span class="order-summary__label">

                                TOTAL

                            </span>

                            <strong class="order-summary__total">

                                ${total}

                            </strong>

                        </div>

                        <div class="order-summary__points">

                            Loyalty Reward:
                            <strong>+${rewardPoint} pts</strong>

                        </div>

                    </div>

                </aside>

            </section>

        </main>


        <footer class="site-footer"
                style="margin-top: var(--spacing-xxl);">

            <div class="site-footer__container main-wrapper">

                <div class="site-footer__bottom">

                    <p>

                        &copy; 2026 AutoWashPro.
                        Secure Online Payment.

                    </p>

                    <a href="${pageContext.request.contextPath}/home.jsp"
                       class="site-footer__staff-link">

                        Return to Home

                    </a>

                </div>

            </div>

        </footer>

        <script>

            const bookingCode = "${BOOKING_DRAFT.bookingCode}";
            const totalAmount = ${BOOKING_DRAFT.totalAmount / 10};
            const expiredAt = ${BOOKING_DRAFT.expiredAt};
        </script>

        <script src="${pageContext.request.contextPath}/js/payment.js"></script>
    </body>
</html>
