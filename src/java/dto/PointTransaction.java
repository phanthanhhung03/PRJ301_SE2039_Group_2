/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.sql.Timestamp;

/**
 *
 * @author Admin
 */
public class PointTransaction {

    private int pointTransactionID;
    private int customerID;
    private Integer bookingID;     
    private int pointsChanged;
    private Timestamp expiryDate;    
    private Timestamp createdAt;

    // Lấy thêm qua JOIN, không phải cột thật trong PointTransactions
    private String customerName;
    private int currentBalance;

    public PointTransaction() {
    }

    public int getPointTransactionID() {
        return pointTransactionID;
    }

    public void setPointTransactionID(int v) {
        this.pointTransactionID = v;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int v) {
        this.customerID = v;
    }

    public Integer getBookingID() {
        return bookingID;
    }

    public void setBookingID(Integer v) {
        this.bookingID = v;
    }

    public int getPointsChanged() {
        return pointsChanged;
    }

    public void setPointsChanged(int v) {
        this.pointsChanged = v;
    }


    public Timestamp getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Timestamp v) {
        this.expiryDate = v;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp v) {
        this.createdAt = v;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String v) {
        this.customerName = v;
    }

    public int getCurrentBalance() {
        return currentBalance;
    }

    public void setCurrentBalance(int v) {
        this.currentBalance = v;
    }
}
