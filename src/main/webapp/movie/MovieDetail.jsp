<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="movie.MovieDTO" %>
<%@ page import="movie.MovieDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String movieIdStr = request.getParameter("movieId");
    if (movieIdStr == null || movieIdStr.trim().isEmpty()) {
        movieIdStr = request.getParameter("movie_id");
    }

    MovieDTO movie = null;
    if (movieIdStr != null && !movieIdStr.trim().isEmpty()) {
        int movieId = Integer.parseInt(movieIdStr);
        MovieDAO dao = new MovieDAO();
        movie = dao.getMovieDetails(movieId);
    }
%>
  <style>
      /* 글래스모피즘 & 시네마틱 다크 테마 */
      .detail-container {
          display: flex;
          gap: 40px;
          background: rgba(31, 41, 55, 0.75); /* 반투명 다크 차콜 */
          backdrop-filter: blur(12px);         /* 유리알 흐림 효과 (글래스모피즘) */
          -webkit-backdrop-filter: blur(12px);
          border: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 16px;
          padding: 40px;
          box-shadow: 0 16px 32px rgba(0,0,0,0.6);
          color: #f3f4f6;
          position: relative;
          overflow: hidden;
      }
      .detail-poster-area {
          flex: 0 0 320px;
      }
      .detail-poster-img {
          width: 100%;
          height: 460px;
          object-fit: cover;
          border-radius: 10px;
          box-shadow: 0 8px 24px rgba(0,0,0,0.7); /* 포스터 입체감 강조 */
          transition: transform 0.3s;
      }
      .detail-poster-img:hover {
          transform: scale(1.02);
      }
      .detail-info-area {
          flex: 1;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
      }
      .movie-title-ko {
          font-size: 36px;
          font-weight: 800;
          color: #ffffff;
          margin-bottom: 20px;
          letter-spacing: -0.5px;
      }
      
      /* 세련된 둥근 태그 (Pill Badges) 스타일 */
      .movie-tags-group {
          display: flex;
          flex-wrap: wrap;
          gap: 10px;
          margin-bottom: 25px;
      }
      .pill-badge {
          display: inline-flex;
          align-items: center;
          padding: 6px 14px;
          background-color: rgba(229, 9, 20, 0.15); /* 넷플릭스 레드 포인트 틴트 */
          color: #ff6b6b;
          border: 1px solid rgba(229, 9, 20, 0.3);
          border-radius: 20px;
          font-size: 13px;
          font-weight: 600;
      }
      .pill-badge span {
          color: #d1d5db;
          margin-left: 6px;
          font-weight: normal;
      }

      /* 빨간 바 헤더 공통 스타일 (# 감독, # 출연, # 줄거리) */
      .section-title-wrap {
          display: flex;
          align-items: center;
          gap: 8px;
          margin-bottom: 8px;
      }
      .section-title-wrap::before {
          content: '';
          display: inline-block;
          width: 3px;
          height: 16px;
          background-color: #e50914; /* 넷플릭스 레드 포인트 바 */
          border-radius: 2px;
      }
      .section-title-wrap h3 {
          font-size: 16px;
          font-weight: 700;
          color: #ffffff;
          margin: 0;
          letter-spacing: -0.3px;
      }

      /* 감독 & 출연 정보 깔끔한 텍스트 영역 */
      .movie-people-info {
          display: flex;
          flex-direction: column;
          gap: 14px;
          margin-bottom: 20px;
      }
      .movie-people-item p {
          margin: 0;
          font-size: 14px;
          color: #cbd5e1;
          line-height: 1.5;
          padding-left: 11px; /* 빨간 바 위치와 시각적 정렬 맞춤 */
      }

      /* 줄거리 전용 박스 디자인 */
      .movie-summary-box {
          background-color: rgba(17, 24, 39, 0.6);
          padding: 18px 20px;
          border-radius: 10px;
          border: 1px solid rgba(255, 255, 255, 0.05);
          max-height: 125px;            /* 일정 높이 넘어가면 스크롤 생성 */
          overflow-y: auto;             /* 세로 스크롤바 */
          box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.2); /* 은은한 내각 그림자 */
      }
      .movie-summary-box p {
          font-size: 14px;
          color: #cbd5e1;               /* 가독성 높은 슬레이트 회색 */
          line-height: 1.75;            /* 여유로운 줄간격 */
          margin: 0;
          word-break: keep-all;         /* 단어 단위 줄바꿈 */
          white-space: pre-line;        /* 줄바꿈(엔터) 자동 반영 */
      }

      /* 텍스트 박스 내부 커스텀 다크 스크롤바 */
      .movie-summary-box::-webkit-scrollbar {
          width: 5px;
      }
      .movie-summary-box::-webkit-scrollbar-track {
          background: transparent;
      }
      .movie-summary-box::-webkit-scrollbar-thumb {
          background-color: #374151;
          border-radius: 3px;
      }
      .movie-summary-box::-webkit-scrollbar-thumb:hover {
          background-color: #e50914;  /* 스크롤바 마우스 올렸을 때 넷플릭스 레드 */
      }

      /* 버튼 그룹 스타일 */
      .detail-btn-group {
          display: flex;
          gap: 12px;
          margin-top: 30px;
      }
      .btn-back, .btn-booking {
          padding: 12px 24px;
          border-radius: 8px;
          font-size: 15px;
          font-weight: 600;
          text-decoration: none;
          text-align: center;
          cursor: pointer;
          border: none;
          transition: all 0.2s;
      }
      .btn-back {
          background-color: #374151;
          color: #d1d5db;
          border: 1px solid #4b5563;
      }
      .btn-back:hover {
          background-color: #4b5563;
          color: #fff;
      }
      .btn-booking {
          background-color: #e50914;
          color: white;
          flex: 1;
          box-shadow: 0 4px 12px rgba(229, 9, 20, 0.4);
      }
      .btn-booking:hover {
          background-color: #f40612;
      }
  </style>

  <main style="padding-top: 112px;">
    <section class="inner-container section-wrap" style="margin-top: 40px; margin-bottom: 80px;">
      <% if (movie != null) { %>
          <div class="detail-container">
              <!-- 좌측: 포스터 이미지 영역 -->
              <div class="detail-poster-area">
                  <img class="detail-poster-img" 
                       src="<%= movie.getPoster() %>" 
                       alt="<%= movie.getTitle() %>" 
                       onerror="this.src='${pageContext.request.contextPath}/poster/default.jpg'">
              </div>
              
              <!-- 우측: 영화 정보 및 줄거리 영역 -->
              <div class="detail-info-area">
                  <div>
                      <h1 class="movie-title-ko">🎬 <%= movie.getTitle() %></h1>
                      
                      <!-- 장르, 국가, 개봉일, 러닝타임을 세련된 태그(Pill Badge)로 배치 -->
                      <div class="movie-tags-group">
                          <div class="pill-badge">장르 <span><%= movie.getGenre() %></span></div>
                          <div class="pill-badge">국가 <span><%= movie.getCountry() %></span></div>
                          <div class="pill-badge">개봉 <span><%= movie.getReleaseDate() %></span></div>
                          <div class="pill-badge">러닝타임 <span><%= movie.getRunningTime() %>분</span></div>
                      </div>

                      <!-- 감독 & 출연진 영역 (빨간 세로 바 포인트) -->
                      <div class="movie-people-info">
                          <div class="movie-people-item">
                              <div class="section-title-wrap">
                                  <h3># 감독</h3>
                              </div>
                              <p><%= movie.getDirector() %></p>
                          </div>
                          
                          <div class="movie-people-item">
                              <div class="section-title-wrap">
                                  <h3># 출연</h3>
                              </div>
                              <p><%= movie.getActors() %></p>
                          </div>
                      </div>
                      
                      <!-- 세련된 # 줄거리 영역 -->
                      <div class="movie-summary-section" style="margin-top: 15px;">
                          <div class="section-title-wrap">
                              <h3># 줄거리</h3>
                          </div>
                          <div class="movie-summary-box">
                              <p><%= movie.getSummary() %></p>
                          </div>
                      </div>
                  </div>
                  
                  <!-- 하단 버튼 그룹 -->
                  <div class="detail-btn-group">
                      <a href="${pageContext.request.contextPath}/movies/MovieList.do" class="btn-back">목록으로</a>
                      <a href="${pageContext.request.contextPath}/movie/Booking.do?movie_id=<%= movie.getMovieId() %>" class="btn-booking">예매하러 가기</a>
                  </div>
              </div>
          </div>
      <% } else { %>
          <script>
              alert("존재하지 않거나 잘못된 영화 정보입니다.");
              history.back();
          </script>
      <% } %>
    </section>
  </main>