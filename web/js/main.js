/**
 * AutoWash Pro - Signup Form Validation
 * File: js/main.js
 */

document.addEventListener('DOMContentLoaded', function () {

    // ================================================================
    // BƯỚC 1: Ẩn popup xấu "Please match the requested format."
    // Chỉ ẩn UI — pattern vẫn chạy, form vẫn bị chặn nếu sai
    // ================================================================
    document.querySelectorAll('input').forEach(function (input) {
        input.addEventListener('invalid', function (e) {
            e.preventDefault(); // ẩn popup trình duyệt
        });
    });

    // ================================================================
    // BƯỚC 2: Helpers hiển thị / xóa lỗi dưới từng field
    // ================================================================
    function showError(inputEl, message) {
        clearError(inputEl);
        inputEl.style.borderColor = '#e53e3e';

        var errEl = document.createElement('p');
        errEl.className = 'field-error';
        errEl.style.cssText = 'color:#e53e3e; font-size:12px; margin-top:5px;';
        errEl.textContent = message;
        inputEl.closest('.form-group').appendChild(errEl);
    }

    function clearError(inputEl) {
        inputEl.style.borderColor = '';
        var wrapper = inputEl.closest('.form-group');
        var existing = wrapper.querySelector('.field-error');
        if (existing) existing.remove();
    }

    function markValid(inputEl) {
        clearError(inputEl);
        inputEl.style.borderColor = '#38a169';
    }

    // ================================================================
    // BƯỚC 3: Rules validate cho từng field
    // ================================================================
    var fnEl  = document.getElementById('fullname');
    var phEl  = document.getElementById('phone');
    var emEl  = document.getElementById('email');
    var adEl  = document.getElementById('address');
    var pwEl  = document.getElementById('password');
    var cpEl  = document.getElementById('confirm-password');

    function validateFullname() {
        var val = fnEl.value.trim();
        if (!val) {
            showError(fnEl, 'FullName is required'); return false;
        }
        if (!/^[A-Za-zÀ-ỹ\s]{2,100}$/.test(val)) {
            showError(fnEl, 'Full name must contain only letters and be at least 2 characters long.'); return false;
        }
        markValid(fnEl); return true;
    }

    function validatePhone() {
        var val = phEl.value.trim();
        if (!val) {
            showError(phEl, 'Phone is required'); return false;
        }
        if (!/^(0[35789])\d{8}$/.test(val)) {
            showError(phEl, 'Invalid Phone. E.g., 0901234567'); return false;
        }
        markValid(phEl); return true;
    }

    function validateEmail() {
        var val = emEl.value.trim();
        if (!val) {
            showError(emEl, 'Email is required.'); return false;
        }
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
            showError(emEl, 'Invalid email. E.g., example@gmail.com'); return false;
        }
        markValid(emEl); return true;
    }

    function validateAddress() {
        var val = adEl.value.trim();
        if (!val || val.length < 5) {
            showError(adEl, 'Address must be at least 5 characters long.'); return false;
        }
        markValid(adEl); return true;
    }

    function validatePassword() {
        if (!pwEl.value) {
            showError(pwEl, 'Password is required'); return false;
        }
        if (pwEl.value.length < 6) {
            showError(pwEl, 'Passord must be at least 5 characters long.'); return false;
        }
        markValid(pwEl); return true;
    }

    function validateConfirm() {
        if (!cpEl.value) {
            showError(cpEl, 'Enter password again'); return false;
        }
        if (cpEl.value !== pwEl.value) {
            showError(cpEl, 'Passwords do not match.'); return false;
        }
        markValid(cpEl); return true;
    }

    // ================================================================
    // BƯỚC 4: Gắn blur listener — hiện lỗi khi rời khỏi field
    // ================================================================
    fnEl.addEventListener('blur', validateFullname);
    phEl.addEventListener('blur', validatePhone);
    emEl.addEventListener('blur', validateEmail);
    adEl.addEventListener('blur', validateAddress);
    pwEl.addEventListener('blur', validatePassword);
    cpEl.addEventListener('blur', validateConfirm);

    // Khi đổi password → re-check confirm nếu đã nhập
    pwEl.addEventListener('input', function () {
        // Cập nhật pattern confirm theo password hiện tại
        var escaped = pwEl.value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        cpEl.pattern = escaped;
        if (cpEl.value) validateConfirm();
    });

    // ================================================================
    // BƯỚC 5: Chặn submit nếu có field lỗi
    // ================================================================
    var form = document.getElementById('signupForm');
    if (form) {
        form.addEventListener('submit', function (e) {
            // Chạy tất cả validation cùng lúc
            var valid =
                validateFullname() &
                validatePhone()    &
                validateEmail()    &
                validateAddress()  &
                validatePassword() &
                validateConfirm();

            if (!valid) {
                e.preventDefault(); // chặn submit
                // Scroll đến lỗi đầu tiên
                var firstError = form.querySelector('.field-error');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        });
    }

});