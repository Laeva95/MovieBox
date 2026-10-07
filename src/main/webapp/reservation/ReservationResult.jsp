<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="booking.ReservationVO" %>
<%@ page import="movie.MovieDAO" %>
<%@ page import="movie.MovieDTO" %>

<%
    ReservationVO reservation =
            (ReservationVO) request.getAttribute("reservation");

    String memberName =
            (String) session.getAttribute("name");

    MovieDTO movie = null;

    String screeningTime = "상영 시간 정보 없음";

    if (reservation != null) {

        MovieDAO movieDAO = new MovieDAO();

        movie = movieDAO.getMovieDetails(
                reservation.getMovieId()
        );

        // 상영번호에 따른 상영시간
        switch (reservation.getScreeningId()) {

            case 1:
                screeningTime = "10:00";
                break;

            case 2:
                screeningTime = "13:00";
                break;

            case 3:
                screeningTime = "16:00";
                break;

            case 4:
                screeningTime = "19:00";
                break;

            default:
                screeningTime = "상영 시간 정보 없음";
                break;
        }
    }
%>

<style>



.result-container {

    width: 650px;

    margin: 80px auto;

    padding: 40px;

    box-sizing: border-box;

    background-color: #1c1c1c;

    border-radius: 12px;

    text-align: center;
}

.result-container h1 {

    margin-bottom: 35px;
}

.result-info {

    padding: 25px;

    background-color: #252525;

    border-radius: 8px;

    text-align: left;
}

.result-row {

    display: flex;

    justify-content: space-between;

    padding: 14px 0;

    border-bottom: 1px solid #444;
}

.result-row:last-child {

    border-bottom: none;
}

.result-label {

    color: #999;
}

.result-value {

    font-weight: bold;
}

.button-area {

    display: flex;

    justify-content: center;

    margin-top: 35px;
}

.button-area button {

    width: 220px;

    padding: 14px;

    box-sizing: border-box;

    border: none;

    border-radius: 6px;

    color: white;

    font-size: 15px;

    font-weight: bold;

    cursor: pointer;
}

.home-button {
    background-color: #e50914;
}

.home-button:hover {
    background-color: #b20710;
}

</style>


<div class="result-container">

    <h1>예매가 완료되었습니다.</h1>

<%
    if (reservation != null) {
%>

    <div class="result-info">

        <div class="result-row">

            <span class="result-label">
                이름
            </span>

            <span class="result-value">

                <%= memberName != null
                        ? memberName
                        : reservation.getMemberId() %>

            </span>

        </div>


        <div class="result-row">

            <span class="result-label">
                영화
            </span>

            <span class="result-value">

                <%= movie != null
                        ? movie.getTitle()
                        : "영화 정보 없음" %>

            </span>

        </div>


        <div class="result-row">

            <span class="result-label">
                예매 날짜
            </span>

            <span class="result-value">

                <%= reservation.getReservationDate() %>

            </span>

        </div>


        <div class="result-row">

            <span class="result-label">
                상영 시간
            </span>

            <span class="result-value">

                <%= screeningTime %>

            </span>

        </div>


        <div class="result-row">

            <span class="result-label">
                좌석
            </span>

            <span class="result-value">

                <%= reservation.getSeatNumber() %>

            </span>

        </div>

    </div>


    <div class="button-area">

        <button type="button"
                class="home-button"
                onclick="location.href='${pageContext.request.contextPath}/Index.jsp'">

            홈

        </button>

    </div>

<%
    } else {
%>

    <h1>예매 정보를 찾을 수 없습니다.</h1>

<%
    }
%>

</div>
