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
</head>
<body>
  <header class="site-header">
    <div class="util-bar">
      <div class="inner-container util-inner">
        <c:choose>
          <c:when test="${empty sessionScope.loginUser}">
            <a href="${pageContext.request.contextPath}/member/login.jsp">로그인</a>
            <a href="${pageContext.request.contextPath}/member/join.jsp">회원가입</a>
          </c:when>
          <c:otherwise>
            <span><strong>${sessionScope.loginUser.name}</strong>님 환영합니다</span>
            <a href="${pageContext.request.contextPath}/member/logout.do">로그아웃</a>
            <a href="${pageContext.request.contextPath}/member/myPage.jsp">마이페이지</a>
          </c:otherwise>
        </c:choose>
        <a href="#">고객센터</a>
      </div>
    </div>
    <div class="inner-container gnb-bar">
      <div class="gnb-left">
        <a href="${pageContext.request.contextPath}/" class="brand-logo">MOVIE<span class="logo-red">BOX</span></a>
        <nav class="main-nav">
          <a href="#">영화</a>
          <a href="#">예매</a>
          <a href="#">영화관</a>
          <a href="#">이벤트</a>
          <a href="#">리뷰</a>
        </nav>
      </div>
      <div class="gnb-right">
        <a href="#quick-booking" class="btn-quick-nav">빠른예매</a>
      </div>
    </div>
  </header>

  <main style="padding-top: 112px;">
    <section class="hero-section">
      <div class="hero-overlay"></div>
      <div class="inner-container hero-content">
        <div class="badge-row">
          <span class="badge-pill">IMAX 4DX 동시 개봉</span>
          <span class="badge-pill badge-red">예매율 1위 42.8%</span>
        </div>
        <h1 class="hero-title">스텔라: 오딧세이</h1>
        <p class="hero-desc">압도적 스케일의 서사시, 지금 극장에서 확인하세요.</p>
        <div class="hero-actions">
          <a href="#quick-booking" class="btn-primary-lg">예매하기</a>
        </div>
      </div>
    </section>

    <div class="inner-container quick-booking-container" id="quick-booking">
      <div class="quick-booking-box">
        <div class="qb-item">
          <div class="qb-left">
            <div class="qb-text"><span class="qb-label">영화 선택</span><span class="qb-value">스텔라: 오딧세이</span></div>
          </div>
        </div>
        <div class="qb-item">
          <div class="qb-left">
            <div class="qb-text"><span class="qb-label">극장 선택</span><span class="qb-value">강남점</span></div>
          </div>
        </div>
        <div class="qb-item">
          <div class="qb-left">
            <div class="qb-text"><span class="qb-label">날짜 선택</span><span class="qb-value">오늘</span></div>
          </div>
        </div>
        <div class="qb-item">
          <div class="qb-left">
            <div class="qb-text"><span class="qb-label">시간 선택</span><span class="qb-value">19:40</span></div>
          </div>
        </div>
        <div>
          <button type="button" class="btn-select-seat">좌석 선택</button>
        </div>
      </div>
    </div>

    <section class="inner-container section-wrap" style="margin-bottom: 80px;">
      <div class="section-head">
        <h2 class="section-title">무비차트</h2>
      </div>
      <div class="movie-grid">
        <div class="movie-card">
          <div class="poster-area">
            <img class="poster-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA3axBl_9YdwjoM3JuqDhIBZM02qem_9WC1Vgg8DhGF-nl3Q0pzYe0H5Z5YRV_t8-7nyFlKPjacinav35mKiyYW9Z8y9lbw6qIw61U_vmI-Cm5PCHyFly0PolRwap3dO5RCOSecScTk5IJay_eojeEoFwLsxa6vw_gt4aDCpdyjTdx43R-nFGDTRhUedA7xF4z5GGr2WH2Nx8kKEdNRgKKfJWXgqH7XX5jvsLyKQRcVWH0dguy44zhI" alt="스텔라">
            <div class="rank-overlay"><span class="rank-number">1</span></div>
          </div>
          <div class="card-info">
            <h3 class="movie-card-title">스텔라: 오딧세이</h3>
            <div class="card-meta-line"><span>예매율 42.8%</span></div>
          </div>
        </div>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <div class="inner-container">
      <p>&copy; Movie Box Cinema Corp. All rights reserved.</p>
    </div>
  </footer>
</body>
</html>