package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.BO.UserBO;
import model.Bean.UserBean;

@WebServlet("/users")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserBO userBO;

	public void init() {
		this.userBO = new UserBO();
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("uid") == null) {
			resp.sendRedirect(req.getContextPath() + "/auth/login");
			return;
		}

		String role = (String) session.getAttribute("userRole");
		if (role == null || !"ADMIN".equals(role)) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		String action = req.getParameter("action");
		if ("edit".equals(action)) {
			String idStr = req.getParameter("id");
			if (idStr != null) {
				try {
					long id = Long.parseLong(idStr);
					UserBean user = userBO.findById(id);
					if (user != null) {
						req.setAttribute("user", user);
					}
				} catch (NumberFormatException e) {
					// Ignore
				}
			}
		}

		List<UserBean> users = userBO.listAll();
		req.setAttribute("users", users);
		req.getRequestDispatcher("/user.jsp").forward(req, resp);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("uid") == null) {
			resp.sendRedirect(req.getContextPath() + "/auth/login");
			return;
		}

		String role = (String) session.getAttribute("userRole");
		if (role == null || !"ADMIN".equals(role)) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		String action = req.getParameter("action");
		String ctx = req.getContextPath();

		try {
			if ("create".equals(action)) {
				String email = req.getParameter("email");
				String password = req.getParameter("password");
				String userRole = req.getParameter("role");
				userBO.create(email, password, userRole);
			} else if ("update".equals(action)) {
				long id = Long.parseLong(req.getParameter("id"));
				String email = req.getParameter("email");
				String password = req.getParameter("password");
				String userRole = req.getParameter("role");
				userBO.update(id, email, password, userRole);
			} else if ("delete".equals(action)) {
				long id = Long.parseLong(req.getParameter("id"));
				userBO.delete(id);
			}
			resp.sendRedirect(ctx + "/users");
		} catch (IllegalArgumentException e) {
			req.setAttribute("error", e.getMessage());
			List<UserBean> users = userBO.listAll();
			req.setAttribute("users", users);
			req.getRequestDispatcher("/user.jsp").forward(req, resp);
		} catch (Exception e) {
			req.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
			List<UserBean> users = userBO.listAll();
			req.setAttribute("users", users);
			req.getRequestDispatcher("/user.jsp").forward(req, resp);
		}
	}
}

