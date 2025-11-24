<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,model.Bean.UserBean"%>
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

Object usersObj = request.getAttribute("users");
List<?> users = usersObj instanceof List ? (List<?>) usersObj : java.util.Collections.emptyList();
String error = (String) request.getAttribute("error");
UserBean editUser = (UserBean) request.getAttribute("user");
String userEmail = (String) session.getAttribute("userEmail");
String welcomeName = userEmail != null ? userEmail.split("@")[0] : "User";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý User</title>
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
        nav {
            display: flex;
            align-items: center;
        }
        nav .logout {
            margin-left: auto;
            color: #ef4444;
        }
        nav .logout:hover {
            background: #fef2f2;
        }
        .main-grid {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 24px;
            align-items: start;
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
        .card-body {
            padding: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 14px;
            color: #374151;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-primary {
            width: 100%;
            padding: 12px 24px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-primary:hover {
            background: #5568d3;
        }
        .btn-secondary {
            padding: 8px 16px;
            background: #6b7280;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }
        .btn-secondary:hover {
            background: #4b5563;
        }
        .error-message {
            margin-top: 16px;
            padding: 12px 16px;
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 6px;
            color: #991b1b;
            font-size: 14px;
        }
        .table-wrapper {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 14px 24px;
            text-align: left;
        }
        th {
            background: #fafbfc;
            font-weight: 600;
            font-size: 13px;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #e5e7eb;
        }
        td {
            border-bottom: 1px solid #f3f4f6;
            color: #374151;
        }
        tbody tr:hover {
            background: #f9fafb;
        }
        .user-row {
            cursor: pointer;
        }
        .user-row:focus-within {
            outline: 2px solid #c7d2fe;
            outline-offset: -2px;
        }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 500;
        }
        .badge.user { background: #dbeafe; color: #1e40af; }
        .badge.admin { background: #fef3c7; color: #92400e; }
        .actions {
            display: flex;
            gap: 8px;
        }
        .actions a, .actions button {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            font-family: inherit;
            font-weight: 500;
            transition: background 0.2s;
        }
        .btn-edit {
            background: #667eea;
            color: white;
        }
        .btn-edit:hover {
            background: #5568d3;
        }
        .btn-delete {
            background: #ef4444;
            color: white;
            display: inline-block;
            text-align: center;
        }
        .btn-delete:hover {
            background: #dc2626;
        }
        .empty {
            text-align: center;
            padding: 48px 20px;
            color: #9ca3af;
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

        <div class="main-grid">
            <div class="card">
                <div class="card-header">
                    <h2><%= editUser != null ? "Sửa User" : "Thêm User" %></h2>
                </div>
                <div class="card-body">
                    <form method="post" action="<%=ctx%>/users">
                        <input type="hidden" name="action" value="<%= editUser != null ? "update" : "create" %>">
                        <% if (editUser != null) { %>
                            <input type="hidden" name="id" value="<%= editUser.getId() %>">
                        <% } %>
                        
                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="email" name="email" id="email" 
                                value="<%= editUser != null ? editUser.getEmail() : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label for="password">Mật khẩu:</label>
                            <input type="password" name="password" id="password" 
                                <%= editUser == null ? "required" : "placeholder='Để trống nếu không đổi'" %>>
                        </div>

                        <div class="form-group">
                            <label for="role">Role:</label>
                            <select name="role" id="role">
                                <option value="USER" <%= editUser != null && "USER".equals(editUser.getRole()) ? "selected" : "" %>>USER</option>
                                <option value="ADMIN" <%= editUser != null && "ADMIN".equals(editUser.getRole()) ? "selected" : "" %>>ADMIN</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn-primary">
                                <%= editUser != null ? "Cập nhật" : "Tạo mới" %>
                            </button>
                            <% if (editUser != null) { %>
                                <a href="<%=ctx%>/users" class="btn-secondary">Hủy</a>
                            <% } %>
                        </div>
                    </form>

                    <% if (error != null) { %>
                        <div class="error-message"><%=error%></div>
                    <% } %>
                </div>
            </div>

            <div class="table-wrapper">
                <div class="card-header">
                    <h2>Danh sách User</h2>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Tạo lúc</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (users.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="5" class="empty">Chưa có user nào.</td>
                        </tr>
                        <%
                        } else {
                            for (Object obj : users) {
                                UserBean user = (UserBean) obj;
                                String displayCreated = "";
                                if (user.getCreatedAt() != null) {
                                    displayCreated = user.getCreatedAt().toString();
                                }
                        %>
                        <tr class="user-row" data-href="<%=ctx%>/images?userId=<%=user.getId()%>">
                            <td><strong>#<%=user.getId()%></strong></td>
                            <td><%=user.getEmail()%></td>
                            <td>
                                <span class="badge <%=user.getRole().toLowerCase()%>">
                                    <%=user.getRole()%>
                                </span>
                            </td>
                            <td><%=displayCreated%></td>
                            <td>
                                <div class="actions">
                                    <a href="<%=ctx%>/users?action=edit&id=<%=user.getId()%>" class="btn-edit" onclick="event.stopPropagation();">Sửa</a>
                                    <form method="post" action="<%=ctx%>/users" style="display:inline; margin:0;" onclick="event.stopPropagation();">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%=user.getId()%>">
                                        <button type="submit" class="btn-delete" 
                                            onclick="event.stopPropagation(); return confirm('Bạn có chắc muốn xóa user này?')">Xóa</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script>
        document.querySelectorAll('.user-row').forEach(function(row) {
            row.addEventListener('click', function() {
                var href = row.getAttribute('data-href');
                if (href) {
                    window.location.href = href;
                }
            });
        });
    </script>
</body>
</html>
