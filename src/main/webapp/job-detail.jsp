<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Bean.JobBean,model.Bean.ResultBean"%>
<%
String ctx = request.getContextPath();
JobBean job = (JobBean) request.getAttribute("job");
ResultBean result = (ResultBean) request.getAttribute("result");
String outRel = (result != null) ? result.getOutputRelPath() : null;
String userRole = (String) session.getAttribute("userRole");
boolean isAdmin = "ADMIN".equals(userRole);
String userEmail = (String) session.getAttribute("userEmail");
String welcomeName = userEmail != null ? userEmail.split("@")[0] : "User";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Job #<%=job == null ? "?" : job.getId()%></title>
<style>
body {
	font-family: system-ui, Arial, sans-serif;
	margin: 0;
	padding: 24px;
	background: #f6f7fb;
}

.container {
	max-width: 1400px;
	margin: 0 auto;
}

nav {
	background: #fff;
	padding: 16px 24px;
	border-radius: 8px;
	margin-bottom: 24px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
	display: flex;
	align-items: center;
	justify-content: space-between;
}

nav a {
	margin-right: 16px;
	color: #667eea;
	text-decoration: none;
	font-weight: 500;
	padding: 8px 12px;
	border-radius: 6px;
	transition: background 0.2s;
}

nav a:hover {
	background: #f0f0f0;
}

.nav-links {
	display: flex;
	align-items: center;
	gap: 0;
}

.nav-right {
	display: flex;
	align-items: center;
	gap: 16px;
}

nav .welcome {
	color: #4b5563;
	font-weight: 500;
}

nav .logout {
	color: #ef4444;
}

nav .logout:hover {
	background: #fef2f2;
}

h2 {
	margin: 0 0 20px;
	margin-left: 20px;
	font-size: 20px;
	font-weight: 600;
}

.card {
	margin-right: auto;
	margin-left: auto;
	background: #fff;
	border-radius: 8px;
	padding: 24px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
	max-width: 980px;
}

.meta-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
	gap: 16px;
	margin-bottom: 20px;
}

.meta-item {
	padding: 12px;
	background: #f9fafb;
	border-radius: 6px;
}

.meta-label {
	font-size: 13px;
	color: #6b7280;
	margin-bottom: 4px;
}

.meta-value {
	font-size: 16px;
	font-weight: 600;
	color: #374151;
}

.badge {
	display: inline-block;
	padding: 4px 10px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 500;
}

.badge.done {
	background: #ecfdf5;
	color: #065f46;
}

.badge.run {
	background: #eff6ff;
	color: #1e40af;
}

.badge.fail {
	background: #fef2f2;
	color: #991b1b;
}

.badge.wait {
	background: #fffbea;
	color: #92400e;
}

hr {
	border: none;
	border-top: 1px solid #e5e7eb;
	margin: 20px 0;
}

.result-section {
	margin-top: 20px;
}

.result-section h3 {
	font-size: 16px;
	font-weight: 600;
	margin-bottom: 16px;
	color: #374151;
}

.image-container {
	max-width: 800px;
	margin: 0 auto;
	text-align: center;
}

img.result {
	max-width: 100%;
	max-height: 600px;
	width: auto;
	height: auto;
	border: 1px solid #e5e7eb;
	border-radius: 8px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	display: block;
	margin: 0 auto 16px;
}

.actions {
	text-align: center;
}

.actions a {
	display: inline-block;
	background: #667eea;
	color: #fff;
	text-decoration: none;
	padding: 10px 20px;
	border-radius: 6px;
	font-weight: 500;
	transition: background 0.2s, transform 0.1s;
}

.actions a:hover {
	background: #5568d3;
	transform: translateY(-1px);
}

.actions a:active {
	transform: translateY(0);
}

.no-result {
	text-align: center;
	padding: 40px 20px;
	color: #6b7280;
	background: #f9fafb;
	border-radius: 8px;
}

@media ( max-width : 768px) {
	body {
		padding: 12px;
	}
	.card {
		padding: 16px;
	}
	.meta-grid {
		grid-template-columns: 1fr;
	}
	img.result {
		max-height: 400px;
	}
}
</style>
</head>
<body>
	<div class="container">
		<nav>
			<div class="nav-links">
				<a href="<%=ctx%>/welcome.jsp">Trang chính</a>
				<a href="<%=ctx%>/ImageController">Nén ảnh</a>
				<% if (isAdmin) { %>
					<a href="<%=ctx%>/images">Ảnh</a>
					<a href="<%=ctx%>/users">User</a>
				<% } %>
			</div>
			<div class="nav-right">
				<span class="welcome">Welcome <%=welcomeName%></span>
				<a href="<%=ctx%>/auth/logout" class="logout">Đăng xuất</a>
			</div>
		</nav>

		<h2>
			Job #<%=job == null ? "?" : job.getId()%></h2>

		<div class="card">
			<div class="meta-grid">
				<div class="meta-item">
					<div class="meta-label">Trạng thái</div>
					<div class="meta-value">
						<%
						String status = job == null ? "-" : job.getStatus();
						String badgeClass = "badge";
						if ("DONE".equals(status))
							badgeClass += " done";
						else if ("RUNNING".equals(status))
							badgeClass += " run";
						else if ("FAILED".equals(status))
							badgeClass += " fail";
						else
							badgeClass += " wait";
						%>
						<span class="<%=badgeClass%>"><%=status%></span>
					</div>
				</div>

				<div class="meta-item">
					<div class="meta-label">Số màu (K)</div>
					<div class="meta-value"><%=job == null ? "-" : job.getK()%></div>
				</div>

				<div class="meta-item">
					<div class="meta-label">Thời gian xử lý</div>
					<div class="meta-value"><%=job == null ? "-" : job.getDurationMs()%>
						ms
					</div>
				</div>
			</div>

			<hr />

			<div class="result-section">
				<%
				if (outRel != null && !"".equals(outRel)) {
				%>
				<h3>Kết quả</h3>
				<div class="image-container">
					<img class="result" src="<%=ctx%>/files/<%=outRel%>"
						alt="Result image" />
				</div>
				<div class="actions">
					<a href="<%=ctx%>/files/<%=outRel%>" download>Tải về</a>
				</div>
				<%
				} else {
				%>
				<div class="no-result">
					<p>Chưa có kết quả hiển thị.</p>
					<p style="font-size: 14px; margin-top: 8px;">Nếu trạng thái vẫn
						PENDING, thử tải lại trang sau khi xử lý xong.</p>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</div>
</body>
</html>