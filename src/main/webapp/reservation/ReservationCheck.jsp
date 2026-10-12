<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="booking.ReservationVO"%>

<%
    String contextPath = request.getContextPath();

    String memberId = (String) request.getAttribute("memberId");
    String message = (String) request.getAttribute("message");

    List<ReservationVO> reservationList =
            (List<ReservationVO>) request.getAttribute("reservationList");

    Map<Integer, String> movieTitles =
            (Map<Integer, String>) request.getAttribute("movieTitles");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>예매 확인 - MovieBox</title>

<style>
    body {
        margin: 0;
        padding: 0;
        background-color: #080808;
        color: white;
        font-family: Arial, sans-serif;
    }

    .container {
        width: 700px;
        max-width: calc(100% - 32px);
        margin: 60px auto;
    }

    h1 {
        text-align: center;
        color: #e50914;
        margin-bottom: 15px;
    }

    .member-info {
        text-align: center;
        color: #aaa;
        margin-bottom: 35px;
    }

    .reservation-box {
        background-color: #111;
        border: 1px solid #333;
        padding: 25px;
        margin-bottom: 18px;
        border-radius: 8px;
    }

    .movie-title {
        color: #fff;
        font-size: 22px;
        font-weight: bold;
        margin-bottom: 20px;
    }

    .reservation-box p {
        margin: 12px 0;
        color: #ddd;
    }

    .reservation-box strong {
        display: inline-block;
        width: 110px;
        color: #aaa;
    }

    .ticket-button {
        display: inline-block;
        margin-top: 15px;
        padding: 11px 18px;
        background-color: #e50914;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-size: 14px;
    }

    .ticket-button:hover {
        background-color: #b80710;
    }

    .empty {
        text-align: center;
        color: #aaa;
        padding: 45px 15px;
        background-color: #111;
        border-radius: 8px;
    }

    .message {
        text-align: center;
        color: #ff7777;
        padding: 30px 10px;
    }

    .home-button {
        display: block;
        width: 150px;
        margin: 30px auto;
        padding: 12px;
        text-align: center;
        background-color: #333;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        box-sizing: border-box;
    }

    @media (max-width: 600px) {
        .container {
            margin: 35px auto;
        }

        .reservation-box {
            padding: 18px;
        }

        .reservation-box strong {
            width: 95px;
        }
    }
</style>
</head>

<body>

<div class="container">

    <h1>나의 예매 내역</h1>

    <% if (memberId == null || memberId.trim().isEmpty()) { %>

        <div class="message">
            <%= message != null ? message : "로그인이 필요합니다." %>
        </div>

    <% } else { %>

        <div class="member-info">
            로그인 회원: <%= memberId %>
        </div>

        <% if (reservationList != null && !reservationList.isEmpty()) { %>

            <% for (ReservationVO reservation : reservationList) {

                int movieId = reservation.getMovieId();
                int screeningId = reservation.getScreeningId();

                String movieTitle = movieTitles != null
                        ? movieTitles.get(movieId)
                        : null;

                if (movieTitle == null) {
                    movieTitle = "영화 정보 없음";
                }

                String ticketMemberId = URLEncoder.encode(
                        reservation.getMemberId(), "UTF-8");

                String ticketDate = URLEncoder.encode(
                        reservation.getReservationDate() != null
                                ? reservation.getReservationDate()
                                : "",
                        "UTF-8");

                String ticketSeat = URLEncoder.encode(
                        reservation.getSeatNumber() != null
                                ? reservation.getSeatNumber()
                                : "",
                        "UTF-8");

                String ticketUrl =
                        contextPath
                        + "/reservation/MobileTicket.jsp"
                        + "?memberId=" + ticketMemberId
                        + "&movieId=" + movieId
                        + "&screeningId=" + screeningId
                        + "&reservationDate=" + ticketDate
                        + "&seats=" + ticketSeat
                        + "&amount=10000";
            %>

                <div class="reservation-box">

                    <div class="movie-title">
                        <%= movieTitle %>
                    </div>

                    <p>
                        <strong>예매 번호</strong>
                        <%= reservation.getReservationId() %>
                    </p>

                    <p>
                        <strong>상영 번호</strong>
                        <%= screeningId %>
                    </p>

                    <p>
                        <strong>상영 날짜</strong>
                        <%= reservation.getReservationDate() %>
                    </p>

                    <p>
                        <strong>좌석 번호</strong>
                        <%= reservation.getSeatNumber() %>
                    </p>

                    <a href="<%= ticketUrl %>" class="ticket-button">
                        모바일 티켓 확인
                    </a>

                </div>

            <% } %>

        <% } else { %>

            <div class="empty">
                아직 예매한 영화가 없습니다.
            </div>

        <% } %>

    <% } %>

    <a href="<%= contextPath %>/Index.jsp" class="home-button">
        메인으로
    </a>

</div>

</body>
</html>

