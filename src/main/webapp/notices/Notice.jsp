<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <c:if>를 사용하기 위한 JSTL 선언 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title>공지사항 | Magic Box</title>

<style>

   /* ========================================
   					기본 설정
   ======================================== */
   
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        font-family: Arial, sans-serif;
        color: #222;
    }

    .container {
        width: 1200px;
        margin: 0 auto;
    }

    /* ========================================
   					Header
   ======================================== */
    
    .header {
        border-bottom: 1px solid #ddd;
    }

    .header-inner {
        height: 80px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .logo {
        font-size: 28px;
        font-weight: bold;
    }

    .nav {
        display: flex;
        gap: 35px;
    }

    .nav a {
        text-decoration: none;
        color: #222;
    }

    /* ========================================
   				Notice - 페이지 제목
   ======================================== */
   
    .notice-section {
        padding: 70px 0;
    }

    .page-title {
        margin-bottom: 10px;
	    color: var(--text-white);
	    font-size: 36px;
	    font-weight: 800;
	    letter-spacing: -1px;
    }

    .page-description {
        color: #777;
        margin-bottom: 40px;
    }

	/* ========================================
   				Notice - 게시판
   ======================================== */

    .notice-table {
        width: 100%;
        border-collapse: collapse;
        border-top: 2px solid #222;
    }

	/* 게시판 기본 */
    .notice-table th,
    .notice-table td {
        padding: 18px;
        border-bottom: 1px solid #ddd;
        text-align: center;
    }
	
	/* 테이블 헤더 -> 검정색 */
    .notice-table th {
        background-color: #f8f8f8;
        color: #222;
    }

	/* 실제 게시글 데이터 → 흰색 */
	.notice-table td {
	    color: white;
	}
	

    .notice-title {
        text-align: left !important;
    }

	/* 공지사항 글 제목 → 흰색 */
    .notice-title a {
        color: white;
        text-decoration: none;
    }

	/* ========================================
   				Pagination
   ======================================== */

	.board-bottom-area {
	  display: flex;
	  justify-content: center; /* 기본적으로 가운데 정렬인 경우 */
	  align-items: center;
	  position: relative;
	  margin-bottom: 20px;
	}

    .pagination {
        margin-top: 35px;
        text-align: center;
    }

	/* 페이지 번호 */
    .pagination a {
        margin: 0 8px auto;
        text-decoration: none;
        color: white;
    }

	/* ========================================
   					Search
   ======================================== */
	

    /* Search */
    .search-box {
        margin-top: 40px;
        text-align: center;
    }

    .search-box input {
        width: 300px;
        padding: 10px;
        border: 1px solid #ccc;
    }

    .search-box button {
        padding: 10px 20px;
        border: none;
        background: #222;
        color: white;
        cursor: pointer;
    }
    
    /* 글쓰기 버튼 (빨간 배경, 흰 글씨) */
    .write-btn {
		position: absolute;
		right: 0; /* 부모 컨테이너 기준 맨 오른쪽에 배치 */
        background-color: #ff4d4d; /* 빨간색 배경 */
        color: #ffffff;            /* 글자색 흰색 */
        border: none;
        padding: 10px 20px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
	}

    .write-btn:hover {
        background-color: #e03e3e;
	}
</style>

</head>

<body>

<!-- Top.jsp 영역 -->
  <div>
    <jsp:include page="/inc/Top.jsp"/>
  </div>


<!-- Notice -->
<main>

    <section class="notice-section">

        <div class="container">

            <h1 class="page-title">공지사항</h1>

            <p class="page-description">
                MOVIE BOX의 새로운 소식과 안내사항을 확인하세요.
            </p>


            <!-- Notice Table -->
            <table class="notice-table">

                <thead>
                    <tr>
                        <th width="10%">번호</th>
                        <th>제목</th>
                        <th width="15%">작성일</th>
                        <th width="10%">조회수</th>
                    </tr>
                </thead>

                <tbody>
                    <!-- DB에서 가져온 공지사항 리스트 반복 출력 -->
                    <c:forEach var="notice" items="${noticeList}">
                        <tr>
                            <td>${notice.noticeId}</td>
                            <td class="notice-title">
                                <a href="${pageContext.request.contextPath}/notice/detail?id=${notice.noticeId}">${notice.title}</a>
                            </td>
                            <td>${notice.createdAt}</td>
                            <td>${notice.viewCount}</td>
                        </tr>
                    </c:forEach>
                    
                    <!-- 만약 등록된 글이 하나도 없을 때 -->
                    <c:if test="${empty noticeList}">
                        <tr>
                            <td colspan="4" style="text-align: center; color: #777;">등록된 공지사항이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>

            </table>


            <!-- 페이지 번호와 글쓰기 버튼을 같은 줄에 배치하기 위한 구조 -->
			<div class="board-bottom-area">

	            <!-- Pagination -->
	            <div class="pagination">

				    <% 
				        Integer currentPage = (Integer) request.getAttribute("page");
				        Integer totalPages = (Integer) request.getAttribute("totalPages");
				
				        if (currentPage == null) currentPage = 1;
				        if (totalPages == null) totalPages = 1;
				
				        String keyword = (String) request.getAttribute("keyword");
				    %>
				
				    <% for (int i = 1; i <= totalPages; i++) { %>
				
				        <a href="<%=request.getContextPath()%>/notice/list?page=<%=i%><%= keyword != null && !keyword.isEmpty() ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>"
				           class="<%= currentPage == i ? "active" : "" %>">
				            <%=i%>
				        </a>
				
				    <% } %>

				</div>
				
				총 게시글 수: <%= request.getAttribute("totalPages") %>
            
            	 <!-- 관리자에게만 글쓰기 버튼 표시 -->
			     <c:if test="${sessionScope.id == 'admin'}">
				 	<button class="write-btn" onclick="location.href='${pageContext.request.contextPath}/notice/write'">
					    글쓰기
					</button>
				 </c:if>   
			    
			    현재 로그인 ID: ${sessionScope.id}
			    
			</div>

            <!-- Search -->
            <div class="search-box">
                <input type="text" placeholder="공지사항 검색">
                <button type="button">검색</button>
            </div>

        </div>

    </section>

</main>

<!-- Bottom.jsp 영역 -->
  <div>
  	<jsp:include page="/inc/Bottom.jsp"/>
  </div>
  
</body>
</html>