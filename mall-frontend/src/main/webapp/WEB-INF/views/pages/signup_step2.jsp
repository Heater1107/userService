<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 (2/2)</title>
<style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Pretendard Variable", Pretendard, Roboto, "Noto Sans KR", "Segoe UI", "Malgun Gothic", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f7f7f7; }
    .container { background: white; padding: 2.5rem; border-radius: 8px; width: 500px; }
    h1 { text-align: center; font-size: 1.8rem; font-weight: bold; margin-bottom: 2rem; }
    .terms-box { border: 1px solid #ccc; padding: 1rem; height: 150px; overflow-y: scroll; margin-bottom: 1rem; background-color: #fafafa; font-size: 0.9rem; }
    .agree-group { margin-bottom: 1.5rem; }
    .agree-group label { font-weight: bold; display: inline-flex; align-items: center; gap: 0.5rem; }
    #agreeAllLabel { font-size: 1.1rem; }
    button { width: 100%; height: 52px; background-color: #E6002D; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 1.1rem; font-weight: bold; margin-top: 1rem; }
</style>
</head>
<body>
    <div class="container">
        <h1>약관 동의</h1>
        <form action="/api/auth/signup/step2" method="post">
            <div class="agree-group">
                <label id="agreeAllLabel"><input type="checkbox" name="agreeAll" id="agreeAll"> 모든 약관에 동의합니다.</label>
            </div>
            <hr style="margin-bottom: 1.5rem;">
            <div class="agree-group">
                <label><input type="checkbox" name="agreeTerms" class="agree-item" required> (필수) 이용약관 동의</label>
                <div class="terms-box">제1조(목적) 이 약관은... (이용약관 내용)</div>
            </div>
            <div class="agree-group">
                <label><input type="checkbox" name="agreePrivacy" class="agree-item" required> (필수) 개인정보 수집 및 이용 동의</label>
                <div class="terms-box">제1조(수집하는 개인정보 항목) 회사는... (개인정보 처리방침 내용)</div>
            </div>
            <div class="agree-group">
                <label><input type="checkbox" name="agreeMarketing" class="agree-item"> (선택) 마케팅 정보 수신 동의</label>
                <div class="terms-box">회사는... (마케팅 정보 수신 동의 내용)</div>
            </div>
            <button type="submit">동의하고 가입 완료</button>
        </form>
    </div>
<script>
    document.getElementById('agreeAll').addEventListener('click', function(e) {
        document.querySelectorAll('.agree-item').forEach(function(checkbox) {
            checkbox.checked = e.target.checked;
        });
    });
</script>
</body>
</html>