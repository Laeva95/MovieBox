<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
/* ========================================
   회원 정보 페이지
   ======================================== */

.member-info-page {
    min-height: 100vh;
    padding: 150px 0 100px;
}

.member-info-container {
    width: 100%;
    max-width: 720px;
    margin: 0 auto;
    padding: 0 24px;
}


/* ========================================
   페이지 제목
   ======================================== */

.member-info-header {
    text-align: center;
    margin-bottom: 36px;
}

.member-info-header h1 {
    margin-bottom: 10px;
    color: var(--text-white);
    font-size: 36px;
    font-weight: 800;
    letter-spacing: -1px;
}

.member-info-header p {
    color: var(--text-muted);
    font-size: 15px;
}


/* ========================================
   회원 정보 카드
   ======================================== */

.member-info-card {
    padding: 40px;
    background-color: var(--bg-surface-card);
    border: 1px solid var(--border-color);
    border-radius: 16px;
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.35);
}


/* ========================================
   정보 영역
   ======================================== */

.member-info-section {
    margin-bottom: 32px;
}

.member-info-section:last-child {
    margin-bottom: 0;
}

.member-info-section-title {
    padding-bottom: 14px;
    margin-bottom: 20px;
    color: var(--text-white);
    border-bottom: 1px solid var(--border-color);
    font-size: 18px;
    font-weight: 700;
}


/* ========================================
   입력 그룹
   ======================================== */

.member-info-group {
    margin-bottom: 20px;
}

.member-info-group:last-child {
    margin-bottom: 0;
}

.member-info-label {
    display: block;
    margin-bottom: 8px;
    color: var(--text-on-surface);
    font-size: 14px;
    font-weight: 600;
}


/* ========================================
   입력창
   ======================================== */

.member-info-input {
    width: 100%;
    height: 48px;
    padding: 0 14px;
    box-sizing: border-box;

    color: var(--text-white);
    background-color: var(--bg-surface-low);

    border: 1px solid var(--border-color);
    border-radius: 8px;

    font-family: inherit;
    font-size: 14px;

    outline: none;
    transition: 0.2s ease-in-out;
}


/* 수정 가능한 입력창 */

.member-info-input:not([readonly]):focus {
    border-color: var(--primary-red);

    box-shadow:
        0 0 0 3px rgba(229, 9, 20, 0.12);
}


/* readonly 입력창 */

.member-info-input[readonly] {
    color: var(--text-muted);
    background-color: var(--bg-surface-high);
    cursor: not-allowed;
}


/* ========================================
   성별 / 2열 입력
   ======================================== */

.member-info-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
}


/* ========================================
   주소 입력
   ======================================== */

.member-info-address {
    display: flex;
    gap: 10px;
}

.member-info-address .member-info-input {
    flex: 1;
}

.member-info-address-button {
    width: 110px;
    flex-shrink: 0;

    color: var(--text-white);
    background-color: var(--bg-surface-high);

    border: 1px solid var(--border-color);
    border-radius: 8px;

    font-size: 13px;
    font-weight: 600;

    cursor: pointer;
    transition: 0.2s ease-in-out;
}

.member-info-address-button:hover {
    background-color: #38393f;
}


/* ========================================
   버튼
   ======================================== */

.member-info-buttons {
    display: flex;
    gap: 12px;
    margin-top: 36px;
}

.member-info-submit-button,
.member-info-cancel-button {
    height: 52px;

    display: flex;
    align-items: center;
    justify-content: center;

    border: none;
    border-radius: 9999px;

    font-size: 16px;
    font-weight: 700;

    cursor: pointer;
    transition: 0.2s ease-in-out;
}


/* 회원정보 수정 버튼 */

.member-info-submit-button {
    flex: 1;

    color: var(--text-white);
    background-color: var(--primary-red);

    box-shadow:
        0 8px 24px rgba(229, 9, 20, 0.3);
}

.member-info-submit-button:hover {
    background-color: var(--primary-hover);
    transform: translateY(-1px);
}


/* 취소 버튼 */

.member-info-cancel-button {
    width: 140px;

    color: var(--text-white);
    background-color: var(--bg-surface-high);
}

.member-info-cancel-button:hover {
    background-color: #38393f;
}


/* ========================================
   반응형
   ======================================== */

@media (max-width: 768px) {

    .member-info-page {
        padding-top: 130px;
    }

    .member-info-card {
        padding: 28px 20px;
    }

    .member-info-header h1 {
        font-size: 30px;
    }

    .member-info-row {
        grid-template-columns: 1fr;
        gap: 20px;
    }

    .member-info-buttons {
        flex-direction: column;
    }

    .member-info-cancel-button {
        width: 100%;
        order: 2;
    }
}
</style>


<div class="member-info-page">

    <div class="member-info-container">

        <!-- 페이지 제목 -->
        <div class="member-info-header">

            <h1>회원 정보</h1>

            <p>
                회원님의 정보를 확인하고 수정할 수 있습니다.
            </p>

        </div>


        <!-- 회원 정보 카드 -->
        <div class="member-info-card">
            <form action="${pageContext.request.contextPath}/member/UpdatePro.do"
                  method="post">
                <!-- 기본 정보 -->
                <div class="member-info-section">

                    <div class="member-info-section-title">
                        기본 정보
                    </div>
                    <!-- 아이디 -->
                    <div class="member-info-group">

                        <label class="member-info-label">
                            아이디
                        </label>
                        <input type="text"
                               name="member_id"
                               class="member-info-input"
                               value="${member.member_id}"
                               readonly>
                    </div>
                    <!-- 이름 -->
                    <div class="member-info-group">

                        <label class="member-info-label">
                            이름
                        </label>
                        <input type="text"
                               name="member_name"
                               class="member-info-input"
                               value="${member.member_name}"
                               readonly>
                    </div>
                    <!-- 나이 / 성별 -->
                    <div class="member-info-row">
                        <div class="member-info-group">
                            <label class="member-info-label">
                                나이
                            </label>
                            <input type="text"
                                   name="age"
                                   class="member-info-input"
                                   value="${member.age}"
                                   >
                        </div>
                        <div class="member-info-group">
                            <label class="member-info-label">
                                성별
                            </label>
                            <input type="text"
                                   name="gender"
                                   class="member-info-input"
                                   value="${member.gender}"
                                   >
                        </div>
                    </div>
                </div>
                <!-- 연락처 및 개인정보 -->
                <div class="member-info-section">
                    <div class="member-info-section-title">
                        연락처 및 개인정보
                    </div>
                    <!-- 이메일 -->
                    <div class="member-info-group">
                        <label class="member-info-label">
                            이메일
                        </label>
                        <input type="email"
                               name="email"
                               class="member-info-input"
                               value="${member.email}">
                    </div>
                    <!-- 주소 -->
                    <div class="member-info-group">
                        <label class="member-info-label">
                            주소
                        </label>
                        <input type="text"
                               name="address"
                               class="member-info-input"
                               value="${member.address}">
                    </div>
                    <!-- 전화번호 -->
                    <div class="member-info-group">
                        <label class="member-info-label">
                            전화번호
                        </label>
                        <input type="text"
                               name="tel"
                               class="member-info-input"
                               value="${member.tel}">
                    </div>
                    <!-- 휴대폰번호 -->
                    <div class="member-info-group">
                        <label class="member-info-label">
                            휴대폰번호
                        </label>
                        <input type="text"
                               name="mtel"
                               class="member-info-input"
                               value="${member.mtel}">
                    </div>
                </div>
                <!-- 버튼 -->
                <div class="member-info-buttons">

                    <button type="submit"
                            class="member-info-submit-button">
                        회원정보 수정
                    </button>
                    <button type="button"
                            class="member-info-cancel-button"
                            onclick="history.back();">
                        취소
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>