/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/ClientSide/javascript.js to edit this template
 */
function openTierModal(button) {

    document.getElementById("modalTierID").value =
            button.dataset.tierId;

    document.getElementById("tierName").value =
            button.dataset.tierName;

    document.getElementById("minBookings").value =
            button.dataset.minBookings;
    document.getElementById("minSpend").value =
            Number(button.dataset.minSpend);
    document.getElementById("pointMultiplier").value =
            button.dataset.pointMultiplier;

    document.getElementById("discountPercent").value =
            button.dataset.discountPercent;

    document.getElementById("tierModal").style.display =
            "flex";
}

function closeTierModal() {

    document.getElementById("tierModal").style.display =
            "none";
}

