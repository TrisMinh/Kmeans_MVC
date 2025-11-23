<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String ctx = request.getContextPath();
  String err = (String) request.getAttribute("err");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng ký</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  body {
    margin: 0;
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    background: #f5f7fb;
    color: #111827;
  }
  .wrap {
    max-width: 420px;
    margin: 40px auto;
    padding: 16px;
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
  }
  h1 {
    margin: 0 0 12px 0;
    font-size: 20px;
  }
  label {
    display: block;
    margin: 12px 0 6px;
    font-weight: 600;
  }
  input[type="email"],
  input[type="password"] {
    width: 100%;
    height: 40px;
    padding: 0 12px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    background: #ffffff;
  }
  .actions {
    margin-top: 14px;
    display: flex;
    gap: 10px;
  }
  button,
  a.btn {
    height: 40px;
    padding: 0 16px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    background: #ffffff;
    text-decoration: none;
    color: #111827;
    display: inline-flex;
    align-items: center;
  }
  .err {
    margin-top: 8px;
    color: #b91c1c;
    font-size: 13px;
  }
</style>
</head>
<body>
  <div class="wrap">
    <h1>Đăng ký</h1>

    <% if (err != null) { %>
      <div class="err"><%= err %></div>
    <% } %>

    <form method="post" action="<%=ctx%>/auth/register">
      <label for="email">Email</label>
      <input id="email" type="email" name="email" required>

      <label for="pw">Mật khẩu</label>
      <input id="pw" type="password" name="password" required>

      <div class="actions">
        <button type="submit">Tạo tài khoản</button>
        <a class="btn" href="<%=ctx%>/login.jsp">Đăng nhập</a>
      </div>
    </form>
  </div>
</body>
</html>
