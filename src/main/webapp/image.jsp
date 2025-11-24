<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,model.Bean.ResultBean,model.Bean.UserBean"%>
<%@ page import="java.time.*" %>
<%
String ctx = request.getContextPath();
if (session == null || session.getAttribute("uid") == null) {
    response.sendRedirect(ctx + "/auth/login");
    return;
}

String userRole = (String) session.getAttribute("userRole");
if (userRole == null || !"ADMIN".equals(userRole)) {
    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ ADMIN mới được truy cập trang này");
    return;
}

Object resultsObj = request.getAttribute("results");
List<?> results = resultsObj instanceof List ? (List<?>) resultsObj : java.util.Collections.emptyList();
UserBean filteredUser = (UserBean) request.getAttribute("filteredUser");
String userEmail = (String) session.getAttribute("userEmail");
String welcomeName = userEmail != null ? userEmail.split("@")[0] : "User";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Ảnh</title>
    <style>
        body {
            font-family: system-ui, Arial, sans-serif;
            margin: 0;
            padding: 24px;
            background: #f6f7fb;
        }
        .container { max-width: 1400px; margin: 0 auto; }
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
        nav a:hover { background: #f0f0f0; }
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
        .card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e5e7eb;
        }
        .card-header h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
            color: #374151;
        }
        .image-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
            padding: 24px;
        }
        .image-item {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .image-item:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        .image-item img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            display: block;
        }
        .image-info {
            padding: 16px;
        }
        .image-info h3 {
            margin: 0 0 4px 0;
            font-size: 16px;
            color: #374151;
        }
        .image-owner {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 8px;
        }
        .image-meta {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 12px;
        }
        .image-actions {
            display: flex;
            gap: 8px;
        }
        .image-actions a {
            flex: 1;
            padding: 8px 12px;
            text-align: center;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            transition: background 0.2s;
        }
        .btn-view {
            background: #667eea;
            color: white;
        }
        .btn-view:hover {
            background: #5568d3;
        }
        .btn-download {
            background: #f3f4f6;
            color: #374151;
            border: 1px solid #e5e7eb;
        }
        .btn-download:hover {
            background: #e5e7eb;
        }
        .empty {
            text-align: center;
            padding: 48px 20px;
            color: #9ca3af;
        }
        .filter-info {
            font-size: 14px;
            color: #4b5563;
            margin-left: 8px;
        }
        .filter-actions {
            margin-top: 12px;
            display: flex;
            gap: 8px;
        }
        .btn-secondary {
            padding: 8px 14px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            background: #fff;
            text-decoration: none;
            color: #374151;
            font-size: 14px;
            font-weight: 500;
        }
        .btn-secondary:hover {
            background: #f3f4f6;
        }
    </style>
</head>
<body>
    <div class="container">
        <nav>
            <div class="nav-links">
                <a href="<%=ctx%>/welcome.jsp">Trang chính</a>
                <a href="<%=ctx%>/ImageController">Nén ảnh</a>
                <a href="<%=ctx%>/images">Ảnh</a>
                <a href="<%=ctx%>/users">User</a>
            </div>
            <div class="nav-right">
                <span class="welcome">Welcome <%=welcomeName%></span>
                <a href="<%=ctx%>/auth/logout" class="logout">Đăng xuất</a>
            </div>
        </nav>

        <div class="card">
            <div class="card-header" style="display:flex; flex-direction:column; gap:4px;">
                <div style="display:flex; align-items:center; justify-content:space-between;">
                    <h2>Danh sách Ảnh</h2>
                    <% if (filteredUser != null) { %>
                        <span class="filter-info">User #<%=filteredUser.getId()%> - <%=filteredUser.getEmail()%></span>
                    <% } %>
                </div>
                <% if (filteredUser != null) { %>
                <div class="filter-actions">
                    <a href="<%=ctx%>/images" class="btn-secondary">Xem tất cả ảnh</a>
                </div>
                <% } %>
            </div>
            <%
            if (results.isEmpty()) {
            %>
            <div class="empty">Chưa có ảnh nào.</div>
            <%
            } else {
            %>
            <div class="image-grid">
                <%
                for (Object obj : results) {
                    ResultBean result = (ResultBean) obj;
                    String displayCreated = "";
                    if (result.getCreatedAt() != null) {
                        displayCreated = result.getCreatedAt().toString();
                    }
                    String imagePath = ctx + "/files/" + result.getOutputRelPath();
                    String ownerEmail = result.getOwnerEmail();
                %>
                <div class="image-item">
                    <img src="<%=imagePath%>" alt="Result image" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'300\' height=\'200\'%3E%3Crect fill=\'%23f3f4f6\' width=\'300\' height=\'200\'/%3E%3Ctext fill=\'%239ca3af\' font-family=\'sans-serif\' font-size=\'14\' x=\'50%25\' y=\'50%25\' text-anchor=\'middle\' dominant-baseline=\'middle\'%3EẢnh không tìm thấy%3C/text%3E%3C/svg%3E'">
                    <div class="image-info">
                        <h3>Job #<%=result.getJobId()%></h3>
                        <div class="image-owner">Bởi: <%=ownerEmail != null ? ownerEmail : "Không xác định"%></div>
                        <div class="image-meta">
                            <div>Kích thước: <%=result.getWidth()%> x <%=result.getHeight()%></div>
                            <div>Điểm: <%=result.getnPoints()%></div>
                            <div>Tạo lúc: <%=displayCreated%></div>
                            <% if (result.getSummary() != null) { %>
                                <div><%=result.getSummary()%></div>
                            <% } %>
                        </div>
                        <div class="image-actions">
                            <a href="<%=ctx%>/jobs?id=<%=result.getJobId()%>" class="btn-view">Chi tiết</a>
                            <a href="<%=imagePath%>" download class="btn-download">Tải về</a>
                        </div>
                    </div>
                </div>
                <%
                }
                %>
            </div>
            <%
            }
            %>
        </div>
    </div>
</body>
</html>

