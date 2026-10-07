<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* ========================================
   MovieBox - 아이디 / 비밀번호 찾기 공통
   ======================================== */

.find-account-page {
    min-height: 100vh;
    padding: 150px 0 100px;
    box-sizing: border-box;
}

.find-account-container {
    width: 100%;
    max-width: 720px;
    margin: 0 auto;
    padding: 0 24px;
    box-sizing: border-box;
}

.find-account-header {
    margin-bottom: 32px;
    text-align: center;
}

.find-account-header h1 {
    margin: 0 0 12px;
    color: var(--text-white);
    font-size: 36px;
    font-weight: 800;
    line-height: 1.3;
    letter-spacing: -1px;
}

.find-account-header p {
    margin: 0;
    color: var(--text-muted);
    font-size: 15px;
    line-height: 1.6;
}

.find-account-card {
    padding: 40px;
    background: var(--bg-surface-card);
    border: 1px solid var(--border-color);
    border-radius: 16px;
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
    box-sizing: border-box;
}

.find-account-help {
    margin: 0 0 28px;
    padding: 14px 16px;
    color: var(--text-muted);
    background: var(--bg-surface-low);
    border: 1px solid var(--border-color);
    border-radius: 8px;
    font-size: 13px;
    line-height: 1.6;
}

.find-form-group {
    margin-bottom: 20px;
}

.find-form-group:last-of-type {
    margin-bottom: 0;
}

.find-form-label {
    display: block;
    margin-bottom: 8px;
    color: var(--text-on-surface);
    font-size: 14px;
    font-weight: 700;
}

.find-form-input {
    width: 100%;
    height: 48px;
    padding: 0 14px;
    box-sizing: border-box;
    color: var(--text-white);
    background: var(--bg-surface-low);
    border: 1px solid var(--border-color);
    border-radius: 8px;
    outline: none;
    font-family: inherit;
    font-size: 14px;
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.find-form-input::placeholder {
    color: var(--text-muted);
}

.find-form-input:focus {
    border-color: var(--primary-red);
    box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.12);
}

.find-form-button {
    width: 100%;
    height: 50px;
    margin-top: 28px;
    border: 0;
    border-radius: 8px;
    color: var(--text-white);
    background: var(--primary-red);
    font-family: inherit;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    transition: background-color 0.2s ease, transform 0.2s ease;
}

.find-form-button:hover {
    background: var(--primary-hover);
    transform: translateY(-1px);
}

.find-back-links {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 14px;
    margin-top: 22px;
}

.find-back-links a {
    color: var(--text-muted);
    font-size: 13px;
    text-decoration: none;
    transition: color 0.2s ease;
}

.find-back-links a:hover {
    color: var(--text-white);
}

.find-link-divider {
    width: 1px;
    height: 12px;
    background: var(--border-color);
}

/* 결과 화면 */
.find-result-message {
    margin: 0 0 24px;
    color: var(--text-muted);
    font-size: 14px;
    line-height: 1.6;
    text-align: center;
}

.member-id-result {
    margin-bottom: 10px;
    padding: 16px 18px;
    color: var(--text-white);
    background: var(--bg-surface-low);
    border: 1px solid var(--border-color);
    border-radius: 8px;
    font-size: 16px;
    font-weight: 700;
    text-align: center;
}

.member-id-result:last-of-type {
    margin-bottom: 0;
}

.find-result-login {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 50px;
    margin-top: 28px;
    border-radius: 8px;
    color: var(--text-white);
    background: var(--primary-red);
    font-size: 15px;
    font-weight: 700;
    text-decoration: none;
    box-sizing: border-box;
    transition: background-color 0.2s ease, transform 0.2s ease;
}

.find-result-login:hover {
    color: var(--text-white);
    background: var(--primary-hover);
    transform: translateY(-1px);
}

@media (max-width: 768px) {
    .find-account-page {
        padding: 120px 0 70px;
    }

    .find-account-container {
        padding: 0 16px;
    }

    .find-account-card {
        padding: 28px 20px;
    }

    .find-account-header h1 {
        font-size: 30px;
    }
}
</style>

<main class="find-account-page">
    <div class="find-account-container">
        <div class="find-account-header">
            <h1>이메일 인증</h1>
            <p>이메일로 전송된 인증번호를 입력해주세요.</p>
        </div>

        <div class="find-account-card">
            <p class="find-account-help">입력하신 이메일로 인증번호를 발송했습니다. 메일을 확인한 후 인증번호를 입력해주세요.</p>
            <form method="post"
      action="${pageContext.request.contextPath}/member/FindIdVerifyPro.do">

    <div class="find-form-group">
        <label class="find-form-label" for="authCode">인증번호</label>
        <input type="text"
               id="authCode"
               name="authCode"
               class="find-form-input"
               placeholder="이메일로 받은 인증번호 6자리"
               maxlength="6"
               inputmode="numeric"
               autocomplete="one-time-code"
               required>
    </div>

    <button type="submit" class="find-form-button">인증번호 확인</button>
</form>
        </div>

        <div class="find-back-links">
            <a href="${pageContext.request.contextPath}/member/Login.do">로그인</a>
            <span class="find-link-divider"></span>
            <a href="${pageContext.request.contextPath}/member/Join.do">회원가입</a>
        </div>
    </div>
</main>
