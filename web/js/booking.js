document.addEventListener('DOMContentLoaded', function() {
    
    // 1. KHAI BÁO CÁC PHẦN TỬ (Đã bỏ Date và Time)
    const vehicleSelect = document.getElementById('vehicleSelect');
    const serviceRadios = document.querySelectorAll('.service-card__radio');
    
    const userTotalPointsInput = document.getElementById('userTotalPoints');
    const userTotalPoints = userTotalPointsInput ? (parseInt(userTotalPointsInput.value) || 0) : 0;
    
    const pointPaymentWrapper = document.getElementById('pointPaymentWrapper');
    const usePointsCheckbox = document.getElementById('usePointsCheckbox');
    const usePointsLabel = document.getElementById('usePointsLabel');
    const pointStatusMessage = document.getElementById('pointStatusMessage');
    
    const summaryVehicle = document.getElementById('summaryVehicle');
    const summaryService = document.getElementById('summaryService');
    const summaryTotal = document.getElementById('summaryTotal');
    const summaryPoints = document.getElementById('summaryPoints');
    const summaryDiscountRow = document.getElementById('summaryDiscountRow');
    const summaryDiscount = document.getElementById('summaryDiscount');

    let currentServicePrice = 0;

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
            // Đổi viền CSS xanh
            document.querySelectorAll('.service-card').forEach(c => c.classList.remove('service-card--selected'));
            checkedRadio.closest('.service-card').classList.add('service-card--selected');

            // Cập nhật tên dịch vụ
            if (summaryService) summaryService.innerText = checkedRadio.value;
            currentServicePrice = parseInt(checkedRadio.getAttribute('data-price')) || 0;

            // Xử lý thông báo điểm thưởng
            if(pointPaymentWrapper && usePointsLabel && pointStatusMessage && usePointsCheckbox) {
                if (userTotalPoints >= currentServicePrice) {
                    pointPaymentWrapper.style.display = 'flex';
                    usePointsLabel.innerHTML = `Redeem Free Wash (<strong>-${currentServicePrice.toLocaleString('vi-VN')} pts</strong>)`;
                    pointStatusMessage.style.color = '#34d399';
                    pointStatusMessage.innerHTML = `You have <strong>${userTotalPoints.toLocaleString('vi-VN')} pts</strong>. You qualify for a free wash!`;
                } else {
                    pointPaymentWrapper.style.display = 'none';
                    usePointsCheckbox.checked = false;
                    pointStatusMessage.style.color = 'var(--color-text-tertiary)';
                    pointStatusMessage.innerHTML = `You have <strong>${userTotalPoints.toLocaleString('vi-VN')} pts</strong>. You need <strong>${currentServicePrice.toLocaleString('vi-VN')} pts</strong> for this service.`;
                }
            }
        }

        // Tính toán tổng tiền cuối cùng
        let isUsingPoints = usePointsCheckbox && usePointsCheckbox.checked;
        let currentDiscount = isUsingPoints ? currentServicePrice : 0;
        let finalTotal = Math.max(0, currentServicePrice - currentDiscount);

        if(summaryDiscountRow && summaryDiscount) {
            if(currentDiscount > 0) {
                summaryDiscountRow.style.display = 'flex';
                summaryDiscount.innerText = "-" + currentDiscount.toLocaleString('vi-VN') + " đ";
            } else {
                summaryDiscountRow.style.display = 'none';
            }
        }

        if(summaryTotal) summaryTotal.innerText = finalTotal.toLocaleString('vi-VN') + " đ";
        if(summaryPoints) summaryPoints.innerText = "+" + Math.floor(finalTotal / 1000).toLocaleString('vi-VN') + " pts";
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
});