package model.BO;

import java.awt.image.BufferedImage;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import javax.imageio.ImageIO;

import model.BO.KmeansProcBO.KMeansResult;
import model.Bean.JobBean;
import model.Bean.ResultBean;
import model.DAO.JobDAO;
import model.DAO.ResultDAO;
import model.Bean.DiemBean;

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

		List<DiemBean> ds = ImageProcBO.imageToDiemList(img);
		KmeansProcBO km = new KmeansProcBO(job.getK(), n, 3);
		KMeansResult rs = km.run(ds);

		BufferedImage outImg = ImageProcBO.labelsToImage(w, h, rs.labels, rs.centers);

//		Files.createDirectories(userDir);
//		String fileName = "image-result-" + job.getId() + ".png";
//		Path outPath = userDir.resolve(fileName);
//		File out = outPath.toFile();
//		ImageIO.write(outImg, "png", out);
		
		String fileName = ImageStoreBO.saveOutputImage(userDir, job.getId(), outImg);

		String webPath  = "kmeans-data/u-" + job.getUserId() + "/" + fileName;

		ResultBean r = new ResultBean();
		r.setJobId(job.getId());
		r.setOutputRelPath(webPath);
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
