package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.BO.JobBO;
import model.BO.UserBO;
import model.Bean.ResultBean;
import model.Bean.UserBean;

@WebServlet("/images")
public class ImageListController extends HttpServlet {
	private JobBO jobBO;
	private UserBO userBO;

	public void init() {
		this.jobBO = new JobBO();
		this.userBO = new UserBO();
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("uid") == null) {
			resp.sendRedirect(req.getContextPath() + "/auth/login");
			return;
		}

		// Chỉ ADMIN mới được truy cập
		String role = (String) session.getAttribute("userRole");
		if (role == null || !"ADMIN".equals(role)) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		List<ResultBean> results;
		String userIdParam = req.getParameter("userId");
		if (userIdParam != null && !userIdParam.isEmpty()) {
			try {
				long targetUserId = Long.parseLong(userIdParam);
				results = jobBO.listResultsByUser(targetUserId);
				UserBean filteredUser = userBO.findById(targetUserId);
				if (filteredUser == null) {
					resp.sendError(HttpServletResponse.SC_NOT_FOUND);
					return;
				}
				req.setAttribute("filteredUser", filteredUser);
			} catch (NumberFormatException ex) {
				resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
				return;
			}
		} else {
			results = jobBO.listAllResults();
		}

		req.setAttribute("results", results);
		req.getRequestDispatcher("/image.jsp").forward(req, resp);
	}
}

