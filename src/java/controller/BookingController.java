package controller;

    import dao.BookingDAO;
    import dto.Booking;
    import dto.Customer;
    import java.io.IOException;
    import java.sql.Timestamp;
    import java.text.SimpleDateFormat;
    import java.util.Date;
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
                // NHÁNH 1: XỬ LÝ HỦY LỊCH 
                // =========================================================
                if ("cancelBooking".equals(action)) {
                    int bookingID = Integer.parseInt(request.getParameter("bookingID"));
                    BookingDAO dao = new BookingDAO();

                    // 1. THỰC HIỆN HỦY LỊCH NGAY LẬP TỨC (Đổi Status thành Cancelled)
                    boolean isSuccess = dao.cancelBooking(bookingID);

                    if (isSuccess) {
                        // 2. GỌI HÀM DAO CẬP NHẬT DỮ LIỆU & QUÉT LẠI HẠNG
                        dao.CustomerDAO cDao = new dao.CustomerDAO();
                        cDao.updateCustomerAfterCancelled(user.getCusId()); 
                        cDao.checkAndUpdateTier(user.getCusId()); 

                        // Cách này an toàn tuyệt đối, hệ thống tự động load điểm mới, lượt mới và Hạng mới nhất!
                        dto.Customer updatedUser = cDao.getCustomer(user.getCusId());
                        if (updatedUser != null) {
                            session.setAttribute("USER", updatedUser); 
                        }
                        
                        session.setAttribute("MSG", "Booking cancelled successfully! Notice: 20 points were deducted for cancellation.");
                    } else {
                        session.setAttribute("ERROR", "Failed to cancel booking. Please try again.");
                    }

                    response.sendRedirect("MainController?action=viewDashBoard");
                    return; 
                }

                // =========================================================
                // NHÁNH 2: TẠO LỊCH MỚI
                // =========================================================
                else if ("createBookingProcess".equals(action)) {
                    // 1. LẤY DỮ LIỆU TỪ FORM JSP GỬI LÊN
                    int vehicleID = Integer.parseInt(request.getParameter("vehicleID"));
                    String dateStr = request.getParameter("bookingDate"); 
                    String timeStr = request.getParameter("bookingTime"); 
                    String serviceType = request.getParameter("serviceType");
                    String notes = request.getParameter("notes");
                    
                    // 2. CHUYỂN ĐỔI NGÀY & GIỜ THÀNH JAVA.SQL.TIMESTAMP
                    String dateTimeStr = dateStr + " " + timeStr + ":00";
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    Date parsedDate = dateFormat.parse(dateTimeStr);
                    Timestamp bookingDate = new Timestamp(parsedDate.getTime());

                    // BẮT ĐẦU CHỐT CHẶN BẢO MẬT NGÀY THÁNG
                    java.time.LocalDate inputDate = java.time.LocalDate.parse(dateStr);
                    java.time.LocalDate today = java.time.LocalDate.now();

                    if (inputDate.isBefore(today)) {
                        request.setAttribute("BOOKING_ERROR", "Invalid booking date. Please select a future date.");
                        request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                        return; 
                    }
                    // KIỂM TRA GIỚI HẠN ÐAT LICH THEO TIER
                    int maxDays = 7;
                    String tierName = user.getTierId().getTierName();
                    if ("Silver".equalsIgnoreCase(tierName)) maxDays = 10;
                    else if ("Gold".equalsIgnoreCase(tierName)) maxDays = 12;
                    else if ("Platinum".equalsIgnoreCase(tierName)) maxDays = 14;

                    // Tính toán thời gian giới hạn cuối cùng (Max allowed time)
                    long maxMillis = System.currentTimeMillis() + (maxDays * 24L * 60L * 60L * 1000L);
                    Timestamp maxAllowedTime = new Timestamp(maxMillis);

                    // Hàm after() trả về true nếu ngày khách gửi lên nằm xa hơn ngày giới hạn
                    if (bookingDate.after(maxAllowedTime)) {
                        request.setAttribute("BOOKING_ERROR", tierName + " tier privileges only allow booking up to " + maxDays + " days in advance.");
                        request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                        return; // Dừng hệ thống
                    }
                    // CHỐT CHẶN TRÙNG LỊCH 
                    BookingDAO checkDao = new BookingDAO();
                    boolean isBooked = checkDao.isSlotBooked(dateStr, timeStr);
                    if (isBooked) {
                        request.setAttribute("BOOKING_ERROR", "This time slot has already been booked. Please choose a different time!");
                        request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                        return; 
                    }

                    // 3. TÍNH TOÁN GIÁ TIỀN GỐC DỊCH VỤ
                    double totalAmount = 0;
                    if (serviceType.equals("Normal Wash")) { 
                        totalAmount = 150000;
                    } else if (serviceType.equals("Premium Wash")) {
                        totalAmount = 300000;
                    } 
                    
                    // 4. TÍNH TOÁN GIẢM GIÁ (TIER + VOUCHER)
                    double discountAmount = 0;

                    // 4.1 Giảm giá mặc định theo Tier (Ví dụ Silver giảm 5%)
                    double tierDiscountPercent = user.getTierId().getDiscountPercent(); 
                    double tierDiscountAmount = totalAmount * (tierDiscountPercent / 100.0);
                    discountAmount += tierDiscountAmount;

                      // 4.2 KIỂM TRA VÀ ÁP DỤNG VOUCHER BẰNG DAO
                    String promoCodeStr = request.getParameter("promoCode");
                    int promoID = 0;
                    boolean usedPersonalAssignment = false; // MỚI

                    if (promoCodeStr != null && !promoCodeStr.equals("0")) {
                        try {
                        promoID = Integer.parseInt(promoCodeStr);
                        dao.PromotionDAO pDao = new dao.PromotionDAO();
                        dao.CustomerPromotionDAO cpDao = new dao.CustomerPromotionDAO(); // MỚI

                        boolean eligibleByTier = pDao.isVoucherValidForTier(promoID, user.getTierId().getTierID());
                        boolean eligibleByAssignment = cpDao.hasActiveAssignment(user.getCusId(), promoID); // MỚI

                            if (eligibleByTier || eligibleByAssignment) {

                            dto.Promotion p = pDao.getPromotionByID(promoID);

                            if (p != null && p.isStatus()) {
                                double voucherDiscount = totalAmount * (p.getDiscountPercent() / 100.0);
                                discountAmount += voucherDiscount;
                                usedPersonalAssignment = eligibleByAssignment; // MỚI — nhớ là dùng voucher cá nhân
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

                    // 5. ĐÓNG GÓI DỮ LIỆU VÀO DTO
                    Booking booking = new Booking();
                    booking.setVehicleID(vehicleID);
                    booking.setBookingDate(bookingDate);
                    booking.setTimeSlot(timeStr);
                    booking.setServiceType(serviceType);
                    booking.setBookingStatus("Pending"); 
                    booking.setNotes(notes);
                    booking.setTotalAmount(totalAmount);
                    booking.setDiscountAmount(discountAmount);
                    booking.setFinalAmount(finalAmount);

                    // 6. GỌI DAO ĐỂ THỰC THI
                    BookingDAO dao = new BookingDAO();
                    boolean isSuccess = dao.insertBooking(booking);

                    if (isSuccess) {
                    if (usedPersonalAssignment) {
                        new dao.CustomerPromotionDAO().markAssignmentUsed(user.getCusId(), promoID); // MỚI
                    }
                    user.setTotalBooking(user.getTotalBooking() + 1);
                    session.setAttribute("MSG", "Booking created successfully!");
                    response.sendRedirect("MainController?action=viewDashBoard");
                    } else {
                        request.setAttribute("BOOKING_ERROR", "Failed to create appointment. Please try again.");
                        request.getRequestDispatcher("/customer/bookingpage.jsp").forward(request, response);
                    }
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