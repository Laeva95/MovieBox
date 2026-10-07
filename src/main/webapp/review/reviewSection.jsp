<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
	.movie-review-area {
   		max-width: 950px;
   		margin: 140px auto 80px auto !important;
        color: #f1f1f1;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Noto Sans KR", sans-serif;
    }

    /* 1. 상단 평점 대시보드 */
    .review-score-board {
        background: linear-gradient(145deg, #1f1f23, #161619);
        border: 1px solid #2d2d35;
        border-radius: 12px;
        padding: 30px 40px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 30px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
    }
    .score-main {
        display: flex;
        align-items: center;
        gap: 24px;
    }
    .score-circle {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: rgba(254, 183, 0, 0.1);
        border: 2px solid #feb700;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        color: #feb700;
    }
    .score-circle .score-num {
        font-size: 26px;
        font-weight: 800;
        line-height: 1;
    }
    .score-circle .score-max {
        font-size: 11px;
        color: #aaa;
        margin-top: 2px;
    }
    .score-info h3 {
        margin: 0 0 6px 0;
        font-size: 20px;
        font-weight: 700;
        color: #fff;
    }
    .score-info p {
        margin: 0;
        font-size: 13px;
        color: #888;
    }
    .badge-certified {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        background: rgba(0, 114, 215, 0.15);
        color: #3897f0;
        border: 1px solid #0072d7;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
    }

    /* 2. 리뷰 작성창 */
    .review-writer-wrap {
        background-color: #1a1a1e;
        border: 1px solid #2d2d35;
        border-radius: 12px;
        padding: 24px 28px;
        margin-bottom: 40px;
    }
    .writer-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
        border-bottom: 1px solid #26262d;
        padding-bottom: 12px;
    }
    .writer-rating-select {
        background-color: #26262d;
        border: 1px solid #3c3c46;
        color: #feb700;
        font-weight: 700;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 14px;
        outline: none;
    }
    .writer-rating-select option {
        background: #1a1a1e;
        color: #fff;
    }
    .review-input-box {
        display: flex;
        gap: 12px;
    }
    .review-textarea {
        flex: 1;
        background: #111113;
        border: 1px solid #33333d;
        border-radius: 8px;
        color: #fff;
        padding: 12px 16px;
        font-size: 14px;
        line-height: 1.5;
        resize: none;
        outline: none;
        box-sizing: border-box;
        transition: border 0.2s;
    }
    .review-textarea:focus {
        border-color: #e50914;
    }
    .btn-submit-review {
        width: 110px;
        background: #e50914;
        color: #fff;
        border: none;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: background 0.2s;
    }
    .btn-submit-review:hover {
        background: #f40612;
    }
    .login-guide-box {
        text-align: center;
        padding: 30px;
        color: #777;
        font-size: 14px;
    }
    .login-guide-box a {
        color: #e50914;
        font-weight: 700;
        text-decoration: underline;
        margin-left: 6px;
    }

    /* 3. 리뷰 피드 리스트 */
    .review-list-title {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 16px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .review-count {
        color: #e50914;
        font-size: 16px;
    }
    .review-feed {
        display: flex;
        flex-direction: column;
        gap: 14px;
    }
    .review-card {
        background: #161619;
        border: 1px solid #26262d;
        border-radius: 10px;
        padding: 20px 24px;
        transition: transform 0.15s, border-color 0.15s;
    }
    .review-card:hover {
        border-color: #3b3b45;
        transform: translateY(-1px);
    }
    .card-top {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
    }
    .user-profile {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .avatar-icon {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background: #2a2a32;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 13px;
        font-weight: 700;
        color: #aaa;
    }
    .user-name {
        font-size: 14px;
        font-weight: 600;
        color: #ddd;
    }
    .user-date {
        font-size: 12px;
        color: #666;
        margin-left: 6px;
    }
    .card-rating-badge {
        background: rgba(254, 183, 0, 0.12);
        color: #feb700;
        padding: 4px 10px;
        border-radius: 4px;
        font-size: 13px;
        font-weight: 700;
    }
    .card-content {
        color: #ccc;
        font-size: 14px;
        line-height: 1.6;
        word-break: break-all;
    }
    .btn-delete-review {
        color: #777;
        font-size: 12px;
        text-decoration: none;
        margin-left: 10px;
        transition: color 0.2s;
    }
    .btn-delete-review:hover {
        color: #ff5252;
    }
    .empty-review-box {
        text-align: center;
        padding: 50px 20px;
        background: #141416;
        border-radius: 10px;
        border: 1px dashed #2d2d35;
        color: #666;
    }
</style>

<section class="movie-review-area">

    <!-- 1. 평점 대시보드 (CGV / 메가박스 스타일 요약) -->
    <div class="review-score-board">
        <div class="score-main">
            <div class="score-circle">
                <span class="score-num">${avgRating > 0 ? avgRating : '0.0'}</span>
                <span class="score-max">/ 10.0</span>
            </div>
            <div class="score-info">
                <h3>실관람객 평점</h3>
                <p>영화를 직접 관람한 관객들이 남긴 생생한 평가입니다.</p>
            </div>
        </div>

        <div>
            <c:choose>
                <c:when test="${isAudience}">
                    <div class="badge-certified">✓ 실관람 인증 완료</div>
                </c:when>
                <c:otherwise>
                    <span style="font-size: 12px; color: #666;">예매 내역 기반 실관람 인증 지원</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 2. 리뷰 작성 폼 -->
    <div class="review-writer-wrap">
        <c:choose>
            <c:when test="${not empty sessionScope.loginId}">
                <form action="${pageContext.request.contextPath}/review/write.do" method="post">
                    <input type="hidden" name="movieId" value="${param.movieId != null ? param.movieId : movieId}">
                    
                    <div class="writer-header">
                        <div style="font-size: 14px; color: #aaa;">
                            작성자 <strong style="color: #fff; margin-left: 4px;">${sessionScope.loginId}</strong> 님
                        </div>
                        <div>
                            <select name="rating" class="writer-rating-select">
                                <option value="10">★ 10점 (인생영화)</option>
                                <option value="9">★ 9점</option>
                                <option value="8">★ 8점 (강력추천)</option>
                                <option value="7">★ 7점</option>
                                <option value="6">★ 6점 (볼만해요)</option>
                                <option value="5">★ 5점 (보통)</option>
                                <option value="3">★ 3점 (아쉬워요)</option>
                                <option value="1">★ 1점 (비추천)</option>
                            </select>
                        </div>
                    </div>

                    <div class="review-input-box">
                        <textarea name="content" class="review-textarea" rows="2" 
                                  placeholder="관람객 여러분의 솔직한 감상평을 남겨주세요 (최대 1000자)" required></textarea>
                        <button type="submit" class="btn-submit-review">관람평 등록</button>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="login-guide-box">
                    <span>영화를 감상하셨나요? 관람평을 남기시려면 먼저</span>
                    <a href="${pageContext.request.contextPath}/member/Login.do">로그인</a><span>을 해주세요.</span>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 3. 리뷰 피드 목록 -->
    <div class="review-list-title">
        <span>실관람객 관람평</span>
        <span class="review-count">${empty reviewList ? 0 : reviewList.size()}건</span>
    </div>

    <div class="review-feed">
        <c:choose>
            <c:when test="${empty reviewList}">
                <div class="empty-review-box">
                    <p style="margin: 0; font-size: 15px;">등록된 관람평이 아직 없습니다.</p>
                    <p style="margin: 6px 0 0 0; font-size: 13px; color: #555;">첫 번째 리뷰의 주인공이 되어 보세요!</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="rev" items="${reviewList}">
                    <div class="review-card">
                        <div class="card-top">
                            <div class="user-profile">
                                <!-- 아바타: 아이디 앞 1글자 노출 -->
                                <div class="avatar-icon">
                                    ${fn:toUpperCase(fn:substring(rev.memberId, 0, 1))}
                                </div>
                                <div>
                                    <span class="user-name">
                                        <!-- 아이디 마스킹 (예: abc****) -->
                                        <c:choose>
                                            <c:when test="${fn:length(rev.memberId) > 3}">
                                                ${fn:substring(rev.memberId, 0, 3)}****
                                            </c:when>
                                            <c:otherwise>
                                                ${rev.memberId}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="user-date">
                                        <fmt:formatDate value="${rev.regDate}" pattern="yyyy.MM.dd"/>
                                    </span>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center;">
                                <div class="card-rating-badge">★ ${rev.rating}점</div>
                                <c:if test="${sessionScope.loginId eq rev.memberId}">
                                    <a href="${pageContext.request.contextPath}/review/delete.do?reviewId=${rev.reviewId}&movieId=${rev.movieId}" 
                                       class="btn-delete-review" 
                                       onclick="return confirm('작성한 관람평을 삭제하시겠습니까?');">삭제</a>
                                </c:if>
                            </div>
                        </div>
                        <div class="card-content">
                            ${rev.content}
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</section>