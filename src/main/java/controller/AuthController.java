package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.BO.UserBO;
import model.Bean.UserBean;

@WebServlet("/auth/*")
public class AuthController extends HttpServlet {
	private UserBO userBO;

	public void init() {
		this.userBO = new UserBO();
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getPathInfo();
		if (path == null) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		if ("/login".equals(path)) {
			req.getRequestDispatcher("/login.jsp").forward(req, resp);
		} else if ("/register".equals(path)) {
			req.getRequestDispatcher("/register.jsp").forward(req, resp);
		} else if ("/logout".equals(path)) {
			handleLogout(req, resp);
		} else {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getPathInfo();
		if (path == null) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		String ctx = req.getContextPath();

		if ("/login".equals(path)) {
			handleLogin(req, resp, ctx);
		} else if ("/register".equals(path)) {
			handleRegister(req, resp, ctx);
		} else {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void handleLogin(HttpServletRequest req, HttpServletResponse resp, String ctx)
			throws ServletException, IOException {
		try {
			String email = req.getParameter("email");
			String password = req.getParameter("password");

			UserBean user = userBO.login(email, password);

			HttpSession session = req.getSession(true);
			session.setAttribute("uid", user.getId());
			session.setAttribute("userEmail", user.getEmail());
			session.setAttribute("userRole", user.getRole());

			resp.sendRedirect(ctx + "/welcome.jsp");
		} catch (IllegalArgumentException e) {
			req.setAttribute("err", e.getMessage());
			req.getRequestDispatcher("/login.jsp").forward(req, resp);
		} catch (Exception e) {
			req.setAttribute("err", "Đã xảy ra lỗi: " + e.getMessage());
			req.getRequestDispatcher("/login.jsp").forward(req, resp);
		}
	}

	private void handleRegister(HttpServletRequest req, HttpServletResponse resp, String ctx)
			throws ServletException, IOException {
		try {
			String email = req.getParameter("email");
			String password = req.getParameter("password");

			UserBean user = userBO.register(email, password);

			HttpSession session = req.getSession(true);
			session.setAttribute("uid", user.getId());
			session.setAttribute("userEmail", user.getEmail());
			session.setAttribute("userRole", user.getRole());

			resp.sendRedirect(ctx + "/welcome.jsp");
		} catch (IllegalArgumentException e) {
			req.setAttribute("err", e.getMessage());
			req.getRequestDispatcher("/register.jsp").forward(req, resp);
		} catch (Exception e) {
			req.setAttribute("err", "Đã xảy ra lỗi: " + e.getMessage());
			req.getRequestDispatcher("/register.jsp").forward(req, resp);
		}
	}

	private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		HttpSession session = req.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		resp.sendRedirect(req.getContextPath() + "/auth/login");
	}
}

