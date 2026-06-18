document.addEventListener('DOMContentLoaded', function() {
    
    // 1. KHAI BÁO CÁC PHẦN TỬ (Đã bỏ Date và Time)
    const vehicleSelect = document.getElementById('vehicleSelect');
    const serviceRadios = document.querySelectorAll('.service-card__radio');
    
    const userTotalPointsInput = document.getElementById('userTotalPoints');
    const userTotalPoints = userTotalPointsInput ? (parseInt(userTotalPointsInput.value) || 0) : 0;
    
    const voucherSelect = document.getElementById('voucherSelect');
    const voucherStatusMessage = document.getElementById('voucherStatusMessage');
    
    const summaryVehicle = document.getElementById('summaryVehicle');
    const summaryService = document.getElementById('summaryService');
    const summaryTotal = document.getElementById('summaryTotal');
    const summaryPoints = document.getElementById('summaryPoints');
    const summaryDiscountRow = document.getElementById('summaryDiscountRow');
    const summaryDiscount = document.getElementById('summaryDiscount');

    let currentServicePrice = 0;
    
    // === CODE MỚI: CHẶN NGÀY GIỜ QUÁ KHỨ ===
    if (bookingDate && bookingTime) {
        // Lấy ngày hiện tại chuẩn theo múi giờ máy tính
        const now = new Date();
        const yyyy = now.getFullYear();
        const mm = String(now.getMonth() + 1).padStart(2, '0');
        const dd = String(now.getDate()).padStart(2, '0');
        const todayStr = `${yyyy}-${mm}-${dd}`; // Định dạng YYYY-MM-DD
        
        // 1. Chặn chọn ngày quá khứ trong bộ lịch
        bookingDate.setAttribute('min', todayStr);

        // 2. Hàm kiểm tra và khóa các Slot giờ đã trôi qua nếu chọn ngày hôm nay
        function validateTimeSlots() {
            if (bookingDate.value === todayStr) {
                const currentHour = now.getHours();
                const currentMinute = now.getMinutes();

                Array.from(bookingTime.options).forEach(option => {
                    if (option.value) { // Bỏ qua dòng placeholder "-- Select a slot --"
                        const [optHour, optMinute] = option.value.split(':').map(Number);
                        // Nếu giờ option < giờ hiện tại (hoặc bằng giờ nhưng phút < phút hiện tại) -> Khóa lại
                        if (optHour < currentHour || (optHour === currentHour && optMinute <= currentMinute)) {
                            option.disabled = true;
                        } else {
                            option.disabled = false;
                        }
                    }
                });
                
                // Nếu slot khách đang chọn vô tình bị khóa (do thời gian vừa trôi qua), reset lại ô chọn giờ
                if (bookingTime.options[bookingTime.selectedIndex] && bookingTime.options[bookingTime.selectedIndex].disabled) {
                    bookingTime.selectedIndex = 0; 
                    if(summaryTime) summaryTime.innerText = "--:--"; // Reset luôn bên Hóa đơn
                }
            } else {
                // Nếu chọn ngày tương lai, mở khóa tất cả các slot giờ
                Array.from(bookingTime.options).forEach(option => {
                    option.disabled = false;
                });
            }
        }

        // Gắn sự kiện để mỗi lần đổi ngày là quét lại slot giờ
        bookingDate.addEventListener('change', validateTimeSlots);
        
        // Chạy ngay lần đầu tiên khi vừa load trang
        validateTimeSlots(); 
    }
    // ========================================
    // --- HÀM 1: CẬP NHẬT XE ---
    function updateVehicle() {
        if (vehicleSelect && summaryVehicle && vehicleSelect.selectedIndex > 0) {
            summaryVehicle.innerText = vehicleSelect.options[vehicleSelect.selectedIndex].getAttribute('data-name') || "-- Not selected --";
        }
    }

    // --- HÀM 2: CẬP NHẬT DỊCH VỤ VÀ TÍNH TIỀN ---
    function updateServiceAndTotal() {
        let checkedRadio = Array.from(serviceRadios).find(r => r.checked);

        if (checkedRadio) {
            // 1. Đổi viền CSS xanh cho gói dịch vụ được chọn
            document.querySelectorAll('.service-card').forEach(c => c.classList.remove('service-card--selected'));
            checkedRadio.closest('.service-card').classList.add('service-card--selected');

            // 2. BẮT CHỮ VÀ HIỂN THỊ LÊN BILL BÊN PHẢI (Chỗ b đang thiếu)
            if (summaryService) {
                summaryService.innerText = checkedRadio.value; // Lấy chữ 'Premium Wash' từ thuộc tính value
            }

            // 3. Lấy giá tiền gốc
            currentServicePrice = parseInt(checkedRadio.getAttribute('data-price')) || 0;

            // 4. Lấy % giảm giá của Tier từ input hidden (mặc định)
            let tierInput = document.getElementById('tierDiscountPercent');
            let tierPercent = tierInput ? (parseFloat(tierInput.value) || 0) : 0;
            
            // 5. Lấy % giảm giá của Voucher (nếu có chọn)
            let voucherPercent = 0;
            if (voucherSelect) {
                let selectedOption = voucherSelect.options[voucherSelect.selectedIndex];
                voucherPercent = parseFloat(selectedOption.getAttribute('data-discount')) || 0;                   
            }
            
            // 6. TÍNH TOÁN CỘNG DỒN TRÊN GIAO DIỆN
            let tierDiscountAmount = (currentServicePrice * tierPercent) / 100;
            let voucherDiscountAmount = (currentServicePrice * voucherPercent) / 100;
            
            // Tổng tiền được giảm = Mặc định hạng + Voucher
            let totalDiscountAmount = tierDiscountAmount + voucherDiscountAmount;
            
            // Không để tiền bị âm
            let finalTotal = Math.max(0, currentServicePrice - totalDiscountAmount);

            // 7. Hiển thị phần giảm giá trong bảng Summary
            if (summaryDiscountRow && summaryDiscount) {
                if (totalDiscountAmount > 0) {
                    summaryDiscountRow.style.display = 'flex';
                    // Hiển thị tổng số tiền đã được giảm
                    summaryDiscount.innerText = "-" + totalDiscountAmount.toLocaleString('vi-VN') + " đ";
                } else {
                    summaryDiscountRow.style.display = 'none';
                }
            }
            
            // 8. Cập nhật tổng tiền và điểm tích lũy
            if (summaryTotal) summaryTotal.innerText = finalTotal.toLocaleString('vi-VN') + " đ";
            if (summaryPoints) summaryPoints.innerText = "+" + Math.floor(finalTotal / 1000).toLocaleString('vi-VN') + " pts";
        }
    }

    // --- HÀM TỔNG HỢP: ĐỒNG BỘ TOÀN BỘ GIAO DIỆN ---
    function syncAllData() {
        updateVehicle();
        updateServiceAndTotal();
    }

    // 2. GẮN SỰ KIỆN LẮNG NGHE
    if(vehicleSelect) vehicleSelect.addEventListener('change', syncAllData);
    serviceRadios.forEach(r => r.addEventListener('change', syncAllData));
    if(usePointsCheckbox) usePointsCheckbox.addEventListener('change', syncAllData);

    // 3. KHỞI CHẠY QUÉT DỮ LIỆU ĐỂ TRỊ LỖI CACHE TRÌNH DUYỆT
    syncAllData(); // Lần 1: Chạy ngay lập tức khi load xong HTML
    setTimeout(syncAllData, 100); // Lần 2: Quét lại sau 0.1 giây để bắt dữ liệu Autocomplete
    setTimeout(syncAllData, 500); // Lần 3: Quét lần cuối sau 0.5 giây cho chắc chắn
    
    // 4. CODE CHẶN NGÀY GIỜ TRONG QUÁ KHỨ 
    const dateInput = document.getElementById("bookingDate");
    const timeInput = document.getElementById("bookingTime");

    // Chỉ chạy khi ở trang có form Booking
    if (dateInput && timeInput) {
        
        
        // Hàm kiểm tra và chặn Giờ
        function validateTime() {
            const selectedDate = dateInput.value;
            const selectedTime = timeInput.value;

            if (!selectedDate) return;

            const currentTime = new Date();
            const currentDateString = currentTime.toISOString().split('T')[0];

            // Nếu chọn ngày hôm nay
            if (selectedDate === currentDateString) {
                const currentHours = String(currentTime.getHours()).padStart(2, '0');
                const currentMinutes = String(currentTime.getMinutes()).padStart(2, '0');
                const currentTimeString = `${currentHours}:${currentMinutes}`;

                timeInput.setAttribute('min', currentTimeString);

                // Cảnh báo nếu giờ đã lỡ chọn nằm trong quá khứ
                if (selectedTime && selectedTime < currentTimeString) {
                    alert("You cannot book an appointment in a past time slot!");
                    timeInput.value = ""; 
                }
            } else {
                timeInput.removeAttribute('min');
            }
        }

        dateInput.addEventListener('change', validateTime);
        timeInput.addEventListener('change', validateTime);
    }
});