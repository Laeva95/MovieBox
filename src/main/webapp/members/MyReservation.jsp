<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="reservation-page-section">
    <div class="mypage-section-title">나의 예매 내역</div>
    <div class="mypage-section-description">
        예매한 영화 목록을 확인할 수 있습니다.
        <br>
    </div>
 	<br>
    <div class="reservation-group">
        <div class="reservation-group-title">상영 예정</div>
        <div class="reservation-list">
            <c:set var="hasUpcomingReservation" value="false"/>

            <c:forEach var="item" items="${myPageReservationList}">
                <c:if test="${not item.past}">
                    <c:set var="hasUpcomingReservation" value="true"/>

                    <div class="reservation-card">
                        <div class="reservation-poster">
                            <c:choose>
                                <c:when test="${not empty item.movie.poster}">
                                    <img src="${item.movie.poster}"
                                         alt="${item.movie.title} 포스터">
                                </c:when>
                                <c:otherwise>
                                    <div class="reservation-poster-empty">
                                        포스터<br>없음
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="reservation-info">
                            <div class="reservation-movie-title">
                                ${item.movie.title}
                            </div>

                            <div class="reservation-detail">
                                <div class="reservation-detail-label">예매 날짜</div>
                                <div class="reservation-detail-value">${item.reservation.reservationDate}</div>

                                <div class="reservation-detail-label">상영 시간</div>
                                <div class="reservation-detail-value">${item.screeningTime}</div>

                                <div class="reservation-detail-label">좌석</div>
                                <div class="reservation-detail-value">${item.reservation.seatNumber}</div>
                            </div>

                            <div class="reservation-number">
                                예매번호 : ${item.reservation.reservationId}
                            </div>
                        </div>

                        <div class="reservation-action">
                            <form action="${pageContext.request.contextPath}/member/CancelReservation.do"
                                  method="post"
                                  onsubmit="return confirm('예매를 취소하시겠습니까?');">
                                <input type="hidden"
                                       name="reservationId"
                                       value="${item.reservation.reservationId}">
                                <button type="submit" class="reservation-cancel-button">
                                    예매 취소
                                </button>
                            </form>
                        </div>
                    </div>
                </c:if>
            </c:forEach>

            <c:if test="${not hasUpcomingReservation}">
                <div class="no-reservation">예정된 예매 내역이 없습니다.</div>
            </c:if>
        </div>
    </div>

    <div class="reservation-group">
        <div class="reservation-group-title">지난 예매</div>
        <div class="reservation-list">
            <c:set var="hasPastReservation" value="false"/>

            <c:forEach var="item" items="${myPageReservationList}">
                <c:if test="${item.past}">
                    <c:set var="hasPastReservation" value="true"/>

                    <div class="reservation-card reservation-card-past">
                        <div class="reservation-poster">
                            <c:choose>
                                <c:when test="${not empty item.movie.poster}">
                                    <img src="${item.movie.poster}"
                                         alt="${item.movie.title} 포스터">
                                </c:when>
                                <c:otherwise>
                                    <div class="reservation-poster-empty">
                                        포스터<br>없음
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="reservation-info">
                            <div class="reservation-movie-title">
                                ${item.movie.title}
                            </div>

                            <div class="reservation-detail">
                                <div class="reservation-detail-label">예매 날짜</div>
                                <div class="reservation-detail-value">${item.reservation.reservationDate}</div>

                                <div class="reservation-detail-label">상영 시간</div>
                                <div class="reservation-detail-value">${item.screeningTime}</div>

                                <div class="reservation-detail-label">좌석</div>
                                <div class="reservation-detail-value">${item.reservation.seatNumber}</div>
                            </div>

                            <div class="reservation-number">
                                예매번호 : ${item.reservation.reservationId}
                            </div>
                        </div>

                        <div class="reservation-action">
                            <span class="reservation-past-badge">상영 종료</span>
                        </div>
                    </div>
                </c:if>
            </c:forEach>

            <c:if test="${not hasPastReservation}">
                <div class="no-reservation">지난 예매 내역이 없습니다.</div>
            </c:if>
        </div>
    </div>

    <div class="reservation-notice">
        ※ 상영 시간이 지난 예매는 취소할 수 없습니다.
    </div>
</div>
