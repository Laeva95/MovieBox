<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>

<%

    // ====================================================
    // 예매 정보 받기
    // ====================================================

    Object movieIdValue =
            request.getAttribute("movieId");

    Object memberIdValue =
            request.getAttribute("memberId");

    Object screeningIdValue =
            request.getAttribute("screeningId");

    Object reservationDateValue =
            request.getAttribute("reservationDate");


    String movieId =
            movieIdValue != null
                    ? movieIdValue.toString()
                    : "";

    String memberId =
            memberIdValue != null
                    ? memberIdValue.toString()
                    : "";

    String screeningId =
            screeningIdValue != null
                    ? screeningIdValue.toString()
                    : "";

    String reservationDate =
            reservationDateValue != null
                    ? reservationDateValue.toString()
                    : "";


    // ====================================================
    // 예약된 좌석 가져오기
    // ====================================================

    List<String> reservedSeats = null;

    Object reservedSeatsValue =
            request.getAttribute("reservedSeats");

    if (reservedSeatsValue instanceof List) {

        reservedSeats =
                (List<String>) reservedSeatsValue;

    }


    // ====================================================
    // 실패 메시지
    // ====================================================

    String message =
            (String) request.getAttribute("message");


    // ====================================================
    // 좌석 가격
    // ====================================================

    int SEAT_PRICE = 10000;

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

    width: 1000px;

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

    width: 700px;

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

    width: 30px;

    text-align: center;

    font-weight: bold;

    margin-right: 8px;

}


/* =========================================
   좌석
========================================= */

.seat {

    width: 34px;

    height: 34px;

}


/* 실제 checkbox 숨김 */

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

    width: 34px;

    height: 34px;

    box-sizing: border-box;

    border: 1px solid #777;

    border-radius: 5px;

    background-color: #333;

    color: white;

    font-size: 10px;

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
   선택 정보
========================================= */

.selected-info {

    width: 700px;

    margin: 40px auto 0;

    padding: 20px;

    background-color: #252525;

    border-radius: 8px;

    box-sizing: border-box;

    text-align: center;

}


.selected-count {

    margin: 0 0 12px;

    font-size: 18px;

    font-weight: bold;

}


.selected-seats {

    margin: 0;

    color: #ddd;

}


.selected-price {

    margin: 12px 0 0;

    font-size: 22px;

    font-weight: bold;

    color: #e50914;

}


/* =========================================
   좌석 안내
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


.button-area button:disabled {

    background-color: #555;

    color: #999;

    cursor: not-allowed;

}


/* =========================================
   닫기 버튼
========================================= */

.close-button {

    position: absolute;

    top: 20px;

    right: 25px;

    border: none;

    background: none;

    color: white;

    font-size: 30px;

    cursor: pointer;

}

</style>

</head>


<body>


<!-- =========================================
     닫기
========================================= -->

<button
    type="button"
    class="close-button"
    onclick="history.back();">

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

            <%= reservationDate %>

        </span>


        <span>

            상영관 :

            <%= screeningId %>

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
         좌석 선택 form
    ========================================== -->

    <form

        id="paymentForm"

        action="<%= request.getContextPath() %>/reservation/Payment.jsp"

        method="get"

        onsubmit="return goPayment();">


        <!-- =====================================
             회원 ID
        ====================================== -->

        <input

            type="hidden"

            name="memberId"

            value="<%= memberId %>">


        <!-- =====================================
             영화 ID
        ====================================== -->

        <input

            type="hidden"

            name="movieId"

            value="<%= movieId %>">


        <!-- =====================================
             상영시간 ID
        ====================================== -->

        <input

            type="hidden"

            name="screeningId"

            value="<%= screeningId %>">


        <!-- =====================================
             예약 날짜
        ====================================== -->

        <input

            type="hidden"

            name="reservationDate"

            value="<%= reservationDate %>">


        <!-- =====================================
             선택 좌석
        ====================================== -->

        <input

            type="hidden"

            name="seats"

            id="seats"

            value="">


        <!-- =====================================
             결제 금액
        ====================================== -->

        <input

            type="hidden"

            name="amount"

            id="amount"

            value="">


        <!-- =========================================
             좌석
        ========================================== -->

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


            boolean reserved =

                    reservedSeats != null
                    && reservedSeats.contains(
                        seatNumber
                    );

%>


                <div class="seat">


                    <input

                        type="checkbox"

                        name="seatNumber"

                        value="<%= seatNumber %>"

                        id="seat_<%= seatNumber %>"

                        <%= reserved
                                ? "disabled"
                                : "" %>>


                    <label

                        for="seat_<%= seatNumber %>">


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
             선택 정보
        ========================================== -->

        <div class="selected-info">


            <p class="selected-count">

                선택 좌석 :

                <span id="selectedCount">

                    0

                </span>

                석

            </p>


            <p class="selected-seats">

                좌석 :

                <span id="selectedSeats">

                    없음

                </span>

            </p>


            <p class="selected-price">

                총 금액 :

                <span id="totalPrice">

                    0

                </span>

                원

            </p>


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
             결제 버튼
        ========================================== -->

        <div class="button-area">


            <button

                type="submit"

                id="paymentButton"

                disabled>

                결제하기

            </button>


        </div>


    </form>


</div>


<script>

/* =========================================
   좌석 가격
========================================= */

var SEAT_PRICE = 10000;


/* =========================================
   좌석 요소 가져오기
========================================= */

var seatInputs =

    document.querySelectorAll(
        'input[name="seatNumber"]'
    );


/* =========================================
   좌석 선택 이벤트
========================================= */

for (
    var i = 0;
    i < seatInputs.length;
    i++
) {

    seatInputs[i].addEventListener(
        "change",
        updateSeatInfo
    );

}


/* =========================================
   좌석 선택 정보 갱신
========================================= */

function updateSeatInfo() {


    var selectedSeats = [];


    /* 선택된 좌석 찾기 */

    for (
        var i = 0;
        i < seatInputs.length;
        i++
    ) {


        if (seatInputs[i].checked) {

            selectedSeats.push(
                seatInputs[i].value
            );

        }

    }


    /* =========================================
       선택 좌석 수
    ========================================= */

    document.getElementById(
        "selectedCount"
    ).innerText =

        selectedSeats.length;


    /* =========================================
       좌석 표시
    ========================================= */

    document.getElementById(
        "selectedSeats"
    ).innerText =

        selectedSeats.length > 0

            ? selectedSeats.join(", ")

            : "없음";


    /* =========================================
       총 금액
    ========================================= */

    var totalPrice =

        selectedSeats.length * SEAT_PRICE;


    document.getElementById(
        "totalPrice"
    ).innerText =

        totalPrice.toLocaleString();


    /* =========================================
       결제 버튼 활성화
    ========================================= */

    var paymentButton =

        document.getElementById(
            "paymentButton"
        );


    if (selectedSeats.length > 0) {

        paymentButton.disabled = false;

    } else {

        paymentButton.disabled = true;

    }

}


/* =========================================
   결제 페이지 이동
========================================= */

function goPayment() {


    var selectedSeats = [];


    /* 선택된 좌석 확인 */

    for (
        var i = 0;
        i < seatInputs.length;
        i++
    ) {


        if (seatInputs[i].checked) {

            selectedSeats.push(
                seatInputs[i].value
            );

        }

    }


    /* =========================================
       좌석을 선택하지 않은 경우
    ========================================= */

    if (selectedSeats.length === 0) {

        alert(
            "좌석을 선택해주세요."
        );

        return false;

    }


    /* =========================================
       총 금액
    ========================================= */

    var totalPrice =

        selectedSeats.length * SEAT_PRICE;


    /* =========================================
       Payment.jsp로 전달
    ========================================= */

    document.getElementById(
        "seats"
    ).value =

        selectedSeats.join(",");


    document.getElementById(
        "amount"
    ).value =

        totalPrice;


    return true;

}


/* =========================================
   처음 화면 상태 확인
========================================= */

updateSeatInfo();

</script>


</body>

</html>