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
import model.Bean.JobBean;

public class JobDAO {

	public JobBean insert(JobBean job) {
		String sql = "INSERT INTO jobs(user_id,type,k,status,input_path) VALUES (?,?,?,?,?)";
		try (Connection c = DBConnect.getConnection();
				PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setLong(1, job.getUserId());
			ps.setString(2, "IMAGE");
			ps.setInt(3, job.getK());
			ps.setString(4, job.getStatus());
			ps.setString(5, job.getInputPath());
			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next())
					job.setId(rs.getLong(1));
			}
			return job;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException("insert job failed", e);
		}
	}

	public void updateStatusAndDuration(long id, String status, long durationMs, String errMsg) {
		String sql = "UPDATE jobs SET status=?, duration_ms=?, error_message=? WHERE id=?";
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setLong(2, durationMs);
			ps.setString(3, errMsg);
			ps.setLong(4, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new RuntimeException("update job failed", e);
		}
	}

	public JobBean findById(long id) {
		String sql = "SELECT id,user_id,type,k,status,duration_ms,input_path,created_at FROM jobs WHERE id=?";
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setLong(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return null;
				JobBean j = new JobBean();
				j.setId(rs.getLong("id"));
				j.setUserId(rs.getLong("user_id"));
				j.setType(JobBean.Type.IMAGE);
				j.setK(rs.getInt("k"));
				j.setStatus(rs.getString("status"));
				j.setDurationMs(rs.getLong("duration_ms"));
				j.setInputPath(rs.getString("input_path"));
				Timestamp ts = rs.getTimestamp("created_at");
				if (ts != null)
					j.setCreatedAt(ts.toInstant());
				return j;
			}
		} catch (SQLException e) {
			throw new RuntimeException("find job failed", e);
		}
	}

	public List<JobBean> listByUser(long userId, int offset, int limit) {
		String sql = "SELECT id,user_id,type,k,status,duration_ms,input_path,created_at FROM jobs WHERE user_id=? ORDER BY created_at DESC LIMIT ? OFFSET ?";
		List<JobBean> list = new ArrayList<>();
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setLong(1, userId);
			ps.setInt(2, limit);
			ps.setInt(3, offset);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					JobBean j = new JobBean();
					j.setId(rs.getLong("id"));
					j.setUserId(rs.getLong("user_id"));
					j.setType(JobBean.Type.IMAGE);
					j.setK(rs.getInt("k"));
					j.setStatus(rs.getString("status"));
					j.setDurationMs(rs.getLong("duration_ms"));
					j.setInputPath(rs.getString("input_path"));
					Timestamp ts = rs.getTimestamp("created_at");
					if (ts != null)
						j.setCreatedAt(ts.toInstant());
					list.add(j);
				}
			}
		} catch (SQLException e) {
			throw new RuntimeException("list jobs failed", e);
		}
		return list;
	}
	
	// Trí làm thêm
	
	public List<JobBean> findPendingJobs() {
		List<JobBean> list = new ArrayList<JobBean>();
		String sql = "SELECT id,user_id,type,k,status,duration_ms,input_path,created_at FROM jobs WHERE status IN ('PENDING','RUNNING') ORDER BY created_at ASC";
		try (Connection c = DBConnect.getConnection();PreparedStatement ps = c.prepareStatement(sql)) {
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					JobBean j = new JobBean();
					j.setId(rs.getLong("id"));
					j.setUserId(rs.getLong("user_id"));
					j.setType(JobBean.Type.IMAGE);
					j.setK(rs.getInt("k"));
					j.setStatus(rs.getString("status"));
					j.setDurationMs(rs.getLong("duration_ms"));
					j.setInputPath(rs.getString("input_path"));
					Timestamp ts = rs.getTimestamp("created_at");
					if (ts != null)
						j.setCreatedAt(ts.toInstant());
					list.add(j);
				}
			} 	
		}	catch (SQLException e) {
			throw new RuntimeException("find pending jobs fail", e);
		}	
		return list;
	}
	
	public void updateStatus(long id, String status) {
		String sql = "UPDATE jobs SET status=? WHERE id=?";
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setLong(2, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new RuntimeException("update job status failed", e);
		}
	}
	
	public void updateInputPath(long id, String inputPath) {
		String sql = "UPDATE jobs SET input_path=? WHERE id=?";
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, inputPath);
			ps.setLong(2, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			throw new RuntimeException("update job input_path failed", e);
		}
	}
	
}
