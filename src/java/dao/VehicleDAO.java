package dao;

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

            String sql = "SELECT VehicleID, LicensePlate, Brand, Model, Color, CreatedAt, Status "
                    + "FROM Vehicles "
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

                vehicle.setStatus(table.getBoolean("Status"));

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

    public List<Vehicle> getAllVehiclesByCustomerId(int customerId) {
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

            String sql
                    = "SELECT VehicleID, "
                    + "LicensePlate, "
                    + "Brand, "
                    + "Model, "
                    + "Color, "
                    + "CreatedAt, "
                    + "Status "
                    + "FROM Vehicles "
                    + "WHERE CustomerID = ?";

            st = cn.prepareStatement(sql);
            st.setInt(1, customerId);

            table = st.executeQuery();
            while (table.next()) {
                Vehicle vehicle = new Vehicle(
                        table.getInt("VehicleID"),
                        customerId,
                        table.getString("LicensePlate"),
                        table.getString("Brand"),
                        table.getString("Model"),
                        table.getString("Color"),
                        table.getDate("CreatedAt"),
                        table.getBoolean("Status"));

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

    public Vehicle getVehicleByLicensePlate(String licensePlate) {
        Vehicle vehicle = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn == null) {
                System.out.println("CANNOT CONNECT TO SQL");
                return vehicle;
            }

            String sql = "SELECT [VehicleID], [CustomerID] ,[LicensePlate], [Brand], [Model], [Color], [CreatedAt], [Status]\n"
                    + "FROM Vehicles\n"
                    + "WHERE UPPER(LicensePlate) = UPPER(?)";

            st = cn.prepareStatement(sql);
            st.setString(1, licensePlate);

            table = st.executeQuery();
            if (table.next()) {
                vehicle = new Vehicle(
                        table.getInt("VehicleID"),
                        table.getInt("CustomerID"),
                        licensePlate,
                        table.getString("Brand"),
                        table.getString("Model"),
                        table.getString("Color"),
                        table.getDate("CreatedAt"),
                        table.getBoolean("Status")
                );
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
        return vehicle;
    }

    public Vehicle getVehicleById(int id) {
        Vehicle vehicle = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn == null) {
                System.out.println("CANNOT CONNECT TO SQL");
                return vehicle;
            }

            String sql = "SELECT [VehicleID], [CustomerID] ,[LicensePlate], [Brand], [Model], [Color], [CreatedAt], [Status]\n"
                    + "FROM Vehicles\n"
                    + "WHERE VehicleID = ?";

            st = cn.prepareStatement(sql);
            st.setInt(1, id);

            table = st.executeQuery();
            if (table.next()) {
                vehicle = new Vehicle(
                        table.getInt("VehicleID"),
                        table.getInt("CustomerID"),
                        table.getString("LicensePlate"),
                        table.getString("Brand"),
                        table.getString("Model"),
                        table.getString("Color"),
                        table.getDate("CreatedAt"),
                        table.getBoolean("Status")
                );
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
        return vehicle;
    }

    public Vehicle getActiveVehicleById(int id) {
        Vehicle vehicle = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn == null) {
                System.out.println("CANNOT CONNECT TO SQL");
                return vehicle;
            }

            String sql = "SELECT [VehicleID], [CustomerID] ,[LicensePlate], [Brand], [Model], [Color], [CreatedAt], [Status]\n"
                    + "FROM Vehicles\n"
                    + "WHERE VehicleID = ? AND Status = ?";

            st = cn.prepareStatement(sql);
            st.setInt(1, id);
            st.setBoolean(2, true);

            table = st.executeQuery();
            if (table.next()) {
                vehicle = new Vehicle(
                        table.getInt("VehicleID"),
                        table.getInt("CustomerID"),
                        table.getString("LicensePlate"),
                        table.getString("Brand"),
                        table.getString("Model"),
                        table.getString("Color"),
                        table.getDate("CreatedAt"),
                        table.getBoolean("Status")
                );
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
        return vehicle;
    }

    public int restoreVehicle(int vehicleId) {
        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn == null) {
                System.out.println("CANNOT CONNECT TO SQL");
                return result;
            }
            String sql
                    = "UPDATE [dbo].[Vehicles]\n"
                    + "   SET [Status] = 1\n"
                    + " WHERE VehicleID = ?\n";

            st = cn.prepareStatement(sql);
            st.setInt(1, vehicleId);
            result = st.executeUpdate();
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

    public int updateVehicle(int vehicleId, String brand, String model, String color) {
        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn == null) {
                System.out.println("CANNOT CONNECT TO SQL");
                return result;
            }
            String sql = "UPDATE [dbo].[Vehicles] "
                    + "SET [Brand] = ?, "
                    + "    [Model] = ?, "
                    + "    [Color] = ? "
                    + "WHERE [VehicleID] = ? AND Status = 1";

            st = cn.prepareStatement(sql);

            st.setString(1, brand);
            st.setString(2, model);
            st.setString(3, color);
            st.setInt(4, vehicleId);

            result = st.executeUpdate();
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

    public int softDeleteVehicle(int vehicleId) {
        int result = 0;
        PreparedStatement st = null;
        Connection cn = null;
        try {
            cn = dbutils.DBUtils.getConnection();
            if (cn == null) {
                System.out.println("CANNOT CONNECT TO SQL");
                return result;
            }
            String sql
                    = "UPDATE [dbo].[Vehicles] "
                    + "SET [Status] = 0 "
                    + "WHERE [VehicleID] = ? AND [Status] = 1";

            st = cn.prepareStatement(sql);
            st.setInt(1, vehicleId);

            result = st.executeUpdate();
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

    public int countVehicles() {

        int total = 0;

        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {

            cn = dbutils.DBUtils.getConnection();

            if (cn != null) {

                String sql
                        = "SELECT COUNT(*) "
                        + "FROM Vehicles "
                        + "WHERE Status = 1";

                st = cn.prepareStatement(sql);

                table = st.executeQuery();

                if (table.next()) {
                    total = table.getInt(1);
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

        return total;
    }

}
