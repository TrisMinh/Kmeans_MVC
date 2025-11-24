package service.worker;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;

import model.Bean.JobBean;

public class JobQueueManager {
	private static final int TOTAL_WORKER_COUNT = 3;
	
	private static JobQueueManager instance; // singleton
	
	private final BlockingQueue<JobBean> jobQueue;
	private final ExecutorService executorService;
	private final int workerThreadCount;
	private volatile boolean isRunning;
	
	private JobQueueManager(int workerThreadCount) {
		this.workerThreadCount = workerThreadCount;
		this.jobQueue = new LinkedBlockingQueue<JobBean>(); //sài ni tại k giới hạn size 
		this.executorService = Executors.newFixedThreadPool(workerThreadCount);
		this.isRunning = false;
	}
	
	public static synchronized JobQueueManager getInstance() {
		if(instance == null) {
			instance = new JobQueueManager(TOTAL_WORKER_COUNT);
		}
		return instance;
	}
	
	public synchronized void start() {
		if (isRunning) {
			System.out.println("[JobQueueManager] Đã được khởi động trước đó");
			return;
		}
		
		isRunning = true;
		System.out.println("[JobQueueManager] Khởi động " + workerThreadCount + " worker threads");
		try {
			for (int i = 0; i < workerThreadCount; i++) { // có mấy worker thì khởi động hết
				ImageProcessingWorker worker = new ImageProcessingWorker(jobQueue);
				executorService.submit(worker);
			}			
		} catch (Exception e) {
			System.out.println("Lỗi không xác định");
			e.printStackTrace();
		}
		System.out.println("[JobQueueManager] Đã khởi động thành công");
	}
	
	public synchronized void shutdown() {
		if (!isRunning) {
			return;
		}
		
		isRunning = false;
		System.out.println("[JobQueueManager] Đang dừng workers...");
		
		executorService.shutdownNow(); // dừng các wokers
		
		System.out.println("[JobQueueManager] Đã dừng hoàn tất. Jobs còn lại trong queue: " + jobQueue.size());
	}
	
	public void submitJob(JobBean job) {
		if (!isRunning) {
			System.out.println();
			throw new IllegalStateException("JobQueueManager chưa được khởi động");
		}
		
		try {
			jobQueue.put(job);
			System.out.println("[JobQueueManager] Job #" + job.getId() + " đã được thêm vào queue. Queue size: " + jobQueue.size());
		} catch (InterruptedException e) {
			Thread.currentThread().interrupt();
			throw new RuntimeException("Bị gián đoạn khi thêm job vào queue", e);
		}
	}
	
	public int getQueueSize() {
		return jobQueue.size();
	}
	
	public boolean isRunning() {
		return isRunning;
	}
}
