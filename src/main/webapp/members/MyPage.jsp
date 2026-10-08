<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/myPage.css">


<div class="mypage-page">
    <div class="mypage-container">

        <nav class="mypage-nav">
            <a class="mypage-nav-link ${myPageMenu == 'info' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/member/MyPage.do?menu=info">
                회원 정보
            </a>

            <a class="mypage-nav-link ${myPageMenu == 'reservation' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/member/MyPage.do?menu=reservation">
                예매 내역
            </a>

            <a class="mypage-nav-link ${myPageMenu == 'favorite' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/member/MyPage.do?menu=favorite">
                찜한 영화
            </a>

            <a class="mypage-nav-link ${myPageMenu == 'review' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/member/MyPage.do?menu=review">
                작성한 리뷰
            </a>
        </nav>

        <div class="mypage-content">
            <c:choose>
                <c:when test="${myPageMenu == 'reservation'}">
                    <jsp:include page="MyReservation.jsp" />
                </c:when>

                <c:when test="${myPageMenu == 'favorite'}">
                    <jsp:include page="MyFavorite.jsp" />
                </c:when>

                <c:when test="${myPageMenu == 'review'}">
                    <jsp:include page="MyReview.jsp" />
                </c:when>

                <c:otherwise>
                    <jsp:include page="MyInfo.jsp" />
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</div>