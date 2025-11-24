package model.BO;

import java.awt.image.BufferedImage;
import java.nio.file.Path;
import java.sql.SQLException;
import java.time.Instant;
import java.util.List;
import model.Bean.JobBean;
import model.Bean.ResultBean;
import model.DAO.JobDAO;
import model.DAO.ResultDAO;

public class JobBO {

	private final JobDAO jobDAO = new JobDAO();
	private final ResultDAO resultDAO = new ResultDAO();
	private final KMeansImageBO kmeansImageBO = new KMeansImageBO(jobDAO, resultDAO);

	public List<JobBean> listJobsByUser(long userId, int offset, int limit) {
		return jobDAO.listByUser(userId, offset, limit);
	}

	public JobBean findJob(long id) {
		return jobDAO.findById(id);
	}

	public ResultBean findResultByJob(long jobId) {
		return resultDAO.findByJob(jobId);
	}

	public JobBean createImageJob(long userId, int k) {
		JobBean job = new JobBean();
		job.setUserId(userId);
		job.setType(JobBean.Type.IMAGE);
		job.setK(k);
		job.setStatus("PENDING");
		job.setCreatedAt(Instant.now());
		jobDAO.insert(job);
		return job;
	}

	public ResultBean processImageJob(JobBean job, BufferedImage img, Path userDir) throws Exception {
		return kmeansImageBO.process(job, img, userDir);
	}

	public void markJobFailed(long jobId, String error) {
		jobDAO.updateStatusAndDuration(jobId, "FAILED", 0L, error);
	}
	
	public List<JobBean> getPendingJobs() throws SQLException {
		return jobDAO.findPendingJobs();
	}
	
	public void updateJobStatus(long jobId, String status) {
		jobDAO.updateStatus(jobId, status);
	}
	
	public void updateJobInputPath(long jobId, String inputPath) {
		jobDAO.updateInputPath(jobId, inputPath);
	}

	public List<ResultBean> listAllResults() {
		return resultDAO.listAll();
	}
}
