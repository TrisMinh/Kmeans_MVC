package service.util;

import java.io.IOException;
import java.nio.file.*;

import jakarta.servlet.ServletContext;

public final class IOUtil {
    private IOUtil() {}

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
