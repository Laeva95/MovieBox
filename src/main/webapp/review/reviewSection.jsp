<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .movie-review-area {
        max-width: 900px;
        margin: 40px auto;
        color: #fff;
    }
    .review-summary-card {
        background-color: #1e1e1e;
        border: 1px solid #333;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .review-form-card {
        background-color: #1e1e1e;
        border: 1px solid #333;
        border-radius: 8px;
        padding: 24px;
        margin-bottom: 30px;
    }
    .review-form-row {
        display: flex;
        align-items: center;
        margin-bottom: 12px;
    }
    .review-form-label {
        width: 80px;
        font-weight: bold;
        color: #aaa;
    }
    .review-input, .review-select {
        background-color: #2b2b2b;
        border: 1px solid #444;
        color: #fff;
        padding: 8px 12px;
        border-radius: 4px;
    }
    .review-btn-submit {
        background-color: #e50914;
        color: #fff;
        border: none;
        padding: 10px 24px;
        border-radius: 4px;
        font-weight: bold;
        cursor: pointer;
    }
    .review-item {
        background-color: #181818;
        border-bottom: 1px solid #2e2e2e;
        padding: 16px;
    }
    .badge-audience {
        background: #0072d7;
        color: white;
        padding: 3px 6px;
        border-radius: 4px;
        font-size: 11px;
    }
</style>

<div class="movie-review-area">
    <!-- 1. 평점 및 관람객 인증 요약 -->
    <div class="review-summary-card">
        <div>
            <h3 style="margin: 0 0 6px 0;">관람객 평점</h3>
            <span style="font-size: 26px; font-weight: bold; color: #feb700;">★ ${avgRating}</span>
            <span style="color: #888;"> / 10.0</span>
        </div>
        <div>
            <c:if test="${isAudience}">
                <span class="badge-audience">✓ 실관람객 인증 회원</span>
            </c:if>
        </div>
    </div>

    <!-- 2. 리뷰 작성 폼 -->
    <div class="review-form-card">
        <c:choose>
            <%-- 로그인되어 있을 때만 작성 폼 노출 --%>
            <c:when test="${not empty sessionScope.loginId}">
                <form action="${pageContext.request.contextPath}/review/write.do" method="post">
                    <input type="hidden" name="movieId" value="${param.movieId != null ? param.movieId : movieId}">
                    
                    <div class="review-form-row">
                        <span class="review-form-label">작성자</span>
                        <span><strong>${sessionScope.loginId}</strong> 님</span>
                    </div>

                    <div class="review-form-row">
                        <span class="review-form-label">별점</span>
                        <select name="rating" class="review-select" style="width: 200px;">
                            <option value="10">★★★★★ 10점 (최고예요)</option>
                            <option value="9">★★★★☆ 9점</option>
                            <option value="8">★★★★☆ 8점 (추천해요)</option>
                            <option value="7">★★★☆☆ 7점</option>
                            <option value="5">★★☆☆☆ 5점 (보통)</option>
                            <option value="2">★☆☆☆☆ 2점 (아쉬워요)</option>
                        </select>
                    </div>

                    <div class="review-form-row" style="align-items: flex-start;">
                        <span class="review-form-label" style="margin-top: 8px;">한줄평</span>
                        <input type="text" name="content" class="review-input" style="flex: 1;" 
                               placeholder="영화에 대한 솔직한 후기를 남겨주세요." required>
                    </div>

                    <div style="text-align: right; margin-top: 10px;">
                        <button type="submit" class="review-btn-submit">등록하기</button>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 20px; color: #888;">
                    리뷰를 남기시려면 <a href="${pageContext.request.contextPath}/member/login.jsp" style="color: #e50914; text-decoration: underline;">로그인</a>이 필요합니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 3. 리뷰 리스트 -->
    <h3 style="margin-bottom: 12px;">등록된 관람평 (${reviewList.size()}건)</h3>
    <div style="border-radius: 8px; overflow: hidden; border: 1px solid #333;">
        <c:choose>
            <c:when test="${empty reviewList}">
                <div style="padding: 30px; text-align: center; color: #777; background: #1a1a1a;">
                    아직 등록된 관람평이 없습니다. 첫 번째 리뷰를 남겨보세요!
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="rev" items="${reviewList}">
                    <div class="review-item">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                            <div>
                                <strong>${rev.memberId}</strong>
                                <span style="color: #feb700; font-weight: bold; margin-left: 10px;">★ ${rev.rating}</span>
                                <span style="color: #666; font-size: 12px; margin-left: 8px;">
                                    <fmt:formatDate value="${rev.regDate}" pattern="yyyy-MM-dd HH:mm"/>
                                </span>
                            </div>
                            <c:if test="${sessionScope.loginId eq rev.memberId}">
                                <a href="${pageContext.request.contextPath}/review/delete.do?reviewId=${rev.reviewId}&movieId=${rev.movieId}" 
                                   style="color: #ff5c5c; font-size: 12px; text-decoration: none;"
                                   onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                            </c:if>
                        </div>
                        <div style="color: #ddd;">${rev.content}</div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>