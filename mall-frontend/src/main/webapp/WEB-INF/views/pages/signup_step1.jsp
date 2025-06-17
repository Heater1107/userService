<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 (1/2)</title>
<style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Pretendard Variable", Pretendard, Roboto, "Noto Sans KR", "Segoe UI", "Malgun Gothic", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f7f7f7; padding: 2rem 0; }
    .container { background: white; padding: 2.5rem; border-radius: 8px; width: 480px; }
    .header { text-align: center; margin-bottom: 2rem; }
    .header .logo { font-size: 1.5rem; font-weight: 900; color: #E6002D; letter-spacing: -1px; }
    .header .title { font-size: 1.8rem; font-weight: bold; margin-top: 0.5rem; }
    .form-group { margin-bottom: 1.5rem; }
    label { display: block; margin-bottom: 0.6rem; font-weight: 600; font-size: 0.9rem; }
    input[type="text"], input[type="password"], input[type="tel"] { width: 100%; height: 50px; padding: 0 15px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; font-size: 1rem; }
    .input-group { display: flex; align-items: center; gap: 0.5rem; }
    .input-group input { flex-grow: 1; }
    .input-group select { height: 50px; border: 1px solid #ccc; border-radius: 4px; padding: 0 0.5rem; }
    .role-selector { display: flex; gap: 1rem; }
    .role-selector label { display: flex; align-items: center; gap: 0.5rem; font-weight: normal; }
    button { width: 100%; height: 52px; border: none; border-radius: 4px; cursor: pointer; font-size: 1.1rem; font-weight: bold; }
    button.btn-secondary { background-color: #fff; color: #333; border: 1px solid #ccc; }
    button.btn-primary { background-color: #E6002D; color: white; margin-top: 1rem; }
    .message-box { padding: 1rem; margin-top: 1rem; border: 1px solid #ddd; border-radius: 4px; text-align: center; background: #f9f9f9; }
    .timer-box { text-align: right; font-size: 0.9rem; color: #E6002D; }
    .helper-text { font-size: 0.8rem; color: #888; margin-top: 0.5rem; }
    .helper-text a { color: #555; text-decoration: underline; }
</style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">EZON</div>
            <div class="title">이메일 간편회원 가입</div>
        </div>
        
        <form action="/api/auth/signup/step1" method="post" id="signupForm">
            <div class="form-group">
                <label>가입 유형</label>
                <div class="role-selector">
                    <label><input type="radio" name="role" value="BUYER" checked> 구매자</label>
                    <label><input type="radio" name="role" value="SELLER"> 판매자</label>
                </div>
            </div>
            
            <div id="sellerInfoGroup" style="display: none;">
                <div class="form-group">
                    <label for="companyName">회사명</label>
                    <input type="text" id="companyName" name="companyName" placeholder="회사명을 입력해주세요">
                </div>
                <div class="form-group">
                    <label for="businessNum">사업자 등록번호</label>
                    <input type="text" id="businessNum" name="businessNum" placeholder="'-' 없이 숫자만 입력해주세요.">
                </div>
            </div>

            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" id="name" name="name" placeholder="이름을 입력해 주세요." required>
            </div>
            
            <div class="form-group">
                <label for="email">이메일 아이디</label>
                <div class="input-group">
                     <input type="text" id="email" name="email" placeholder="이메일을 입력해 주세요." required>
                     <span>@</span>
                     <select id="emailDomain" name="emailDomain">
                         <option value="gmail.com">gmail.com</option>
                         <option value="naver.com">naver.com</option>
                         <option value="daum.net">daum.net</option>
                     </select>
                </div>
            </div>
            
            <button type="button" id="sendCodeBtn" class="btn-secondary">이메일 인증하기</button>
            
            <div id="verificationSection" style="display: none;">
                <div class="message-box">
                    입력하신 이메일 주소로 인증번호가 전송되었습니다.<br>
                    인증번호 확인 후 회원가입을 진행해 주세요.
                </div>
                <div class="form-group">
                    <label for="verificationCode">인증번호</label>
                    <input type="text" id="verificationCode" name="verificationCode" placeholder="인증번호 6자리를 입력해주세요." required>
                    <div class="timer-box" id="timer"></div>
                    <div class="helper-text">
                        인증번호가 오지 않았나요? <a href="#" id="resendCodeBtn">재전송하기</a>
                    </div>
                </div>
                <button type="button" id="confirmCodeBtn" class="btn-primary">인증번호 확인</button>
            </div>
            
            <div id="mainFormFields" style="display: none;">
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="passwordConfirm">비밀번호 확인</label>
                    <input type="password" id="passwordConfirm" name="passwordConfirm" required>
                </div>
                <div class="form-group">
                    <label for="tel">휴대폰 번호</label>
                    <input type="tel" id="tel" name="tel" placeholder="'-' 없이 숫자만 입력해주세요." required>
                </div>
                
                <button type="submit" class="btn-primary">다음 단계로</button>
            </div>
        </form>
    </div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const sendCodeBtn = document.getElementById('sendCodeBtn');
        const resendCodeBtn = document.getElementById('resendCodeBtn');
        const confirmCodeBtn = document.getElementById('confirmCodeBtn');
        
        const verificationSection = document.getElementById('verificationSection');
        const mainFormFields = document.getElementById('mainFormFields');
        let timerInterval;

        document.querySelectorAll('input[name="role"]').forEach(elem => {
            elem.addEventListener('change', function() {
                document.getElementById('sellerInfoGroup').style.display = (this.value === 'SELLER') ? 'block' : 'none';
            });
        });

        function startTimer(duration, display) {
            let timer = duration, minutes, seconds;
            clearInterval(timerInterval);
            timerInterval = setInterval(function () {
                minutes = parseInt(timer / 60, 10);
                seconds = parseInt(timer % 60, 10);
                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;
                const expirationTime = new Date(Date.now() + duration * 1000);
                const timeStr = expirationTime.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit', hour12: false });
                display.textContent = `${minutes}:${seconds} (${timeStr}까지 인증)`;
                if (--timer < 0) {
                    clearInterval(timerInterval);
                    display.textContent = "인증 시간이 만료되었습니다.";
                }
            }, 1000);
        }

        function sendVerificationCode() {
            const emailId = document.getElementById('email').value;
            const emailDomain = document.getElementById('emailDomain').value;
            if (!emailId || !emailDomain) {
                alert('이메일 주소를 입력해주세요.');
                return;
            }
            const fullEmail = emailId + '@' + emailDomain;

            fetch('/api/auth/send-verification', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email: fullEmail })
            })
            .then(response => {
                if (!response.ok) { return response.json().then(err => Promise.reject(err)); }
                return response.json();
            })
            .then(data => {
                alert(data.message);
                verificationSection.style.display = 'block'; 
                sendCodeBtn.style.display = 'none';
                const fiveMinutes = 60 * 5;
                const display = document.querySelector('#timer');
                startTimer(fiveMinutes, display);
            })
            .catch(err => {
                alert('오류: ' + (err.error || '알 수 없는 오류가 발생했습니다.'));
                console.error('Error:', err);
            });
        }
        
        confirmCodeBtn.addEventListener('click', function() {
            const code = document.getElementById('verificationCode').value;
            const emailId = document.getElementById('email').value;
            const emailDomain = document.getElementById('emailDomain').value;
            const fullEmail = emailId + '@' + emailDomain;

            if (!code || code.length < 6) {
                alert('인증번호 6자리를 올바르게 입력해주세요.');
                return;
            }

            fetch('/api/auth/verify-code', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email: fullEmail, verificationCode: code })
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => Promise.reject(err));
                }
                return response.json();
            })
            .then(data => {
                alert(data.message); 
                
                verificationSection.style.display = 'none';
                
                mainFormFields.style.display = 'block';
            })
            .catch(err => {
                alert('오류: ' + (err.error || '알 수 없는 오류가 발생했습니다.'));
                console.error('Error:', err);
            });
        });

        sendCodeBtn.addEventListener('click', sendVerificationCode);
        resendCodeBtn.addEventListener('click', function(e){
            e.preventDefault();
            sendVerificationCode();
        });

        document.getElementById('signupForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;
            if (password !== passwordConfirm) {
                alert('비밀번호가 일치하지 않습니다.');
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>