package model.BO;

import java.awt.image.BufferedImage;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import javax.imageio.ImageIO;

import model.Bean.JobBean;
import model.Bean.ResultBean;
import model.DAO.JobDAO;
import model.DAO.ResultDAO;
import service.algo.Diem;
import service.algo.KMeansResult;
import service.algo.Kmeans;
import service.util.ImageUtil;

public class KMeansImageBO {
	private final JobDAO jobDAO;
	private final ResultDAO resultDAO;

	public KMeansImageBO(JobDAO jobDAO, ResultDAO resultDAO) {
		this.jobDAO = jobDAO;
		this.resultDAO = resultDAO;
	}

	public ResultBean process(JobBean job, BufferedImage img, Path userDir) throws Exception {
		int w = img.getWidth();
		int h = img.getHeight();
		int n = w * h;
		long t0 = System.currentTimeMillis();

		List<Diem> ds = ImageUtil.imageToDiemList(img);
		Kmeans km = new Kmeans(job.getK(), n, 3);
		KMeansResult rs = km.run(ds);

		BufferedImage outImg = ImageUtil.labelsToImage(w, h, rs.labels, rs.centers);

		Files.createDirectories(userDir);
		String fileName = "image-result-" + job.getId() + ".png";
		Path outPath = userDir.resolve(fileName);
		File out = outPath.toFile();
		ImageIO.write(outImg, "png", out);

		String outputAbsPath = outPath.toAbsolutePath().toString().replace('\\', '/');

		ResultBean r = new ResultBean();
		r.setJobId(job.getId());
		r.setOutputRelPath(outputAbsPath);
		r.setWidth(w);
		r.setHeight(h);
		r.setnPoints(n);
		r.setSummary("K=" + job.getK() + ", " + w + "x" + h + ", iters=" + rs.iterations);
		resultDAO.insert(r);

		long dur = System.currentTimeMillis() - t0;
		jobDAO.updateStatusAndDuration(job.getId(), "DONE", dur, null);
		return r;
	}
}
