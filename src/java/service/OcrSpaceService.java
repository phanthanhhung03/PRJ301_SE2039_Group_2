package service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dto.Vehicle;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class OcrSpaceService {

    private static final String API_KEY = "K85827049688957";

    private List<String> cleanLines(
            String text) {

        List<String> result
                = new ArrayList<>();

        String[] lines
                = text.split("\\r?\\n");

        for (String line : lines) {

            line = line.trim();

            if (!line.isEmpty()) {
                result.add(line);
            }
        }

        return result;
    }

    public Vehicle extractVehicle(File image)
            throws Exception {

        String parsedText = getParsedText(image);

        System.out.println("===== PARSED TEXT =====");
        System.out.println(parsedText);

        List<String> lines
                = cleanLines(parsedText);

        Vehicle vehicle = new Vehicle();

        if (lines.size() >= 11) {

            vehicle.setLicensePlate(
                    lines.get(7));

            vehicle.setBrand(
                    lines.get(8));

            vehicle.setModel(
                    lines.get(9));

            vehicle.setColor(
                    lines.get(10));
        }

        return vehicle;
    }

    public String extractOwnerName(File image)
            throws Exception {

        String parsedText
                = getParsedText(image);

        List<String> lines
                = cleanLines(parsedText);

        if (lines.size() >= 7) {
            return lines.get(6);
        }

        return "";
    }

    private String getParsedText(File image)
            throws Exception {

        String boundary
                = Long.toHexString(
                        System.currentTimeMillis());

        HttpURLConnection connection
                = (HttpURLConnection) new URL(
                        "https://api.ocr.space/parse/image")
                        .openConnection();

        connection.setDoOutput(true);
        connection.setRequestMethod("POST");

        connection.setRequestProperty(
                "Content-Type",
                "multipart/form-data; boundary=" + boundary);

        try (
                 OutputStream output
                = connection.getOutputStream();  PrintWriter writer
                = new PrintWriter(
                        new OutputStreamWriter(
                                output,
                                "UTF-8"),
                        true)) {

            writer.append("--")
                    .append(boundary)
                    .append("\r\n");

            writer.append(
                    "Content-Disposition: form-data; name=\"apikey\"\r\n\r\n");

            writer.append(API_KEY)
                    .append("\r\n");

            writer.append("--")
                    .append(boundary)
                    .append("\r\n");

            writer.append(
                    "Content-Disposition: form-data; name=\"file\"; filename=\"");

            writer.append(image.getName())
                    .append("\"\r\n");

            writer.append(
                    "Content-Type: image/jpeg\r\n\r\n");

            writer.flush();

            FileInputStream input
                    = new FileInputStream(image);

            byte[] buffer
                    = new byte[4096];

            int bytesRead;

            while ((bytesRead
                    = input.read(buffer))
                    != -1) {

                output.write(
                        buffer,
                        0,
                        bytesRead);
            }

            output.flush();

            input.close();

            writer.append("\r\n");

            writer.append("--")
                    .append(boundary)
                    .append("--\r\n");

            writer.flush();
        }

        BufferedReader reader
                = new BufferedReader(
                        new InputStreamReader(
                                connection.getInputStream(),
                                "UTF-8"));

        StringBuilder response
                = new StringBuilder();

        String line;

        while ((line = reader.readLine())
                != null) {

            response.append(line);
        }

        reader.close();

        JsonObject root
                = JsonParser.parseString(
                        response.toString())
                        .getAsJsonObject();

        return root.getAsJsonArray(
                "ParsedResults")
                .get(0)
                .getAsJsonObject()
                .get("ParsedText")
                .getAsString();
    }

    private String extractField(
            String text,
            String fieldName) {

        String[] lines
                = text.split("\\r?\\n");

        for (int i = 0;
                i < lines.length - 1;
                i++) {

            if (lines[i]
                    .trim()
                    .equalsIgnoreCase(
                            fieldName)) {

                return lines[i + 1]
                        .trim();
            }
        }

        return "";
    }

    public static void main(String[] args)
            throws Exception {

        OcrSpaceService service
                = new OcrSpaceService();

        File image
                = new File(
                        "E:\\Meterials\\FPT\\4. SUM26\\PRJ301\\PRJ301_SE2039_Group_2\\test-img\\cavet.png");

        Vehicle vehicle
                = service.extractVehicle(image);

        System.out.println("===== VEHICLE =====");

        System.out.println(
                vehicle.getLicensePlate());

        System.out.println(
                vehicle.getBrand());

        System.out.println(
                vehicle.getModel());

        System.out.println(
                vehicle.getColor());

        System.out.println("===== OWNER =====");

        System.out.println(
                service.extractOwnerName(image));

    }
}
