package controller;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StaticFileController", urlPatterns = { "/files/*" })
public class StaticFileController extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getPathInfo();
		if (path == null || path.length() <= 1) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		path = path.substring(1);
		if (path.contains("..")) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		Path file = Paths.get(path);
		if (!Files.isRegularFile(file)) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		String mime = getServletContext().getMimeType(file.getFileName().toString());
		if (mime == null)
			mime = "application/octet-stream";
		resp.setContentType(mime);

		try (OutputStream out = resp.getOutputStream()) {
			Files.copy(file, out);
		}
	}
}

