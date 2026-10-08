<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<div class="mypage-sub-header">
    <div class="mypage-section-title">작성한 리뷰</div>
    <div class="mypage-section-description">
        작성한 영화 리뷰를 확인할 수 있습니다.
        <br>
    </div>
</div>
 <br>
<c:choose>
    <c:when test="${not empty myReviewList}">
        <div class="my-review-list">
            <c:forEach var="review" items="${myReviewList}">
                <article class="my-review-card">
                    <div class="my-review-top">
                        <div class="my-review-movie">
                            ${review.movieTitle}
                        </div>

                        <div class="my-review-rating">
                            ★ ${review.rating} / 10
                        </div>
                    </div>

                    <p class="my-review-content">${review.content}</p>

                    <div class="my-review-bottom">
                        <div class="my-review-date">
                            ${review.regDate}
                        </div>

                        <div class="my-review-actions">
                            <a class="my-review-link"
                               href="${pageContext.request.contextPath}/review/list.do?movieId=${review.movieId}">
                                리뷰 보기
                            </a>

                            <form action="${pageContext.request.contextPath}/review/delete.do"
                                  method="post"
                                  onsubmit="return confirm('이 리뷰를 삭제하시겠습니까?');">
                                <input type="hidden" name="reviewId" value="${review.reviewId}">
                                <input type="hidden" name="movieId" value="${review.movieId}">
                                <button type="submit" class="my-review-delete-button">
                                    삭제
                                </button>
                            </form>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>
    </c:when>

    <c:otherwise>
        <div class="mypage-empty">
            아직 작성한 리뷰가 없습니다.<br>
            영화를 관람한 뒤 리뷰를 작성해보세요.
        </div>
    </c:otherwise>
</c:choose>
