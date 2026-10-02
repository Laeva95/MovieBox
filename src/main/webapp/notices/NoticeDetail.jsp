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

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>공지사항</title>

<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background-color: #fff;
        color: #333;
    }

    .container {
        width: 1000px;
        margin: 80px auto;
    }

    .title {
        font-size: 32px;
        font-weight: bold;
        margin-bottom: 40px;
    }

    .notice-box {
        border-top: 2px solid #333;
    }

    .notice-header {
        padding: 20px;
        border-bottom: 1px solid #ddd;
    }

    .notice-title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 15px;
    }

    .notice-info {
        font-size: 14px;
        color: #888;
    }

    .notice-content {
        min-height: 300px;
        padding: 30px 20px;
        border-bottom: 1px solid #ddd;
        line-height: 1.8;
        white-space: pre-wrap;
    }

    .nav {
        border-bottom: 1px solid #ddd;
    }

    .nav-row {
        display: flex;
        align-items: center;
        padding: 15px 20px;
        border-bottom: 1px solid #eee;
    }

    .nav-label {
        width: 100px;
        font-weight: bold;
    }

    .nav-row a {
        color: #333;
        text-decoration: none;
    }

    .nav-row a:hover {
        text-decoration: underline;
    }

    .button-area {
        margin-top: 30px;
        text-align: center;
    }

    .btn {
        display: inline-block;
        padding: 12px 25px;
        background-color: #333;
        color: white;
        text-decoration: none;
        border-radius: 4px;
        margin: 0 5px;
    }

    .btn:hover {
        background-color: #555;
    }
    
    .attachment {
    padding: 18px 20px;
    border-bottom: 1px solid #ddd;
    background-color: #fafafa;
	}
	
	.attachment-label {
	    font-weight: bold;
	    margin-right: 20px;
	}
	
	.attachment-name {
	    margin-right: 15px;
	}
	
	.file-btn {
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
	
	.file-btn:hover {
	    background-color: #f0f0f0;
	}
    
</style>

</head>

<body>

<div class="container">

    <div class="title">
        공지사항
    </div>


    <!-- 공지사항 내용 -->
    <div class="notice-box">

        <div class="notice-header">

            <div class="notice-title">
                <%= notice.getTitle() %>
            </div>

            <div class="notice-info">
                작성자 : <%= notice.getWriter() %>
                &nbsp;&nbsp;|&nbsp;&nbsp;
                작성일 : <%= notice.getCreatedAt() %>
                &nbsp;&nbsp;|&nbsp;&nbsp;
                조회수 : <%= notice.getViewCount() %>
            </div>

        </div>


        <div class="notice-content">
            <%= notice.getContent() %>
        </div>
        
        <% if (notice.getFileName() != null && !notice.getFileName().isEmpty()) { %>

    <div class="attachment">
        <span class="attachment-label">첨부파일</span>

        <span class="attachment-name">
            <%= notice.getFileName() %>
        </span>

        <a href="<%=request.getContextPath()%>/notice/file?fileName=<%=java.net.URLEncoder.encode(notice.getFileName(), "UTF-8")%>&mode=view"
           target="_blank"
           class="file-btn">
            보기
        </a>

        <a href="<%=request.getContextPath()%>/notice/file?fileName=<%=java.net.URLEncoder.encode(notice.getFileName(), "UTF-8")%>&mode=download"
           class="file-btn">
            다운로드
        </a>
    </div>

<% } %>

    </div>


    <!-- 이전글 / 다음글 -->
<div class="nav">

    <!-- 다음글 -->
    <div class="nav-row">
        <span class="nav-label">
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
    <div class="nav-row">
        <span class="nav-label">
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

<div style="background: #ffeaa7; padding: 10px; margin-bottom: 10px; font-size: 13px; color: #333;">
    [현재 세션에 들어있는 모든 키 값 확인]<br>
    <%
        java.util.Enumeration<String> attrNames = session.getAttributeNames();
        if (!attrNames.hasMoreElements()) {
            out.println("-> 현재 세션에 저장된 데이터가 아예 없습니다! (로그인 상태 아님)");
        }
        while(attrNames.hasMoreElements()){
            String attrName = attrNames.nextElement();
            out.println("- " + attrName + " : " + session.getAttribute(attrName) + "<br>");
        }
    %>
</div>

<%-- 세션에 저장된 id가 admin인 경우에만 수정/삭제 버튼 노출 --%>
<c:if test="${not empty sessionScope.id and sessionScope.id == 'admin'}">
    <div class="btn-area" style="margin-top: 20px; text-align: right;">
        <a href="edit?id=<%= notice.getNoticeId() %>" class="btn btn-primary" style="padding: 6px 12px; background-color: #333; color: #fff; text-decoration: none; border-radius: 4px; margin-right: 5px;">수정</a>
        
        <a href="${pageContext.request.contextPath}/notice/deleteOk?id=${notice.noticeId}" 
           onclick="return confirm('정말 이 공지사항을 삭제하시겠습니까?');"
           style="padding: 6px 12px; background-color: #ff4757; color: #fff; text-decoration: none; border-radius: 4px; margin-right: 5px;">삭제</a>
    </div>
</c:if>

<!-- 목록 버튼은 항상 노출 -->
<div class="button-area" style="margin-top: 20px; text-align: center;">
    <a href="list" class="btn" style="padding: 8px 20px; background-color: #666; color: #fff; text-decoration: none; border-radius: 4px;">목록</a>
</div>

</div>

</body>
</html>