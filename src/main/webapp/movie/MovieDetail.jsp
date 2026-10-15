<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="movie.MovieDTO" %>
<%@ page import="movie.MovieDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    // 1. MovieController가 request에 담아준 movie 객체를 최우선으로 가져옵니다.
    MovieDTO movie = (MovieDTO) request.getAttribute("movie");

    // 2. 만약 직접 URL로 접근해서 객체가 없다면 파라미터를 읽어와서 조회합니다.
    if (movie == null) {
        String movieIdStr = request.getParameter("movieId");
        if (movieIdStr == null || movieIdStr.trim().isEmpty()) {
            movieIdStr = request.getParameter("movie_id");
        }

        if (movieIdStr != null && !movieIdStr.trim().isEmpty()) {
            try {
                int movieId = Integer.parseInt(movieIdStr.trim());
                MovieDAO dao = new MovieDAO();
                movie = dao.getMovieDetails(movieId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
  <style>
      /* 글래스모피즘 & 시네마틱 다크 테마 */
      .detail-container {
          display: flex;
          gap: 40px;
          background: rgba(31, 41, 55, 0.75);
          backdrop-filter: blur(12px);
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
          box-shadow: 0 8px 24px rgba(0,0,0,0.7);
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
          margin: 0;
          letter-spacing: -0.5px;
      }
      
      /* 태그 (Pill Badges) 스타일 */
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
          background-color: rgba(229, 9, 20, 0.15);
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

      /* 섹션 타이틀 공통 스타일 */
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
          background-color: #e50914;
          border-radius: 2px;
      }
      .section-title-wrap h3 {
          font-size: 16px;
          font-weight: 700;
          color: #ffffff;
          margin: 0;
          letter-spacing: -0.3px;
      }

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
          padding-left: 11px;
      }

      /* 줄거리 박스 */
      .movie-summary-box {
          background-color: rgba(17, 24, 39, 0.6);
          padding: 18px 20px;
          border-radius: 10px;
          border: 1px solid rgba(255, 255, 255, 0.05);
          max-height: 110px;
          overflow-y: auto;
          box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.2);
      }
      .movie-summary-box p {
          font-size: 14px;
          color: #cbd5e1;
          line-height: 1.75;
          margin: 0;
          word-break: keep-all;
          white-space: pre-line;
      }
      .movie-summary-box::-webkit-scrollbar { width: 5px; }
      .movie-summary-box::-webkit-scrollbar-track { background: transparent; }
      .movie-summary-box::-webkit-scrollbar-thumb { background-color: #374151; border-radius: 3px; }
      .movie-summary-box::-webkit-scrollbar-thumb:hover { background-color: #e50914; }

      /* 스틸컷 갤러리 */
      .stills-gallery {
          display: flex;
          gap: 10px;
          overflow-x: auto;
          scroll-behavior: smooth;
          padding-bottom: 5px;
          scrollbar-width: none;
          max-width: 900px;
          scroll-snap-type: x mandatory;
      }
      .stills-gallery::-webkit-scrollbar {
          display: none;
      }
      .stills-gallery img {
          width: 120px;
          height: 75px;
          object-fit: cover;
          border-radius: 6px;
          border: 1px solid rgba(255, 255, 255, 0.1);
          box-shadow: 0 4px 8px rgba(0,0,0,0.4);
          transition: transform 0.2s, border-color 0.2s;
          flex-shrink: 0;
          cursor: pointer;
          scroll-snap-align: start;
      }
      .stills-gallery img:hover {
          transform: scale(1.05);
          border-color: #e50914;
      }

      /* 버튼 그룹 스타일 */
      .detail-btn-group {
          display: flex;
          gap: 10px;
          margin-top: 25px;
          flex-wrap: wrap;
      }
      .btn-back, .btn-trailer, .btn-review, .btn-booking {
          padding: 12px 18px;
          border-radius: 8px;
          font-size: 14px;
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
      .btn-back:hover { background-color: #4b5563; color: #fff; }
      
      .btn-trailer {
          background-color: rgba(229, 9, 20, 0.2);
          color: #ff6b6b;
          border: 1px solid rgba(229, 9, 20, 0.4);
      }
      .btn-trailer:hover { background-color: #e50914; color: white; }

      .btn-review {
          background-color: rgba(59, 130, 246, 0.2);
          color: #60a5fa;
          border: 1px solid rgba(59, 130, 246, 0.4);
      }
      .btn-review:hover { background-color: #3b82f6; color: white; }

      .btn-booking {
          background-color: #e50914;
          color: white;
          box-shadow: 0 4px 12px rgba(229, 9, 20, 0.4);
      }
      .btn-booking:hover { background-color: #f40612; }

      /* 스틸컷 확대 보기 팝업 모달 스타일 */
      .still-modal-overlay {
          position: fixed;
          top: 0; left: 0;
          width: 100%; height: 100%;
          background: rgba(0, 0, 0, 0.95);
          display: none;
          justify-content: center;
          align-items: center;
          z-index: 10000;
          backdrop-filter: blur(10px);
      }
      .still-modal-content {
          width: 700px;
          max-width: 90vw;
          height: auto;
          object-fit: contain;
          border-radius: 12px;
          box-shadow: 0 20px 40px rgba(0,0,0,0.8);
          border: 1px solid rgba(255, 255, 255, 0.15);
          background-color: #111;
          padding: 8px;
          animation: scaleUp 0.2s ease-in-out;
      }
      @keyframes scaleUp {
          from { transform: scale(0.95); opacity: 0; }
          to { transform: scale(1); opacity: 1; }
      }
      .still-modal-close {
          position: absolute;
          top: 30px; right: 40px;
          color: #9ca3af;
          font-size: 36px;
          font-weight: 300;
          cursor: pointer;
          background: none;
          border: none;
          transition: color 0.2s;
          z-index: 10001;
      }
      .still-modal-close:hover { color: #ffffff; }
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
                      <!-- 영화 제목과 관람 등급을 같은 줄에 배치 -->
                      <%
                          String watchGrade = (movie.getWatchGrade() == null) ? "" : movie.getWatchGrade().trim();
                          String shortGrade = "전체";
                          String badgeBg = "#059669";
                          if (watchGrade.contains("12")) { shortGrade = "12세"; badgeBg = "#d97706"; }
                          else if (watchGrade.contains("15")) { shortGrade = "15세"; badgeBg = "#b45309"; }
                          else if (watchGrade.contains("청소년") || watchGrade.contains("19") || watchGrade.contains("제한")) { shortGrade = "청불"; badgeBg = "#dc2626"; }
                          else if (!watchGrade.isEmpty() && !watchGrade.contains("전체")) { shortGrade = watchGrade; }
                      %>
                      <div class="movie-title-grade-row">
                          <h1 class="movie-title-ko"><%= movie.getTitle() %></h1>
                          <span style="background-color:<%= badgeBg %>; color:#fff; padding:5px 8px; font-size:12px; font-weight:800; border-radius:5px; display:inline-flex; align-items:center; justify-content:center; white-space:nowrap;"><%= shortGrade %></span>
                      </div>
                      
                      <!-- 태그 영역 -->
                      <div class="movie-tags-group">
                          <div class="pill-badge">장르 <span><%= movie.getGenre() %></span></div>
                          <div class="pill-badge">국가 <span><%= movie.getCountry() %></span></div>
                          <div class="pill-badge">개봉 <span><%= movie.getReleaseDate() %></span></div>
                          <div class="pill-badge">러닝타임 <span><%= movie.getRunningTime() %>분</span></div>
                      </div>

                      <!-- 감독 & 출연진 영역 -->
                      <div class="movie-people-info">
                          <div class="movie-people-item">
                              <div class="section-title-wrap"><h3># 감독</h3></div>
                              <p><%= movie.getDirector() %></p>
                          </div>
                          
                          <div class="movie-people-item">
                              <div class="section-title-wrap"><h3># 출연</h3></div>
                              <p><%= movie.getActors() %></p>
                          </div>
                      </div>
                      
                      <!-- 줄거리 영역 -->
                      <div class="movie-summary-section" style="margin-top: 12px;">
                          <div class="section-title-wrap"><h3># 줄거리</h3></div>
                          <div class="movie-summary-box">
                              <p><%= movie.getSummary() %></p>
                          </div>
                      </div>

                      <!-- 스틸컷 갤러리 영역 -->
                      <% if (movie.getStills() != null && !movie.getStills().trim().isEmpty()) { %>
                          <div class="movie-stills-section" style="margin-top: 20px;">
                              <div class="section-title-wrap" style="margin-bottom: 10px;">
                                  <h3># 스틸컷</h3>
                              </div>
                              
                              <!-- 스틸컷 이미지 갤러리 -->
                              <div class="stills-gallery" id="stillsGallery">
                                  <%
                                      String stillsStr = movie.getStills();
                                      String[] stillsArr = stillsStr.split(",");
                                      for (String still : stillsArr) {
                                          if (still != null && !still.trim().isEmpty()) {
                                  %>
                                              <img src="<%= still.trim() %>" alt="스틸컷" onclick="openStillModal(this.src)" onerror="this.style.display='none';">
                                  <%
                                          }
                                      }
                                  %>
                              </div>

                              <!-- 좌우 화살표 버튼 그룹 -->
                              <div style="display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 10px;">
                                  <button type="button" onclick="scrollStills(-1)" style="cursor: pointer; width: 32px; height: 32px; border-radius: 50%; background-color: #374151; color: #ffffff; border: 1px solid #4b5563; font-size: 14px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 6px rgba(0,0,0,0.3);">&#10094;</button>
                                  <button type="button" onclick="scrollStills(1)" style="cursor: pointer; width: 32px; height: 32px; border-radius: 50%; background-color: #374151; color: #ffffff; border: 1px solid #4b5563; font-size: 14px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 6px rgba(0,0,0,0.3);">&#10095;</button>
                              </div>
                          </div>
                      <% } %>
                  </div>
                  
                  <!-- 하단 버튼 그룹 -->
                  <div class="detail-btn-group">
                      <a href="${pageContext.request.contextPath}/movies/MovieList.do" class="btn-back">목록으로</a>
                      
                      <% 
                          String trailerUrl = movie.getVodUrl();
                          if (trailerUrl == null || trailerUrl.trim().isEmpty()) {
                              trailerUrl = "https://www.youtube.com/results?search_query=" + java.net.URLEncoder.encode(movie.getTitle() + " 예고편", "UTF-8");
                          }
                      %>
                      <a href="<%= trailerUrl %>" target="_blank" class="btn-trailer">▶ 예고편 보기</a>
                      
                      <!-- 실관람평 보기 버튼 -->
                      <a href="${pageContext.request.contextPath}/review/main.do" class="btn-review">⭐ 실관람평 보기</a>
                      
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

  <!-- 스틸컷 확대 보기 모달 -->
  <div id="stillModal" class="still-modal-overlay" onclick="closeStillModal()">
      <button type="button" class="still-modal-close" onclick="closeStillModal()">&times;</button>
      <img id="stillModalImg" class="still-modal-content" alt="스틸컷 확대 이미지" onclick="event.stopPropagation();">
  </div>

  <script>
  // 스틸컷 좌우 슬라이드 함수 (오타 수정 반영 완료)
  function scrollStills(direction) {
      var gallery = document.getElementById('stillsGallery');
      if (gallery) {
          gallery.scrollBy({ left: direction * 600, behavior: 'smooth' });
      }
  }

  // 스틸컷 확대 팝업 열기
  function openStillModal(imgSrc) {
      var modal = document.getElementById('stillModal');
      var modalImg = document.getElementById('stillModalImg');
      modalImg.src = imgSrc;
      modal.style.display = 'flex';
  }

  // 스틸컷 확대 팝업 닫기
  function closeStillModal() {
      var modal = document.getElementById('stillModal');
      modal.style.display = 'none';
  }
  </script>