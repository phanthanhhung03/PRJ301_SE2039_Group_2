// Đợi HTML tải xong mới chạy code để tránh lỗi không tìm thấy ID
document.addEventListener('DOMContentLoaded', function() {
    
    // 1. Khai báo các phần tử DOM
    const vehicleSelect = document.getElementById('vehicleSelect');
    const serviceRadios = document.querySelectorAll('.service-card__radio');
    
    const summaryVehicle = document.getElementById('summaryVehicle');
    const summaryService = document.getElementById('summaryService');
    const summaryTotal = document.getElementById('summaryTotal');
    const summaryPoints = document.getElementById('summaryPoints');

    // 2. Lắng nghe sự kiện người dùng chọn Biển số xe
    if(vehicleSelect) {
        vehicleSelect.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            // Lấy biển số từ thuộc tính data-name gán sang Hóa đơn
            summaryVehicle.innerText = selectedOption.getAttribute('data-name');
        });
    }

    // 3. Lắng nghe sự kiện người dùng chọn Gói dịch vụ
    serviceRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            
            // Bước A: Gỡ bỏ viền sáng (class highlight) của TẤT CẢ các thẻ
            document.querySelectorAll('.service-card').forEach(card => {
                card.classList.remove('service-card--selected');
            });

            // Bước B: Thêm viền sáng cho thẻ đang được click
            if(this.checked) {
                const parentCard = this.closest('.service-card');
                parentCard.classList.add('service-card--selected');

                /// Bước C: Cập nhật thông tin sang Hóa Đơn Tạm Tính
                summaryService.innerText = this.value;
                
                // Lấy giá tiền và format định dạng (Ví dụ: 300000 -> 300,000 đ)
                const price = parseInt(this.getAttribute('data-price'));
                summaryTotal.innerText = price.toLocaleString('vi-VN') + " đ";
                
                // CẬP NHẬT MỚI: Tính điểm thưởng = Số tiền / 1000
                // Dùng Math.floor() để làm tròn xuống, tránh bị lẻ số thập phân nếu giá tiền bị lẻ
                const earnedPoints = Math.floor(price / 1000);
                summaryPoints.innerText = "+" + earnedPoints.toLocaleString('vi-VN') + " pts";
            }
        });
    });
});