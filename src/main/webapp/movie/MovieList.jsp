
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="movie.MovieDTO" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 컨트롤러에서 request에 담아준 데이터 꺼내기
    List<MovieDTO> movieList = (List<MovieDTO>) request.getAttribute("movieList");
    String country = (String) request.getAttribute("country");
    String genre = (String) request.getAttribute("genre");
    String sort = (String) request.getAttribute("sort");
%>
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


  <main style="padding-top: 112px;">
    <section class="inner-container section-wrap" style="margin-top: 40px; margin-bottom: 80px;">
      <div class="section-head">
        <h2 class="section-title">현재 상영 중인 영화 (총 <%= movieList != null ? movieList.size() : 0 %>편)</h2>
      </div>
      
      <!-- 필터와 정렬 폼 -->
      <div class="filter-container">
      <!-- method를 get에서 post로 변경 -->
	  <form method="post" action="${pageContext.request.contextPath}/movies/MovieList.do" style="display: flex; gap: 10px;">
            <select name="country">
                <option value="all">전체 국가</option>
                <option value="대한민국" <%= "대한민국".equals(country) ? "selected" : "" %>>한국</option>
                <option value="미국" <%= "미국".equals(country) ? "selected" : "" %>>미국</option>
                <option value="일본" <%= "일본".equals(country) ? "selected" : "" %>>일본</option>
            </select>
            
            <select name="genre">
                <option value="all">전체 장르</option>
                <option value="액션" <%= "액션".equals(genre) ? "selected" : "" %>>액션</option>
                <option value="드라마" <%= "드라마".equals(genre) ? "selected" : "" %>>드라마</option>
                <option value="스릴러" <%= "스릴러".equals(genre) ? "selected" : "" %>>스릴러</option>
                <option value="코미디" <%= "코미디".equals(genre) ? "selected" : "" %>>코미디</option>
                <option value="SF" <%= "SF".equals(genre) ? "selected" : "" %>>SF</option>
                <option value="애니메이션" <%= "애니메이션".equals(genre) ? "selected" : "" %>>애니메이션</option>
            </select>
            
            <select name="sort">
                <option value="date" <%= "date".equals(sort) ? "selected" : "" %>>개봉순</option>
                <option value="title" <%= "title".equals(sort) ? "selected" : "" %>>가나다순</option>
            </select>
            
            <button type="submit">적용</button>
            <%
            	if(session.getAttribute("id") != null && "admin".equals(session.getAttribute("id"))){
            %>
            <button type="button" onclick="location.href='MovieUpdate.do'">갱신</button>
            <%
            	}
            %>
        </form>
      </div>

      <!-- 영화 카드 목록 그리드 -->
      <div class="movie-grid">
        <% if (movieList != null && !movieList.isEmpty()) { %>
            <% for(int i = 0; i < movieList.size(); i++) { 
                MovieDTO movie = movieList.get(i);
            %>
                <div class="movie-card" onclick="location.href='MovieDetail.do?movie_id=<%= movie.getMovieId() %>'">
                  <div class="poster-area">
                    <!-- 포스터 이미지 경로 수정 (${pageContext.request.contextPath}/poster/...) -->
					<img class="poster-img" src="<%= movie.getPoster() %>" 
					                        alt="<%= movie.getTitle() %>" 
					                        style="width: 100%;
					                               height: auto; 
					                               object-fit: contain; 
					                               border-radius: 4px; 
					                               margin-bottom: 10px;"
                        onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
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

