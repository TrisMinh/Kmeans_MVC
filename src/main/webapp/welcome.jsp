<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String ctx = request.getContextPath();
if (session == null || session.getAttribute("uid") == null) {
    response.sendRedirect(ctx + "/auth/login");
    return;
}

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
    <title>Trang chủ - K-Means</title>
    <style>
        body {
            font-family: system-ui, Arial, sans-serif;
            margin: 0;
            padding: 24px;
            background: #f6f7fb;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .container { 
            max-width: 1400px; 
            margin: 0 auto; 
            width: 100%;
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
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        h1 {
            margin: 0 0 16px 0;
            font-size: 36px;
            font-weight: 600;
            color: #374151;
            text-align: center;
        }
        .subtitle {
            margin-bottom: 48px;
            font-size: 18px;
            color: #6b7280;
            text-align: center;
        }
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            width: 100%;
            max-width: 900px;
        }
        .menu-card {
            background: #fff;
            padding: 32px 24px;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
            text-decoration: none;
            display: block;
        }
        .menu-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
        }
        .menu-card .icon {
            font-size: 48px;
            margin-bottom: 16px;
        }
        .menu-card h2 {
            margin: 0 0 8px 0;
            font-size: 20px;
            font-weight: 600;
            color: #374151;
        }
        .menu-card p {
            margin: 0;
            font-size: 14px;
            color: #6b7280;
        }
        .icon-compress { color: #667eea; }
        .icon-image { color: #10b981; }
        .icon-user { color: #f59e0b; }
        @media (max-width: 768px) {
            body { padding: 12px; }
            h1 { font-size: 28px; }
            .menu-grid {
                grid-template-columns: 1fr;
                max-width: 400px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <nav>
            <div class="nav-links">
                <a href="<%=ctx%>/welcome.jsp">Trang chính</a>
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

        <div class="main-content">
            <h1>Chào mừng đến với K-Means</h1>
            <div class="subtitle">Chọn chức năng bạn muốn sử dụng</div>

            <div class="menu-grid">
                <a href="<%=ctx%>/ImageController" class="menu-card">
                    <div class="icon icon-compress">🖼️</div>
                    <h2>Nén ảnh</h2>
                    <p>Upload và nén ảnh bằng thuật toán K-Means</p>
                </a>

                <% if (isAdmin) { %>
                <a href="<%=ctx%>/images" class="menu-card">
                    <div class="icon icon-image">📷</div>
                    <h2>Quản lý Ảnh</h2>
                    <p>Xem tất cả ảnh đã được xử lý</p>
                </a>

                <a href="<%=ctx%>/users" class="menu-card">
                    <div class="icon icon-user">👥</div>
                    <h2>Quản lý User</h2>
                    <p>Thêm, sửa, xóa người dùng</p>
                </a>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>

