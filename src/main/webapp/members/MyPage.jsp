<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css">

<style>

/* =========================================================
   회원 정보 페이지
   ========================================================= */
.member-info-page {
    min-height: 100vh;
    padding: 150px 0 100px;
}
.member-info-container {
    width: 100%;
    max-width: 1100px;
    margin: 0 auto;
    padding: 0 24px;
}
/* =========================================================
   페이지 제목
   ========================================================= */
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
/* =========================================================
   회원 정보 카드
   ========================================================= */
.member-info-card {
    max-width: 720px;
    margin: 0 auto;
    padding: 40px;
    background-color: var(--bg-surface-card);
    border: 1px solid var(--border-color);
    border-radius: 16px;
    box-shadow:
        0 15px 40px rgba(0, 0, 0, 0.35);
}
/* =========================================================
   정보 영역
   ========================================================= */
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
/* =========================================================
   입력 그룹
   ========================================================= */
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
/* =========================================================
   입력창
   ========================================================= */
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
/* =========================================================
   성별 / 2열 입력
   ========================================================= */
.member-info-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
}
/* =========================================================
   버튼
   ========================================================= */
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
/* 회원정보 수정 */
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
/* 취소 */
.member-info-cancel-button {
    width: 140px;
    color: var(--text-white);
    background-color: var(--bg-surface-high);
}
.member-info-cancel-button:hover {
    background-color: #38393f;
}
/* =========================================================
   예약 내역 영역
   ========================================================= */
.reservation-section {
    margin-top: 60px;
}
.reservation-section-title {
    margin-bottom: 24px;
    color: var(--text-white);
    font-size: 28px;
    font-weight: 800;
}
.reservation-section-description {
    margin-bottom: 30px;
    color: var(--text-muted);
    font-size: 14px;
}
/* =========================================================
   예약 그룹
   ========================================================= */

.reservation-group {
    margin-bottom: 50px;
}
.reservation-group-title {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 18px;
    color: var(--text-white);
    font-size: 20px;
    font-weight: 700;
}
.reservation-group-title::before {
    content: "";
    width: 5px;
    height: 22px;
    border-radius: 999px;
    background-color: var(--primary-red);
}
/* =========================================================
   예약 없음
   ========================================================= */
.no-reservation {
    padding: 40px 20px;
    color: var(--text-muted);
    background-color: var(--bg-surface-card);
    border: 1px solid var(--border-color);
    border-radius: 14px;
    text-align: center;
}
/* =========================================================
   예약 카드
   ========================================================= */
.reservation-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}
.reservation-card {
    display: flex;
    gap: 22px;
    padding: 20px;
    background-color: var(--bg-surface-card);
    border: 1px solid var(--border-color);
    border-radius: 14px;
    box-shadow:
        0 10px 25px rgba(0, 0, 0, 0.18);
    transition: 0.2s ease-in-out;
}
.reservation-card:hover {
    transform: translateY(-2px);
    border-color: #555;
}
/* =========================================================
   지난 예약
   ========================================================= */
.reservation-card-past {
    opacity: 0.55;
}
/* =========================================================
   영화 포스터
   ========================================================= */
.reservation-poster {
    width: 110px;
    height: 155px;
    flex-shrink: 0;
    overflow: hidden;
    background-color: var(--bg-surface-high);
    border-radius: 8px;
}
.reservation-poster img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}
.reservation-poster-empty {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--text-muted);
    font-size: 12px;
    text-align: center;
}

/* =========================================================
   예약 정보
   ========================================================= */
.reservation-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
}
.reservation-movie-title {
    margin-bottom: 14px;
    color: var(--text-white);
    font-size: 21px;
    font-weight: 700;
    word-break: keep-all;
}
.reservation-detail {
    display: grid;
    grid-template-columns: 100px 1fr;
    row-gap: 8px;
    font-size: 14px;
}
.reservation-detail-label {
    color: var(--text-muted);
}
.reservation-detail-value {
    color: var(--text-on-surface);
}
.reservation-number {
    margin-top: 14px;
    color: var(--text-muted);
    font-size: 12px;
}
/* =========================================================
   예약 상태 영역
   ========================================================= */
.reservation-action {
    width: 130px;
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
}
/* 예약 취소 버튼 */
.reservation-cancel-button {
    width: 100%;
    height: 44px;
    color: var(--text-white);
    background-color: var(--primary-red);
    border: none;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 700;
    cursor: pointer;
    transition: 0.2s ease-in-out;
}
.reservation-cancel-button:hover {
    background-color: var(--primary-hover);
    transform: translateY(-1px);
}

/* 지난 예약 표시 */
.reservation-past-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 90px;
    height: 36px;
    color: var(--text-muted);
    background-color: var(--bg-surface-high);
    border: 1px solid var(--border-color);
    border-radius: 9999px;
    font-size: 13px;
    font-weight: 600;
}
/* =========================================================
   예약 취소 안내
   ========================================================= */
.reservation-notice {
    margin-top: 20px;
    padding: 16px 18px;
    color: var(--text-muted);
    background-color: var(--bg-surface-card);
    border: 1px solid var(--border-color);
    border-radius: 10px;
    font-size: 13px;
    line-height: 1.6;
}
/* =========================================================
   반응형
   ========================================================= */
@media (max-width: 768px) {
    .member-info-page {
        padding-top: 130px;
    }
    .member-info-container {
        padding: 0 16px;
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
    /* 예약 카드 */
    .reservation-card {
        flex-direction: column;

        gap: 18px;
    }
    .reservation-poster {
        width: 120px;
        height: 170px;
    }
    .reservation-action {
        width: 100%;
    }
    .reservation-cancel-button {
        height: 46px;
    }
    .reservation-detail {
        grid-template-columns: 85px 1fr;
    }
}
</style>
<div class="member-info-page">
    <div class="member-info-container">
        <!-- =====================================================
             페이지 제목
             ===================================================== -->
        <div class="member-info-header">
            <h1>회원 정보</h1>
            <p>
                회원님의 정보를 확인하고 수정할 수 있습니다.
            </p>
        </div>
        <!-- =====================================================
             회원 정보
             ===================================================== -->
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
                                   value="${member.age}">
                        </div>
                        <div class="member-info-group">
                            <label class="member-info-label">
                                성별
                            </label>
                            <input type="text"
                                   name="gender"
                                   class="member-info-input"
                                   value="${member.gender}">
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
        <!-- =====================================================
             예약 내역
             ===================================================== -->
        <div class="reservation-section">
            <div class="reservation-section-title">
                나의 예매 내역
            </div>
            <div class="reservation-section-description">
                회원님이 예매한 영화 목록을 확인할 수 있습니다.
            </div>
            <!-- =================================================
                 상영 예정
                 ================================================= -->
            <div class="reservation-group">
                <div class="reservation-group-title">
                    상영 예정
                </div>
                <div class="reservation-list">
                    <c:set var="hasUpcomingReservation"
                           value="false"/>
                    <c:forEach var="item"
                               items="${myPageReservationList}">
                        <c:if test="${not item.past}">
                            <c:set var="hasUpcomingReservation"
                                   value="true"/>
                            <div class="reservation-card">
                                <!-- 포스터 -->
                                <div class="reservation-poster">
                                    <c:choose>
                                        <c:when test="${not empty item.movie.poster}">
                                            <img src="${item.movie.poster}"
                                                 alt="${item.movie.title} 포스터">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="reservation-poster-empty">
                                                포스터<br>없음
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <!-- 예약 정보 -->
                                <div class="reservation-info">
                                    <div class="reservation-movie-title">
                                        ${item.movie.title}
                                    </div>
                                    <div class="reservation-detail">
                                        <div class="reservation-detail-label">
                                            예매 날짜
                                        </div>
                                        <div class="reservation-detail-value">
                                            ${item.reservation.reservationDate}
                                        </div>
                                        <div class="reservation-detail-label">
                                            상영 시간
                                        </div>
                                        <div class="reservation-detail-value">
                                            ${item.screeningTime}
                                        </div>
                                        <div class="reservation-detail-label">
                                            좌석
                                        </div>
                                        <div class="reservation-detail-value">
                                            ${item.reservation.seatNumber}
                                        </div>
                                    </div>
                                    <div class="reservation-number">
                                        예매번호 :
                                        ${item.reservation.reservationId}
                                    </div>
                                </div>
                                <!-- 취소 버튼 -->
                                <div class="reservation-action">
                                    <form action="${pageContext.request.contextPath}/member/CancelReservation.do"
                                          method="post"
                                          onsubmit="return confirm('예매를 취소하시겠습니까?');">
                                        <input type="hidden"
                                               name="reservationId"
                                               value="${item.reservation.reservationId}">
                                        <button type="submit"
                                                class="reservation-cancel-button">
                                            예매 취소
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                    <!-- 예매 예정 내역이 없는 경우 -->
                    <c:if test="${not hasUpcomingReservation}">
                        <div class="no-reservation">
                            예정된 예매 내역이 없습니다.
                        </div>
                    </c:if>
                </div>
            </div>
            <!-- =================================================
                 지난 예매
                 ================================================= -->
            <div class="reservation-group">
                <div class="reservation-group-title">
                    지난 예매
                </div>
                <div class="reservation-list">
                    <c:set var="hasPastReservation"
                           value="false"/>
                    <c:forEach var="item"
                               items="${myPageReservationList}">
                        <c:if test="${item.past}">
                            <c:set var="hasPastReservation"
                                   value="true"/>
                            <div class="reservation-card reservation-card-past">
                                <!-- 포스터 -->
                                <div class="reservation-poster">
                                    <c:choose>
                                        <c:when test="${not empty item.movie.posterUrl}">
                                            <img src="${item.movie.posterUrl}"
                                                 alt="${item.movie.title} 포스터">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="reservation-poster-empty">
                                                포스터<br>없음
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <!-- 예약 정보 -->
                                <div class="reservation-info">
                                    <div class="reservation-movie-title">
                                        ${item.movie.title}
                                    </div>
                                    <div class="reservation-detail">
                                        <div class="reservation-detail-label">
                                            예매 날짜
                                        </div>
                                        <div class="reservation-detail-value">
                                            ${item.reservation.reservationDate}
                                        </div>
                                        <div class="reservation-detail-label">
                                            상영 시간
                                        </div>
                                        <div class="reservation-detail-value">
                                            ${item.screeningTime}
                                        </div>
                                        <div class="reservation-detail-label">
                                            좌석
                                        </div>
                                        <div class="reservation-detail-value">
                                            ${item.reservation.seatNumber}
                                        </div>
                                    </div>
                                    <div class="reservation-number">
                                        예매번호 :
                                        ${item.reservation.reservationId}
                                    </div>
                                </div>
                                <!-- 지난 예매 표시 -->
                                <div class="reservation-action">
                                    <span class="reservation-past-badge">
                                        상영 종료
                                    </span>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                    <!-- 지난 예매가 없는 경우 -->
                    <c:if test="${not hasPastReservation}">
                        <div class="no-reservation">
                            지난 예매 내역이 없습니다.
                        </div>
                    </c:if>
                </div>
            </div>
            <!-- =================================================
                 안내
                 ================================================= -->
            <div class="reservation-notice">
                ※ 상영 시간이 지난 예매는 취소할 수 없습니다.
            </div>
        </div>
    </div>
</div>