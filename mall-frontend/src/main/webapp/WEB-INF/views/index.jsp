<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mall 메인 페이지</title>
<style>
    body { font-family: sans-serif; padding: 2rem; }
    .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #ccc; padding-bottom: 1rem; }
    .header a { text-decoration: none; color: #007bff; padding: 0.5rem 1rem; border: 1px solid #007bff; border-radius: 4px; }
    .header a:hover { background-color: #007bff; color: white; }
</style>
</head>
<body>
    <div class="header">
        <h1>Ezon</h1>
        <div>
            <c:choose>
                <c:when test="${not empty user}">
                    <span><strong>${userName}</strong>님, 환영합니다.</span>
                    <a href="/logout">로그아웃</a>
                </c:when>
                <c:otherwise>
                    <a href="/login">로그인</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="content" style="margin-top: 2rem;">
        <h2>메인 컨텐츠</h2>
        <p>여기는 ezon 메인화면 나와야함.</p>
        
        <c:if test="${not empty user}">
            <h3>사용자 정보 (세션)</h3>
            <pre>${user}</pre>
        </c:if>
    </div>
</body>
</html>