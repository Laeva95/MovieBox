<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="booking.ReservationVO" %>

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

<title>예매 확인 - Movie Box</title>


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

    gap: 12px;

    margin-top: 35px;
}


.button-area a,
.button-area button {

    width: 180px;

    padding: 13px;

    box-sizing: border-box;

    border: none;

    border-radius: 6px;

    text-align: center;

    font-size: 14px;

    font-weight: bold;

    text-decoration: none;

    cursor: pointer;
}


.btn-main {

    background-color: #555;

    color: white;
}


.btn-cancel {

    background-color: #e50914;

    color: white;
}


.btn-cancel:hover {

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


        <!-- 예약번호 -->

        <div class="result-row">

            <span class="result-label">

                예약번호

            </span>

            <span class="result-value">

                <%= reservation.getReservationId() %>

            </span>

        </div>


        <!-- 회원 ID -->

        <div class="result-row">

            <span class="result-label">

                회원 ID

            </span>

            <span class="result-value">

                <%= reservation.getMemberId() %>

            </span>

        </div>


        <!-- 영화 ID -->

        <div class="result-row">

            <span class="result-label">

                영화 ID

            </span>

            <span class="result-value">

                <%= reservation.getMovieId() %>

            </span>

        </div>


        <!-- 예약 날짜 -->

        <div class="result-row">

            <span class="result-label">

                예매 날짜

            </span>

            <span class="result-value">

                <%= reservation.getReservationDate() %>

            </span>

        </div>


        <!-- 상영시간 -->

        <div class="result-row">

            <span class="result-label">

                상영시간

            </span>

            <span class="result-value">

                <%= reservation.getScreeningId() %>

            </span>

        </div>


        <!-- 좌석 -->

        <div class="result-row">

            <span class="result-label">

                좌석

            </span>

            <span class="result-value">

                <%= reservation.getSeatNumber() %>

            </span>

        </div>


    </div>



    <!-- =========================================
         버튼
    ========================================== -->

    <div class="button-area">


        <!-- 메인으로 -->

        <a
            href="<%= request.getContextPath() %>/"
            class="btn-main">

            메인으로

        </a>


        <!-- =====================================
             예매 취소
        ====================================== -->

        <form
            action="<%= request.getContextPath() %>/reservation"
            method="post"
            style="margin: 0;">

            <input
                type="hidden"
                name="action"
                value="cancel">


            <input
                type="hidden"
                name="reservationId"
                value="<%= reservation.getReservationId() %>">


            <button
                type="submit"
                class="btn-cancel"
                onclick="return confirm('정말 예매를 취소하시겠습니까?');">

                예매 취소

            </button>

        </form>


    </div>


<%

    } else {

%>


    <p>

        예매 정보를 찾을 수 없습니다.

    </p>


<%

    }

%>


</div>


</body>

</html>