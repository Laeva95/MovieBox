<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="notice.NoticeDAO"%>
<%@ page import="notice.NoticeDTO"%>

<%
    // URL에서 id 가져오기
    String idParam = request.getParameter("id");

    if (idParam == null) {
        response.sendRedirect("list");
        return;
    }

    int id = Integer.parseInt(idParam);

    // DAO에서 해당 공지사항 가져오기
    NoticeDAO dao = new NoticeDAO();
    NoticeDTO notice = dao.getNoticeById(id);

    // 공지사항이 없으면 목록으로 이동
    if (notice == null) {
        response.sendRedirect("list");
        return;
    }

 	// 이전글 / 다음글 정보 가져오기 (DAO 메서드 호출)
    NoticeDTO prevNotice = dao.getPrevNotice(id);
    NoticeDTO nextNotice = dao.getNextNotice(id);
%>

<style>

    .notice-detail-container {
        width: 1000px;
        margin: 80px auto;
    }

    .notice-detail-page-title {
        font-size: 32px;
        font-weight: bold;
        margin-bottom: 40px;
    }

    .notice-detail-box {
        border-top: 2px solid #333;
    }

    .notice-detail-header {
        padding: 20px;
        border-bottom: 1px solid #ddd;
    }

    .notice-detail-title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 15px;
    }

    .notice-detail-info {
        font-size: 14px;
        color: #888;
    }

    .notice-detail-content {
        min-height: 300px;
        padding: 30px 20px;
        border-bottom: 1px solid #ddd;
        line-height: 1.8;
        white-space: pre-wrap;
    }

    .notice-detail-nav {
        border-bottom: 1px solid #ddd;
    }

    .notice-detail-nav-row {
        display: flex;
        align-items: center;
        padding: 15px 20px;
        border-bottom: 1px solid #eee;
    }

    .notice-detail-nav-label {
        width: 100px;
        font-weight: bold;
    }

    .notice-detail-nav-row a {
        color: #333;
        text-decoration: none;
    }

    .notice-detail-nav-row a:hover {
        text-decoration: underline;
    }

    .notice-detail-button-area {
        margin-top: 30px;
        text-align: center;
    }

    .notice-detail-btn {
        display: inline-block;
        padding: 12px 25px;
        background-color: #333;
        color: white;
        text-decoration: none;
        border-radius: 4px;
        margin: 0 5px;
    }

    .notice-detail-btn:hover {
        background-color: #555;
    }
    
    .notice-detail-attachment {
    padding: 18px 20px;
    border-bottom: 1px solid #ddd;
    background-color: #fafafa;
	}
	
	.notice-detail-attachment-label {
	    font-weight: bold;
	    margin-right: 20px;
	}
	
	.notice-detail-attachment-name {
	    margin-right: 15px;
	}
	
	.notice-detail-file-btn {
	    display: inline-block;
	    padding: 6px 12px;
	    margin-left: 5px;
	    border: 1px solid #ccc;
	    border-radius: 4px;
	    color: #333;
	    text-decoration: none;
	    background-color: white;
	    font-size: 13px;
	}
	
	.notice-detail-file-btn:hover {
	    background-color: #f0f0f0;
	}
    
</style>


<div class="notice-detail-container">
	<br>
	<br>
	<br>
    <div class="notice-detail-page-title">
        공지사항
    </div>


    <!-- 공지사항 내용 -->
    <div class="notice-detail-box">

        <div class="notice-detail-header">

            <div class="notice-detail-title">
                <%= notice.getTitle() %>
            </div>

            <div class="notice-detail-info">
                작성자 : <%= notice.getWriter() %>
                &nbsp;&nbsp;|&nbsp;&nbsp;
                작성일 : <%= notice.getCreatedAt() %>
                &nbsp;&nbsp;|&nbsp;&nbsp;
                조회수 : <%= notice.getViewCount() %>
            </div>

        </div>


        <div class="notice-detail-content">
            <%= notice.getContent() %>
        </div>
        
        <% if (notice.getFileName() != null && !notice.getFileName().isEmpty()) { %>

    <div class="notice-detail-attachment">
        <span class="notice-detail-attachment-label">첨부파일</span>

        <span class="notice-detail-attachment-name">
            <%= notice.getFileName() %>
        </span>

        <a href="<%=request.getContextPath()%>/notice/file?fileName=<%=java.net.URLEncoder.encode(notice.getFileName(), "UTF-8")%>&mode=view"
           target="_blank"
           class="notice-detail-file-btn">
            보기
        </a>

        <a href="<%=request.getContextPath()%>/notice/file?fileName=<%=java.net.URLEncoder.encode(notice.getFileName(), "UTF-8")%>&mode=download"
           class="notice-detail-file-btn">
            다운로드
        </a>
    </div>

<% } %>

    </div>


    <!-- 이전글 / 다음글 -->
<div class="notice-detail-nav">

    <!-- 다음글 -->
    <div class="notice-detail-nav-row">
        <span class="notice-detail-nav-label">
            다음글 &and;
        </span>

        <%-- 다음글이 있는 경우 --%>
        <% if (nextNotice != null) { %>
            <!-- ★ 여기를 NoticeDetail.jsp 대신 detail 로 변경 -->
            <a href="detail?id=<%= nextNotice.getNoticeId() %>">
                <%= nextNotice.getTitle() %>
            </a>
        <% } else { %>
            <span style="color: #999;">
                다음글이 없습니다.
            </span>
        <% } %>
    </div>


    <!-- 이전글 -->
    <div class="notice-detail-nav-row">
        <span class="notice-detail-nav-label">
            이전글 &or;
        </span>

        <%-- 이전글이 있는 경우 --%>
        <% if (prevNotice != null) { %>
            <!-- ★ 여기를 NoticeDetail.jsp 대신 detail 로 변경 -->
            <a href="detail?id=<%= prevNotice.getNoticeId() %>">
                <%= prevNotice.getTitle() %>
            </a>
        <% } else { %>
            <span style="color: #999;">
                이전글이 없습니다.
            </span>
        <% } %>
    </div>

</div>

<%-- 세션에 저장된 id가 admin인 경우에만 수정/삭제 버튼 노출 --%>
<c:if test="${not empty sessionScope.id and sessionScope.id == 'admin'}">
    <div class="notice-detail-btn-area" style="margin-top: 20px; text-align: right;">
        <a href="edit?id=<%= notice.getNoticeId() %>" class="notice-detail-btn notice-detail-btn-primary" style="padding: 6px 12px; background-color: #333; color: #fff; text-decoration: none; border-radius: 4px; margin-right: 5px;">수정</a>
        
        <a href="${pageContext.request.contextPath}/notice/deleteOk?id=${notice.noticeId}" 
           onclick="return confirm('정말 이 공지사항을 삭제하시겠습니까?');"
           style="padding: 6px 12px; background-color: #ff4757; color: #fff; text-decoration: none; border-radius: 4px; margin-right: 5px;">삭제</a>
    </div>
</c:if>

<!-- 목록 버튼은 항상 노출 -->
<div class="notice-detail-button-area" style="margin-top: 20px; text-align: center;">
    <a href="list" class="notice-detail-btn" style="padding: 8px 20px; background-color: #666; color: #fff; text-decoration: none; border-radius: 4px;">목록</a>
</div>

</div>
