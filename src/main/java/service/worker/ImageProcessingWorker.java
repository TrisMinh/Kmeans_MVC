package service.worker;

import java.awt.image.BufferedImage;
import java.io.File;
import java.nio.file.Path;
import java.util.concurrent.BlockingQueue;

import javax.imageio.ImageIO;

import model.BO.ImageStoreBO;
import model.BO.JobBO;
import model.Bean.JobBean;

public class ImageProcessingWorker implements Runnable{
	private final BlockingQueue<JobBean> jobQueue;
	public ImageProcessingWorker(BlockingQueue<JobBean> jobQueue) {
			this.jobQueue = jobQueue;
	}
	@Override
	public void run() {
		String threadName = Thread.currentThread().getName();
		System.out.println("[Worker " + threadName + "] Bắt đầu chạy!" );
		
		JobBO jobBO = new JobBO();
		
		while (!Thread.currentThread().isInterrupted()) {
			try {
				JobBean job = jobQueue.take();
				System.out.println("[Worker " + threadName + "] Đang xử lý Job #" + job.getId() + " (K=" + job.getK() + ")");
				
				jobBO.updateJobStatus(job.getId(), "RUNNING"); //cap nhat trang thai
				
				processJob(job);
				
				System.out.println("[Worker " + threadName + "] Hoàn thành Job #" + job.getId());
				
			} catch (InterruptedException e) { // bat loi dung truoc, khong bat duoc thi bat loi chung
				System.out.println("[Worker " + threadName + "] Bị ngắt, dừng worker");
				Thread.currentThread().interrupt();
				break;
			} catch (Exception e) {
				System.err.println("[Worker " + threadName + "] Lỗi không mong đợi: " + e.getMessage());
				e.printStackTrace();
			}
		}		
	}
	
	private void processJob(JobBean job) {
		JobBO jobBO = new JobBO();
		try {
			Path baseDir = ImageStoreBO.ensureBaseDir(null);
			Path userDir = ImageStoreBO.ensureUserDir(baseDir, job.getUserId());
			
			String inputPath = job.getInputPath();
			if (inputPath != null && !inputPath.isEmpty()) {
				File inputFile = new File(inputPath);
				if (inputFile.exists()) {
					BufferedImage img = ImageIO.read(inputFile);
					if (img != null) {
						jobBO.processImageJob(job, img, userDir);
						return;
					}
				}
				// sai illegal throw text cho dễ
				throw new IllegalStateException("File input không tồn tại: " + inputPath);
			}
			throw new IllegalStateException("Job không có dữ liệu ảnh để xử lý");
		} catch (Exception e) {
			System.err.println("[Worker] Lỗi xử lý Job #" + job.getId() + ": " + e.getMessage());
			e.printStackTrace();
			jobBO.markJobFailed(job.getId(), e.getMessage());
		}
		
	}
	
}
