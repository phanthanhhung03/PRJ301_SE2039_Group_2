/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Customer;
import dto.Vehicle;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Asus
 */
public class VehicleDAO {

    public int createVehicle(Vehicle vehicle) {

        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            // Step 1: Connect DB
            cn = dbutils.DBUtils.getConnection();

            if (cn == null) {
                System.out.println("not connect");
            }

            if (cn != null) {

                // Step 2: SQL
                String sql = "INSERT INTO [dbo].[Vehicles]\n"
                        + "([CustomerID]\n"
                        + ",[LicensePlate]\n"
                        + ",[Brand]\n"
                        + ",[Model]\n"
                        + ",[Color])\n"
                        + "VALUES (?, ?, ?, ?, ?)";

                // Step 3
                st = cn.prepareStatement(sql);

                st.setInt(1, vehicle.getCustomerID());
                st.setString(2, vehicle.getLicensePlate());
                st.setString(3, vehicle.getBrand());
                st.setString(4, vehicle.getModel());
                st.setString(5, vehicle.getColor());

                // Execute
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            try {
                if (st != null) {
                    st.close();
                }

                if (cn != null) {
                    cn.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return result;
    }
}
