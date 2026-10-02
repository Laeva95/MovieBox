<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="notice.NoticeDTO" %>
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

	.board-bottom-wrapper {
	    margin-top: 25px;
	}

	.board-info-top {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-bottom: 15px;
	    color: #aaa;
	    font-size: 14px;
	}

	.board-bottom-area {
	  display: flex;
	  justify-content: center; /* 페이징 번호는 항상 정중앙 */
	  align-items: center;
	  position: relative;
	  margin-bottom: 20px;
	}

    .pagination {
        display: flex;
        gap: 8px;
        align-items: center;
        justify-content: center;
	}

	.pagination a {
        text-decoration: none;
        color: #fff;
        padding: 6px 12px;
        border-radius: 4px;
        background-color: #222;
	}
	
	.pagination a.active {
        font-weight: bold;
        background-color: #ff5722;
        color: #fff;
	}

    .pagination a.disabled {
        color: #555;
        background-color: #111;
        pointer-events: none;
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
	    position: absolute; /* 부모 컨테이너 기준 맨 오른쪽에 배치 */
	    right: 0; 
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
    <% 
        // 컨트롤러에서 넘어온 noticeList를 받아와서 자바 코드로 반복 출력
        List<NoticeDTO> pinnedList = (List<NoticeDTO>) request.getAttribute("pinnedList");
        List<NoticeDTO> noticeList = (List<NoticeDTO>) request.getAttribute("noticeList");
        
     	// 1. 상단 고정 글 출력 (어느 페이지에서든 항상 노출)
        if (pinnedList != null) {
            for (NoticeDTO notice : pinnedList) {
    %>
        <tr style="background-color: rgba(255, 71, 87, 0.03);">
            <td>
                <span style="color: #ff4757; font-weight: bold; border: 1px solid #ff4757; border-radius: 50%; padding: 1px 6px; font-size: 12px;">!</span>
            </td>
            <td class="notice-title" style="text-align: left;">
                <a href="<%=request.getContextPath()%>/notice/detail?id=<%=notice.getNoticeId()%>" 
                   style="color: #ff4757; font-weight: bold;">
                    <%= notice.getTitle() %>
                </a>
            </td>
            <td style="color: white;"><%= notice.getCreatedAt() %></td>
            <td style="color: white;"><%= notice.getViewCount() %></td>
        </tr>
    <% 
            } 
        } 
     	
     	// 2. 일반 페이징 글 출력
        if (noticeList != null && !noticeList.isEmpty()) {
            for (NoticeDTO notice : noticeList) {
    %>
		<tr>
            <td><%= notice.getNoticeId() %></td>
            <td class="notice-title" style="text-align: left;">
                <a href="<%=request.getContextPath()%>/notice/detail?id=<%=notice.getNoticeId()%>" style="color: white;">
                    <%= notice.getTitle() %>
                </a>
            </td>
            <td style="color: white;"><%= notice.getCreatedAt() %></td>
            <td style="color: white;"><%= notice.getViewCount() %></td>
        </tr>
    <% 
            } 
        } else if ((pinnedList == null || pinnedList.isEmpty()) && (noticeList == null || noticeList.isEmpty())) { 
    %>
        <tr>
            <td colspan="4" style="text-align: center; color: #777;">등록된 공지사항이 없습니다.</td>
        </tr>
    <% } %>
</tbody>

            </table>


            <!-- 하단 정보 및 페이징 영역 -->
            <div class="board-bottom-wrapper">

                <!-- 상단 정보 라인 (총 게시글 수 / 로그인 ID) -->
                <div class="board-info-top">
                    <div>총 페이지 수: ${totalPages}</div>
                    <div>
                        <c:if test="${not empty sessionScope.id}">
                            현재 로그인 ID: ${sessionScope.id}
                        </c:if>
                    </div>
                </div>

                <!-- 페이징 및 글쓰기 버튼 영역 -->
                <div class="board-bottom-area">

                    <% 
                        Integer currentPage = (Integer) request.getAttribute("page");
                        Integer totalPages = (Integer) request.getAttribute("totalPages");
                
                        if (currentPage == null) currentPage = 1;
                        if (totalPages == null) totalPages = 1;
                
                        String keyword = (String) request.getAttribute("keyword");
                        
                        // --- 10개씩 페이징 블록 계산 ---
                        int blockSize = 10;
                        int endPage = (int)(Math.ceil(currentPage / (double)blockSize)) * blockSize;
                        int startPage = (endPage - blockSize) + 1;
                        
                        if (endPage > totalPages) {
                            endPage = totalPages;
                        }

                        // 이전/다음 블록 존재 여부 계산
                        boolean prev = startPage > 1;
                        boolean next = endPage < totalPages;
                        int prevPage = startPage - 1;
                        int nextPage = endPage + 1;

                        String searchParam = (keyword != null && !keyword.isEmpty()) ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "";
                    %>
                
                    <!-- Pagination -->
                    <div class="pagination">
                        <!-- 이전 블록 버튼 -->
                        <a href="<%=request.getContextPath()%>/notice/list?page=<%=prevPage%><%=searchParam%>" 
                           class="<%= !prev ? "disabled" : "" %>">&lt;</a>

                        <!-- 페이지 번호 반복 -->
                        <% for (int i = startPage; i <= endPage; i++) { %>
                            <a href="<%=request.getContextPath()%>/notice/list?page=<%=i%><%=searchParam%>"
                               class="<%= currentPage == i ? "active" : "" %>">
                                <%=i%>
                            </a>
                        <% } %>

                        <!-- 다음 블록 버튼 -->
                        <a href="<%=request.getContextPath()%>/notice/list?page=<%=nextPage%><%=searchParam%>" 
                           class="<%= !next ? "disabled" : "" %>">&gt;</a>
                    </div>
                
                    <!-- 관리자에게만 글쓰기 버튼 표시 (우측 절대 위치 배치) -->
                    <c:if test="${sessionScope.id == 'admin'}">
                        <button class="write-btn" onclick="location.href='${pageContext.request.contextPath}/notice/write'" style="position: absolute; right: 0;">
                            글쓰기
                        </button>
                    </c:if>   
                    
                </div>

            </div>

            <!-- Search -->
            <div class="search-box">
                <form action="${pageContext.request.contextPath}/notice/list" method="get">
                    <!-- 검색 시 첫 페이지(1페이지)부터 보여주도록 설정 -->
                    <input type="hidden" name="page" value="1">
                    
                    <!-- name="keyword"를 추가해야 백엔드로 검색어가 전달됩니다 -->
                    <input type="text" name="keyword" value="${param.keyword != null ? param.keyword : ''}" placeholder="공지사항 검색">
                    
                    <!-- type="button"을 type="submit"으로 변경하거나 유지하되 폼이 제출되도록 합니다 -->
                    <button type="submit">검색</button>
                </form>
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