<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>

<%

    // ====================================================
    // 예매 정보 받기
    // ====================================================

    String movieId =
            (String) request.getAttribute("movieId");

    String memberId =
            (String) request.getAttribute("memberId");

    String screeningId =
            (String) request.getAttribute("screeningId");

    // ★ 예약 날짜
    String reservationDate =
            (String) request.getAttribute("reservationDate");


    // ====================================================
    // 예약된 좌석 가져오기
    // ====================================================

    List<String> reservedSeats =
            (List<String>) request.getAttribute("reservedSeats");


    // ====================================================
    // 실패 메시지
    // ====================================================

    String message =
            (String) request.getAttribute("message");

%>


<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>좌석 선택 - Movie Box</title>


<style>

/* =========================================
   전체
========================================= */

body {

    margin: 0;

    background-color: #111;

    color: white;

    font-family:
        Arial,
        "Noto Sans KR",
        sans-serif;
}


/* =========================================
   전체 컨테이너
========================================= */

.seat-container {

    width: 900px;

    margin: 50px auto 80px;

    padding: 40px;

    background-color: #1c1c1c;

    border-radius: 12px;

    box-sizing: border-box;
}


/* =========================================
   제목
========================================= */

.seat-title {

    text-align: center;

    margin-bottom: 30px;

}


.seat-title h1 {

    margin: 0 0 15px;

}


.seat-title p {

    margin: 5px 0;

    color: #aaa;

}


/* =========================================
   예매 정보
========================================= */

.booking-info {

    display: flex;

    justify-content: center;

    gap: 30px;

    margin-bottom: 35px;

    padding: 15px;

    background-color: #252525;

    border-radius: 8px;

}


.booking-info span {

    color: #ddd;

}


/* =========================================
   메시지
========================================= */

.message {

    margin-bottom: 25px;

    padding: 12px;

    text-align: center;

    background-color: #3a2020;

    color: #ff7777;

    border: 1px solid #e50914;

    border-radius: 6px;

}


/* =========================================
   스크린
========================================= */

.screen {

    width: 650px;

    margin: 0 auto 45px;

    padding: 12px;

    text-align: center;

    background-color: #eee;

    color: #222;

    border-radius: 5px;

    font-weight: bold;

}


/* =========================================
   좌석 영역
========================================= */

.seat-area {

    display: flex;

    flex-direction: column;

    align-items: center;

    gap: 10px;

}


/* =========================================
   좌석 한 줄
========================================= */

.seat-row {

    display: flex;

    align-items: center;

    gap: 8px;

}


/* =========================================
   행 이름
========================================= */

.row-name {

    width: 25px;

    text-align: center;

    font-weight: bold;

    margin-right: 8px;

}


/* =========================================
   좌석
========================================= */

.seat {

    width: 32px;

    height: 32px;

}


/* 실제 radio 숨김 */

.seat input {

    display: none;

}


/* =========================================
   좌석 버튼
========================================= */

.seat label {

    display: flex;

    justify-content: center;

    align-items: center;

    width: 32px;

    height: 32px;

    box-sizing: border-box;

    border: 1px solid #777;

    border-radius: 5px;

    background-color: #333;

    color: white;

    font-size: 11px;

    cursor: pointer;

}


/* =========================================
   선택된 좌석
========================================= */

.seat input:checked + label {

    background-color: #e50914;

    border-color: #e50914;

    color: white;

}


/* =========================================
   예약된 좌석
========================================= */

.seat input:disabled + label {

    background-color: #555;

    border-color: #555;

    color: #999;

    cursor: not-allowed;

    text-decoration: line-through;

}


/* =========================================
   안내
========================================= */

.seat-guide {

    display: flex;

    justify-content: center;

    gap: 25px;

    margin-top: 35px;

    color: #bbb;

    font-size: 13px;

}


.guide-item {

    display: flex;

    align-items: center;

    gap: 7px;

}


.guide-box {

    width: 18px;

    height: 18px;

    border-radius: 4px;

    background-color: #333;

    border: 1px solid #777;

}


.guide-box.selected {

    background-color: #e50914;

    border-color: #e50914;

}


.guide-box.reserved {

    background-color: #555;

    border-color: #555;

}


/* =========================================
   버튼
========================================= */

.button-area {

    margin-top: 45px;

    text-align: center;

}


.button-area button {

    width: 250px;

    padding: 15px;

    border: none;

    border-radius: 6px;

    background-color: #e50914;

    color: white;

    font-size: 16px;

    font-weight: bold;

    cursor: pointer;

}


.button-area button:hover {

    background-color: #b20710;

}

</style>

</head>


<body>
<button type="button"
        onclick="history.back()"
        style="
            position: absolute;
            top: 20px;
            right: 25px;
            border: none;
            background: none;
            color: white;
            font-size: 30px;
            cursor: pointer;
        ">
    ×
</button>


<div class="seat-container">


    <!-- =========================================
         제목
    ========================================== -->

    <div class="seat-title">

        <h1>

            좌석 선택

        </h1>


        <p>

            예매할 좌석을 선택해주세요.

        </p>

    </div>



    <!-- =========================================
         예매 정보
    ========================================== -->

    <div class="booking-info">


        <span>

            날짜 :
            <%= reservationDate != null
                    ? reservationDate
                    : "" %>

        </span>


        <span>

            상영관 :
            <%= screeningId != null
                    ? screeningId
                    : "" %>

        </span>


    </div>



<%

    // ====================================================
    // 메시지가 있는 경우
    // ====================================================

    if (message != null
            && !message.isEmpty()) {

%>


    <div class="message">

        <%= message %>

    </div>


    <script>

        alert("<%= message %>");

    </script>


<%

    }

%>



    <!-- =========================================
         스크린
    ========================================== -->

    <div class="screen">

        SCREEN

    </div>



    <!-- =========================================
         좌석 선택
    ========================================== -->

    <form
        action="<%= request.getContextPath() %>/reservation"
        method="post"
        onsubmit="return checkReservation();">


        <!-- =====================================
             회원 ID
        ====================================== -->

        <input
            type="hidden"
            name="memberId"
            value="<%= memberId != null ? memberId : "" %>">


        <!-- =====================================
             영화 ID
        ====================================== -->

        <input
            type="hidden"
            name="movieId"
            value="<%= movieId != null ? movieId : "" %>">


        <!-- =====================================
             상영시간 ID
        ====================================== -->

        <input
            type="hidden"
            name="screeningId"
            value="<%= screeningId != null ? screeningId : "" %>">


        <!-- =====================================
             예약 날짜
        ====================================== -->

        <input
            type="hidden"
            name="reservationDate"
            value="<%= reservationDate != null
                    ? reservationDate
                    : "" %>">



        <div class="seat-area">


<%

    // ====================================================
    // A ~ E 좌석
    // ====================================================

    String[] rows =
            {"A", "B", "C", "D", "E"};


    for (String row : rows) {

%>


            <div class="seat-row">


                <!-- 행 이름 -->

                <div class="row-name">

                    <%= row %>

                </div>


<%

        // ====================================================
        // 1 ~ 20 좌석
        // ====================================================

        for (int i = 1; i <= 20; i++) {


            String seatNumber =
                    row + i;


            // 예약된 좌석인지 확인

            boolean reserved =
                    reservedSeats != null
                    && reservedSeats.contains(seatNumber);

%>


                <div class="seat">


                    <input

                        type="radio"

                        name="seatNumber"

                        value="<%= seatNumber %>"

                        id="seat_<%= seatNumber %>"

                        <%= reserved
                                ? "disabled"
                                : "" %>


                    >


                    <label for="seat_<%= seatNumber %>">


<%

            if (reserved) {

%>

                        예약됨


<%

            } else {

%>

                        <%= seatNumber %>


<%

            }

%>


                    </label>


                </div>


<%

        }

%>


            </div>


<%

    }

%>


        </div>



        <!-- =========================================
             좌석 안내
        ========================================== -->

        <div class="seat-guide">


            <div class="guide-item">

                <div class="guide-box"></div>

                선택 가능

            </div>


            <div class="guide-item">

                <div class="guide-box selected"></div>

                선택

            </div>


            <div class="guide-item">

                <div class="guide-box reserved"></div>

                예약됨

            </div>


        </div>



        <!-- =========================================
             예약 버튼
        ========================================== -->

        <div class="button-area">

            <button type="submit">

                예매하기

            </button>

        </div>


    </form>


</div>



<script>


/* =========================================
   좌석 선택 확인
========================================= */

function checkReservation() {


    var seat =
            document.querySelector(
                'input[name="seatNumber"]:checked'
            );


    if (!seat) {

        alert("좌석을 선택해주세요.");

        return false;

    }


    return true;

}


</script>


</body>

</html>