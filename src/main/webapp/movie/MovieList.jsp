<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="movie.MovieDTO" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    List<MovieDTO> movieList = (List<MovieDTO>) request.getAttribute("movieList");
    
    List<Integer> favoriteMovieIds =
            (List<Integer>) request.getAttribute("favoriteMovieIds");

    if (favoriteMovieIds == null) {
        favoriteMovieIds = new java.util.ArrayList<Integer>();
    }
    
    String country = (String) request.getAttribute("country");
    String genre = (String) request.getAttribute("genre");
    String sort = (String) request.getAttribute("sort");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    if (searchKeyword == null) {
        searchKeyword = "";
    }
    
    int currentPage = 1;
    if (request.getAttribute("currentPage") != null) {
        currentPage = (Integer) request.getAttribute("currentPage");
    }
    int pageSize = 8;
%>
  <style>
    /* 필터 전체 영역 */
    .filter-container {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 30px;
        width: 100%;
    }

    .filter-form {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        gap: 10px;
    }

    .filter-select-group {
        display: flex;
        gap: 8px;
        position: relative;
    }

    .filter-btn-group {
        display: flex;
        gap: 8px;
    }

    /* --------------------------------------------- */
    /* 커스텀 드롭다운 스타일 (클릭 시 4개 높이 + 스크롤) */
    /* --------------------------------------------- */
    .custom-dropdown {
        position: relative;
        width: 130px;
        user-select: none;
    }

    .dropdown-selected {
        background-color: #1f2937;
        color: #f3f4f6;
        padding: 8px 14px;
        border: 1px solid #374151;
        border-radius: 6px;
        font-size: 14px;
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: border-color 0.2s;
    }

    .dropdown-selected:hover {
        border-color: #e50914;
    }

    .dropdown-selected::after {
        content: "▼";
        font-size: 10px;
        color: #9ca3af;
        margin-left: 6px;
    }

    .dropdown-list {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background-color: #1f2937;
        border: 1px solid #374151;
        border-radius: 6px;
        margin-top: 4px;
        z-index: 100;
        box-shadow: 0 4px 12px rgba(0,0,0,0.5);
        
        /* 핵심: 딱 4개 항목 정도의 높이(약 140px)로 제한하고 스크롤 생성 */
        max-height: 145px;
        overflow-y: auto;
    }

    .dropdown-list.show {
        display: block;
    }

    .dropdown-item {
        padding: 9px 14px;
        font-size: 14px;
        color: #f3f4f6;
        cursor: pointer;
    }

    .dropdown-item:hover {
        background-color: #374151;
        color: #ffffff;
    }

    .dropdown-item.selected {
        background-color: #111827;
        color: #e50914;
        font-weight: bold;
    }
    /* --------------------------------------------- */

    /* 버튼 디자인 */
    .filter-container button {
        padding: 8px 16px;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 500;
        border: none;
        cursor: pointer;
    }
    .filter-container button[type="submit"] {
        background: #e50914;
        color: #fff;
    }
    .filter-container button[type="submit"]:hover {
        background: #f40612;
    }
    .btn-reset {
        background: #374151;
        color: #d1d5db;
    }
    .btn-reset:hover {
        background: #4b5563;
        color: #fff;
    }
    .btn-refresh {
        background: #111827;
        color: #9ca3af;
        border: 1px solid #374151 !important;
    }

    .movie-card {
        cursor: pointer;
        transition: transform 0.2s;
    }
    .movie-card:hover {
        transform: translateY(-5px);
    }
    
    .favorite-btn {
        position: absolute;
        top: 10px;
        right: 10px;
        z-index: 10;
        width: 38px;
        height: 38px;
        border: none;
        border-radius: 50%;
        background: rgba(0, 0, 0, 0.55);
        color: white;
        font-size: 22px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: 0.2s;
    }

    .favorite-btn:hover {
        transform: scale(1.1);
        background: rgba(0, 0, 0, 0.75);
    }

    .favorite-btn.active {
        color: #e50914;
    }
      
    .search-container {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-bottom: 25px;
    }

    .search-container input {
        width: 350px;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 5px 0 0 5px;
        font-size: 14px;
        outline: none;
    }

    .search-container button {
        padding: 12px 20px;
        border: none;
        border-radius: 0 5px 5px 0;
        background: #e50914;
        color: white;
        font-size: 14px;
        cursor: pointer;
    }

    .search-container button:hover {
        background: #c40812;
    }
      
    .poster-area {
        position: relative;
    }

    .badge-new {
        position: absolute;
        bottom: 10px;
        left: 10px;
        z-index: 10;
        background-color: #ff4757;
        color: yellow;
        padding: 3px 8px;
        font-size: 11px;
        font-weight: bold;
        border-radius: 4px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.3);
    }    
	    
    .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 6px;
        margin: 50px 0;
    }
	
    .pagination .page-btn {
        display: inline-flex;
        justify-content: center;
        align-items: center;
        min-width: 32px;
        height: 32px;
        padding: 0 8px;
        background-color: #1f2937;
        color: #9ca3af;
        border: 1px solid #374151;
        border-radius: 4px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s ease;
    }
	
    .pagination .page-btn:hover {
        background-color: #374151;
        color: #ffffff;
        border-color: #4b5563;
    }
	
    .pagination .page-btn.active {
        background-color: #e50914;
        color: #ffffff;
        border-color: #e50914;
        box-shadow: 0 2px 8px rgba(229, 9, 20, 0.4);
    }
  </style>

  <main style="padding-top: 112px;">
    <section class="inner-container section-wrap" style="margin-top: 40px; margin-bottom: 80px;">
      <div class="section-head">
		<h2 class="section-title">📽️ 현재 상영 중인 영화 🎥</h2>
      </div>

      <div class="search-container">
          <form method="post" action="${pageContext.request.contextPath}/movies/MovieList.do" style="display: flex;">
              <input type="text" name="searchKeyword" value="<%= searchKeyword %>" placeholder="영화 제목을 검색하세요">
              <input type="hidden" name="country" value="<%= country != null ? country : "" %>">
              <input type="hidden" name="genre" value="<%= genre != null ? genre : "" %>">
              <input type="hidden" name="sort" value="<%= sort != null ? sort : "" %>">
              <button type="submit">검색</button>
          </form>
      </div>

      <div class="filter-container">
          <form class="filter-form" method="post" action="${pageContext.request.contextPath}/movies/MovieList.do" id="filterForm">
              
              <!-- 실제 서버로 전송될 히든 인풋 -->
              <input type="hidden" name="country" id="inputCountry" value="<%= country != null ? country : "all" %>">
              <input type="hidden" name="genre" id="inputGenre" value="<%= genre != null ? genre : "all" %>">
              <input type="hidden" name="sort" id="inputSort" value="<%= sort != null ? sort : "date" %>">
              <input type="hidden" name="searchKeyword" value="<%= searchKeyword %>">

              <div class="filter-select-group">
                  
                  <!-- 1. 국가 커스텀 드롭다운 -->
                  <div class="custom-dropdown" id="countryDropdown">
                      <%
                          String countryText = "전체 국가";
                          if("대한민국".equals(country)) countryText = "한국";
                          else if("미국".equals(country)) countryText = "미국";
                          else if("일본".equals(country)) countryText = "일본";
                          else if("중국".equals(country)) countryText = "중국";
                          else if("프랑스".equals(country)) countryText = "프랑스";
                          else if("기타".equals(country)) countryText = "기타";
                      %>
                      <div class="dropdown-selected"><%= countryText %></div>
                      <div class="dropdown-list">
                          <div class="dropdown-item <%= "all".equals(country) || country == null ? "selected" : "" %>" data-value="all">전체 국가</div>
                          <div class="dropdown-item <%= "대한민국".equals(country) ? "selected" : "" %>" data-value="대한민국">한국</div>
                          <div class="dropdown-item <%= "미국".equals(country) ? "selected" : "" %>" data-value="미국">미국</div>
                          <div class="dropdown-item <%= "일본".equals(country) ? "selected" : "" %>" data-value="일본">일본</div>
                          <div class="dropdown-item <%= "중국".equals(country) ? "selected" : "" %>" data-value="중국">중국</div>
                          <div class="dropdown-item <%= "프랑스".equals(country) ? "selected" : "" %>" data-value="프랑스">프랑스</div>
                          <div class="dropdown-item <%= "기타".equals(country) ? "selected" : "" %>" data-value="기타">기타</div>
                      </div>
                  </div>

                  <!-- 2. 장르 커스텀 드롭다운 -->
                  <div class="custom-dropdown" id="genreDropdown">
                      <%
                          String genreText = "전체 장르";
                          if(genre != null && !genre.equals("all") && !genre.isEmpty()) {
                              genreText = genre;
                          }
                      %>
                      <div class="dropdown-selected"><%= genreText %></div>
                      <div class="dropdown-list">
                          <div class="dropdown-item <%= "all".equals(genre) || genre == null ? "selected" : "" %>" data-value="all">전체 장르</div>
                          <div class="dropdown-item <%= "액션".equals(genre) ? "selected" : "" %>" data-value="액션">액션</div>
                          <div class="dropdown-item <%= "드라마".equals(genre) ? "selected" : "" %>" data-value="드라마">드라마</div>
                          <div class="dropdown-item <%= "스릴러".equals(genre) ? "selected" : "" %>" data-value="스릴러">스릴러</div>
                          <div class="dropdown-item <%= "코미디".equals(genre) ? "selected" : "" %>" data-value="코미디">코미디</div>
                          <div class="dropdown-item <%= "SF".equals(genre) ? "selected" : "" %>" data-value="SF">SF</div>
                          <div class="dropdown-item <%= "공포".equals(genre) ? "selected" : "" %>" data-value="공포">공포</div>
                          <div class="dropdown-item <%= "로맨스".equals(genre) ? "selected" : "" %>" data-value="로맨스">로맨스</div>
                          <div class="dropdown-item <%= "멜로".equals(genre) ? "selected" : "" %>" data-value="멜로">멜로</div>
                          <div class="dropdown-item <%= "범죄".equals(genre) ? "selected" : "" %>" data-value="범죄">범죄</div>
                          <div class="dropdown-item <%= "어드벤처".equals(genre) ? "selected" : "" %>" data-value="어드벤처">어드벤처</div>
                      </div>
                  </div>

                  <!-- 3. 정렬 커스텀 드롭다운 -->
                  <div class="custom-dropdown" id="sortDropdown">
                      <%
                          String sortText = "개봉순";
                          if("title".equals(sort)) sortText = "가나다순";
                      %>
                      <div class="dropdown-selected"><%= sortText %></div>
                      <div class="dropdown-list">
                          <div class="dropdown-item <%= "date".equals(sort) || sort == null ? "selected" : "" %>" data-value="date">개봉순</div>
                          <div class="dropdown-item <%= "title".equals(sort) ? "selected" : "" %>" data-value="title">가나다순</div>
                      </div>
                  </div>

              </div>

              <div class="filter-btn-group">
                  <button type="submit">적용</button> 
                  
                  <button type="button" class="btn-reset"
                   onclick="location.href='${pageContext.request.contextPath}/movies/MovieList.do'">초기화</button>
                  
                  <%
                      if(session.getAttribute("id") != null && "admin".equals(session.getAttribute("id"))){
                  %>
                  <button type="button" class="btn-refresh" onclick="location.href='MovieUpdate.do'">갱신</button>
                  <%
                      }
                  %>
              </div>
          </form>
      </div>

      <div class="movie-grid">
          <% if (movieList != null && !movieList.isEmpty()) { %>
              <% for(int i = 0; i < movieList.size(); i++) {  
                  MovieDTO movie = movieList.get(i); 
              %>
                  <div class="movie-card" onclick="location.href='MovieDetail.do?movie_id=<%= movie.getMovieId() %>'">
                    <div class="poster-area">	
                      <% if(movie.isNew()) { %>
                          <span class="badge-new">NEW</span>
                      <% } %> 

                      <%
                          boolean isFavorite = favoriteMovieIds.contains(movie.getMovieId());
                      %>
                      <button type="button"
                              class="favorite-btn <%= isFavorite ? "active" : "" %>"
                              id="fav-btn-<%= movie.getMovieId() %>"
                              onclick="event.stopPropagation(); toggleFavorite(<%= movie.getMovieId() %>);">
                          <%= isFavorite ? "♥" : "♡" %>
                      </button>

                      <img class="poster-img" src="<%= movie.getPoster() %>"  	
                                              alt="<%= movie.getTitle() %>"   
                                              style="width: 100%; height: auto; object-fit: contain; border-radius: 4px; margin-bottom: 10px;"
                          onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
                      
                      	<div class="rank-overlay">
    						<span class="rank-number"><%= ((currentPage - 1) * pageSize) + (i + 1) %></span>
						</div>
                    </div>
                    
                    <div class="card-info">
<% 
                            String grade = movie.getWatchGrade();
                            if (grade == null || grade.isEmpty()) {
                                grade = "전체관람가";
                            }
                            
                            // 등급별 배지 색상 동적 설정
                            String bg = "#6b7280"; // 기본 회색
                            if (grade.contains("12")) {
                                bg = "#d97706"; // 12세: 주황색
                            } else if (grade.contains("15")) {
                                bg = "#b45309"; // 15세: 진한 주황
                            } else if (grade.contains("청소년") || grade.contains("19") || grade.contains("제한")) {
                                bg = "#dc2626"; // 청불: 빨간색
                            } else if (grade.contains("전체")) {
                                bg = "#059669"; // 전체: 초록색
                            }
                        %>
                        <div class="movie-title-grade-row">
                            <h3 class="movie-card-title" style="margin: 0;"><%= movie.getTitle() %></h3>
                            <span class="movie-grade-badge" style="background-color: <%= bg %>;">
                                <%= grade %>
                            </span>
                        </div>
                        
                        <div class="card-meta-line">
                          <span><%= movie.getGenre() %> | <%= movie.getCountry() %> | <%= movie.getReleaseDate() %> 개봉</span>
                        </div>
                    </div>
                   </div>
              <% } %>
          <% } else { %>
              <div style="grid-column: 1 / -1; text-align: center; padding: 60px 0; color: #666;">
                  <% if (!searchKeyword.isEmpty()) { %>
                      <p style="font-size: 18px;">'<%= searchKeyword %>' 검색 결과가 없습니다.</p>
                      <p>다른 영화 제목으로 검색해 주세요.</p>
                  <% } else { %>
                      등록된 영화가 없습니다.
                  <% } %>
              </div>
          <% } %>
      </div>
 
		<div class="pagination">
		    <c:forEach var="p" begin="1" end="${totalPage}">
		        <a href="${pageContext.request.contextPath}/movies/MovieList.do?pageNum=${p}&country=${param.country}&genre=${param.genre}&sort=${param.sort}&searchKeyword=${param.searchKeyword}"
		           class="page-btn ${p == currentPage ? 'active' : ''}">
		            ${p}
		        </a>
		    </c:forEach>
		</div>
    </section>
    
    <script>
    // 커스텀 드롭다운 동작 제어 스크립트
    document.addEventListener("click", function(e) {
        const dropdowns = document.querySelectorAll(".custom-dropdown");
        dropdowns.forEach(drop => {
            const list = drop.querySelector(".dropdown-list");
            const selected = drop.querySelector(".dropdown-selected");
            if (selected.contains(e.target)) {
                // 다른 열린 드롭다운 닫기
                dropdowns.forEach(d => {
                    if (d !== drop) d.querySelector(".dropdown-list").classList.remove("show");
                });
                list.classList.toggle("show");
            } else if (!drop.contains(e.target)) {
                list.classList.remove("show");
            }
        });
    });

    // 각 항목 선택 시 값 반영
    document.querySelectorAll(".custom-dropdown").forEach(drop => {
        const selectedDiv = drop.querySelector(".dropdown-selected");
        const listDiv = drop.querySelector(".dropdown-list");
        const items = drop.querySelectorAll(".dropdown-item");

        items.forEach(item => {
            item.addEventListener("click", function() {
                selectedDiv.innerText = this.innerText;
                items.forEach(i => i.classList.remove("selected"));
                this.classList.add("selected");
                listDiv.classList.remove("show");

                const val = this.getAttribute("data-value");
                if (drop.id === "countryDropdown") {
                    document.getElementById("inputCountry").value = val;
                } else if (drop.id === "genreDropdown") {
                    document.getElementById("inputGenre").value = val;
                } else if (drop.id === "sortDropdown") {
                    document.getElementById("inputSort").value = val;
                }
            });
        });
    });

    function toggleFavorite(movieId) {
        const contextPath = "${pageContext.request.contextPath}";
        
        fetch(contextPath + "/movies/Favorite.do?movieId=" + movieId, {
            method: "POST",
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === "unauthorized") {
                alert("로그인 후 이용할 수 있습니다.");
                location.href = contextPath + "/member/Login.do";
                return;
            }

            const btn = document.getElementById("fav-btn-" + movieId);
            if (!btn) return;

            if (data.success) {
                if (data.status === "added") {
                    btn.classList.add("active");
                    btn.innerText = "♥";
                } else if (data.status === "removed") {
                    btn.classList.remove("active");
                    btn.innerText = "♡";
                }
            } else {
                alert("처리에 실패했습니다.");
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert("오류가 발생했습니다.");
        });
    }
    </script>
  </main>