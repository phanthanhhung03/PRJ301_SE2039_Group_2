package dto;

import java.sql.Date;

/**
 * DTO for a row in CustomerPromotions table. Contains extra display fields
 * (customerName, promotionName, discountPercent) joined from the Customers and
 * Promotions tables.
 */
public class CustomerPromotion {

    private int customerPromotionID;
    private int promotionID;
    private int customerID;
    private Date assignedDate;
    private boolean isUsed;
    private Date usedDate;
    private String notes;
    // --- Joined display fields (not in DB, populated by DAO) ---
    private String customerName;
    private String promotionName;
    private double discountPercent;
    private Date lastBookingDate;

    public CustomerPromotion() {
    }

    // -----------------------------------------------
    // Getters & Setters
    // -----------------------------------------------
    public int getCustomerPromotionID() {
        return customerPromotionID;
    }

    public void setCustomerPromotionID(int customerPromotionID) {
        this.customerPromotionID = customerPromotionID;
    }

    public int getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(int promotionID) {
        this.promotionID = promotionID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public Date getAssignedDate() {
        return assignedDate;
    }

    public void setAssignedDate(Date assignedDate) {
        this.assignedDate = assignedDate;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public Date getUsedDate() {
        return usedDate;
    }

    public void setUsedDate(Date usedDate) {
        this.usedDate = usedDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public Date getLastBookingDate() {
        return lastBookingDate;
    }

    public void setLastBookingDate(Date lastBookingDate) {
        this.lastBookingDate = lastBookingDate;
    }
}
