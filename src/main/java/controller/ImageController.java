package controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import javax.imageio.ImageIO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.BO.JobBO;
import model.Bean.JobBean;
import service.util.IOUtil;
import service.worker.JobQueueManager;

@WebServlet("/ImageController")
@MultipartConfig(maxFileSize = 20_000_000L)
public class ImageController extends HttpServlet {

	private JobBO jobBO;

	public void init() {
		this.jobBO = new JobBO();
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		long userId = getUserId(req);
		if (userId == -1) {
			resp.sendRedirect(req.getContextPath() + "/auth/login");
			return;
		}

		List<JobBean> jobs = jobBO.listJobsByUser(userId, 0, 100);
		req.setAttribute("jobs", jobs);

		req.getRequestDispatcher("/image-upload.jsp").forward(req, resp);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			long userId = getUserId(req);
			if (userId == -1) {
				resp.sendRedirect(req.getContextPath() + "/auth/login");
				return;
			}
			int k = Integer.parseInt(req.getParameter("k"));
			Part file = req.getPart("file");
			if (file == null || file.getSize() == 0)
				throw new IllegalArgumentException("Chưa chọn ảnh");

			BufferedImage img = ImageIO.read(file.getInputStream());
			if (img == null)
				throw new IllegalArgumentException("File ảnh không hợp lệ");
			if ((long) img.getWidth() * img.getHeight() > 15_000_000L)
				throw new IllegalArgumentException("Ảnh quá lớn");

			Path base = IOUtil.ensureBaseDir(null);
			Path userDir = IOUtil.ensureUserDir(base, userId);

			JobBean job = jobBO.createImageJob(userId, k);

			Files.createDirectories(userDir);
			String inputFileName = "image-input-" + job.getId() + ".png";
			Path inputPath = userDir.resolve(inputFileName);
			File inputFile = inputPath.toFile();
			ImageIO.write(img, "png", inputFile);

			String inputAbsPath = inputPath.toAbsolutePath().toString().replace('\\', '/');
			jobBO.updateJobInputPath(job.getId(), inputAbsPath);
			job.setInputPath(inputAbsPath);
			
//			final BufferedImage imgForWorker = img;
//			final Path userDirForWorker = userDir;
//			final JobBean jobForWorker = job;
//
//			new Thread(() -> {
//				try {
//					jobBO.processImageJob(jobForWorker, imgForWorker, userDirForWorker);
//				} catch (Exception e) {
//					e.printStackTrace();
//					jobBO.markJobFailed(jobForWorker.getId(), e.getMessage());
//				}
//			}, "kmeans-image-worker").start();

			// Chỗ ni t sửa thành queue nhé
			JobQueueManager.getInstance().submitJob(job);
		
			resp.sendRedirect("ImageController");
		} catch (Exception ex) {
			req.setAttribute("error", ex.getMessage());
			 req.getRequestDispatcher("/image-upload.jsp").forward(req, resp);
		}
	}

	private long getUserId(HttpServletRequest req) {
		HttpSession s = req.getSession(false);
		if (s == null) {
			return -1;
		}
		Object v = s.getAttribute("uid");
		if (v == null) {
			return -1;
		}
		return (Long) v;
	}
}
