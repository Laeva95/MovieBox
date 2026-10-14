<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="notice.NoticeDTO" %>
<%-- <c:if>를 사용하기 위한 JSTL 선언 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<style>

   /* ========================================
   					기본 설정
   ======================================== */
   

    .notice-list-container {
        width: 1200px;
        margin: 0 auto;
    }


    /* ========================================
   				Notice - 페이지 제목
   ======================================== */
   
    .notice-list-section {
        padding: 70px 0;
    }

    .notice-list-page-title {
        margin-bottom: 10px;
	    color: var(--text-white);
	    font-size: 36px;
	    font-weight: 800;
	    letter-spacing: -1px;
    }

    .notice-list-page-description {
        color: #777;
        margin-bottom: 40px;
    }

	/* ========================================
   				Notice - 게시판
   ======================================== */

    .notice-list-table {
        width: 100%;
        border-collapse: collapse;
        border-top: 2px solid #222;
    }

	/* 게시판 기본 */
    .notice-list-table th,
    .notice-list-table td {
        padding: 18px;
        border-bottom: 1px solid #ddd;
        text-align: center;
    }
	
	/* 테이블 헤더 -> 검정색 */
    .notice-list-table th {
        background-color: #f8f8f8;
        color: #222;
    }

	/* 실제 게시글 데이터 → 흰색 */
	.notice-list-table td {
	    color: white;
	}
	

    .notice-list-title {
        text-align: left !important;
    }

	/* 공지사항 글 제목 → 흰색 */
    .notice-list-title a {
        color: white;
        text-decoration: none;
    }

	/* ========================================
   				Pagination
   ======================================== */

	.notice-list-board-bottom-wrapper {
	    margin-top: 25px;
	}

	.notice-list-board-info-top {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-bottom: 15px;
	    color: #aaa;
	    font-size: 14px;
	}

	.notice-list-board-bottom-area {
	  display: flex;
	  justify-content: center; /* 페이징 번호는 항상 정중앙 */
	  align-items: center;
	  position: relative;
	  margin-bottom: 20px;
	}

    .notice-list-pagination {
        display: flex;
        gap: 8px;
        align-items: center;
        justify-content: center;
	}

	.notice-list-pagination a {
        text-decoration: none;
        color: #fff;
        padding: 6px 12px;
        border-radius: 4px;
        background-color: #222;
	}
	
	.notice-list-pagination a.notice-list-active {
        font-weight: bold;
        background-color: #ff5722;
        color: #fff;
	}

    .notice-list-pagination a.notice-list-disabled {
        color: #555;
        background-color: #111;
        pointer-events: none;
    }

	/* ========================================
   					Search
   ======================================== */
	

    /* Search */
    .notice-list-search-box {
        margin-top: 40px;
        text-align: center;
    }

    .notice-list-search-box input {
        width: 300px;
        padding: 10px;
        border: 1px solid #ccc;
    }

    .notice-list-search-box button {
        padding: 10px 20px;
        border: none;
        background: #222;
        color: white;
        cursor: pointer;
    }
    
    /* 글쓰기 버튼 (빨간 배경, 흰 글씨) */
	.notice-list-write-btn {
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

    .notice-list-write-btn:hover {
        background-color: #e03e3e;
	}
</style>


<!-- Notice -->
<main>

    <section class="notice-list-section">

        <div class="notice-list-container">
			<br>
			<br>
			<br>
            <h1 class="notice-list-page-title">공지사항</h1>

            <p class="notice-list-page-description">
                MOVIE BOX의 새로운 소식과 안내사항을 확인하세요.
            </p>


            <!-- Notice Table -->
            <table class="notice-list-table">

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
            <td class="notice-list-title" style="text-align: left;">
                <a href="<%=request.getContextPath()%>/notice/NoticeDetail.do?id=<%=notice.getNoticeId()%>"
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
            <td class="notice-list-title" style="text-align: left;">
                <a href="${pageContext.request.contextPath}/notice/NoticeDetail.do?id=<%=notice.getNoticeId()%>" style="color: white;">
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
            <div class="notice-list-board-bottom-wrapper">

                <!-- 상단 정보 라인 (총 게시글 수 / 로그인 ID) -->
                <div class="notice-list-board-info-top">
                    <div>총 페이지 수: ${totalPages}</div>
                    <div>
                        <c:if test="${not empty sessionScope.id}">
                            현재 로그인 ID: ${sessionScope.id}
                        </c:if>
                    </div>
                </div>

                <!-- 페이징 및 글쓰기 버튼 영역 -->
                <div class="notice-list-board-bottom-area">

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
					<div class="notice-list-pagination">
					
					    <!-- 이전 블록 버튼 -->
					    <% if (prev) { %>
					        <a href="<%=request.getContextPath()%>/notice/Notice.do?page=<%=prevPage%><%=searchParam%>">
					            &lt;
					        </a>
					    <% } else { %>
					        <a class="notice-list-disabled" href="#">
					            &lt;
					        </a>
					    <% } %>
					
					    <!-- 페이지 번호 반복 -->
					    <% for (int i = startPage; i <= endPage; i++) { %>
					        <a href="<%=request.getContextPath()%>/notice/Notice.do?page=<%=i%><%=searchParam%>"
					           class="<%= currentPage == i ? "notice-list-active" : "" %>">
					            <%=i%>
					        </a>
					    <% } %>
					
					    <!-- 다음 블록 버튼 -->
					    <% if (next) { %>
					        <a href="<%=request.getContextPath()%>/notice/Notice.do?page=<%=nextPage%><%=searchParam%>">
					            &gt;
					        </a>
					    <% } else { %>
					        <a class="notice-list-disabled" href="#">
					            &gt;
					        </a>
					    <% } %>
					
					</div>
					                
                    <!-- 관리자에게만 글쓰기 버튼 표시 (우측 절대 위치 배치) -->
                    <c:if test="${sessionScope.id == 'admin'}">
                        <button class="notice-list-write-btn"
						        onclick="location.href='${pageContext.request.contextPath}/notice/NoticeWrite.do'"
						        style="position: absolute; right: 0;">
						    글쓰기
						</button>
                    </c:if>   
                    
                </div>

            </div>

            <!-- Search -->
            <div class="notice-list-search-box">
               <form action="${pageContext.request.contextPath}/notice/Notice.do" method="get">
				    <input type="hidden" name="page" value="1">
				
				    <input type="text"
				           name="keyword"
				           value="${param.keyword != null ? param.keyword : ''}"
				           placeholder="공지사항 검색">
				
				    <button type="submit">검색</button>
				</form>
            </div>

        </div>

    </section>

</main>
