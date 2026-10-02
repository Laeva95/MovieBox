```jsp
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="VO.ReservationVO" %>

<%

    ReservationVO reservation =
            (ReservationVO) request.getAttribute(
                    "reservation"
            );

%>

<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>예매 완료 - Movie Box</title>


<style>

body {

    margin: 0;

    background-color: #111;

    color: white;

    font-family:
        Arial,
        "Noto Sans KR",
        sans-serif;
}


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

    margin-top: 35px;
}


.button-area a {

    display: inline-block;

    width: 220px;

    padding: 14px;

    box-sizing: border-box;

    border-radius: 6px;

    background-color: #e50914;

    color: white;

    text-decoration: none;

    font-weight: bold;
}


.button-area a:hover {

    background-color: #b20710;
}

</style>

</head>


<body>


<div class="result-container">


    <h1>

        예매가 완료되었습니다.

    </h1>


<%

    if (reservation != null) {

%>


    <div class="result-info">


        <div class="result-row">

            <span class="result-label">

                회원 ID

            </span>

            <span class="result-value">

                <%= reservation.getMemberId() %>

            </span>

        </div>


        <div class="result-row">

            <span class="result-label">

                영화 번호

            </span>

            <span class="result-value">

                <%= reservation.getMovieId() %>

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

                상영 번호

            </span>

            <span class="result-value">

                <%= reservation.getScreeningId() %>

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

        <a href="<%= request.getContextPath() %>/movie/booking.jsp">

            다시 예매하기

        </a>

    </div>


<%

    } else {

%>


    <h1>

        예매 정보를 찾을 수 없습니다.

    </h1>


<%

    }

%>


</div>


</body>

</html>
```
