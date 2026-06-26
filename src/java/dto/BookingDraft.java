package dto;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;

public class BookingDraft implements Serializable {

    private String bookingCode;
    private int customerId;
    private int vehicleId;
    private int promotionId;

    private String serviceType;

    private Date bookingDate;
    private Time bookingTime;

    private double totalAmount;
    private double voucherDiscount;
    private double tierDiscount;
    private double finalAmount;
    private String notes;

    public BookingDraft() {
    }

    public BookingDraft(int customerId,
            int vehicleId,
            int promotionId,
            String serviceType,
            Date bookingDate,
            Time bookingTime,
            double totalAmount,
            double voucherDiscount,
            double tierDiscount,
            double finalAmount,
            String bookingCode) {

        this.customerId = customerId;
        this.vehicleId = vehicleId;
        this.promotionId = promotionId;
        this.serviceType = serviceType;
        this.bookingDate = bookingDate;
        this.bookingTime = bookingTime;
        this.totalAmount = totalAmount;
        this.voucherDiscount = voucherDiscount;
        this.tierDiscount = tierDiscount;
        this.finalAmount = finalAmount;
        this.bookingCode = bookingCode;
    }

    private long expiredAt;

    public long getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(long expiredAt) {
        this.expiredAt = expiredAt;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public int getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(int promotionId) {
        this.promotionId = promotionId;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public Time getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(Time bookingTime) {
        this.bookingTime = bookingTime;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getVoucherDiscount() {
        return voucherDiscount;
    }

    public void setVoucherDiscount(double voucherDiscount) {
        this.voucherDiscount = voucherDiscount;
    }

    public double getTierDiscount() {
        return tierDiscount;
    }

    public void setTierDiscount(double tierDiscount) {
        this.tierDiscount = tierDiscount;
    }

    public double getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(double finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

}
