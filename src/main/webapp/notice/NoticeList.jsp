<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<%
    // 1. 여기서 데이터를 만듭니다.
    List<Map<String, Object>> noticeList = new ArrayList<>();
    
    Map<String, Object> n1 = new HashMap<>();
    n1.put("noticeId", 1);
    n1.put("title", "추석 연휴 영화관 운영 안내");
    n1.put("createdAt", "2026-09-23");
    n1.put("viewCount", 0);
    noticeList.add(n1);

    Map<String, Object> n2 = new HashMap<>();
    n2.put("noticeId", 2);
    n2.put("title", "시스템 점검 안내");
    n2.put("createdAt", "2026-09-23");
    n2.put("viewCount", 0);
    noticeList.add(n2);

    Map<String, Object> n3 = new HashMap<>();
    n3.put("noticeId", 3);
    n3.put("title", "주차장 이용 안내");
    n3.put("createdAt", "2026-09-23");
    n3.put("viewCount", 0);
    noticeList.add(n3);

    // 2. request 영역에 담아줍니다.
    request.setAttribute("noticeList", noticeList);
%>
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
<script>
    function searchNotice() {
        // 1. 검색 버튼이 눌렸는지 확인용 로그
        console.log("검색 버튼 클릭됨!");

        const inputObj = document.getElementById("searchInput");
        if (!inputObj) {
            console.log("searchInput 요소를 찾을 수 없습니다!");
            return;
        }

        const keyword = inputObj.value.trim().toLowerCase();
        console.log("입력된 검색어:", keyword);

        const rows = document.querySelectorAll(".notice-table tbody tr");
        console.log("찾은 공지사항 행 개수:", rows.length);

        rows.forEach((row, index) => {
            if (row.cells.length < 2) return;

            const titleTd = row.querySelector(".notice-title");
            if (!titleTd) {
                console.log(index +번째 행에서 .notice-title을 찾지 못했습니다.");
                return;
            }

            const titleText = titleTd.innerText.toLowerCase();
            console.log(index +번째 글 제목:", titleText);

            // 검색어가 포함되어 있는지 확인 후 표시/숨김 처리
            if (titleText.includes(keyword)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    }
</script>
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
                    <!-- 3. 반복문을 통해 데이터 출력 -->
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
                                    
                                    	<%-- 각 글의 번호(id)를 들고 상세 페이지로 넘어가는 링크 --%>
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
                <input type="text" id="searchInput" placeholder="공지사항 검색" onkeyup="if(event.key === 'Enter'){ searchNotice(); }">
    			<button type="button" onclick="searchNotice()">검색</button>
            </div>
        </div>
    </section>
</main>

</body>
</html>