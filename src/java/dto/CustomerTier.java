/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Admin
 */
public class CustomerTier {

    private int tierID;
    private String tierName;
    private int minBookings;
    private double minSpend;
    private double pointMultiplier;
    private double discountPercent;
    private int priorityLevel;
    private int bookingWindowDays;

    public CustomerTier() {
    }

    public CustomerTier(int tierID, String tierName,
            int minBookings, double minSpend,
            double pointMultiplier,
            double discountPercent,
            int priorityLevel,
            int bookingWindowDays) {

        this.tierID = tierID;
        this.tierName = tierName;
        this.minBookings = minBookings;
        this.minSpend = minSpend;
        this.pointMultiplier = pointMultiplier;
        this.discountPercent = discountPercent;
        this.priorityLevel = priorityLevel;
        this.bookingWindowDays = bookingWindowDays;
    }

    public int getTierID() {
        return tierID;
    }

    public void setTierID(int tierID) {
        this.tierID = tierID;
    }

    public String getTierName() {
        return tierName;
    }

    public void setTierName(String tierName) {
        this.tierName = tierName;
    }

    public int getMinBookings() {
        return minBookings;
    }

    public void setMinBookings(int minBookings) {
        this.minBookings = minBookings;
    }

    public double getMinSpend() {
        return minSpend;
    }

    public void setMinSpend(double minSpend) {
        this.minSpend = minSpend;
    }

    public double getPointMultiplier() {
        return pointMultiplier;
    }

    public void setPointMultiplier(double pointMultiplier) {
        this.pointMultiplier = pointMultiplier;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public int getPriorityLevel() {
        return priorityLevel;
    }

    public void setPriorityLevel(int priorityLevel) {
        this.priorityLevel = priorityLevel;
    }

    public int getBookingWindowDays() {
        return bookingWindowDays;
    }

    public void setBookingWindowDays(int bookingWindowDays) {
        this.bookingWindowDays = bookingWindowDays;
    }
}
