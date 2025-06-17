<%-- mall-frontend/src/main/webapp/WEB-INF/views/pages/login.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Pretendard Variable", Pretendard, Roboto, "Noto Sans KR", "Segoe UI", "Malgun Gothic", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f7f7f7; }
    .container { background: white; padding: 2.5rem; border-radius: 8px; width: 400px; }
    .header { text-align: center; margin-bottom: 2rem; }
    .header .logo { font-size: 1.5rem; font-weight: 900; color: #E6002D; letter-spacing: -1px; }
    .form-group { margin-bottom: 1.5rem; }
    label { display: block; margin-bottom: 0.6rem; font-weight: 600; font-size: 0.9rem; }
    input[type="email"], input[type="password"] { width: 100%; height: 50px; padding: 0 15px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; font-size: 1rem; }
    button.btn-primary { width: 100%; height: 52px; background-color: #E6002D; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 1.1rem; font-weight: bold; margin-top: 1rem; }
    .links { text-align: center; margin-top: 1rem; }
    .links a { color: #555; text-decoration: none; font-size: 0.9rem; }
    .message { padding: 1rem; margin-bottom: 1rem; border-radius: 4px; text-align: center; }
    .message.success { background-color: #d4edda; color: #155724; }
    .message.error { background-color: #f8d7da; color: #721c24; }
</style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">EZON</div>
        </div>

        <c:if test="${not empty message}"><div class="message success">${message}</div></c:if>
        <c:if test="${not empty error}"><div class="message error">${error}</div></c:if>
        
        <form action="/api/auth/login" method="post">
            <div class="form-group">
                <input type="email" id="email" name="email" placeholder="이메일" required>
            </div>
            <div class="form-group">
                <input type="password" id="password" name="password" placeholder="비밀번호" required>
            </div>
            <button type="submit" class="btn-primary">로그인</button>
        </form>
        <div class="links">
            <a href="/api/auth/signup">회원가입</a>
        </div>
    </div>
</body>
</html>