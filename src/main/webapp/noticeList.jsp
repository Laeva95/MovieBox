<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 목록</title>
</head>
<body>
    <h2>영화 예매 사이트 - 공지사항</h2>
    
    <table border="1">
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성일</th>
                <th>조회수</th>
            </tr>
        </thead>
        <tbody>
            <!-- 데이터가 없을 때 -->
            <c:if test="${empty noticeList}">
                <tr>
                    <td colspan="4" align="center">등록된 공지사항이 없습니다.</td>
                </tr>
            </c:if>
            
            <!-- 데이터가 있을 때 반복문 돌려서 출력 -->
            <c:forEach var="notice" items="${noticeList}">
                <tr>
                    <td>${notice.noticeId}</td>
                    <td><a href="detail?id=${notice.noticeId}">${notice.title}</a></td>
                    <td>${notice.createdAt}</td>
                    <td>${notice.viewCount}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>