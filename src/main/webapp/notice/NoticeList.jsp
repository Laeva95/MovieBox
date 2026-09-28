<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 | Magic Box</title>

<style>
    * { box-sizing: border-box; }
    body { margin: 0; font-family: Arial, sans-serif; color: #222; }
    .container { width: 1200px; margin: 0 auto; }
    .header { border-bottom: 1px solid #ddd; }
    .header-inner { height: 80px; display: flex; align-items: center; justify-content: space-between; }
    .logo { font-size: 28px; font-weight: bold; }
    .nav { display: flex; gap: 35px; }
    .nav a { text-decoration: none; color: #222; }
    .notice-section { padding: 70px 0; }
    .page-title { font-size: 32px; margin-bottom: 10px; }
    .page-description { color: #777; margin-bottom: 40px; }
    .notice-table { width: 100%; border-collapse: collapse; border-top: 2px solid #222; }
    .notice-table th, .notice-table td { padding: 18px; border-bottom: 1px solid #ddd; text-align: center; }
    .notice-table th { background-color: #f8f8f8; }
    .notice-title { text-align: left !important; }
    .notice-title a { color: #222; text-decoration: none; }
    .pagination { margin-top: 35px; text-align: center; }
    .pagination a { margin: 0 8px; text-decoration: none; color: #555; }
    .search-box { margin-top: 40px; text-align: center; }
    .search-box input { width: 300px; padding: 10px; border: 1px solid #ccc; }
    .search-box button { padding: 10px 20px; border: none; background: #222; color: white; cursor: pointer; }
</style>
</head>

<body>

<header class="header">
    <div class="container header-inner">
        <div class="logo">MOVIE BOX</div>
        <nav class="nav">
            <a href="#">영화</a>
            <a href="#">예매</a>
            <a href="#">영화관</a>
            <a href="#">이벤트</a>
            <a href="#">MY</a>
        </nav>
    </div>
</header>

<main>
    <section class="notice-section">
        <div class="container">
            <h1 class="page-title">공지사항</h1>
            <p class="page-description">MOVIE BOX의 새로운 소식과 안내사항을 확인하세요.</p>

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
                    <!-- 데이터베이스에서 가져온 공지사항 목록을 반복문으로 출력 -->
                    <c:choose>
                        <c:when test="${empty noticeList}">
                            <tr>
                                <td colspan="4">등록된 공지사항이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="notice" items="${noticeList}">
                                <tr>
                                    <td>${notice.noticeId}</td>
                                    <td class="notice-title">
                                        <!-- 클릭 시 해당 글 번호(id)를 들고 detail 컨트롤러로 이동 -->
                                        <a href="detail?id=${notice.noticeId}">${notice.title}</a>
                                    </td>
                                    <td>${notice.createdAt}</td>
                                    <td>${notice.viewCount}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="pagination">
                <a href="#">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
            </div>

            <div class="search-box">
                <input type="text" placeholder="공지사항 검색">
                <button type="button">검색</button>
            </div>
        </div>
    </section>
</main>

</body>
</html>