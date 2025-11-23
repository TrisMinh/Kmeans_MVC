<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,model.Bean.JobBean,model.Bean.ResultBean"%>
<%@ page import="java.time.*, java.time.format.DateTimeFormatter" %>
<%
  // formatter cho cột "Tạo lúc"
  DateTimeFormatter F = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
  ZoneId Z = ZoneOffset.UTC;
%>
<%
String ctx = request.getContextPath();
Object jobsObj = request.getAttribute("jobs");
List<?> jobs = jobsObj instanceof List ? (List<?>) jobsObj : java.util.Collections.emptyList();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Jobs ảnh</title>
<style>
body {
	font-family: system-ui, Arial, sans-serif;
	margin: 0;
	padding: 24px;
	background: #f6f7fb;
}
.container { max-width: 1400px; margin: 0 auto; }
nav { background: #fff; padding: 16px 24px; border-radius: 8px; margin-bottom: 24px; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); }
nav a { margin-right: 16px; color: #667eea; text-decoration: none; font-weight: 500; padding: 8px 12px; border-radius: 6px; transition: background 0.2s; }
nav a:hover { background: #f0f0f0; }
h2 { margin: 0 0 20px; font-size: 20px; font-weight: 600; }
.table-wrapper { background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); overflow: hidden; }
.table-header { padding: 20px 24px; border-bottom: 1px solid #e5e7eb; }
table { width: 100%; border-collapse: collapse; }
th, td { padding: 14px 24px; text-align: left; }
th { background: #fafbfc; font-weight: 600; font-size: 13px; color: #6b7280; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 1px solid #e5e7eb; }
td { border-bottom: 1px solid #f3f4f6; color: #374151; }
tbody tr:hover { background: #f9fafb; }
tbody tr:last-child td { border-bottom: none; }
.badge { display: inline-block; padding: 4px 10px; border: 1px solid #e5e7eb; border-radius: 999px; font-size: 12px; font-weight: 500; background: #fff; }
.done { background: #ecfdf5; border-color: #a7f3d0; color: #065f46; }
.run { background: #fffbea; border-color: #fde68a; color: #92400e; }
.fail { background: #fef2f2; border-color: #fecaca; color: #991b1b; }
.wait { background: #fffbea; border-color: #fde68a; color: #92400e; }
.actions { display: flex; gap: 8px; }
.actions a { color: #667eea; text-decoration: none; font-size: 14px; font-weight: 500; transition: color 0.2s; }
.actions a:hover { color: #5568d3; text-decoration: underline; }
img.thumb { height: 48px; width: 48px; object-fit: cover; border: 1px solid #e5e7eb; border-radius: 6px; cursor: pointer; transition: transform 0.2s; }
img.thumb:hover { transform: scale(1.1); box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15); }
.empty { text-align: center; padding: 48px 20px; color: #9ca3af; }
@media ( max-width : 768px) {
	body { padding: 12px; }
	th, td { padding: 10px 12px; font-size: 13px; }
	img.thumb { height: 36px; width: 36px; }
	.actions { flex-direction: column; gap: 4px; }
}
</style>
</head>
<body>
	<div class="container">
		<nav>
			<a href="<%=ctx%>/image-upload.jsp">Nén ảnh</a>
			<a href="<%=ctx%>/jobs">Jobs</a>
		</nav>

		<div class="table-wrapper">
			<div class="table-header">
				<h2>Danh sách job (ẢNH)</h2>
			</div>

			<table>
				<thead>
					<tr>
						<th>ID</th>
						<th>K</th>
						<th>Trạng thái</th>
						<th>Tạo lúc</th>
						<th>Xem nhanh</th>
						<th>Hành động</th>
					</tr>
				</thead>
				<tbody>
					<%
					if (jobs.isEmpty()) {
					%>
					<tr>
						<td colspan="6" class="empty">Chưa có job nào.</td>
					</tr>
					<%
					} else {
					  for (Object o : jobs) {
						long id; int k; String status; String type; String outRel = null;
						String displayCreated = "";

						if (o instanceof JobBean) {
							JobBean j = (JobBean) o;
							id = j.getId();
							k = j.getK();
							status = j.getStatus();
							type = "IMAGE";
							if (j.getCreatedAt() != null) {
								displayCreated = F.format(j.getCreatedAt().atZone(Z)); // format đẹp
							}
						} else {
							Map m = (Map) o;
							id = ((Number) m.get("id")).longValue();
							k = ((Number) m.get("k")).intValue();
							status = String.valueOf(m.get("status"));
							type = String.valueOf(m.get("type"));
							Object c = m.get("createdAt");
							if (c != null) {
								try { displayCreated = F.format(Instant.parse(String.valueOf(c)).atZone(Z)); }
								catch (Exception ignore) { displayCreated = String.valueOf(c); }
							}
							Object rp = m.get("outputRelPath");
							if (rp != null) outRel = String.valueOf(rp);
						}

						if (!"IMAGE".equals(type)) continue;
						String badge = "badge";
						if ("DONE".equals(status)) badge += " done";
						else if ("PENDING".equals(status)) badge += " run";
						else if ("FAILED".equals(status)) badge += " fail";
						else badge += " wait";
					%>
					<tr>
						<td><strong>#<%=id%></strong></td>
						<td><%=k%></td>
						<td><span class="<%=badge%>"><%=status%></span></td>
						<td><%=displayCreated%></td>
						<td>
							<% if (outRel != null && !"".equals(outRel)) { %>
							  <img class="thumb" src="<%=ctx%>/files/<%=outRel%>" alt="thumb" />
							<% } else { %>—<% } %>
						</td>
						<td>
							<div class="actions">
								<a href="<%=ctx%>/jobs?id=<%=id%>">Chi tiết</a>
								<% if (outRel != null && !"".equals(outRel)) { %>
								  <a href="<%=ctx%>/files/<%=outRel%>" download>Tải về</a>
								<% } %>
							</div>
						</td>
					</tr>
					<%
					  } // end for
					} // end else
					%>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>
