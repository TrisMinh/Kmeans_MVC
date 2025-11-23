package controller;

import java.io.IOException;
import java.util.Optional;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BO.JobBO;
import model.Bean.JobBean;
import model.Bean.ResultBean;

@WebServlet("/jobs")
public class JobController extends HttpServlet {
	private JobBO jobBO;

	public void init() {
		jobBO = new JobBO();
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String id = req.getParameter("id");
		if (id == null || id.isEmpty()) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		long jobId = Long.parseLong(id);
		JobBean job = jobBO.findJob(jobId);
		if (job == null) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		req.setAttribute("job", job);
		ResultBean result = jobBO.findResultByJob(jobId);
		if (result != null) {
			req.setAttribute("result", result);
		}

		req.getRequestDispatcher("/job-detail.jsp").forward(req, resp);
	}
}
