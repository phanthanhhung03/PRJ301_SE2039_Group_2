package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.CustomerPromotionDAO;
import dao.PromotionDAO;
import dto.Booking;
import dto.BookingDraft;
import dto.Customer;
import dto.Promotion;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BookingController", urlPatterns = {"/BookingController"})
public class BookingController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Customer user = (Customer) session.getAttribute("USER");

        // Kiểm tra bảo mật Session
        if (user == null) {
            response.sendRedirect("MainController?action=viewSignIn");
            return;
        }

        try {
            // Lấy biến action từ form gửi lên để phân chia nhiệm vụ
            String action = request.getParameter("action");

            // =========================================================
            // NHÁNH 1: HỦY LỊCH
            // =========================================================
            if ("cancelBooking".equals(action)) {
                int bookingID = Integer.parseInt(request.getParameter("bookingID"));
                BookingDAO dao = new BookingDAO();

                Booking b = dao.getBookingByID(bookingID);
                if (b == null) {
                    session.setAttribute("ERROR", "Booking not found.");
                    response.sendRedirect("MainController?action=viewDashBoard");
                    return;
                }

                boolean isSuccess = dao.cancelBooking(bookingID);

                if (isSuccess) {
                    CustomerDAO cDao = new CustomerDAO();
                    
                    double multiplier = user.getTierId().getPointMultiplier();
                    int deductPoints = (int) Math.floor((b.getFinalAmount() / 1000) * multiplier);
                    double refundAmount = b.getFinalAmount();

                    cDao.processCancellationRefund(user.getCusId(), deductPoints, refundAmount);
                    cDao.checkAndUpdateTier(user.getCusId());

                    Customer updatedUser = cDao.getCustomer(user.getCusId());
                    if (updatedUser != null) {
                        session.setAttribute("USER", updatedUser);
                    }

                    session.setAttribute("MSG", "Booking cancelled successfully! " + deductPoints + " reward points were deducted and " + refundAmount + " VNĐ has been refunded to your wallet.");
                } else {
                    session.setAttribute("ERROR", "Failed to cancel booking. Please try again.");
                }

                response.sendRedirect("MainController?action=viewDashBoard");
                return;

            // =========================================================
            // NHÁNH 2: TẠO LỊCH MỚI → Validate + Tính tiền + Tạo BookingDraft + Lưu Session
            // =========================================================
            } else if ("createBookingProcess".equals(action)) {

                // 1. LẤY DỮ LIỆU TỪ FORM
                int vehicleID    = Integer.parseInt(request.getParameter("vehicleID"));
                String dateStr   = request.getParameter("bookingDate");
                String timeStr   = request.getParameter("bookingTime");
                String serviceType = request.getParameter("serviceType");
                String notes     = request.getParameter("notes");

                // 2. VALIDATE NGÀY
                java.time.LocalDate inputDate = java.time.LocalDate.parse(dateStr);
                java.time.LocalDate today     = java.time.LocalDate.now();

                if (inputDate.isBefore(today)) {
                    request.setAttribute("BOOKING_ERROR", "Invalid booking date. Please select a future date.");
                    request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                    return;
                }

                // VALIDATE GIỚI HẠN ĐẶT LỊCH THEO TIER
                int maxDays = 7;
                String tierName = user.getTierId().getTierName();
                if ("Silver".equalsIgnoreCase(tierName))   maxDays = 10;
                else if ("Gold".equalsIgnoreCase(tierName))     maxDays = 12;
                else if ("Platinum".equalsIgnoreCase(tierName)) maxDays = 14;

                String dateTimeStr = dateStr + " " + timeStr + ":00";
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                java.util.Date parsedDate = dateFormat.parse(dateTimeStr);
                Timestamp bookingTimestamp = new Timestamp(parsedDate.getTime());

                long maxMillis = System.currentTimeMillis() + (maxDays * 24L * 60L * 60L * 1000L);
                if (bookingTimestamp.after(new Timestamp(maxMillis))) {
                    request.setAttribute("BOOKING_ERROR", tierName + " tier privileges only allow booking up to " + maxDays + " days in advance.");
                    request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                    return;
                }

                // VALIDATE TRÙNG SLOT
                BookingDAO checkDao = new BookingDAO();
                // Phải thêm ":00" vào timeStr vì trong DB TimeSlot được lưu dưới dạng "HH:mm:ss"
                if (checkDao.isSlotBooked(dateStr, timeStr + ":00")) {
                    request.setAttribute("BOOKING_ERROR", "This time slot has already been booked. Please choose a different time!");
                    request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                    return;
                }

                // 3. TÍNH GIÁ GỐC
                double totalAmount = 0;
                if ("Normal Wash".equals(serviceType))   totalAmount = 150000;
                else if ("Premium Wash".equals(serviceType)) totalAmount = 300000;

                // 4. TÍNH TOÁN GIẢM GIÁ (TIER + VOUCHER)
                double discountAmount = 0;

                // 4.1 Giảm giá mặc định theo Tier (Ví dụ Silver giảm 5%)
                double tierDiscountPercent = user.getTierId().getDiscountPercent();
                double tierDiscountAmount = totalAmount * (tierDiscountPercent / 100.0);
                discountAmount += tierDiscountAmount;

                // 4.2 KIỂM TRA VÀ ÁP DỤNG VOUCHER BẰNG DAO
                String promoCodeStr = request.getParameter("promoCode");
                int promoID = 0;
                double voucherDiscount = 0;
                CustomerPromotionDAO cpDao = new CustomerPromotionDAO();

                if (promoCodeStr != null && !promoCodeStr.equals("0")) {
                    try {
                        promoID = Integer.parseInt(promoCodeStr);
                        PromotionDAO pDao = new PromotionDAO();

                        boolean eligibleByTier = pDao.isCustomerEligibleByTier(user.getCusId(), promoID);
                        boolean eligibleByAssignment = cpDao.hasActiveAssignment(user.getCusId(), promoID);

                        // When Customer has used this Promotion
                        if (cpDao.hasCustomerUsedPromotion(user.getCusId(), promoID)) {
                            request.setAttribute("BOOKING_ERROR", "You have already used this voucher before!");
                            request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                            return;
                        }

                        if (eligibleByTier || eligibleByAssignment) {

                            Promotion p = pDao.getPromotionByID(promoID);
                            if (p != null && p.isStatus()) {
                                voucherDiscount = totalAmount * (p.getDiscountPercent() / 100.0);
                                discountAmount += voucherDiscount;
                            } else {
                                request.setAttribute("BOOKING_ERROR", "This voucher is expired or unavailable!");
                                request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                                return;
                            }

                        } else {
                            request.setAttribute("BOOKING_ERROR", "This voucher is not applicable for your account!");
                            request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                            return;
                        }

                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }
                }

                // Chốt số tiền cuối cùng (Đảm bảo không bao giờ bị âm tiền)
                double finalAmount = totalAmount - discountAmount;
                if (finalAmount < 0) {
                    finalAmount = 0;
                }

                // 7. TẠO BOOKING DRAFT VÀ LƯU SESSION
                BookingDraft draft = new BookingDraft();
                draft.setCustomerId(user.getCusId());
                draft.setVehicleId(vehicleID);
                draft.setPromotionId(promoID);
                draft.setServiceType(serviceType);
                draft.setBookingDate(Date.valueOf(dateStr));
                draft.setBookingTime(Time.valueOf(timeStr + ":00"));
                draft.setTotalAmount(totalAmount);
                draft.setVoucherDiscount(voucherDiscount);
                draft.setTierDiscount(tierDiscountAmount);
                draft.setFinalAmount(finalAmount);
                draft.setNotes(notes);
                draft.setBookingCode("BK" + user.getCusId() + " " + System.currentTimeMillis());
                draft.setExpiredAt(System.currentTimeMillis() + 10 * 60 * 1000L);

                session.setAttribute("BOOKING_DRAFT", draft);

                // 8. CHUYỂN QUA PAYMENT SERVLET ĐỂ HIỂN THỊ TRANG THANH TOÁN
                // Dùng forward thay vì sendRedirect để giữ lại toàn bộ dữ liệu request.getParameter cho PaymentServlet
                request.getRequestDispatcher("/PaymentServlet").forward(request, response);
                return;

            // =========================================================
            // NHÁNH 3: HOÀN TẤT BOOKING SAU KHI THANH TOÁN THÀNH CÔNG
            // Lấy BOOKING_DRAFT → insertBooking → Update Voucher → Update Customer → Xóa Session
            // =========================================================
            } else if ("completeBooking".equals(action)) {

                BookingDraft draft = (BookingDraft) session.getAttribute("BOOKING_DRAFT");

                if (draft == null) {
                    response.sendRedirect("MainController?action=viewNewBooking");
                    return;
                }

                // Kiểm tra hết hạn
                if (System.currentTimeMillis() > draft.getExpiredAt()) {
                    session.removeAttribute("BOOKING_DRAFT");
                    session.setAttribute("ERROR", "Payment session expired. Please try again.");
                    response.sendRedirect("MainController?action=viewNewBooking");
                    return;
                }

                // RE-VALIDATE trước khi insertBooking
                // 1. Kiểm tra ngày không được là ngày quá khứ
                java.time.LocalDate bookingLocalDate = draft.getBookingDate().toLocalDate();
                if (bookingLocalDate.isBefore(java.time.LocalDate.now())) {
                    session.removeAttribute("BOOKING_DRAFT");
                    session.setAttribute("BOOKING_ERROR", "Booking date has already passed. Please create a new booking.");
                    response.sendRedirect("MainController?action=viewNewBooking");
                    return;
                }

                // 2. Re-validate trùng slot (ai đó có thể đã đặt trong lúc user đang thanh toán)
                BookingDAO dao = new BookingDAO();
                String dateStr = draft.getBookingDate().toString();
                String timeStr = draft.getBookingTime().toString();
                if (dao.isSlotBooked(dateStr, timeStr)) {
                    session.removeAttribute("BOOKING_DRAFT");
                    session.setAttribute("BOOKING_ERROR", "Sorry, this time slot was just booked by someone else. Please choose a different time.");
                    response.sendRedirect("MainController?action=viewNewBooking");
                    return;
                }

                // Xây dựng Booking từ BookingDraft
                Booking booking = new Booking();
                booking.setVehicleID(draft.getVehicleId());

                Timestamp bookingTimestamp = Timestamp.valueOf(
                        draft.getBookingDate().toString()
                        + " "
                        + draft.getBookingTime().toString());
                booking.setBookingDate(bookingTimestamp);
                booking.setTimeSlot(draft.getBookingTime().toString());
                booking.setServiceType(draft.getServiceType());
                booking.setBookingStatus("Pending");
                booking.setNotes(draft.getNotes() != null ? draft.getNotes() : "");
                booking.setTotalAmount(draft.getTotalAmount());
                booking.setDiscountAmount(draft.getVoucherDiscount() + draft.getTierDiscount());
                booking.setFinalAmount(draft.getFinalAmount());
                booking.setPaymentStatus(true);

                boolean isSuccess = dao.insertBooking(booking);

                if (isSuccess) {

                    // Update Voucher (đánh dấu đã sử dụng)
                    int promoID = draft.getPromotionId();
                    if (promoID != 0) {
                        CustomerPromotionDAO cpDao = new CustomerPromotionDAO();
                        cpDao.markAsUsed(user.getCusId(), promoID);
                    }

                    // Update Customer (điểm + số lượt + tier)
                    CustomerDAO cDao = new CustomerDAO();
                    cDao.updateCustomerAfterBookingCreated(user.getCusId(), draft.getFinalAmount());
                    cDao.checkAndUpdateTier(user.getCusId());   

                    // Refresh session USER
                    Customer updatedUser = cDao.getCustomer(user.getCusId());
                    if (updatedUser != null) {
                        session.setAttribute("USER", updatedUser);
                    }

                    // Xóa Session Draft
                    session.removeAttribute("BOOKING_DRAFT");

                    session.setAttribute("MSG", "Booking created successfully! Thank you for your payment.");
                    response.sendRedirect("MainController?action=viewDashBoard");

                } else {
                    session.setAttribute("ERROR", "Failed to create booking. Please contact support.");
                    response.sendRedirect("MainController?action=viewDashBoard");
                }

                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MainController?action=viewDashBoard");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
