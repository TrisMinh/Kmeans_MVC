package service.worker;

import java.util.List;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import model.BO.JobBO;
import model.Bean.JobBean;

@WebListener
public class StartListener implements ServletContextListener{
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("[AppStart] Ứng dụng đang khởi động...");
		
		JobQueueManager queueManager = JobQueueManager.getInstance();
		queueManager.start();
		
		recoverPendingJobs(queueManager);
		
		System.out.println("[AppStart] Ứng dụng đã khởi động xong!");
	}
	
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("[AppStart] Ứng dụng đang dừng...");
		
		JobQueueManager queueManager = JobQueueManager.getInstance();
		queueManager.shutdown(); 
		
		System.out.println("[AppStart] Ứng dụng đã dừng hoàn tất!");
	}
	
	private void recoverPendingJobs(JobQueueManager queueManager) {
		try {
			JobBO jobBO = new JobBO();
			List<JobBean> pendingJobs = jobBO.getPendingJobs();
			
			if (pendingJobs.isEmpty()) {
				System.out.println("[AppStart] Không có job nào cần khôi phục");
				return;
			}
			
			System.out.println("[AppStart] Tìm thấy " + pendingJobs.size() + " job cần khôi phục:");
			
			for (JobBean job : pendingJobs) {
				// Reset status về pending nếu đang runnign
				if ("RUNNING".equals(job.getStatus())) {
					jobBO.updateJobStatus(job.getId(), "PENDING");
					job.setStatus("PENDING");
				}
				System.out.println("  - Job #" + job.getId() + " (K=" + job.getK() + ", User=" + job.getUserId() + ")");	
				// Submit vào queue để khôi phục việc xử lý job bị gián đoạn
				queueManager.submitJob(job);
			}			
			System.out.println("[AppStart] Đã thêm tất cả job vào queue để xử lý");
		} catch (Exception e) {
			System.err.println("[AppStart] Lỗi khi khôi phục pending jobs:");
			e.printStackTrace();
		}
	}
}
