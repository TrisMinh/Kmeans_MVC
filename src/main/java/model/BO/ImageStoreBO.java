package model.BO;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.imageio.ImageIO;

import jakarta.servlet.ServletContext;

public final class ImageStoreBO {

	private static final Path BASE_DIR = Paths.get("D:/eclipse/eclipse-workspace/KMeans/src/main/webapp/images");
	
	public static Path ensureBaseDir(ServletContext ctx) throws IOException {
        String realPath = ctx.getRealPath("/kmeans-data");
        Path base = Paths.get(realPath);
        if (!Files.exists(base)) {
            Files.createDirectories(base);
        }
        return base;
    }

    public static Path ensureUserDir(Path base, long userId) throws IOException {
        Path p = base.resolve("u-" + userId);
        if (!Files.exists(p)) {
            Files.createDirectories(p);
        }
        return p;
    }
	
    public static String saveInputImage(Path userDir, long jobId, BufferedImage img) throws IOException {
        Files.createDirectories(userDir);

        String fileName = "image-input-" + jobId + ".png";
        Path inputPath = userDir.resolve(fileName);

        ImageIO.write(img, "png", inputPath.toFile());

        return inputPath.toAbsolutePath().toString().replace('\\', '/');
    }
    
    public static String saveOutputImage(Path userDir, long jobId, BufferedImage img) throws IOException {
        Files.createDirectories(userDir);

        String fileName = "image-result-" + jobId + ".png";
        Path outPath = userDir.resolve(fileName);
        File out = outPath.toFile();
        ImageIO.write(img, "png", out);

        return fileName;
    }
	
	public static Path resolveExistingFile(String rawPath) {
        if (rawPath == null || rawPath.isEmpty()) {
            return null;
        }
        Path p = Paths.get(rawPath);
        if (!Files.isRegularFile(p)) {
            return null;
        }
        return p;
    }
}

