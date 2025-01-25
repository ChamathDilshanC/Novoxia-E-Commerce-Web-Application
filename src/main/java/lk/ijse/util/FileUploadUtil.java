package lk.ijse.util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

public class FileUploadUtil {
    // Base upload directory relative to your project
    private static final String UPLOAD_DIR = "uploads/products";

    public static String saveFile(Part filePart, String baseDirectory) throws IOException {
        // Create uploads directory if it doesn't exist
        String applicationPath = baseDirectory;
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;

        // Create directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Generate unique filename
        String fileName = UUID.randomUUID().toString() + "_" + getSubmittedFileName(filePart);

        // Save file
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // Return relative path for database storage
        return UPLOAD_DIR + File.separator + fileName;
    }

    public static void deleteFile(String filePath, String baseDirectory) {
        if (filePath != null && !filePath.isEmpty()) {
            try {
                Path fullPath = Paths.get(baseDirectory, filePath);
                Files.deleteIfExists(fullPath);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private static String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}