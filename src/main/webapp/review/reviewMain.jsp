<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .review-hub-container {
        max-width: 1200px;
        margin: 140px auto 100px auto !important;
        color: #f1f1f1;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Noto Sans KR", sans-serif;
        padding: 0 20px;
        box-sizing: border-box;
    }
    
    .hub-header {
        margin-bottom: 36px;
    }
    .hub-header h1 {
        font-size: 32px;
        font-weight: 800;
        margin: 0 0 10px 0;
        color: #fff;
    }
    .hub-header p {
        font-size: 14px;
        color: #888;
        margin: 0;
    }

    /* 1. 상영작 평점 탐색 */
    .section-title-wrap {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: #fff;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .section-title::before {
        content: '';
        width: 4px;
        height: 18px;
        background: #e50914;
        border-radius: 2px;
    }

    .movie-hub-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
        gap: 22px;
        margin-bottom: 65px;
    }
    
    /* 카드 전체를 링크 처리 */
    .hub-movie-card {
        background: #18181c;
        border: 1px solid #282830;
        border-radius: 12px;
        overflow: hidden;
        transition: transform 0.25s, border-color 0.25s, box-shadow 0.25s;
        display: flex;
        flex-direction: column;
        text-decoration: none;
        color: inherit;
    }
    .hub-movie-card:hover {
        transform: translateY(-6px);
        border-color: #e50914;
        box-shadow: 0 12px 24px rgba(229, 9, 20, 0.18);
    }
    .hub-poster-wrap {
        position: relative;
        width: 100%;
        height: 295px;
        background: #111;
        overflow: hidden;
    }
    .hub-poster-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s;
    }
    .hub-movie-card:hover .hub-poster-img {
        transform: scale(1.04);
    }

    /* 평점 뱃지 단일 골드 옐로우 스타일 */
    .hub-score-badge {
        position: absolute;
        bottom: 10px;
        right: 10px;
        background: rgba(0, 0, 0, 0.85);
        color: #feb700;
        border: 1px solid #feb700;
        padding: 4px 8px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 800;
        backdrop-filter: blur(4px);
    }

    .hub-info-wrap {
        padding: 16px 16px 14px;
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    
    /* 2줄 말줄임 처리로 카드 높이 균일화 */
    .hub-movie-title {
        font-size: 15px;
        font-weight: 700;
        color: #fff;
        margin: 0 0 6px 0;
        line-height: 1.35;
        height: 40px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .hub-movie-meta {
        font-size: 12px;
        color: #777;
        margin-bottom: 14px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .btn-go-review {
        display: block;
        text-align: center;
        background: #25252d;
        color: #fff;
        padding: 9px 0;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 700;
        border: 1px solid #363642;
        transition: background 0.2s, border-color 0.2s;
    }
    .hub-movie-card:hover .btn-go-review {
        background: #e50914;
        border-color: #e50914;
    }

    /* 2. 실시간 최신 관람평 피드 */
    .recent-feed-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 16px;
    }
    .recent-card {
        background: #17171a;
        border: 1px solid #26262d;
        border-radius: 10px;
        padding: 20px 22px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        transition: border-color 0.2s;
    }
    .recent-card:hover {
        border-color: #40404e;
    }
    .recent-movie-name {
        font-size: 14px;
        font-weight: 700;
        color: #ff4d4d;
        margin-bottom: 10px;
        display: inline-block;
        text-decoration: none;
    }
    .recent-movie-name:hover {
        text-decoration: underline;
    }
    .recent-content {
        font-size: 14px;
        color: #ccc;
        line-height: 1.6;
        margin-bottom: 16px;
        word-break: break-all;
    }
    .recent-bottom {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 12px;
        color: #666;
        border-top: 1px solid #222228;
        padding-top: 12px;
    }
    .badge-real-audience {
        display: inline-flex;
        align-items: center;
        gap: 3px;
        background: rgba(0, 114, 215, 0.18);
        color: #4da3ff;
        border: 1px solid #0072d7;
        font-size: 11px;
        font-weight: 700;
        padding: 1px 6px;
        border-radius: 4px;
        margin-left: 6px;
    }

    @media (max-width: 768px) {
        .recent-feed-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="review-hub-container">
    <div class="hub-header">
        <h1>실관람객 관람평</h1>
        <p>실제 관람객들의 생생한 리뷰를 확인하고, 보고 싶은 영화의 리뷰를 남겨보세요.</p>
    </div>

    <!-- 1. 영화별 리뷰 탐색 -->
    <div class="section-title-wrap">
        <div class="section-title">상영작별 평점 탐색</div>
    </div>

    <div class="movie-hub-grid">
        <c:choose>
            <c:when test="${not empty movieList}">
                <c:forEach var="mv" items="${movieList}">
                    <c:set var="mScore" value="${ratingMap[mv.movieId]}" />
                    
                    <!-- 카드 전체 링크화 -->
                    <a href="${pageContext.request.contextPath}/review/list.do?movieId=${mv.movieId}" class="hub-movie-card">
                        <div class="hub-poster-wrap">
                            <img class="hub-poster-img" 
                                 src="${mv.poster}" 
                                 alt="${mv.title}"
                                 onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
                            
                            <!-- 노란색 평점 뱃지 (0점이어도 ★ 0.0 으로 통일 출력) -->
                            <div class="hub-score-badge">
                                ★ ${mScore > 0 ? mScore : '0.0'}
                            </div>
                        </div>
                        
                        <div class="hub-info-wrap">
                            <div>
                                <h3 class="hub-movie-title">${mv.title}</h3>
                                <div class="hub-movie-meta">${mv.genre} · ${mv.country}</div>
                            </div>
                            <span class="btn-go-review">관람평 보기 / 작성</span>
                        </div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #666;">
                    등록된 영화 정보가 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 2. 실시간 전체 최신 관람평 -->
    <div class="section-title-wrap">
        <div class="section-title">실시간 최신 관람평 피드</div>
    </div>

    <div class="recent-feed-grid">
        <c:choose>
            <c:when test="${not empty recentReviews}">
                <c:forEach var="rev" items="${recentReviews}">
                    <div class="recent-card">
                        <div>
                            <a href="${pageContext.request.contextPath}/review/list.do?movieId=${rev.movieId}" class="recent-movie-name">
                                🎬 ${rev.movieTitle} &gt;
                            </a>
                            <div class="recent-content">${rev.content}</div>
                        </div>
                        <div class="recent-bottom">
                            <div>
                                <strong style="color: #bbb;">
                                    <c:choose>
                                        <c:when test="${fn:length(rev.memberId) > 3}">
                                            ${fn:substring(rev.memberId, 0, 3)}****
                                        </c:when>
                                        <c:otherwise>${rev.memberId}</c:otherwise>
                                    </c:choose>
                                </strong>
                                <c:if test="${rev.audience}">
                                    <span class="badge-real-audience">✓ 실관람객</span>
                                </c:if>
                            </div>
                            <div>
                                <span style="color: #feb700; font-weight: 700; margin-right: 8px;">★ ${rev.rating}점</span>
                                <span><fmt:formatDate value="${rev.regDate}" pattern="MM.dd"/></span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #666;">
                    아직 등록된 실시간 리뷰가 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>