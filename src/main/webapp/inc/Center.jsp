<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ page import="movie.MovieDAO" %>
<%@ page import="movie.MovieDTO" %>
<%@ page import="review.ReviewDAO" %>
<%@ page import="review.ReviewDTO" %>

<%
    /*
     * 메인 화면에서 MovieDAO에 직접 접근하여
     * 현재 DB에 등록된 영화 목록 중 5개를 무작위로 출력
     */
    MovieDAO movieDAO = new MovieDAO();
    List<MovieDTO> movieList = movieDAO.getMovieList();

    if (movieList == null) {
        movieList = new ArrayList<MovieDTO>();
    }

    // getMovieList()로 가져온 목록 자체를 섞은 뒤 최대 5개만 사용
    Collections.shuffle(movieList);

    int movieCount = Math.min(movieList.size(), 5);
    List<MovieDTO> randomMovies = movieList.subList(0, movieCount);

    // 로그인한 회원의 찜한 영화 ID 목록 가져오기
    String loginId = (String) session.getAttribute("id");
    List<Integer> favoriteMovieIds = new ArrayList<>();
    if (loginId != null) {
        favoriteMovieIds = movieDAO.getFavoriteMovieIds(loginId);
    }

 	// 최신 리뷰 3개 조회
    ReviewDAO reviewDAO = new ReviewDAO();

    List<ReviewDTO> recentReviews =
            reviewDAO.getRecentReviews(3);
%>

<style>
    /* =========================================================
       메인 홈 화면
       ========================================================= */

    .home-page {
        padding-top: 112px;
        padding-bottom: 80px;
    }

    .home-hero {
        position: relative;
        overflow: hidden;
        padding: 64px 0;
        background:
            radial-gradient(circle at 75% 35%, rgba(229, 9, 20, 0.22), transparent 32%),
            linear-gradient(135deg, #17181e 0%, #0d0e13 100%);
        border-bottom: 1px solid var(--border-color);
    }

    .home-hero::after {
        content: "";
        position: absolute;
        width: 420px;
        height: 420px;
        right: -120px;
        top: -180px;
        border-radius: 50%;
        background: rgba(229, 9, 20, 0.08);
        filter: blur(10px);
    }

    .home-hero-content {
        position: relative;
        z-index: 2;
    }

    .home-eyebrow {
        display: inline-flex;
        align-items: center;
        gap: 7px;
        margin-bottom: 14px;
        color: var(--primary-red);
        font-size: 13px;
        font-weight: 800;
        letter-spacing: 0.08em;
        text-transform: uppercase;
    }

    .home-title {
        margin: 0 0 14px;
        font-size: clamp(34px, 4vw, 54px);
        line-height: 1.15;
        font-weight: 900;
        letter-spacing: -1.8px;
        color: #fff;
    }

    .home-description {
        max-width: 680px;
        margin: 0;
        color: var(--text-muted);
        font-size: 16px;
        line-height: 1.75;
    }

    .home-section {
        margin-top: 72px;
    }

    .home-section-head {
        display: flex;
        align-items: flex-end;
        justify-content: space-between;
        gap: 20px;
        margin-bottom: 24px;
    }

    .home-section-title-wrap {
        display: flex;
        flex-direction: column;
        gap: 4px;
    }

    .home-section-title {
        margin: 0;
        font-size: 30px;
        font-weight: 800;
        letter-spacing: -1px;
    }

    .home-section-subtitle {
        margin: 0;
        color: var(--text-muted);
        font-size: 13px;
    }

    .home-more-link {
        color: var(--text-muted);
        font-size: 13px;
        font-weight: 700;
    }

    .home-more-link:hover {
        color: var(--primary-red);
    }

    .home-movie-grid {
        display: grid;
        grid-template-columns: repeat(5, minmax(0, 1fr));
        gap: 20px;
    }

    .home-movie-card {
        overflow: hidden;
        background: var(--bg-surface-card);
        border: 1px solid rgba(255,255,255,0.04);
        border-radius: 16px;
        box-shadow: 0 12px 26px rgba(0,0,0,0.24);
        transition: transform 0.22s ease, box-shadow 0.22s ease;
    }

    .home-movie-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 18px 34px rgba(0,0,0,0.35);
    }

    .home-poster {
        position: relative;
        aspect-ratio: 2 / 3;
        overflow: hidden;
        background: #2b2c32;
    }

    .home-poster img {
        display: block;
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.35s ease;
    }

    .home-movie-card:hover .home-poster img {
        transform: scale(1.05);
    }

    .home-random-badge {
        position: absolute;
        left: 10px;
        top: 10px;
        display: inline-flex;
        align-items: center;
        padding: 5px 9px;
        border-radius: 999px;
        background: rgba(13, 14, 19, 0.80);
        color: var(--accent-gold);
        font-size: 11px;
        font-weight: 800;
        backdrop-filter: blur(8px);
    }

	/* 좌하단 NEW 뱃지 스타일 (빨간 바탕 + 노란 글씨) */
	.badge-new {
	    position: absolute;
	    bottom: 10px;
	    left: 10px;
	    z-index: 5;
	    background-color: #e50914; 
	    color: #f1c40f;            
	    padding: 4px 8px;
	    font-size: 11px;
	    font-weight: 800;
	    border-radius: 4px;
	    box-shadow: 0 2px 6px rgba(0,0,0,0.3);
	}
	
	/* 우상단 찜(하트) 버튼 스타일 */
	.home-like-btn {
	    position: absolute;
	    top: 10px;
	    right: 10px;
	    z-index: 5;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    width: 32px;
	    height: 32px;
	    border: none;
	    border-radius: 50%;
	    background: rgba(13, 14, 19, 0.6);
	    color: #ffffff;
	    cursor: pointer;
	    backdrop-filter: blur(6px);
	    transition: background 0.2s, transform 0.2s;
	}
	
	.home-like-btn:hover {
	    background: rgba(229, 9, 20, 0.8);
	    transform: scale(1.1);
	}
	
	.home-like-btn .material-symbols-outlined {
	    font-size: 18px;
	}
	
	/* 찜 상태일 때 하트 아이콘 채우기 */
    .home-like-btn.active .material-symbols-outlined {
        font-variation-settings: 'FILL' 1;
        color: #e50914;
    }

    .home-movie-info {
        padding: 16px;
    }

    .home-movie-title {
        overflow: hidden;
        margin: 0 0 7px;
        color: #fff;
        font-size: 17px;
        font-weight: 800;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    .home-movie-meta {
        overflow: hidden;
        color: var(--text-muted);
        font-size: 12px;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    .home-empty {
        grid-column: 1 / -1;
        padding: 64px 20px;
        border: 1px dashed var(--border-color);
        border-radius: 16px;
        color: var(--text-muted);
        text-align: center;
    }

    .home-review-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 20px;
    }

    .home-review-card {
        min-height: 230px;
        padding: 24px;
        background: var(--bg-surface-card);
        border: 1px solid rgba(255,255,255,0.04);
        border-radius: 16px;
        box-shadow: 0 10px 22px rgba(0,0,0,0.20);
    }

    .home-review-top {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        margin-bottom: 12px;
    }

    .home-review-user {
        display: flex;
        align-items: center;
        gap: 10px;
        min-width: 0;
    }

    .home-review-avatar {
        display: flex;
        flex: 0 0 34px;
        width: 34px;
        height: 34px;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        background: rgba(229, 9, 20, 0.14);
        color: #ff706f;
        font-size: 13px;
        font-weight: 800;
    }

    .home-review-user-info {
        min-width: 0;
    }

    .home-review-user-name {
        margin: 0;
        color: #fff;
        font-size: 13px;
        font-weight: 700;
    }

    .home-review-date {
        margin: 2px 0 0;
        color: var(--text-muted);
        font-size: 11px;
    }

    .home-review-rating {
        flex: 0 0 auto;
        color: var(--accent-gold);
        font-size: 13px;
        font-weight: 800;
    }

    .home-review-movie {
        margin: 0 0 10px;
        color: #fff;
        font-size: 15px;
        font-weight: 700;
    }

    .home-review-content {
        margin: 0;
        color: var(--text-muted);
        font-size: 13px;
        line-height: 1.75;
        word-break: keep-all;
    }

    @media (max-width: 1100px) {
        .home-movie-grid {
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        .home-review-grid {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 700px) {
        .home-page {
            padding-top: 104px;
        }

        .home-hero {
            padding: 48px 0;
        }

        .home-section {
            margin-top: 52px;
        }

        .home-movie-grid {
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px;
        }

        .home-section-head {
            align-items: flex-start;
            flex-direction: column;
        }
    }
    .home-review-card {
    display: flex;
    flex-direction: column;

    min-height: 230px;
    padding: 24px;

    background: var(--bg-surface-card);
    border: 1px solid rgba(255, 255, 255, 0.04);
    border-radius: 16px;

    box-shadow: 0 10px 22px rgba(0, 0, 0, 0.20);

    text-decoration: none;
    color: inherit;

    transition:
        transform 0.22s ease,
        box-shadow 0.22s ease,
        border-color 0.22s ease;
}

.home-review-card:hover {
    transform: translateY(-4px);

    border-color: rgba(255, 255, 255, 0.10);

    box-shadow: 0 16px 30px rgba(0, 0, 0, 0.28);
}

.home-review-card .home-review-movie {
    color: #fff;
}

.home-review-card:hover .home-review-movie {
    color: var(--primary-red);
}
</style>

<main class="home-page">

    <!-- 메인 소개 영역 -->
    <section class="home-hero">
        <div class="inner-container home-hero-content">
            <div class="home-eyebrow">
                <span class="material-symbols-outlined" style="font-size: 16px;">movie</span>
                MOVIEBOX
            </div>

            <h1 class="home-title">오늘은 어떤 영화를<br>만나볼까요?</h1>

            <p class="home-description">
                현재 등록된 영화 중 새로운 작품을 랜덤으로 만나보세요.
                마음에 드는 영화를 발견했다면 영화 상세 정보와 예매 메뉴에서 이어서 확인할 수 있습니다.
            </p>
        </div>
    </section>

    <!-- 랜덤 영화 5개 -->
    <section class="inner-container home-section">
        <div class="home-section-head">
            <div class="home-section-title-wrap">
                <h2 class="home-section-title">오늘의 영화</h2>
                <p class="home-section-subtitle">
                    DB에 등록된 영화 중 무작위로 5편을 보여드립니다.
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/movies/MovieList.do"
               class="home-more-link">
                전체 영화 보기 →
            </a>
        </div>

        <div class="home-movie-grid">
            <% if (randomMovies.isEmpty()) { %>

                <div class="home-empty">
                    등록된 영화가 없습니다.
                </div>

            <% } else { %>

                <% for (int i = 0; i < randomMovies.size(); i++) {
                    MovieDTO movie = randomMovies.get(i);
                    boolean alreadyFav = favoriteMovieIds.contains(movie.getMovieId());
                %>

                    <div class="home-movie-card">
                        <div class="home-poster">
                            <!-- 포스터 이미지를 누르면 상세페이지로 이동 -->
                            <a href="${pageContext.request.contextPath}/movies/MovieDetail.do?movie_id=<%= movie.getMovieId() %>">
                                <img
                                    src="<%= movie.getPoster() %>"
                                    alt="<%= movie.getTitle() %>"
                                    onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';"
                                >
                            </a>

                            <span class="home-random-badge">
                                PICK <%= i + 1 %>
                            </span>

                            <!-- 우상단 찜(하트) 버튼 -->
                            <button type="button" class="home-like-btn <%= alreadyFav ? "active" : "" %>" onclick="toggleLike(event, '<%= movie.getMovieId() %>')">
                                <span class="material-symbols-outlined">favorite</span>
                            </button>

                            <!-- 좌하단 NEW 뱃지 (빨간 바탕 + 노란 글씨) -->
                            <% if (movie.isNew()) { %>
                                <span class="badge-new">NEW</span>
                            <% } %>
                        </div>

                        <div class="home-movie-info">
                            <a href="${pageContext.request.contextPath}/movies/MovieDetail.do?movie_id=<%= movie.getMovieId() %>" style="text-decoration: none; color: inherit;">
                                <h3 class="home-movie-title">
                                    <%= movie.getTitle() %>
                                </h3>
                            </a>

                            <p class="home-movie-meta">
                                <%= movie.getGenre() %>
                                <% if (movie.getCountry() != null && !movie.getCountry().isEmpty()) { %>
                                    · <%= movie.getCountry() %>
                                <% } %>
                                · <%= movie.getReleaseDate() %>
                            </p>
                        </div>
                    </div>

                <% } %>

            <% } %>
        </div>
    </section>

    <!-- 최신 리뷰 더미 데이터 -->
    <section class="inner-container home-section">
        <div class="home-section-head">
            <div class="home-section-title-wrap">
                <h2 class="home-section-title">최신 리뷰</h2>
                <p class="home-section-subtitle">
                    리뷰 기능 연결 전까지 임시 더미 데이터를 표시합니다.
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/review/main.do"
               class="home-more-link">
                리뷰 전체보기 →
            </a>
        </div>

        <div class="home-review-grid">

           <% if (recentReviews != null && !recentReviews.isEmpty()) { %>

        <% for (ReviewDTO review : recentReviews) { %>

            <a class="home-review-card"
   href="${pageContext.request.contextPath}/review/list.do?movieId=<%= review.getMovieId() %>">

    <div class="home-review-top">

        <div class="home-review-user">

            <div class="home-review-avatar">
                <%= review.getMemberId()
                        .substring(0, 1)
                        .toUpperCase() %>
            </div>

            <div class="home-review-user-info">

                <p class="home-review-user-name">
                    <%= review.getMemberId() %>
                </p>

                <p class="home-review-date">
                    <fmt:formatDate
                        value="<%= review.getRegDate() %>"
                        pattern="yyyy.MM.dd" />
                </p>

            </div>

        </div>

        <span class="home-review-rating">
            ★ <%= review.getRating() %>
        </span>

    </div>

    <h3 class="home-review-movie">
        <%= review.getMovieTitle() %>
    </h3>

    <p class="home-review-content">
        <%= review.getContent() %>
    </p>

</a>

        <% } %>

    <% } else { %>

        <div class="home-empty">

            <span class="material-symbols-outlined">
                rate_review
            </span>

            <p>아직 등록된 리뷰가 없습니다.</p>

        </div>

    <% } %>

        </div>
    </section>

</main>

<script>
function toggleLike(event, movieId) {
    event.preventDefault(); // a태그 상세페이지 이동 방지
    const btn = event.currentTarget;

    fetch('${pageContext.request.contextPath}/movies/Favorite.do', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: 'movieId=' + encodeURIComponent(movieId)
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'unauthorized') {
            alert('로그인이 필요한 서비스입니다.');
            location.href = '${pageContext.request.contextPath}/member/Login.do';
            return;
        }

        if (data.success) {
            if (data.status === 'added') {
                btn.classList.add('active');
            } else if (data.status === 'removed') {
                btn.classList.remove('active');
            }
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
}
</script>