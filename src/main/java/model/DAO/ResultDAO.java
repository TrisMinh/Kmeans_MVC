package model.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Optional;

import DBConnection.DBConnect;
import model.Bean.ResultBean;

public class ResultDAO {

	public ResultBean insert(ResultBean r) {
		String sql = "INSERT INTO results(job_id, output_rel_path, width, height, n_points, summary) "
				+ "VALUES (?,?,?,?,?,?)";
		try (Connection c = DBConnect.getConnection();
				PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setLong(1, r.getJobId());
			ps.setString(2, r.getOutputRelPath());
			ps.setInt(3, r.getWidth());
			ps.setInt(4, r.getHeight());
			ps.setInt(5, r.getnPoints());
			ps.setString(6, r.getSummary());
			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next())
					r.setId(rs.getLong(1));
			}
			return r;
		} catch (SQLException e) {
			throw new RuntimeException("insert result failed", e);
		}
	}

	public ResultBean findByJob(long jobId) {
		String sql = "SELECT id, job_id, output_rel_path, width, height, n_points, summary, created_at "
				+ "FROM results WHERE job_id=?";
		try (Connection c = DBConnect.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setLong(1, jobId);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return null;
				ResultBean r = new ResultBean();
				r.setId(rs.getLong("id"));
				r.setJobId(rs.getLong("job_id"));
				r.setOutputRelPath(rs.getString("output_rel_path"));
				r.setWidth(rs.getInt("width"));
				r.setHeight(rs.getInt("height"));
				r.setnPoints(rs.getInt("n_points"));
				r.setSummary(rs.getString("summary"));
				Timestamp ts = rs.getTimestamp("created_at");
				if (ts != null)
					r.setCreatedAt(ts.toInstant());
				return r;
			}
		} catch (SQLException e) {
			throw new RuntimeException("find result failed", e);
		}
	}
}
