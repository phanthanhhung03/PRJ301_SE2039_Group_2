/*
 * promotion-management.js
 *
 * Intentionally minimal: this file ONLY handles the "Add New Promotion"
 * modal (open / close / a small date-range check before submit).
 *
 * The "Edit Promotion" and "Grant Promotion to Customer" modals are
 * hard-coded per row directly in promotion-management.jsp (one modal
 * per promotion / per at-risk customer, pre-filled by JSTL) and are
 * opened/closed with a plain one-line inline onclick - no JS needed
 * for those.
 */

function openAddPromotionModal() {
    document.getElementById("addPromotionModal").style.display = "flex";
}

function closeAddPromotionModal() {
    document.getElementById("addPromotionModal").style.display = "none";
}

function validatePromotionForm(form) {
    const start = form.querySelector(".add-start-date").value;
    const end = form.querySelector(".add-end-date").value;

    if (start && end && end < start) {
        alert("End Date must be on or after Start Date.");
        return false;
    }

    return true;
}

function toggleTierSelection(value, boxId = "tierSelectionBox") {
    const box = document.getElementById(boxId);
    if (!box)
        return;
    if (value === "TIER_ONLY") {
        box.style.display = "block";
    } else {
        box.style.display = "none";
        // clear checkbox trong đúng box này, không clear box khác
        box.querySelectorAll('input[name="tierIDs"]').forEach(cb => {
            cb.checked = false;
        });
    }
}

