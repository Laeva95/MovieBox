<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="movie.MovieDTO" %>
<%@ page import="movie.MovieDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 1. 전달받은 movieId 파라미터 가져오기
    String movieIdStr = request.getParameter("movie_id");
    MovieDTO movie = null;
    
    if (movieIdStr != null && !movieIdStr.isEmpty()) {
        int movieId = Integer.parseInt(movieIdStr);
        
        // 2. DAO를 통해 해당 영화의 상세 정보 조회
        MovieDAO dao = new MovieDAO();
        movie = dao.getMovieDetails(movieId);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>영화 상세 정보 - Movie Box</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
      /* 상세 페이지 전용 레이아웃 스타일 */
      .detail-container {
          display: flex;
          gap: 40px;
          background-color: #fff;
          border: 1px solid #ddd;
          border-radius: 12px;
          padding: 40px;
          box-shadow: 0 4px 12px rgba(0,0,0,0.05);
      }
      .detail-poster-area {
          flex: 0 0 320px;
      }
      .detail-poster-img {
          width: 100%;
          height: 460px;
          object-fit: cover;
          border-radius: 8px;
          box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      }
      .detail-info-area {
          flex: 1;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
      }
      .movie-title-ko {
          font-size: 32px;
          font-weight: 700;
          color: #111;
          margin-bottom: 15px;
      }
      .movie-meta-box {
          background-color: #f9f9f9;
          padding: 20px;
          border-radius: 8px;
          margin-bottom: 25px;
      }
      .movie-meta-box p {
          margin: 8px 0;
          font-size: 15px;
          color: #333;
      }
      .movie-summary-section h3 {
          font-size: 18px;
          margin-bottom: 10px;
          color: #111;
      }
      .movie-summary-section p {
          font-size: 14px;
          color: #666;
          line-height: 1.6;
      }
      .detail-btn-group {
          display: flex;
          gap: 12px;
          margin-top: 30px;
      }
      .btn-back, .btn-booking {
          padding: 12px 24px;
          border-radius: 6px;
          font-size: 15px;
          font-weight: 600;
          text-decoration: none;
          text-align: center;
          cursor: pointer;
          border: none;
      }
      .btn-back {
          background-color: #eee;
          color: #333;
      }
      .btn-back:hover {
          background-color: #ddd;
      }
      .btn-booking {
          background-color: #e50914;
          color: white;
          flex: 1;
      }
      .btn-booking:hover {
          background-color: #b20710;
      }
  </style>
</head>
<body>
  <!-- 헤더 영역 (index.jsp, MovieList.jsp와 동일) -->
  <header class="site-header">
    <div class="util-bar">
      <div class="inner-container util-inner">
        <c:choose>
          <c:when test="${empty sessionScope.loginUser}">
            <a href="${pageContext.request.contextPath}/member/login.jsp">로그인</a>
            <a href="${pageContext.request.contextPath}/member/join.jsp">회원가입</a>
          </c:when>
          <c:otherwise>
            <span><strong>${sessionScope.loginUser.name}</strong>님 환영합니다</span>
            <a href="${pageContext.request.contextPath}/member/logout.do">로그아웃</a>
            <a href="${pageContext.request.contextPath}/member/myPage.jsp">마이페이지</a>
          </c:otherwise>
        </c:choose>
        <a href="#">고객센터</a>
      </div>
    </div>
    <div class="inner-container gnb-bar">
      <div class="gnb-left">
        <a href="${pageContext.request.contextPath}/" class="brand-logo">MOVIE<span class="logo-red">BOX</span></a>
        <nav class="main-nav">
		  <a href="${pageContext.request.contextPath}/movie/MovieList.do" style="color: #e50914;">영화</a>
          <a href="#">예매</a>
          <a href="#">영화관</a>
          <a href="#">이벤트</a>
          <a href="#">리뷰</a>
        </nav>
      </div>
      <div class="gnb-right">
        <a href="${pageContext.request.contextPath}/#quick-booking" class="btn-quick-nav">빠른예매</a>
      </div>
    </div>
  </header>

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
                      <h1 class="movie-title-ko"><%= movie.getTitle() %></h1>
                      
                      <div class="movie-meta-box">
                          <p><strong>장르:</strong> <%= movie.getGenre() %></p>
                          <p><strong>국가:</strong> <%= movie.getCountry() %></p>
                          <p><strong>개봉일:</strong> <%= movie.getReleaseDate() %></p>
                          <p><strong>러닝타임:</strong> <%= movie.getRunningTime() %></p>
                      	  <p><strong>감독:</strong> <%= movie.getDirector() %></p>
                          <p><strong>출연:</strong> <%= movie.getActors() %></p>
                      
                      </div>
                      
						<div class="movie-summary-section">
						
						    <h3>줄거리</h3>
						
						    <p><%= movie.getSummary() %></p>
						
						</div>
                  </div>
                  
                  <!-- 하단 버튼 그룹 -->
                  <div class="detail-btn-group">
                     <a href="${pageContext.request.contextPath}/movie/MovieList.do" class="btn-back">목록으로</a>
                      <a href="booking.jsp?movie_id=<%= movie.getMovieId() %>" class="btn-booking">예매하러 가기</a>
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

  <footer class="site-footer">
    <div class="inner-container">
      <p>&copy; Movie Box Cinema Corp. All rights reserved.</p>
    </div>
  </footer>
</body>
</html>