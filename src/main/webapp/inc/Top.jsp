<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="util-bar">
  <div class="inner-container util-inner">
    <c:choose>
      <c:when test="${empty sessionScope.id}">
        <a href="${pageContext.request.contextPath}/member/Login.do">로그인</a>
        <a href="${pageContext.request.contextPath}/member/Join.do">회원가입</a>
      </c:when>
      <c:otherwise>
        <span><strong>${sessionScope.name}</strong>님 환영합니다</span>
        <a href="${pageContext.request.contextPath}/member/Logout.do">로그아웃</a>
        <a href="${pageContext.request.contextPath}/member/MyPage.do">마이페이지</a>
      </c:otherwise>
    </c:choose>

  </div>
</div>
<div class="inner-container gnb-bar">
  <div class="gnb-left">
    <a href="${pageContext.request.contextPath}/" class="brand-logo">MOVIE<span class="logo-red">BOX</span></a>
    <nav class="main-nav">
      <a href="${pageContext.request.contextPath}/movies/MovieList.do">영화</a>
      <a href="${pageContext.request.contextPath}/movie/booking.jsp">예매</a>
      <a href="#">리뷰</a>
      <a href="${pageContext.request.contextPath}/notice/list">공지사항</a>
    </nav>
  </div>
  <div class="gnb-right">
    <a href="#quick-booking" class="btn-quick-nav">빠른예매</a>
  </div>
</div>
