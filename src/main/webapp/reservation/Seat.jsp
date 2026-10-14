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

    if (reservedSeatsValue instanceof List<?>) {

        reservedSeats =
                (List<String>) reservedSeatsValue;

    }


    // ====================================================
    // 메시지
    // ====================================================

    String message =
            (String) request.getAttribute("message");


    // ====================================================
    // 좌석 가격
    // ====================================================

    int seatPrice = 10000;

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
   AI 좌석 추천
========================================= */

.ai-seat-box {

    width: 700px;

    margin: 35px auto 0;

    padding: 25px;

    box-sizing: border-box;

    background-color: #151515;

    border: 1px solid #2c2c2c;

    border-radius: 8px;

}


.ai-seat-title {

    text-align: center;

    color: #e50914;

    font-size: 20px;

    font-weight: bold;

}


.ai-seat-subtitle {

    margin-top: 8px;

    text-align: center;

    color: #888;

    font-size: 13px;

}


.ai-seat-options {

    display: flex;

    justify-content: center;

    gap: 20px;

    margin-top: 20px;

}


.ai-option {

    display: flex;

    flex-direction: column;

    gap: 7px;

}


.ai-option label {

    color: #aaa;

    font-size: 12px;

}


.ai-option select {

    width: 150px;

    height: 38px;

    padding: 0 10px;

    border: 1px solid #333;

    border-radius: 5px;

    background-color: #222;

    color: white;

    outline: none;

}


.ai-option select:focus {

    border-color: #e50914;

}


.ai-recommend-button {

    display: block;

    width: 220px;

    margin: 20px auto 0;

    padding: 12px;

    border: none;

    border-radius: 6px;

    background-color: #e50914;

    color: white;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

}


.ai-recommend-button:hover {

    background-color: #b20710;

}


.ai-seat-result {

    margin-top: 18px;

    padding: 15px;

    background-color: #202020;

    border-radius: 6px;

    color: #ddd;

    text-align: center;

    font-size: 14px;

}


.apply-recommend-button {

    display: none;

    width: 220px;

    margin: 12px auto 0;

    padding: 11px;

    border: 1px solid #e50914;

    border-radius: 6px;

    background-color: transparent;

    color: #e50914;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

}


.apply-recommend-button:hover {

    background-color: #e50914;

    color: white;

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


/* =========================================
   반응형
========================================= */

@media (max-width: 1050px) {

    .seat-container {

        width: 95%;

    }


    .screen,
    .selected-info,
    .ai-seat-box {

        width: 100%;

    }

}


@media (max-width: 750px) {

    .seat-container {

        padding: 20px;

    }


    .seat-row {

        gap: 4px;

    }


    .seat {

        width: 28px;

        height: 28px;

    }


    .seat label {

        width: 28px;

        height: 28px;

        font-size: 8px;

    }


    .ai-seat-options {

        flex-direction: column;

        align-items: center;

    }

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

            && !message.trim().isEmpty()) {

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
             좌석 영역
        ========================================== -->

        <div class="seat-area">


<%

    // ====================================================
    // A ~ E
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
        // 1 ~ 20
        // ====================================================

        for (int i = 1; i <= 20; i++) {


            String seatNumber =

                    row + i;


            // ====================================================
            // 예약된 좌석인지 확인
            // ====================================================

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
             AI 좌석 추천
        ========================================== -->

        <div class="ai-seat-box">


            <div class="ai-seat-title">

                🤖 AI 좌석 추천

            </div>


            <div class="ai-seat-subtitle">

                관람 인원과 선호 위치를 선택하면
                추천 좌석을 알려드립니다.

            </div>


            <div class="ai-seat-options">


                <div class="ai-option">

                    <label for="peopleCount">

                        관람 인원

                    </label>


                    <select id="peopleCount">

                        <option value="1">

                            1명

                        </option>


                        <option value="2">

                            2명

                        </option>


                        <option value="3">

                            3명

                        </option>


                        <option value="4">

                            4명

                        </option>

                    </select>

                </div>


                <div class="ai-option">

                    <label for="seatPreference">

                        선호 위치

                    </label>


                    <select id="seatPreference">

                        <option value="center">

                            가운데

                        </option>


                        <option value="front">

                            앞쪽

                        </option>


                        <option value="back">

                            뒤쪽

                        </option>


                        <option value="left">

                            왼쪽

                        </option>


                        <option value="right">

                            오른쪽

                        </option>

                    </select>

                </div>


            </div>


            <button

                type="button"

                class="ai-recommend-button"

                onclick="recommendSeats();">

                AI 좌석 추천

            </button>


            <div

                id="aiSeatResult"

                class="ai-seat-result">

                추천 좌석이 여기에 표시됩니다.

            </div>


            <button

                type="button"

                id="applyRecommendButton"

                class="apply-recommend-button"

                onclick="applyRecommendedSeats();">

                추천 좌석 선택

            </button>


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

var SEAT_PRICE = <%= seatPrice %>;


/* =========================================
   좌석 요소
========================================= */

var seatInputs =

        document.querySelectorAll(
            'input[name="seatNumber"]'
        );


/* =========================================
   추천 좌석
========================================= */

var recommendedSeats = [];


/* =========================================
   좌석 선택 이벤트 등록
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
   선택된 좌석 가져오기
========================================= */

function getSelectedSeats() {


    var selectedSeats = [];


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


    return selectedSeats;

}


/* =========================================
   좌석 정보 갱신
========================================= */

function updateSeatInfo() {


    var selectedSeats =
            getSelectedSeats();


    var selectedCount =
            document.getElementById(
                "selectedCount"
            );


    if (selectedCount != null) {

        selectedCount.innerText =
                selectedSeats.length;

    }


    var selectedSeatsElement =
            document.getElementById(
                "selectedSeats"
            );


    if (selectedSeatsElement != null) {

        selectedSeatsElement.innerText =

                selectedSeats.length > 0

                ? selectedSeats.join(", ")

                : "없음";

    }


    var totalPrice =
            selectedSeats.length
            * SEAT_PRICE;


    var totalPriceElement =
            document.getElementById(
                "totalPrice"
            );


    if (totalPriceElement != null) {

        totalPriceElement.innerText =
                totalPrice.toLocaleString();

    }


    var paymentButton =
            document.getElementById(
                "paymentButton"
            );


    if (paymentButton != null) {

        paymentButton.disabled =
                selectedSeats.length === 0;

    }

}


/* =========================================
   추천 좌석 정렬
========================================= */

function sortSeatCandidates(
        candidates,
        preference) {


    candidates.sort(

        function(a, b) {


            var scoreA =
                    getSeatScore(
                        a,
                        preference
                    );


            var scoreB =
                    getSeatScore(
                        b,
                        preference
                    );


            return scoreB - scoreA;

        }

    );

}


/* =========================================
   좌석 점수 계산
========================================= */

function getSeatScore(
        seatNumber,
        preference) {


    var row =
            seatNumber.charAt(0);


    var number =
            parseInt(
                seatNumber.substring(1)
            );


    var score = 0;


    /* 가운데 */

    if (
        number >= 8
        &&
        number <= 13
    ) {

        score += 20;

    }


    /* 중앙 행 */

    if (row === "C") {

        score += 20;

    }


    /* 선호 위치 */

    if (
        preference === "center"
        &&
        number >= 8
        &&
        number <= 13
    ) {

        score += 50;

    }


    if (
        preference === "front"
        &&
        (
            row === "A"
            ||
            row === "B"
        )
    ) {

        score += 50;

    }


    if (
        preference === "back"
        &&
        (
            row === "D"
            ||
            row === "E"
        )
    ) {

        score += 50;

    }


    if (
        preference === "left"
        &&
        number <= 7
    ) {

        score += 50;

    }


    if (
        preference === "right"
        &&
        number >= 14
    ) {

        score += 50;

    }


    return score;

}


/* =========================================
   연속 좌석 찾기
========================================= */

function findConsecutiveSeats(
        availableSeats,
        peopleCount,
        preference) {


    var rows =
            ["A", "B", "C", "D", "E"];


    var possibleGroups = [];


    for (
        var r = 0;
        r < rows.length;
        r++
    ) {


        var rowSeats = [];


        for (
            var i = 0;
            i < availableSeats.length;
            i++
        ) {


            if (
                availableSeats[i].charAt(0)
                ===
                rows[r]
            ) {

                rowSeats.push(
                    availableSeats[i]
                );

            }

        }


        rowSeats.sort(

            function(a, b) {

                return parseInt(
                    a.substring(1)
                )
                -
                parseInt(
                    b.substring(1)
                );

            }

        );


        for (
            var start = 0;
            start <= rowSeats.length - peopleCount;
            start++
        ) {


            var group = [];

            var valid = true;


            for (
                var k = 0;
                k < peopleCount;
                k++
            ) {


                var currentNumber =

                        parseInt(
                            rowSeats[start]
                                .substring(1)
                        )
                        +
                        k;


                var currentSeat =

                        rows[r]
                        +
                        currentNumber;


                if (
                    rowSeats.indexOf(
                        currentSeat
                    ) === -1
                ) {

                    valid = false;

                    break;

                }


                group.push(
                    currentSeat
                );

            }


            if (valid) {

                var groupScore = 0;


                for (
                    var j = 0;
                    j < group.length;
                    j++
                ) {

                    groupScore +=
                            getSeatScore(
                                group[j],
                                preference
                            );

                }


                possibleGroups.push({

                    seats:
                            group,

                    score:
                            groupScore

                });

            }

        }

    }


    possibleGroups.sort(

        function(a, b) {

            return b.score - a.score;

        }

    );


    if (
        possibleGroups.length > 0
    ) {

        return possibleGroups[0].seats;

    }


    return [];

}


/* =========================================
   AI 좌석 추천
========================================= */

function recommendSeats() {


    var peopleCount =

            parseInt(
                document.getElementById(
                    "peopleCount"
                ).value
            );


    var preference =

            document.getElementById(
                "seatPreference"
            ).value;


    var availableSeats = [];


    /* 사용 가능한 좌석 수집 */

    for (

        var i = 0;

        i < seatInputs.length;

        i++

    ) {


        if (!seatInputs[i].disabled) {

            availableSeats.push(
                seatInputs[i].value
            );

        }

    }


    /* 좌석 부족 */

    if (
        availableSeats.length
        <
        peopleCount
    ) {


        recommendedSeats = [];


        document.getElementById(
            "aiSeatResult"
        ).innerText =

            "현재 선택 가능한 좌석이 부족합니다.";


        document.getElementById(
            "applyRecommendButton"
        ).style.display =

            "none";


        return;

    }


    /* 연속 좌석 우선 */

    recommendedSeats =

            findConsecutiveSeats(
                availableSeats,
                peopleCount,
                preference
            );


    /* 연속 좌석이 없는 경우 */

    if (
        recommendedSeats.length
        !==
        peopleCount
    ) {


        var scoredSeats =
                availableSeats.slice();


        sortSeatCandidates(
            scoredSeats,
            preference
        );


        recommendedSeats =

                scoredSeats.slice(
                    0,
                    peopleCount
                );

    }


    /* 추천 결과 */

    document.getElementById(
        "aiSeatResult"
    ).innerText =

        "AI 추천 좌석 : "
        +
        recommendedSeats.join(", ");


    document.getElementById(
        "applyRecommendButton"
    ).style.display =

        "block";

}


/* =========================================
   추천 좌석 실제 선택
========================================= */

function applyRecommendedSeats() {


    if (
        recommendedSeats.length === 0
    ) {

        return;

    }


    /* 기존 선택 해제 */

    for (

        var i = 0;

        i < seatInputs.length;

        i++

    ) {


        if (!seatInputs[i].disabled) {

            seatInputs[i].checked =
                    false;

        }

    }


    /* 추천 좌석 선택 */

    for (

        var i = 0;

        i < recommendedSeats.length;

        i++

    ) {


        var seatElement =

                document.getElementById(
                    "seat_"
                    +
                    recommendedSeats[i]
                );


        if (
            seatElement != null
            &&
            !seatElement.disabled
        ) {

            seatElement.checked =
                    true;

        }

    }


    /* 정보 갱신 */

    updateSeatInfo();

}


/* =========================================
   결제 페이지 이동
========================================= */

function goPayment() {


    var selectedSeats =
            getSelectedSeats();


    /* 좌석 선택 확인 */

    if (
        selectedSeats.length === 0
    ) {


        alert(
            "좌석을 선택해주세요."
        );


        return false;

    }


    /* 총 금액 */

    var totalPrice =

            selectedSeats.length
            *
            SEAT_PRICE;


    /* 좌석 정보 */

    var seatsElement =

            document.getElementById(
                "seats"
            );


    var amountElement =

            document.getElementById(
                "amount"
            );


    if (
        seatsElement == null
        ||
        amountElement == null
    ) {


        alert(
            "결제 정보를 전달할 수 없습니다."
        );


        return false;

    }


    seatsElement.value =

            selectedSeats.join(",");


    amountElement.value =

            totalPrice;


    return true;

}


/* =========================================
   최초 상태 확인
========================================= */

updateSeatInfo();

</script>


</body>

</html>