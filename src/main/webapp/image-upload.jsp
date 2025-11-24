<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,model.Bean.JobBean"%>
<%@ page import="java.time.*, java.time.format.DateTimeFormatter" %>
<%
String ctx = request.getContextPath();
DateTimeFormatter F = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
ZoneId Z = ZoneOffset.UTC;
Object jobsObj = request.getAttribute("jobs");
List<?> jobs = jobsObj instanceof List ? (List<?>) jobsObj : java.util.Collections.emptyList();
String error = (String) request.getAttribute("error");
String userRole = (String) session.getAttribute("userRole");
boolean isAdmin = "ADMIN".equals(userRole);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>K-Means Image Compression</title>
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
        .form-group:last-child {
            margin-bottom: 0;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 14px;
            color: #374151;
        }
        input[type="file"],
        input[type="number"] {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box;
        }
        input[type="file"]:focus,
        input[type="number"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        input[type="number"] {
            -moz-appearance: textfield;
        }
        input[type="number"]::-webkit-inner-spin-button,
        input[type="number"]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
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
            transition: background 0.2s, transform 0.1s;
        }
        .btn-primary:hover {
            background: #5568d3;
        }
        .btn-primary:active {
            transform: scale(0.98);
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
        tbody tr:last-child td {
            border-bottom: none;
        }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border: 1px solid #e5e7eb;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 500;
            background: #fff;
        }
        .done { background: #ecfdf5; border-color: #a7f3d0; color: #065f46; }
        .run { background: #fffbea; border-color: #fde68a; color: #92400e; }
        .fail { background: #fef2f2; border-color: #fecaca; color: #991b1b; }
        .wait { background: #fffbea; border-color: #fde68a; color: #92400e; }
        .actions a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.2s;
        }
        .actions a:hover {
            color: #5568d3;
            text-decoration: underline;
        }
        .empty {
            text-align: center;
            padding: 48px 20px;
            color: #9ca3af;
        }
        @media (max-width: 1024px) {
            .main-grid {
                grid-template-columns: 1fr;
            }
        }
        @media (max-width: 768px) {
            body { padding: 12px; }
            th, td { padding: 10px 12px; font-size: 13px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <nav style="display: flex; align-items: center;">
            <div style="display: flex; gap: 0;">
                <a href="<%=ctx%>/ImageController">Nén ảnh</a>
                <% if (isAdmin) { %>
                    <a href="<%=ctx%>/images">Ảnh</a>
                    <a href="<%=ctx%>/users">User</a>
                <% } %>
            </div>
            <a href="<%=ctx%>/auth/logout" class="logout">Đăng xuất</a>
        </nav>

        <div class="main-grid">
            <div class="card">
                <div class="card-header">
                    <h2>Tải ảnh lên</h2>
                </div>
                <div class="card-body">
                    <form action="ImageController" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label for="file">Chọn ảnh:</label>
                            <input type="file" name="file" id="file" accept="image/*" required>
                        </div>

                        <div class="form-group">
                            <label for="k">Số cụm (k):</label>
                            <input type="number" name="k" id="k" min="2" max="50" value="5" required>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn-primary">Bắt đầu nén ảnh</button>
                        </div>
                    </form>

                    <% if (error != null) { %>
                        <div class="error-message"><%=error%></div>
                    <% } %>
                </div>
            </div>

            <div class="table-wrapper">
                <div class="card-header">
                    <h2>Danh sách công việc</h2>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>K</th>
                            <th>Trạng thái</th>
                            <th>Tạo lúc</th>
                            <th>Thời gian (ms)</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (jobs.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="6" class="empty">Chưa có công việc nào.</td>
                        </tr>
                        <%
                        } else {
                            for (Object obj : jobs) {
                                JobBean job = (JobBean) obj;
                                String badge = "badge";
                                if ("DONE".equals(job.getStatus())) badge += " done";
                                else if ("PENDING".equals(job.getStatus())) badge += " run";
                                else if ("FAILED".equals(job.getStatus())) badge += " fail";
                                else badge += " wait";
                                
                                String displayCreated = "";
                                if (job.getCreatedAt() != null) {
                                    displayCreated = F.format(job.getCreatedAt().atZone(Z));
                                }
                        %>
                        <tr>
                            <td><strong>#<%=job.getId()%></strong></td>
                            <td><%=job.getK()%></td>
                            <td><span class="<%=badge%>"><%=job.getStatus()%></span></td>
                            <td><%=displayCreated%></td>
                            <td><%=job.getDurationMs()%></td>
                            <td>
                                <div class="actions">
                                    <% if ("DONE".equals(job.getStatus())) { %>
                                        <a href="<%=ctx%>/jobs?id=<%=job.getId()%>">Chi tiết</a>
                                    <% } %>
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
</body>
</html>
