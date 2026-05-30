package dto;

import java.sql.Date;

public class Customer {

    private int cusId;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String password;
    private String address;
    private CustomerTier tierId;
    private int currentPoint;
    private int totalBooking;
    private Double totalSpend;
    private boolean status;
    private Date createdAt;

    public Customer() {
    }

    public Customer(int cusId, String fullName, String phoneNumber, String email, String password, String address, CustomerTier tierId, int currentPoint, int totalBooking, Double totalSpend, boolean status, Date createdAt) {
        this.cusId = cusId;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.password = password;
        this.address = address;
        this.tierId = tierId;
        this.currentPoint = currentPoint;
        this.totalBooking = totalBooking;
        this.totalSpend = totalSpend;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getCusId() {
        return cusId;
    }

    public void setCusId(int cusId) {
        this.cusId = cusId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public CustomerTier getTierId() {
        return tierId;
    }

    public void setTierId(CustomerTier tierId) {
        this.tierId = tierId;
    }

    public int getCurrentPoint() {
        return currentPoint;
    }

    public void setCurrentPoint(int currentPoint) {
        this.currentPoint = currentPoint;
    }

    public int getTotalBooking() {
        return totalBooking;
    }

    public void setTotalBooking(int totalBooking) {
        this.totalBooking = totalBooking;
    }

    public Double getTotalSpend() {
        return totalSpend;
    }

    public void setTotalSpend(Double totalSpend) {
        this.totalSpend = totalSpend;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getInitials() {
        if (fullName == null || fullName.isEmpty()) {
            return "U";
        }

        String parts[] = fullName.trim().split("\\s+");

        if (parts.length == 1) {
            return parts[0].substring(0, 1).toUpperCase();
        }

        return (parts[0].substring(0, 1)
                + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }

}
