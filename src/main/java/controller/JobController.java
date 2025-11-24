package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("uid") == null) {
			resp.sendRedirect(req.getContextPath() + "/auth/login");
			return;
		}

		long userId = (Long) session.getAttribute("uid");
		String role = (String) session.getAttribute("userRole");
		boolean isAdmin = "ADMIN".equals(role);

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
		if (!isAdmin && job.getUserId() != userId) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
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
