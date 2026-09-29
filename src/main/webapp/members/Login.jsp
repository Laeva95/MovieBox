<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
 <style>
     /* ================================
        로그인 페이지
        ================================ */

     .login-page {
         min-height: 100vh;
         padding: 150px 0 100px;
     }

     .login-container {
         width: 100%;
         max-width: 720px;
         margin: 0 auto;
         padding: 0 24px;
         box-sizing: border-box;
     }

     .login-header {
         margin-bottom: 32px;
         text-align: center;
     }

     .login-header h1 {
         margin: 0 0 12px;
         color: var(--text-white);
         font-size: 36px;
         font-weight: 800;
         line-height: 1.3;
     }

     .login-header p {
         margin: 0;
         color: var(--text-muted);
         font-size: 15px;
         line-height: 1.6;
     }

     .login-card {
         padding: 40px;
         background: var(--bg-surface-card);
         border: 1px solid var(--border-color);
         border-radius: 16px;
         box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
         box-sizing: border-box;
     }

     .login-form-group {
         margin-bottom: 20px;
     }

     .login-form-label {
         display: block;
         margin-bottom: 8px;
         color: var(--text-on-surface);
         font-size: 14px;
         font-weight: 700;
     }

     .login-form-input {
         width: 100%;
         height: 48px;
         padding: 0 14px;
         box-sizing: border-box;
         color: var(--text-white);
         background: var(--bg-surface-low);
         border: 1px solid var(--border-color);
         border-radius: 8px;
         outline: none;
         font-size: 14px;
         transition: border-color 0.2s ease, box-shadow 0.2s ease;
     }

     .login-form-input::placeholder {
         color: var(--text-muted);
     }

     .login-form-input:focus {
         border-color: var(--primary-red);
         box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.12);
     }

     .btn-login {
         width: 100%;
         height: 50px;
         margin-top: 8px;
         border: 0;
         border-radius: 8px;
         color: var(--text-white);
         background: var(--primary-red);
         font-size: 15px;
         font-weight: 700;
         cursor: pointer;
         transition: background-color 0.2s ease;
     }

     .btn-login:hover {
         background: var(--primary-hover);
     }

     .login-links {
         display: flex;
         justify-content: center;
         align-items: center;
         gap: 14px;
         margin-top: 22px;
     }

     .login-links a {
         color: var(--text-muted);
         font-size: 13px;
         text-decoration: none;
         transition: color 0.2s ease;
     }

     .login-links a:hover {
         color: var(--text-white);
     }

     .link-divider {
         width: 1px;
         height: 12px;
         background: var(--border-color);
     }

     .login-divider {
         display: flex;
         align-items: center;
         gap: 14px;
         margin: 30px 0 20px;
         color: var(--text-muted);
         font-size: 13px;
     }

     .login-divider::before,
     .login-divider::after {
         content: "";
         flex: 1;
         height: 1px;
         background: var(--border-color);
     }

     .btn-kakao-login {
         display: flex;
         justify-content: center;
         align-items: center;
         gap: 8px;
         width: 100%;
         height: 50px;
         box-sizing: border-box;
         border-radius: 8px;
         color: #191919;
         background: #FEE500;
         font-size: 15px;
         font-weight: 700;
         text-decoration: none;
         transition: filter 0.2s ease;
     }

     .btn-kakao-login:hover {
         filter: brightness(0.95);
     }

     .kakao-symbol {
         display: inline-flex;
         justify-content: center;
         align-items: center;
         width: 22px;
         height: 22px;
         border-radius: 50%;
         color: #FEE500;
         background: #191919;
         font-size: 12px;
         font-weight: 800;
     }

     .login-social-help {
         margin: 12px 0 0;
         color: var(--text-muted);
         font-size: 12px;
         line-height: 1.5;
         text-align: center;
     }

     /* 모바일 */
     @media (max-width: 768px) {
         .login-page {
             padding: 120px 0 70px;
         }

         .login-container {
             padding: 0 16px;
         }

         .login-card {
             padding: 28px 20px;
         }

         .login-header h1 {
             font-size: 30px;
         }

         .login-links {
             gap: 10px;
         }

         .login-links a {
             font-size: 12px;
         }
     }
 </style>

 <main class="login-page">
     <div class="login-container">
         <div class="login-header">
             <h1>로그인</h1>
             <p>MovieBox의 다양한 서비스를 이용해보세요.</p>
         </div>
         <div class="login-card">
             <form method="post"
                   action="${pageContext.request.contextPath}/member/LoginPro.do">
                 <div class="login-form-group">
                     <label class="login-form-label" for="memberId">
                         아이디
                     </label>
                     <input
                         type="text"
                         id="memberId"
                         name="member_id"
                         class="login-form-input"
                         placeholder="아이디를 입력해주세요"
                         maxlength="12"
                         autocomplete="username"
                         required
                     >
                 </div>
                 <div class="login-form-group">
                     <label class="login-form-label" for="memberPass">
                         비밀번호
                     </label>
                     <input
                         type="password"
                         id="memberPass"
                         name="member_pass"
                         class="login-form-input"
                         placeholder="비밀번호를 입력해주세요"
                         maxlength="20"
                         autocomplete="current-password"
                         required
                     >
                 </div>
                 <button type="submit" class="btn-login">
                     로그인
                 </button>
             </form>
             <div class="login-links">
                 <a href="${pageContext.request.contextPath}/member/Join.do">
                     회원가입
                 </a>
             </div>
             <div class="login-divider">
                 <span>또는</span>
             </div>
             <a href="${pageContext.request.contextPath}/member/kakaoLogin.do"
                class="btn-kakao-login">
                 <span class="kakao-symbol">K</span>
                 카카오로 로그인
             </a>
             <p class="login-social-help">
                 카카오 계정으로 간편하게 로그인할 수 있습니다.
             </p>
         </div>
     </div>
</main>