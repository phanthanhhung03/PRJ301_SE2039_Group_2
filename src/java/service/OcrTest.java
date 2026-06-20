package service;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class OcrTest {

    public static void main(String[] args) throws Exception {

        String apiKey = "K85827049688957";

        File image = new File(
            "E:\\Meterials\\FPT\\4. SUM26\\PRJ301\\PRJ301_SE2039_Group_2\\test-img\\cavet.png"
        );

        String boundary = Long.toHexString(System.currentTimeMillis());

        HttpURLConnection connection =
                (HttpURLConnection)
                        new URL("https://api.ocr.space/parse/image")
                                .openConnection();

        connection.setDoOutput(true);
        connection.setRequestMethod("POST");

        connection.setRequestProperty(
                "Content-Type",
                "multipart/form-data; boundary=" + boundary
        );

        try (
                OutputStream output = connection.getOutputStream();
                PrintWriter writer =
                        new PrintWriter(
                                new OutputStreamWriter(output, "UTF-8"),
                                true
                        )
        ) {

            // API KEY
            writer.append("--").append(boundary).append("\r\n");
            writer.append(
                    "Content-Disposition: form-data; name=\"apikey\"\r\n\r\n"
            );
            writer.append(apiKey).append("\r\n");

            // FILE
            writer.append("--").append(boundary).append("\r\n");
            writer.append(
                    "Content-Disposition: form-data; name=\"file\"; filename=\""
            );
            writer.append(image.getName()).append("\"\r\n");
            writer.append(
                    "Content-Type: image/jpeg\r\n\r\n"
            );
            writer.flush();

            FileInputStream input = new FileInputStream(image);

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }

            output.flush();
            input.close();

            writer.append("\r\n");
            writer.append("--")
                    .append(boundary)
                    .append("--\r\n");
            writer.flush();
        }

        int responseCode = connection.getResponseCode();

        System.out.println("HTTP Code: " + responseCode);

        BufferedReader reader;

        if (responseCode >= 400) {
            reader = new BufferedReader(
                    new InputStreamReader(
                            connection.getErrorStream(),
                            "UTF-8"
                    )
            );
        } else {
            reader = new BufferedReader(
                    new InputStreamReader(
                            connection.getInputStream(),
                            "UTF-8"
                    )
            );
        }

        String line;

        System.out.println("===== OCR RESPONSE =====");

        while ((line = reader.readLine()) != null) {
            System.out.println(line);
        }

        reader.close();
    }
}