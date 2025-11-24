package model.BO;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import model.Bean.UserBean;
import model.DAO.UserDAO;

public class UserBO {
	private final UserDAO userDAO = new UserDAO();

	public UserBean register(String email, String password) {
		UserBean existing = userDAO.findByEmail(email);
		if (existing != null) {
			throw new IllegalArgumentException("Email đã tồn tại");
		}
		if (email == null || email.trim().isEmpty()) {
			throw new IllegalArgumentException("Email không được để trống");
		}
		if (password == null || password.length() < 6) {
			throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự");
		}

		String passwordHash = hashPassword(password);

		UserBean user = new UserBean();
		user.setEmail(email.trim().toLowerCase());
		user.setPasswordHash(passwordHash);
		user.setRole("USER");
		return userDAO.insert(user);
	}

	public UserBean login(String email, String password) {
		if (email == null || email.trim().isEmpty()) {
			throw new IllegalArgumentException("Email không được để trống");
		}
		if (password == null || password.isEmpty()) {
			throw new IllegalArgumentException("Mật khẩu không được để trống");
		}

		UserBean user = userDAO.findByEmail(email.trim().toLowerCase());
		if (user == null) {
			throw new IllegalArgumentException("Email hoặc mật khẩu không đúng");
		}

		String storedHash = user.getPasswordHash();
		boolean isHashed = storedHash != null && storedHash.length() == 64 && storedHash.matches("[0-9a-f]+");
		
		if (isHashed) {
			String passwordHash = hashPassword(password);
			if (!passwordHash.equals(storedHash)) {
				throw new IllegalArgumentException("Email hoặc mật khẩu không đúng");
			}
		} else {
			if (!password.equals(storedHash)) {
				throw new IllegalArgumentException("Email hoặc mật khẩu không đúng");
			}
		}

		return user;
	}

	public List<UserBean> listAll() {
		return userDAO.listAll();
	}

	public UserBean findById(long id) {
		return userDAO.findById(id);
	}

	public UserBean create(String email, String password, String role) {
		UserBean existing = userDAO.findByEmail(email);
		if (existing != null) {
			throw new IllegalArgumentException("Email đã tồn tại");
		}
		if (email == null || email.trim().isEmpty()) {
			throw new IllegalArgumentException("Email không được để trống");
		}
		if (password == null || password.length() < 6) {
			throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự");
		}
		if (role == null || role.trim().isEmpty()) {
			role = "USER";
		}

		String passwordHash = hashPassword(password);

		UserBean user = new UserBean();
		user.setEmail(email.trim().toLowerCase());
		user.setPasswordHash(passwordHash);
		user.setRole(role);
		return userDAO.insert(user);
	}

	public UserBean update(long id, String email, String password, String role) {
		UserBean user = userDAO.findById(id);
		if (user == null) {
			throw new IllegalArgumentException("User không tồn tại");
		}

		if (email != null && !email.trim().isEmpty()) {
			UserBean existing = userDAO.findByEmail(email.trim().toLowerCase());
			if (existing != null && existing.getId() != id) {
				throw new IllegalArgumentException("Email đã được sử dụng bởi user khác");
			}
			user.setEmail(email.trim().toLowerCase());
		}

		if (password != null && !password.isEmpty()) {
			if (password.length() < 6) {
				throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự");
			}
			user.setPasswordHash(hashPassword(password));
		}

		if (role != null && !role.trim().isEmpty()) {
			user.setRole(role);
		}

		userDAO.update(user);
		return user;
	}

	public void delete(long id) {
		UserBean user = userDAO.findById(id);
		if (user == null) {
			throw new IllegalArgumentException("User không tồn tại");
		}
		userDAO.delete(id);
	}

	private String hashPassword(String password) {
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
			StringBuilder hexString = new StringBuilder();
			for (byte b : hash) {
				String hex = Integer.toHexString(0xff & b);
				if (hex.length() == 1) {
					hexString.append('0');
				}
				hexString.append(hex);
			}
			return hexString.toString();
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("Hash password failed", e);
		}
	}
}

