/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Customer;
import dto.Vehicle;
import java.sql.ResultSet;
import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Asus
 */
public class VehicleDAO {

    public int insertVehicle(Vehicle vehicle) {

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

    public int countVehiclesByCustomer(int customerId) {
        int totalVehicles = 0;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            //Step 1: Make Connection
            cn = dbutils.DBUtils.getConnection();

            if (cn != null) {
                //Step 2: Querry SQL
                String sql = "SELECT CustomerID ,COUNT(VehicleID) AS TotalVehicles\n"
                        + "FROM [dbo].[Vehicles]\n"
                        + "WHERE CustomerID = ?\n"
                        + "GROUP BY CustomerID";

                //Step 3:
                st = cn.prepareStatement(sql);
                st.setInt(1, customerId);

                //Step 4
                table = st.executeQuery();
                if (table.next()) {
                    totalVehicles = table.getInt("TotalVehicles");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {

                if (table != null) {
                    table.close();
                }

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

        return totalVehicles;
    }

    public List<Vehicle> getVehiclesByCustomerId(int customerId) {
        List<Vehicle> vehicleList = new ArrayList<>();
        PreparedStatement st = null;
        ResultSet table = null;
        Connection cn = null;
        try {
            cn = dbutils.DBUtils.getConnection();

            if (cn == null) {
                System.out.println("CANNOT CONNECT TO SQL");
                return vehicleList;
            }

            String sql = "SELECT [VehicleID], [LicensePlate], [Brand], [Model], [Color], [CreatedAt]\n"
                    + "FROM Vehicles\n"
                    + "WHERE CustomerID = ? AND Status = ?";

            st = cn.prepareStatement(sql);
            st.setInt(1, customerId);
            st.setBoolean(2, true);

            table = st.executeQuery();
            while (table.next()) {
                Vehicle vehicle = new Vehicle(
                        table.getInt("VehicleID"),
                        customerId,
                        table.getString("LicensePlate"),
                        table.getString("Brand"),
                        table.getString("Model"),
                        table.getString("Color"),
                        table.getDate("CreatedAt"));

                vehicleList.add(vehicle);

            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (table != null) {
                    table.close();
                }
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

        return vehicleList;
    }
}
