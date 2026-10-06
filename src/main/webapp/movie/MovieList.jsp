
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="movie.MovieDTO" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <!-- JSTL core 라이브러리 사용 선언 -->
<%
    // 컨트롤러에서 request에 담아준 데이터 꺼내오기 (MovieList.do_영화 목록/ 필터링된 국가, 장르, 정렬 기준)
    List<MovieDTO> movieList = (List<MovieDTO>) request.getAttribute("movieList"); // 영화 목록 가져오기
    String country = (String) request.getAttribute("country"); // 필터링된 국가 값 가져오기
    String genre = (String) request.getAttribute("genre");	// 필터링된 장르 값 가져오기
    String sort = (String) request.getAttribute("sort");	// 정렬 기준 값 가져오기
    String searchKeyword = (String) request.getAttribute("searchKeyword"); // 검색 키워드 값 가져오기
    if (searchKeyword == null) {
        searchKeyword = "";
    }
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
      
      /* 영화 검색 영역 */
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
      
      
      
  </style>


  <main style="padding-top: 112px;">
    <section class="inner-container section-wrap" style="margin-top: 40px; margin-bottom: 80px;">
      <div class="section-head">
        <h2 class="section-title">현재 상영 중인 영화 (총 <%= movieList != null ? movieList.size() : 0 %>편)</h2>
      </div>
      <!-- 영화 검색 -->
<div class="search-container">

    <form method="post"
          action="${pageContext.request.contextPath}/movies/MovieList.do"
          style="display: flex;">

        <input type="text"
               name="searchKeyword"
               value="<%= searchKeyword %>"
               placeholder="영화 제목을 검색하세요">

        <input type="hidden"
               name="country"
               value="<%= country %>">

        <input type="hidden"
               name="genre"
               value="<%= genre %>">

        <input type="hidden"
               name="sort"
               value="<%= sort %>">

        <button type="submit">
            검색
        </button>

    </form>

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

            </select>
            
            <select name="sort">
                <option value="date" <%= "date".equals(sort) ? "selected" : "" %>>개봉순</option> 
                <option value="title" <%= "title".equals(sort) ? "selected" : "" %>>가나다순</option>
            </select>
            
            <button type="submit">적용</button> 
            <%
            	// 세션에서 로그인한 사용자 ID 확인
            	if(session.getAttribute("id") != null && "admin".equals(session.getAttribute("id"))){
            %>
            <!-- 관리자 계정이면 갱신 버튼 표시 -->
            <button type="button" onclick="location.href='MovieUpdate.do'">갱신</button>
            <%
            	}
            %>
        </form>
      </div>

<!-- 영화 카드 목록 그리드 영역 시작 -->
<div class="movie-grid">
    <!-- [1단계] 컨트롤러(Servlet)가 DB에서 조회해서 전달해준 영화 목록(movieList)이 존재하는지 검증 -->
    <% if (movieList != null && !movieList.isEmpty()) { %>
        
        <!-- [2단계] 반복문(for)을 돌며 리스트에 담긴 영화 DTO 객체들을 하나씩 순차적으로 꺼냄 -->
        <% for(int i = 0; i < movieList.size(); i++) {  
            // movieList에서 i번째 영화 정보 가방(MovieDTO)을 가져옴 (이 가방 안에 DB에서 조회한 값들이 들어있음)
            MovieDTO movie = movieList.get(i); 
        %>
<!--     
    
/@1. [kMDb API] ──(포스터 URL 수집)──> /@2.[내 Java DB 처리부]@1/ ──(INSERT)──> [MySQL 등 내 DB]@2/
           																│
                                                                        ▼ (사용자가 페이지 요청)
[JSP 화면 (여기)] <──(List에 담아 전달)── [MovieDAO.getMovieList()] <── (SELECT * FROM movie) 


@1. MovieDAO_getMovieListFromAPI()               
.parseString(jsonResult).getAsJsonObject();

@2. movie.MovieDAO.insertMovie(MovieDTO movie)
 java.sql.PreparedStatement.executeUpdate()
                  
                                             
3구간: [MySQL 등 내 DB] ──(SELECT)──> MovieDAO.getMovieList()
• movie.MovieDAO.getMovieList()
	• 역할: 사용자가 웹 페이지에 접속했을 때 호출되며, DB 테이블에 저장된 영화 30개를 SELECT * FROM movie... 쿼리로 조회해오는 메소드입니다.
• java.sql.PreparedStatement.executeQuery()
	• 역할: DB 서버에 SELECT 쿼리를 날려 결과 데이터(ResultSet)를 받아오는 메소드입니다.
• java.sql.ResultSet.next() 및 rs.getString("poster")
	• 역할: DB 결과 창고에서 한 줄씩 넘겨보며(next()), poster 컬럼에 들어있는 kMDb 이미지 주소 문자열을 추출해 내는 메소드입니다.
• java.util.List.add(movie)
	• 역할: DB에서 꺼낸 포스터 주소가 담긴 영화 가방(MovieDTO)들을 JSP에 한 번에 보내기 위해 리스트 바구니(movieList)에 차곡차곡 담아주는 메소드입니다.


4구간: MovieDAO.getMovieList() ──(List 전달)──> [JSP 화면]
• javax.servlet.http.HttpServletRequest.setAttribute("movieList", list)
	• 역할: 컨트롤러(서블릿) 단계에서 DB로부터 확보한 영화 리스트 바구니를 JSP 화면이 꺼내 쓸 수 있도록 보관함(request)에 묶어두는 메소드입니다.
• java.util.List.get(i) (JSP 내 movieList.get(i))
	• 역할: JSP 화면에서 반복문을 돌며 보관함에서 꺼낸 리스트 바구니 속 i번째 영화 가방을 하나씩 끄집어내는 메소드입니다.
• movie.MovieDTO.getPoster() (JSP 내 < %= movie.getPoster() %>)
	• 역할: 전체 흐름의 최종 목적지입니다. 영화 가방의 지퍼를 열어 내부에 담겨있던 kMDb 포스터 URL 주소(http://kmdb.or.kr...)를 HTML src="" 자리에 문자로 뱉어내어 브라우저가 화면에 이미지를 그리도록 만드는 메소드입니다


-->
        
            <!-- 영화 카드를 클릭하면 해당 영화의 고유 ID(movie_id)를 파라미터로 가지고 상세페이지(MovieDetail.do)로 이동 -->
            <div class="movie-card" onclick="location.href='MovieDetail.do?movie_id=<%= movie.getMovieId() %>'">
              
              <!-- 포스터 이미지 영역 -->
              <div class="poster-area">	
<%-- 
   [3단계] DB에서 따온 진짜 포스터 주소값 출력 핵심부!
   - movie.getPoster() 메소드가 DB에서 꺼내온 'http://kmdb.or.kr' 문자열을 반환합니다.
   -  <%= ... %> 표현식 태그를 통해 그 문자열 주소가 HTML의 src="" 자리에 그대로 쏙 박히게 됩니다.
   - 브라우저는 이 주소를 읽어서 kMDb 서버에 있는 이미지를 화면에 띄웁니다.
--%>
                <img class="poster-img" src="<%= movie.getPoster() %>"  	
                                        alt="<%= movie.getTitle() %>"   
                                        style="width: 100%;
                                               height: auto; 
                                               object-fit: contain; 
                                               border-radius: 4px; 
                                               margin-bottom: 10px;"
                    /* [예외 처리] 만약 DB에 포스터 주소가 없거나, kMDb 서버 문제로 이미지를 불러오지 못하면 내 프로젝트의 기본 노이미지 파일로 대체 */
                    onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
                
                <!-- 영화 순위 오버레이 (0부터 시작하므로 인덱스 i에 1을 더해 1등, 2등... 표현) -->
                <div class="rank-overlay"><span class="rank-number"><%= i + 1 %></span></div>
              </div>
              
              <!-- 영화 정보 텍스트 영역 -->
              <div class="card-info">
                <!-- DB에서 꺼내온 영화 제목 출력 -->
                <h3 class="movie-card-title"><%= movie.getTitle() %></h3>
                <div class="card-meta-line">
                  <!-- DB에서 꺼내온 장르, 제작국가, 개봉일 데이터를 한 줄로 정렬하여 출력 -->
                  <span><%= movie.getGenre() %> | <%= movie.getCountry() %> | <%= movie.getReleaseDate() %> 개봉</span>
                </div>
              </div>
              
            </div>
        <% } // 반복문(for) 끝 %>
        
 <% } else { %>

    <div style="grid-column: 1 / -1;
                text-align: center;
                padding: 60px 0;
                color: #666;">

        <% if (!searchKeyword.isEmpty()) { %>

            <p style="font-size: 18px;">
                '<%= searchKeyword %>' 검색 결과가 없습니다.
            </p>

            <p>
                다른 영화 제목으로 검색해 주세요.
            </p>

        <% } else { %>

            등록된 영화가 없습니다.

        <% } %>

    </div>

<% } %>
<!-- 영화 카드 목록 그리드 영역 끝 -->
 
    </section>
  </main>

