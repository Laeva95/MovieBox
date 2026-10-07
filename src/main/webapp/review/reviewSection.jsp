<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    /* 전체 컨테이너 및 폰트 세팅 */
    .movie-review-area {
        max-width: 980px;
        margin: 140px auto 90px auto !important;
        color: #f3f4f6;
        font-family: -apple-system, BlinkMacSystemFont, "Pretendard", "Segoe UI", Roboto, "Noto Sans KR", sans-serif;
        letter-spacing: -0.3px;
    }

    /* 0. 대상 영화 안내 카드 (글래스모피즘 & 시네마틱 룩) */
    .target-movie-card {
        background: linear-gradient(135deg, rgba(30, 30, 36, 0.95), rgba(20, 20, 24, 0.98));
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 16px;
        padding: 28px;
        margin-bottom: 26px;
        display: flex;
        gap: 28px;
        box-shadow: 0 16px 36px rgba(0, 0, 0, 0.45), inset 0 1px 0 rgba(255, 255, 255, 0.05);
        backdrop-filter: blur(10px);
    }
    .target-movie-poster {
        width: 130px;
        height: 190px;
        object-fit: cover;
        border-radius: 10px;
        background-color: #1a1a1e;
        border: 1px solid rgba(255, 255, 255, 0.1);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.5);
        flex-shrink: 0;
        transition: transform 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
    }
    .target-movie-card:hover .target-movie-poster {
        transform: scale(1.03) rotate(-0.5deg);
    }
    .target-movie-info {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    .target-movie-title {
        margin: 0 0 12px 0;
        font-size: 26px;
        font-weight: 800;
        color: #ffffff;
        letter-spacing: -0.5px;
    }
    .target-movie-meta {
        color: #9ca3af;
        font-size: 13.5px;
        line-height: 1.85;
    }
    .target-movie-meta strong {
        color: #e5e7eb;
        margin-right: 6px;
        font-weight: 600;
    }
    .target-movie-actions {
        display: flex;
        gap: 12px;
        margin-top: 18px;
    }
    .btn-movie-link {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 10px 20px;
        border-radius: 8px;
        font-size: 13.5px;
        font-weight: 700;
        text-decoration: none;
        cursor: pointer;
        transition: all 0.2s ease;
        border: none;
    }
    .btn-movie-detail {
        background: rgba(255, 255, 255, 0.08);
        color: #e5e7eb;
        border: 1px solid rgba(255, 255, 255, 0.12);
    }
    .btn-movie-detail:hover {
        background: rgba(255, 255, 255, 0.15);
        color: #ffffff;
        transform: translateY(-2px);
    }
    .btn-movie-booking {
        background: linear-gradient(135deg, #e50914, #c40812);
        color: #ffffff;
        box-shadow: 0 4px 14px rgba(229, 9, 20, 0.35);
    }
    .btn-movie-booking:hover {
        background: linear-gradient(135deg, #f40612, #d10711);
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(229, 9, 20, 0.5);
    }

    /* 상세정보 팝업 모달 */
    .movie-modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: rgba(0, 0, 0, 0.8);
        backdrop-filter: blur(8px);
        z-index: 9999;
        justify-content: center;
        align-items: center;
    }
    .movie-modal-content {
        position: relative;
        background: #18181d;
        border: 1px solid rgba(255, 255, 255, 0.12);
        border-radius: 18px;
        max-width: 660px;
        width: 90%;
        max-height: 85vh;
        overflow-y: auto;
        padding: 34px;
        box-shadow: 0 24px 60px rgba(0,0,0,0.7);
        color: #fff;
        animation: modalFadeIn 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    }
    @keyframes modalFadeIn {
        from { opacity: 0; transform: scale(0.94) translateY(10px); }
        to { opacity: 1; transform: scale(1) translateY(0); }
    }
    .modal-close-btn {
        position: absolute;
        top: 20px;
        right: 20px;
        background: rgba(255,255,255,0.06);
        border: none;
        border-radius: 50%;
        width: 32px;
        height: 32px;
        color: #9ca3af;
        font-size: 20px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
    }
    .modal-close-btn:hover {
        background: rgba(255,255,255,0.15);
        color: #fff;
    }
    .modal-header-flex {
        display: flex;
        gap: 22px;
        margin-bottom: 22px;
    }
    .modal-poster {
        width: 120px;
        height: 175px;
        object-fit: cover;
        border-radius: 8px;
        border: 1px solid rgba(255,255,255,0.1);
        box-shadow: 0 8px 20px rgba(0,0,0,0.4);
        flex-shrink: 0;
    }
    .modal-summary-box {
        background: #111114;
        border: 1px solid rgba(255, 255, 255, 0.06);
        border-radius: 10px;
        padding: 18px 20px;
        margin-top: 15px;
        line-height: 1.75;
        font-size: 14px;
        color: #cbd5e1;
    }

    /* 1. 상단 평점 대시보드 */
    .review-score-board {
        background: linear-gradient(145deg, #1d1d22, #141417);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 16px;
        padding: 26px 36px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 24px;
        box-shadow: 0 12px 28px rgba(0, 0, 0, 0.35);
    }
    .score-main {
        display: flex;
        align-items: center;
        gap: 22px;
    }
    .score-circle {
        width: 82px;
        height: 82px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(255, 204, 0, 0.15) 0%, rgba(20, 20, 24, 0.8) 100%);
        border: 2px solid #ffd700;
        box-shadow: 0 0 16px rgba(255, 215, 0, 0.25);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        color: #ffd700;
    }
    .score-circle .score-num {
        font-size: 26px;
        font-weight: 800;
        line-height: 1;
        letter-spacing: -0.5px;
    }
    .score-circle .score-max {
        font-size: 11px;
        color: #9ca3af;
        margin-top: 3px;
        font-weight: 500;
    }
    .score-info h3 {
        margin: 0 0 6px 0;
        font-size: 19px;
        font-weight: 700;
        color: #ffffff;
    }
    .score-info p {
        margin: 0;
        font-size: 13.5px;
        color: #9ca3af;
    }
    .badge-certified {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        background: rgba(14, 165, 233, 0.12);
        color: #38bdf8;
        border: 1px solid rgba(56, 189, 248, 0.4);
        padding: 7px 14px;
        border-radius: 30px;
        font-size: 13px;
        font-weight: 700;
        box-shadow: 0 0 12px rgba(56, 189, 248, 0.15);
    }

    /* 2. 리뷰 작성창 */
    .review-writer-wrap {
        background: #17171b;
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 16px;
        padding: 24px 28px;
        margin-bottom: 38px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
    }
    .writer-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
        padding-bottom: 14px;
    }
    .writer-rating-select {
        background: #202026;
        border: 1px solid rgba(255, 255, 255, 0.12);
        color: #ffd700;
        font-weight: 700;
        padding: 8px 14px;
        border-radius: 8px;
        font-size: 14px;
        outline: none;
        cursor: pointer;
        transition: border-color 0.2s;
    }
    .writer-rating-select:focus {
        border-color: #ffd700;
    }
    .review-input-box {
        display: flex;
        gap: 14px;
    }
    .review-textarea {
        flex: 1;
        background: #101013;
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 10px;
        color: #f3f4f6;
        padding: 14px 18px;
        font-size: 14.5px;
        line-height: 1.6;
        resize: none;
        outline: none;
        box-sizing: border-box;
        transition: all 0.2s ease;
        font-family: inherit;
    }
    .review-textarea:focus {
        border-color: #e50914;
        box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.15);
        background: #131317;
    }
    .btn-submit-review {
        width: 115px;
        background: linear-gradient(135deg, #e50914, #c40812);
        color: #fff;
        border: none;
        border-radius: 10px;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.2s ease;
        box-shadow: 0 4px 14px rgba(229, 9, 20, 0.3);
    }
    .btn-submit-review:hover {
        background: linear-gradient(135deg, #f40612, #d10711);
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(229, 9, 20, 0.45);
    }
    .login-guide-box {
        text-align: center;
        padding: 34px;
        color: #9ca3af;
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
        font-size: 19px;
        font-weight: 800;
        margin-bottom: 18px;
        display: flex;
        align-items: center;
        gap: 8px;
        color: #fff;
    }
    .review-count {
        color: #e50914;
        font-size: 17px;
    }
    .review-feed {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }
    .review-card {
        background: #17171a;
        border: 1px solid rgba(255, 255, 255, 0.06);
        border-radius: 12px;
        padding: 22px 26px;
        transition: all 0.2s ease;
    }
    .review-card:hover {
        border-color: rgba(255, 255, 255, 0.15);
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
    }
    .card-top {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 14px;
    }
    .user-profile {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .avatar-icon {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: linear-gradient(135deg, #2e2e38, #1e1e24);
        border: 1px solid rgba(255, 255, 255, 0.1);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        font-weight: 800;
        color: #e5e7eb;
    }
    .user-name {
        font-size: 14.5px;
        font-weight: 700;
        color: #f3f4f6;
    }
    .user-date {
        font-size: 12px;
        color: #6b7280;
        margin-left: 8px;
    }
    .card-rating-badge {
        background: rgba(255, 215, 0, 0.1);
        color: #ffd700;
        border: 1px solid rgba(255, 215, 0, 0.25);
        padding: 5px 12px;
        border-radius: 6px;
        font-size: 13.5px;
        font-weight: 800;
    }
    .card-content {
        color: #d1d5db;
        font-size: 14.5px;
        line-height: 1.65;
        word-break: break-all;
        white-space: pre-line;
    }
    .btn-delete-review, .btn-edit-review {
        font-size: 12.5px;
        text-decoration: none;
        margin-left: 12px;
        cursor: pointer;
        transition: color 0.2s;
    }
    .btn-edit-review {
        color: #9ca3af;
    }
    .btn-edit-review:hover {
        color: #ffd700;
    }
    .btn-delete-review {
        color: #9ca3af;
    }
    .btn-delete-review:hover {
        color: #ef4444;
    }

    .badge-real-audience {
        display: inline-flex;
        align-items: center;
        gap: 3px;
        background: rgba(14, 165, 233, 0.15);
        color: #38bdf8;
        border: 1px solid rgba(56, 189, 248, 0.4);
        font-size: 11px;
        font-weight: 700;
        padding: 2px 7px;
        border-radius: 4px;
        margin-left: 6px;
        vertical-align: middle;
    }

    /* 수정 폼 스타일 */
    .edit-review-form {
        display: none;
        margin-top: 16px;
        padding-top: 18px;
        border-top: 1px dashed rgba(255, 255, 255, 0.1);
        width: 100%;
        box-sizing: border-box;
    }
    .edit-textarea {
        width: 100%;
        min-height: 90px;
        background: #111114;
        border: 1px solid rgba(255, 255, 255, 0.12);
        border-radius: 10px;
        color: #fff;
        padding: 14px 18px;
        font-size: 14.5px;
        line-height: 1.6;
        resize: vertical;
        outline: none;
        box-sizing: border-box;
        transition: all 0.2s;
        font-family: inherit;
    }
    .edit-textarea:focus {
        border-color: #e50914;
        box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.15);
    }
    .edit-btn-group {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 12px;
    }
    .btn-edit-cancel {
        background: #25252c;
        color: #9ca3af;
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        padding: 8px 18px;
        font-size: 13.5px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
    }
    .btn-edit-cancel:hover {
        background: #32323a;
        color: #fff;
    }
    .btn-edit-submit {
        background: linear-gradient(135deg, #e50914, #c40812);
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 8px 20px;
        font-size: 13.5px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.2s;
    }
    .btn-edit-submit:hover {
        background: linear-gradient(135deg, #f40612, #d10711);
        transform: translateY(-1px);
    }
</style>

<section class="movie-review-area">

    <!-- 0. 대상 영화 안내 카드 -->
    <c:if test="${not empty movie}">
        <div class="target-movie-card">
            <img class="target-movie-poster" 
                 src="${movie.poster}" 
                 alt="${movie.title}" 
                 onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
            
            <div class="target-movie-info">
                <div>
                    <h2 class="target-movie-title">${movie.title}</h2>
                    <div class="target-movie-meta">
                        <div><strong>장르</strong> ${movie.genre} · ${movie.country}</div>
                        <div><strong>개봉</strong> ${movie.releaseDate} (${movie.runningTime})</div>
                        <c:if test="${not empty movie.director}">
                            <div><strong>감독</strong> ${movie.director}</div>
                        </c:if>
                    </div>
                </div>
                <div class="target-movie-actions">
                    <button type="button" class="btn-movie-link btn-movie-detail" onclick="openMovieModal()">
                        영화 상세정보 보기
                    </button>
                    <a href="${pageContext.request.contextPath}/movie/Booking.do?movie_id=${movie.movieId}" class="btn-movie-link btn-movie-booking">
                        예매하러 가기
                    </a>
                </div>
            </div>
        </div>

        <!-- 상세정보 모달 팝업 레이어 -->
        <div id="movieDetailModal" class="movie-modal-overlay" onclick="handleOverlayClick(event)">
            <div class="movie-modal-content">
                <button type="button" class="modal-close-btn" onclick="closeMovieModal()">&times;</button>
                
                <div class="modal-header-flex">
                    <img class="modal-poster" 
                         src="${movie.poster}" 
                         alt="${movie.title}" 
                         onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
                    <div>
                        <h2 style="margin: 0 0 10px 0; font-size: 22px; color: #fff;">${movie.title}</h2>
                        <div style="font-size: 13px; color: #aaa; line-height: 1.8;">
                            <div><strong style="color:#ddd;">장르:</strong> ${movie.genre}</div>
                            <div><strong style="color:#ddd;">국가:</strong> ${movie.country}</div>
                            <div><strong style="color:#ddd;">개봉일:</strong> ${movie.releaseDate}</div>
                            <div><strong style="color:#ddd;">러닝타임:</strong> ${movie.runningTime}</div>
                            <c:if test="${not empty movie.director}">
                                <div><strong style="color:#ddd;">감독:</strong> ${movie.director}</div>
                            </c:if>
                            <c:if test="${not empty movie.actors}">
                                <div><strong style="color:#ddd;">출연:</strong> ${movie.actors}</div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div style="font-size: 15px; font-weight: 700; color: #fff; margin-top: 15px;">줄거리</div>
                <div class="modal-summary-box">
                    ${not empty movie.summary ? movie.summary : '등록된 줄거리 정보가 없습니다.'}
                </div>

                <div style="text-align: right; margin-top: 20px;">
                    <button type="button" class="btn-movie-link btn-movie-detail" onclick="closeMovieModal()" style="padding: 8px 20px;">닫기</button>
                </div>
            </div>
        </div>
    </c:if>

    <!-- 1. 평점 대시보드 -->
    <div class="review-score-board">
        <div class="score-main">
            <div class="score-circle">
                <span class="score-num">${avgRating > 0 ? avgRating : '0.0'}</span>
                <span class="score-max">/ 10.0</span>
            </div>
            <div class="score-info">
                <h3>${not empty movie ? movie.title : '영화'} 관람객 평점</h3>
                <p>실제 관람객들이 남긴 신뢰도 높은 평점입니다.</p>
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
        <c:set var="currentId" value="${not empty sessionScope.id ? sessionScope.id : (not empty sessionScope.member_id ? sessionScope.member_id : (not empty sessionScope.memberId ? sessionScope.memberId : sessionScope.loginId))}" />
        <c:set var="currentName" value="${not empty sessionScope.name ? sessionScope.name : currentId}" />

        <c:choose>
            <c:when test="${not empty currentId}">
                <form action="${pageContext.request.contextPath}/review/write.do" method="post">
                    <input type="hidden" name="movieId" value="${param.movieId != null ? param.movieId : movieId}">
                    
                    <div class="writer-header">
                        <div style="font-size: 14px; color: #aaa;">
                            작성자 <strong style="color: #fff; margin-left: 4px;">${currentName} (${currentId})</strong> 님
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
                    <div class="review-card" id="card-${rev.reviewId}">
                        <div class="card-top">
                            <div class="user-profile">
                                <div class="avatar-icon">
                                    ${fn:toUpperCase(fn:substring(rev.memberId, 0, 1))}
                                </div>
                                <div>
                                    <span class="user-name">
                                        <c:choose>
                                            <c:when test="${fn:length(rev.memberId) > 3}">
                                                ${fn:substring(rev.memberId, 0, 3)}****
                                            </c:when>
                                            <c:otherwise>
                                                ${rev.memberId}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    
       								<c:if test="${rev.audience}">
        							    <span class="badge-real-audience">✓ 실관람객</span>
       							    </c:if>
                                    
                                    <span class="user-date">
                                        <fmt:formatDate value="${rev.regDate}" pattern="yyyy.MM.dd"/>
                                    </span>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center;">
                                <div class="card-rating-badge">★ ${rev.rating}점</div>

                                <%-- 본인 작성 리뷰일 때만 수정/삭제 버튼 노출 --%>
                                <c:if test="${currentId eq rev.memberId}">
                                    <span class="btn-edit-review" onclick="toggleEditForm(${rev.reviewId});">수정</span>
                                    <a href="${pageContext.request.contextPath}/review/delete.do?reviewId=${rev.reviewId}&movieId=${rev.movieId}" 
                                       class="btn-delete-review" 
                                       onclick="return confirm('작성한 관람평을 삭제하시겠습니까?');">삭제</a>
                                </c:if>
                            </div>
                        </div>

                        <!-- 일반 본문 내용 -->
                        <div class="card-content" id="content-${rev.reviewId}">
                            ${rev.content}
                        </div>

                        <!-- 인라인 수정 폼 (카드 너비 100% 확장) -->
                        <c:if test="${currentId eq rev.memberId}">
                            <form id="editForm-${rev.reviewId}" class="edit-review-form" 
                                  action="${pageContext.request.contextPath}/review/update.do" method="post">
                                <input type="hidden" name="reviewId" value="${rev.reviewId}">
                                <input type="hidden" name="movieId" value="${rev.movieId}">
                                
                                <div style="display: flex; justify-content: flex-end; margin-bottom: 10px;">
                                    <select name="rating" class="writer-rating-select">
                                        <option value="10" ${rev.rating == 10 ? 'selected' : ''}>★ 10점 (인생영화)</option>
                                        <option value="9" ${rev.rating == 9 ? 'selected' : ''}>★ 9점</option>
                                        <option value="8" ${rev.rating == 8 ? 'selected' : ''}>★ 8점 (강력추천)</option>
                                        <option value="7" ${rev.rating == 7 ? 'selected' : ''}>★ 7점</option>
                                        <option value="6" ${rev.rating == 6 ? 'selected' : ''}>★ 6점 (볼만해요)</option>
                                        <option value="5" ${rev.rating == 5 ? 'selected' : ''}>★ 5점 (보통)</option>
                                        <option value="3" ${rev.rating == 3 ? 'selected' : ''}>★ 3점 (아쉬워요)</option>
                                        <option value="1" ${rev.rating == 1 ? 'selected' : ''}>★ 1점 (비추천)</option>
                                    </select>
                                </div>
                                <textarea name="content" class="edit-textarea" rows="3" placeholder="수정할 관람평 내용을 입력하세요" required>${rev.content}</textarea>
                                
                                <div class="edit-btn-group">
                                    <button type="button" class="btn-edit-cancel" onclick="toggleEditForm(${rev.reviewId});">취소</button>
                                    <button type="submit" class="btn-edit-submit">수정 완료</button>
                                </div>
                            </form>
                        </c:if>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</section>

<!-- 모달 및 인라인 수정 스크립트 -->
<script>
    function openMovieModal() {
        var modal = document.getElementById("movieDetailModal");
        if (modal) {
            modal.style.display = "flex";
            document.body.style.overflow = "hidden";
        }
    }

    function closeMovieModal() {
        var modal = document.getElementById("movieDetailModal");
        if (modal) {
            modal.style.display = "none";
            document.body.style.overflow = "auto";
        }
    }

    function handleOverlayClick(event) {
        if (event.target === document.getElementById("movieDetailModal")) {
            closeMovieModal();
        }
    }

    window.addEventListener("keydown", function(event) {
        if (event.key === "Escape") {
            closeMovieModal();
        }
    });

    /* 인라인 수정 폼 열기/닫기 토글 */
    function toggleEditForm(reviewId) {
        var form = document.getElementById("editForm-" + reviewId);
        var content = document.getElementById("content-" + reviewId);
        if (!form) return;

        if (form.style.display === "none" || form.style.display === "") {
            form.style.display = "block";
            content.style.display = "none";
        } else {
            form.style.display = "none";
            content.style.display = "block";
        }
    }
</script>