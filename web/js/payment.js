console.log("Payment JS Version 2");
const PAYMENT_TIMEOUT = Math.floor((expiredAt - Date.now()) / 1000);
let remainingSeconds = Math.max(0, PAYMENT_TIMEOUT);
let countdownId = null;

const GOOGLE_SCRIPT_URL =
        "https://script.google.com/macros/s/AKfycbxZbqUMu0s_6ZiW7NozAMh166AceVx3a8she4bc3wXOW9IIE49Dvy-1K4IAzFxGisVz/exec";

let isPaid = false;
let pollingId = null;

document.addEventListener("DOMContentLoaded", () => {

    // Nếu có countdown thì gọi luôn
    // startCountdown();
    startCountdown();
    checkPaid();

    pollingId = setInterval(checkPaid, 3000);

});

let checkingPayment = false;
async function checkPaid() {

    if (isPaid || checkingPayment || remainingSeconds <= 0) {
        return;
    }

    checkingPayment = true;

    try {

        const response = await fetch(GOOGLE_SCRIPT_URL);

        if (!response.ok) {
            console.error("Cannot connect to Google Script");
            return;
        }

        const data = await response.json();

        if (!data.success) {
            return;
        }

        const transaction = data.transaction;

        const lastPrice = Number(transaction["Giá trị"]);
        const lastContent = transaction["Mô tả"];

        console.log("Latest Transaction");
        console.log("Price:", lastPrice);
        console.log("Content:", lastContent);

        console.log("Expected");
        console.log("Price:", totalAmount);
        console.log("Booking Code:", "QR - " + bookingCode);

        if (lastPrice === Number(totalAmount)
                && lastContent.includes(bookingCode)) {

            isPaid = true;

            paymentSuccess();
        }

    } catch (error) {

        console.error("Payment Check Error:", error);

    } finally {

        checkingPayment = false;

    }

}

function startCountdown() {

    updateCountdown();

    countdownId = setInterval(() => {

        if (remainingSeconds <= 0) {

            paymentExpired();
            return;

        }

        remainingSeconds--;

        updateCountdown();

    }, 1000);

}

function updateCountdown() {

    const minute =
            Math.floor(remainingSeconds / 60);

    const second =
            remainingSeconds % 60;

    document.getElementById("countdown").textContent =
            String(minute).padStart(2, "0")
            + ":"
            + String(second).padStart(2, "0");

}

function paymentExpired() {

    clearInterval(countdownId);

    clearInterval(pollingId);

    document.getElementById("countdown").textContent =
            "EXPIRED";

    document.getElementById("countdown").style.color =
            "#ff3b3b";

    document.getElementById("paymentStatus").textContent =
            "Payment expired.";

    document.getElementById("paymentStatusDot").style.background =
            "#ff3b3b";

    document.getElementById("cancelPaymentBtn").textContent =
            "Return to Booking";

}

function paymentSuccess() {

    clearInterval(countdownId);
    clearInterval(pollingId);

    document.getElementById("paymentStatus").textContent =
            "Payment received. Confirming booking...";

    document.getElementById("paymentStatusDot").style.background =
            "#22c55e";

    document.getElementById("countdown").style.color =
            "#22c55e";

    setTimeout(() => {

        window.location.href = "BookingController?action=completeBooking";

    }, 1200);

}