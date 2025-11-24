<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String ctx = request.getContextPath();
  String err = (String) request.getAttribute("err");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng nhập</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  body {
    margin: 0;
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    background: #f5f7fb;
    color: #111827;
  }
  .wrap {
    max-width: 320px;
    margin: 40px auto;
    padding: 24px;
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
  }
  h1 {
    margin: 0 0 12px 0;
    font-size: 20px;
    text-align: center;
  }
  form {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  label {
    display: block;
    margin: 12px 0 6px;
    font-weight: 600;
    max-width: 280px;
    width: 100%;
  }
  input[type="email"],
  input[type="password"] {
    width: 100%;
    max-width: 280px;
    height: 40px;
    padding: 0 12px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    background: #ffffff;
    box-sizing: border-box;
  }
  .actions {
    margin-top: 14px;
    display: flex;
    gap: 10px;
    width: 100%;
    justify-content: center;
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
    justify-content: center;
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: background 0.2s;
  }
  button.active,
  a.btn.active {
    background: #9ca3af;
    color: #ffffff;
    border-color: #9ca3af;
  }
  button:hover,
  a.btn:hover {
    background: #f3f4f6;
  }
  button.active:hover,
  a.btn.active:hover {
    background: #6b7280;
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
    <h1>Đăng nhập</h1>

    <% if (err != null) { %>
      <div class="err"><%= err %></div>
    <% } %>

    <form method="post" action="<%=ctx%>/auth/login">
      <label for="email">Email</label>
      <input id="email" type="email" name="email" required>

      <label for="pw">Mật khẩu</label>
      <input id="pw" type="password" name="password" required>

      <div class="actions">
        <button type="submit" class="active">Đăng nhập</button>
        <a class="btn" href="<%=ctx%>/auth/register">Đăng ký</a>
      </div>
    </form>
  </div>
</body>
</html>
