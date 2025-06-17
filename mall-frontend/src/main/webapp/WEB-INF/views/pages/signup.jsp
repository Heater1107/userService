<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
    body { font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f4f4f4; }
    .container { background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 400px; }
    h1 { text-align: center; }
    .form-group { margin-bottom: 1rem; }
    label { display: block; margin-bottom: 0.5rem; }
    input, select { width: 100%; padding: 0.5rem; box-sizing: border-box; }
    .input-group { display: flex; }
    .input-group input { flex-grow: 1; }
    .input-group button { margin-left: 0.5rem; padding: 0.5rem 1rem; }
    button[type="submit"] { width: 100%; padding: 0.75rem; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
    .message { padding: 1rem; margin-bottom: 1rem; border-radius: 4px; }
    .message.success { background-color: #d4edda; color: #155724; }
    .message.error { background-color: #f8d7da; color: #721c24; }
</style>
</head>
<body>
    <div class="container">
        <h1>회원가입</h1>
        
        <c:if test="${not empty message}">
            <div class="message success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>

        <form action="/api/auth/signup" method="post" id="signupForm">
            <div class="form-group">
                <label for="email">이메일</label>
                <div class="input-group">
                     <input type="email" id="email" name="email" value="${not empty formData.email ? formData.email : email}" required>
                     <button type="button" id="sendCodeBtn">인증번호 발송</button>
                </div>
            </div>
            <div class="form-group">
                <label for="verificationCode">인증번호</label>
                <input type="text" id="verificationCode" name="verificationCode" required>
            </div>
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" id="name" name="name" value="${formData.name}" required>
            </div>
            <div class="form-group">
                <label for="tel">연락처</label>
                <input type="tel" id="tel" name="tel" value="${formData.tel}" required>
            </div>
            <div class="form-group">
                <label for="role">가입 유형</label>
                <select id="role" name="role" required>
                    <option value="BUYER" ${formData.role == 'BUYER' ? 'selected' : ''}>구매자</option>
                    <option value="SELLER" ${formData.role == 'SELLER' ? 'selected' : ''}>판매자</option>
                </select>
            </div>
            <div class="form-group" id="businessNumGroup" style="display: none;">
                <label for="businessNum">사업자 등록번호</label>
                <input type="text" id="businessNum" name="businessNum" value="${formData.businessNum}">
            </div>
            <button type="submit">가입하기</button>
        </form>
        
        <form action="/send-verification" method="post" id="verificationForm" style="display:none;">
            <input type="hidden" name="email" id="verificationEmail">
        </form>
    </div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const roleSelect = document.getElementById('role');
        const businessNumGroup = document.getElementById('businessNumGroup');

        function toggleBusinessNumField() {
            if (roleSelect.value === 'SELLER') {
                businessNumGroup.style.display = 'block';
                document.getElementById('businessNum').required = true;
            } else {
                businessNumGroup.style.display = 'none';
                document.getElementById('businessNum').required = false;
            }
        }

        roleSelect.addEventListener('change', toggleBusinessNumField);
        toggleBusinessNumField();
        
        document.getElementById('sendCodeBtn').addEventListener('click', function() {
            const email = document.getElementById('email').value;
            if (!email) {
                alert('이메일을 입력해주세요.');
                return;
            }
            document.getElementById('verificationEmail').value = email;
            document.getElementById('verificationForm').submit();
        });
    });
</script>
</body>
</html>