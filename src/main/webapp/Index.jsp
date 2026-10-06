<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Movie Box</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  
  <script>
  // 페이지가 캐시에서 로드될 때 새로고침(뒤로가기, 앞으로가기 등)
        window.addEventListener("pageshow", function(event) {
        	// persisted: 페이지가 캐시에서 로드되었는지 확인
            if (event.persisted) {
            	// 강제 새로고침
                window.location.reload();
            }
        });
    </script>
</head>
<body>
<%
// request 객체의  "center" 키에 저장된 값을 가져옴
String centerPage = (String) request.getAttribute("center");

// 가져온 값이 null 이거나 ""공백 문자열 이라면 중앙 화면을 기본 Center.jsp 페이지를 저장
if (centerPage == null || centerPage.trim().isEmpty()) {
    centerPage = "/inc/Center.jsp";
}

// 현재 page 객체의 "center" 키에 중앙 화면 페이지 주소를 저장
pageContext.setAttribute("center", centerPage);
%>

<!-- Top.jsp 영역 -->
  <header class="site-header">
    <jsp:include page="/inc/Top.jsp"/>
  </header>
  
<!-- center 영역 -->
  <jsp:include page="${center}"/>
     <jsp:include page="/ai/aiChat.jsp" />
<!-- Bottom.jsp 영역 -->
  <footer class="site-footer"> 

  	<jsp:include page="/inc/Bottom.jsp"/>
  </footer>

</body>
</html>