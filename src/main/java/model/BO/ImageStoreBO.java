package model.BO;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import jakarta.servlet.ServletContext;

public final class ImageStoreBO {
    private ImageStoreBO() {}

    private static final Path BASE_DIR = Paths.get("D:/kmeans-data");

    public static Path ensureBaseDir(ServletContext ctx) throws IOException {
        if (!Files.exists(BASE_DIR)) {
            Files.createDirectories(BASE_DIR);
        }
        return BASE_DIR;
    }

    public static Path ensureUserDir(Path base, long userId) throws IOException {
        Path p = base.resolve("u-" + userId);
        if (!Files.exists(p)) {
            Files.createDirectories(p);
        }
        return p;
    }
}
