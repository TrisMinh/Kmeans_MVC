package model.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DBConnect;
import model.Bean.UserBean;

public class UserDAO {

	public UserBean insert(UserBean user) {
		String sql = "INSERT INTO users(email, password_hash, role) VALUES (?,?,?)";
		try (Connection c = DBConnect.getConnection();
				PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setString(1, user.getEmail());
			ps.setString(2, user.getPasswordHash());
			ps.setString(3, user.getRole());
			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next())
					user.setId(rs.getLong(1));
			}
			return user;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException("insert user failed", e);
		}
	}

	public UserBean findByEmail(String email) {
		String sql = "SELECT id, email, password_hash, role, created_at FROM users WHERE email=?";
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, email);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return null;
				return mapResultSetToUser(rs);
			}
		} catch (SQLException e) {
			throw new RuntimeException("find user by email failed", e);
		}
	}

	public UserBean findById(long id) {
		String sql = "SELECT id, email, password_hash, role, created_at FROM users WHERE id=?";
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setLong(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return null;
				return mapResultSetToUser(rs);
			}
		} catch (SQLException e) {
			throw new RuntimeException("find user by id failed", e);
		}
	}

	public List<UserBean> listAll() {
		String sql = "SELECT id, email, password_hash, role, created_at FROM users ORDER BY created_at DESC";
		List<UserBean> list = new ArrayList<>();
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapResultSetToUser(rs));
				}
			}
		} catch (SQLException e) {
			throw new RuntimeException("list all users failed", e);
		}
		return list;
	}

	public void update(UserBean user) {
		String sql = "UPDATE users SET email=?, password_hash=?, role=? WHERE id=?";
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, user.getEmail());
			ps.setString(2, user.getPasswordHash());
			ps.setString(3, user.getRole());
			ps.setLong(4, user.getId());
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new RuntimeException("update user failed", e);
		}
	}

	public void delete(long id) {
		String sql = "DELETE FROM users WHERE id=?";
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setLong(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new RuntimeException("delete user failed", e);
		}
	}

	private UserBean mapResultSetToUser(ResultSet rs) throws SQLException {
		UserBean u = new UserBean();
		u.setId(rs.getLong("id"));
		u.setEmail(rs.getString("email"));
		u.setPasswordHash(rs.getString("password_hash"));
		u.setRole(rs.getString("role"));
		Timestamp ts = rs.getTimestamp("created_at");
		if (ts != null)
			u.setCreatedAt(ts.toInstant());
		return u;
	}
}

