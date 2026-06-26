package dto;

import java.sql.Timestamp;

public class Booking {

    // --- 10 CỘT KHỚP 100% VỚI DATABASE ---
    private int bookingID;
    private int vehicleID;
    private Timestamp bookingDate;
    private String timeSlot;
    private String serviceType;
    private String bookingStatus;
    private String notes;
    private double totalAmount;
    private double discountAmount;
    private double finalAmount;
    private Timestamp createdAt;
    private boolean paymentStatus;

    // --- CỘT ẢO (VIRTUAL COLUMN) ĐỂ HIỂN THỊ UI ---
    // Cột này không có trong SQL, nhưng cực kỳ cần thiết để hứng dữ liệu 
    // khi viết lệnh JOIN sang bảng Vehicles để in tên xe ra màn hình.
    private String vehicleName;
    private String customerName;
    private int cusId;
    private int estimatedPoints;
    private double tierPointMultiplier;

    // 1. Hàm khởi tạo rỗng (Bắt buộc)
    public Booking() {
    }

    // 2. Hàm khởi tạo đầy đủ tham số
    public Booking(int bookingID, int vehicleID, Timestamp bookingDate, String timeSlot, String serviceType, String bookingStatus, String notes, double totalAmount, double discountAmount, double finalAmount, Timestamp createdAt, String vehicleName) {
        this.bookingID = bookingID;
        this.vehicleID = vehicleID;
        this.bookingDate = bookingDate;
        this.timeSlot = timeSlot;
        this.serviceType = serviceType;
        this.bookingStatus = bookingStatus;
        this.notes = notes;
        this.totalAmount = totalAmount;
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
        this.createdAt = createdAt;
        this.vehicleName = vehicleName;
    }

    // 3. Getters và Setters
    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
    }

    public Timestamp getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Timestamp bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(double finalAmount) {
        this.finalAmount = finalAmount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(boolean paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getVehicleName() {
        return vehicleName;
    }

    public void setVehicleName(String vehicleName) {
        this.vehicleName = vehicleName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public int getCusId() {
        return cusId;
    }

    public void setCusId(int cusId) {
        this.cusId = cusId;
    }

    public double getTierPointMultiplier() {
        return tierPointMultiplier;
    }

    public void setTierPointMultiplier(double tierPointMultiplier) {
        this.tierPointMultiplier = tierPointMultiplier;
    }

    public int getEstimatedPoints() {
        return estimatedPoints;
    }

    public void setEstimatedPoints(int estimatedPoints) {
        this.estimatedPoints = estimatedPoints;
    }

    // 4. Hàm toString để in ra Console tìm lỗi cho dễ
    @Override
    public String toString() {
        return "Booking{" + "bookingID=" + bookingID + ", serviceType=" + serviceType + ", bookingStatus=" + bookingStatus + ", finalAmount=" + finalAmount + '}';
    }
}
