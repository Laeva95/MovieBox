<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="movie.MovieDTO" %>
<%@ page import="movie.MovieDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 사용자가 선택한 파라미터 값 받기
    String country = request.getParameter("country");
    String genre = request.getParameter("genre");
    String sort = request.getParameter("sort");
    
    MovieDAO dao = new MovieDAO();
    // 필터 및 정렬이 적용된 목록 가져오기
    List<MovieDTO> movieList = dao.getFilteredAndSortedMovieList(country, genre, sort);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>영화 목록 - Movie Box</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
      /* 필터 영역 스타일 (인덱스 스타일과 조화되도록 가볍게 다듬음) */
      .filter-container {
          display: flex;
          gap: 10px;
          margin-bottom: 30px;
          justify-content: flex-end;
          align-items: center;
      }
      .filter-container select, .filter-container button {
          padding: 8px 12px;
          border-radius: 4px;
          border: 1px solid #ddd;
          font-size: 14px;
      }
      .filter-container button {
          background: #e50914;
          color: #fff;
          border: none;
          cursor: pointer;
      }
      .movie-card {
          cursor: pointer;
          transition: transform 0.2s;
      }
      .movie-card:hover {
          transform: translateY(-5px);
      }
  </style>
</head>
<body>
  <!-- 헤더 영역 (index.jsp와 동일한 스타일) -->
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
          <a href="${pageContext.request.contextPath}/movie/MovieList.jsp" style="color: #e50914;">영화</a>
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
      <div class="section-head">
        <h2 class="section-title">현재 상영 중인 영화 (총 <%= movieList != null ? movieList.size() : 0 %>편)</h2>
      </div>
      
      <!-- 필터와 정렬 폼 -->
      <div class="filter-container">
        <form method="get" action="MovieList.jsp" style="display: flex; gap: 10px;">
            <select name="country">
                <option value="all">전체 국가</option>
                <option value="한국" <%= "한국".equals(country) ? "selected" : "" %>>한국</option>
                <option value="미국" <%= "미국".equals(country) ? "selected" : "" %>>미국</option>
                <option value="일본" <%= "일본".equals(country) ? "selected" : "" %>>일본</option>
            </select>
            
            <select name="genre">
                <option value="all">전체 장르</option>
                <option value="액션" <%= "액션".equals(genre) ? "selected" : "" %>>액션</option>
                <option value="드라마" <%= "드라마".equals(genre) ? "selected" : "" %>>드라마</option>
                <option value="코미디" <%= "코미디".equals(genre) ? "selected" : "" %>>코미디</option>
                <option value="애니메이션" <%= "애니메이션".equals(genre) ? "selected" : "" %>>애니메이션</option>
            </select>
            
            <select name="sort">
                <option value="date" <%= "date".equals(sort) ? "selected" : "" %>>개봉순</option>
                <option value="title" <%= "title".equals(sort) ? "selected" : "" %>>가나다순</option>
            </select>
            
            <button type="submit">적용</button>
        </form>
      </div>

      <!-- 영화 카드 목록 그리드 -->
      <div class="movie-grid">
        <% if (movieList != null && !movieList.isEmpty()) { %>
            <% for(int i = 0; i < movieList.size(); i++) { 
                MovieDTO movie = movieList.get(i);
            %>
                <div class="movie-card" onclick="location.href='MovieDetail.jsp?movie_id=<%= movie.getMovieId() %>'">
                  <div class="poster-area">
                    <!-- 포스터 이미지 경로 수정 (${pageContext.request.contextPath}/poster/...) -->
                    <img class="poster-img" src="${pageContext.request.contextPath}/poster/<%= movie.getPosterUrl() %>" 
                    						alt="<%= movie.getTitle() %>" 
                    						style="width: 100%;
                    						 height: auto; /* 🌟 높이를 고정값 대신 auto로 설정하여 원본 비율대로 늘어남 */;
                    						 object-fit: contain; /* 🌟 이미지가 잘리지 않고 영역 안에 전체 다 들어오도록 함 (권장) */ 	
                    					     border-radius: 4px; 
                    					     margin-bottom: 10px;">
                    <div class="rank-overlay"><span class="rank-number"><%= i + 1 %></span></div>
                  </div>
                  <div class="card-info">
                    <h3 class="movie-card-title"><%= movie.getTitle() %></h3>
                    <div class="card-meta-line">
                      <span><%= movie.getGenre() %> | <%= movie.getCountry() %> | <%= movie.getReleaseDate() %> 개봉</span>
                    </div>
                  </div>
                </div>
            <% } %>
        <% } else { %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 60px 0; color: #666;">
              등록된 영화가 없습니다.
            </div>
        <% } %>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <div class="inner-container">
      <p>&copy; Movie Box Cinema Corp. All rights reserved.</p>
    </div>
  </footer>
</body>
</html>