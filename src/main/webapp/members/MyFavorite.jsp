<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="mypage-sub-header">
    <div class="mypage-section-title">찜한 영화</div>
    <div class="mypage-section-description">
        나중에 보고 싶은 영화를 모아볼 수 있습니다.
        <br>
    </div>
</div>
 <br>
<c:choose>
    <c:when test="${not empty favoriteMovies}">
        <div class="favorite-grid">
            <c:forEach var="movie" items="${favoriteMovies}">
                <article class="favorite-card">
                    <div class="favorite-poster">
                        <c:choose>
                            <c:when test="${not empty movie.poster}">
                                <img src="${movie.poster}" alt="${movie.title} 포스터">
                            </c:when>
                            <c:otherwise>
                                <div class="favorite-poster-empty">포스터 없음</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="favorite-info">
                        <div class="favorite-title">${movie.title}</div>
                        <div class="favorite-meta">
                            ${movie.genre}<br>
                            ${movie.runningTime} · ${movie.releaseDate}
                        </div>

                        <div class="favorite-actions">
                            <a class="favorite-detail-button"
                               href="${pageContext.request.contextPath}/movies/MovieDetail.do?movie_id=${movie.movieId}">
                                상세보기
                            </a>

                            <button type="button"
                                    class="favorite-remove-button"
                                    onclick="removeFavorite(${movie.movieId});">
                                찜 해제
                            </button>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>
    </c:when>

    <c:otherwise>
        <div class="mypage-empty">
            아직 찜한 영화가 없습니다.<br>
            영화 상세 페이지에서 하트 버튼을 눌러 영화를 추가해보세요.
        </div>
    </c:otherwise>
</c:choose>

<script>
function removeFavorite(movieId) {
    if (!confirm('이 영화를 찜 목록에서 삭제하시겠습니까?')) {
        return;
    }

    fetch('${pageContext.request.contextPath}/movies/Favorite.do?movieId=' + movieId, {
        method: 'POST',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.success && data.status === 'removed') {
            location.reload();
        } else if (data.status === 'unauthorized') {
            location.href = '${pageContext.request.contextPath}/member/Login.do';
        } else {
            alert('찜 해제에 실패했습니다.');
        }
    })
    .catch(function(error) {
        console.error(error);
        alert('찜 해제 중 오류가 발생했습니다.');
    });
}
</script>
