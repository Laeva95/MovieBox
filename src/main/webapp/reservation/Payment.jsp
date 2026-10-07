<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

    // ====================================================
    // 예매 정보
    // ====================================================

    String memberId =
            request.getParameter("memberId");

    String movieId =
            request.getParameter("movieId");

    String screeningId =
            request.getParameter("screeningId");

    String reservationDate =
            request.getParameter("reservationDate");

    String seats =
            request.getParameter("seats");

    String amount =
            request.getParameter("amount");



    // ====================================================
    // null 처리
    // ====================================================

    if (memberId == null) {
        memberId = "";
    }


    if (movieId == null) {
        movieId = "";
    }


    if (screeningId == null) {
        screeningId = "";
    }


    if (reservationDate == null) {
        reservationDate = "";
    }


    if (seats == null) {
        seats = "";
    }


    if (amount == null) {
        amount = "0";
    }



    // ====================================================
    // 상영시간
    // ====================================================

    String screeningTime =
            "-";


    try {

        int screeningNo =
                Integer.parseInt(
                        screeningId
                );


        switch (screeningNo) {

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

        }

    } catch (Exception e) {

        screeningTime = "-";

    }



    // ====================================================
    // 금액
    // ====================================================

    int totalAmount =
            0;


    try {

        totalAmount =
                Integer.parseInt(
                        amount
                );

    } catch (Exception e) {

        totalAmount =
                0;

    }

%>


<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    가상 결제 - Movie Box
</title>


<style>

* {

    box-sizing: border-box;

}


body {

    margin: 0;

    min-height: 100vh;

    background:
        linear-gradient(
            180deg,
            #0d0d0d 0%,
            #151515 50%,
            #0d0d0d 100%
        );

    color: #fff;

    font-family:
        Arial,
        "Noto Sans KR",
        sans-serif;

}


.payment-container {

    width: 520px;

    max-width:
        calc(100% - 30px);

    margin:
        60px auto;

}


.payment-box {

    padding: 30px;

    background-color: #191919;

    border:
        1px solid #2c2c2c;

    border-radius: 10px;

}


.payment-header {

    margin-bottom: 25px;

}


.payment-header .sub-title {

    margin-bottom: 8px;

    color: #e50914;

    font-size: 12px;

    font-weight: bold;

    letter-spacing: 2px;

}


.payment-header h1 {

    margin: 0;

    font-size: 28px;

}


.payment-header p {

    margin:
        9px 0 0;

    color: #777;

    font-size: 13px;

}



/* =========================================================
   예매 정보
========================================================= */

.info-box {

    margin-bottom: 20px;

    padding: 18px;

    background-color: #101010;

    border:
        1px solid #2c2c2c;

    border-radius: 7px;

}


.info-row {

    display: flex;

    justify-content: space-between;

    padding: 8px 0;

    border-bottom:
        1px solid #222;

}


.info-row:last-child {

    border-bottom: none;

}


.info-label {

    color: #777;

    font-size: 13px;

}


.info-value {

    color: #fff;

    font-size: 13px;

    font-weight: bold;

}


.amount {

    color: #e50914;

    font-size: 19px;

}



/* =========================================================
   입력
========================================================= */

.input-group {

    margin-bottom: 17px;

}


.input-group label {

    display: block;

    margin-bottom: 8px;

    color: #bbb;

    font-size: 13px;

    font-weight: bold;

}


.input-group input {

    width: 100%;

    height: 44px;

    padding: 0 12px;

    border:
        1px solid #3a3a3a;

    border-radius: 6px;

    outline: none;

    background-color: #101010;

    color: #fff;

    font-size: 14px;

}


.input-group input:focus {

    border-color: #e50914;

}



/* =========================================================
   결제 버튼
========================================================= */

.payment-button {

    width: 100%;

    height: 50px;

    margin-top: 8px;

    border: none;

    border-radius: 7px;

    background-color: #e50914;

    color: #fff;

    font-size: 15px;

    font-weight: bold;

    cursor: pointer;

}


.payment-button:hover {

    background-color: #b20710;

}


.payment-button:disabled {

    background-color: #444;

    color: #777;

    cursor: not-allowed;

}



/* =========================================================
   이전 버튼
========================================================= */

.cancel-button {

    width: 100%;

    height: 45px;

    margin-top: 10px;

    border:
        1px solid #333;

    border-radius: 7px;

    background-color: #111;

    color: #999;

    font-size: 13px;

    cursor: pointer;

}


.cancel-button:hover {

    color: #fff;

    border-color: #555;

}



/* =========================================================
   오류 메시지
========================================================= */

.message {

    display: none;

    margin-top: 15px;

    padding: 12px;

    border:
        1px solid #4a2222;

    border-radius: 6px;

    background-color: #251313;

    color: #ff7c7c;

    font-size: 13px;

    line-height: 1.5;

}



/* =========================================================
   안내
========================================================= */

.notice {

    margin-top: 18px;

    padding: 12px;

    background-color: #151515;

    color: #666;

    font-size: 11px;

    line-height: 1.6;

    text-align: center;

}



@media (max-width: 600px) {

    .payment-container {

        margin:
            20px auto;

    }


    .payment-box {

        padding: 20px;

    }

}

</style>

</head>



<body>



<div class="payment-container">


    <div class="payment-box">



        <!-- =================================================
             제목
        ================================================== -->

        <div class="payment-header">

            <div class="sub-title">

                MOVIE BOX

            </div>


            <h1>

                가상 결제

            </h1>


            <p>

                예매 정보를 확인하고 결제를 진행해주세요.

            </p>

        </div>



        <!-- =================================================
             예매 정보
        ================================================== -->

        <div class="info-box">


            <div class="info-row">

                <span class="info-label">

                    영화 번호

                </span>


                <span class="info-value">

                    <%= movieId %>

                </span>

            </div>



            <div class="info-row">

                <span class="info-label">

                    예매 날짜

                </span>


                <span class="info-value">

                    <%= reservationDate %>

                </span>

            </div>



            <div class="info-row">

                <span class="info-label">

                    상영시간

                </span>


                <span class="info-value">

                    <%= screeningTime %>

                </span>

            </div>



            <div class="info-row">

                <span class="info-label">

                    선택 좌석

                </span>


                <span class="info-value">

                    <%= seats %>

                </span>

            </div>



            <div class="info-row">

                <span class="info-label">

                    결제 금액

                </span>


                <span class="info-value amount">

                    <%= String.format(
                            "%,d",
                            totalAmount
                    ) %>원

                </span>

            </div>


        </div>



        <!-- =================================================
             결제 form
        ================================================== -->

        <form
            id="paymentForm">



            <input
                type="hidden"
                name="memberId"
                value="<%= memberId %>">



            <input
                type="hidden"
                name="movieId"
                value="<%= movieId %>">



            <input
                type="hidden"
                name="screeningId"
                value="<%= screeningId %>">



            <input
                type="hidden"
                name="reservationDate"
                value="<%= reservationDate %>">



            <input
                type="hidden"
                name="seats"
                value="<%= seats %>">



            <input
                type="hidden"
                name="amount"
                value="<%= amount %>">



            <!-- 카드번호 -->

            <div class="input-group">


                <label for="cardNumber">

                    카드번호

                </label>


                <input
                    type="text"
                    id="cardNumber"
                    maxlength="16"
                    inputmode="numeric"
                    placeholder="카드번호 16자리를 입력하세요">


            </div>



            <!-- 유효기간 -->

            <div class="input-group">


                <label for="expiry">

                    유효기간

                </label>


                <input
                    type="text"
                    id="expiry"
                    maxlength="5"
                    inputmode="numeric"
                    placeholder="MM/YY">


            </div>



            <!-- CVC -->

            <div class="input-group">


                <label for="cvc">

                    CVC

                </label>


                <input
                    type="password"
                    id="cvc"
                    maxlength="3"
                    inputmode="numeric"
                    placeholder="3자리">


            </div>



            <button
                type="submit"
                id="paymentButton"
                class="payment-button">

                결제하기

            </button>


        </form>



        <!-- 오류 -->

        <div
            id="message"
            class="message">

        </div>



        <!-- 이전 -->

        <button
            type="button"
            class="cancel-button"
            onclick="history.back();">

            이전으로

        </button>



        <div class="notice">

            실제 카드 결제가 이루어지지 않는
            가상 결제 화면입니다.

        </div>


    </div>

</div>



<script>

/* =========================================================
   결제 버튼
========================================================= */

document.getElementById(
    "paymentForm"
).addEventListener(
    "submit",
    function(event) {


        event.preventDefault();



        // ================================================
        // 입력 검사
        // ================================================

        if (!checkPayment()) {

            return;

        }



        var form =
                document.getElementById(
                    "paymentForm"
                );


        var button =
                document.getElementById(
                    "paymentButton"
                );


        var message =
                document.getElementById(
                    "message"
                );



        button.disabled =
                true;


        button.innerText =
                "결제 처리 중...";


        message.style.display =
                "none";



        // ================================================
        // form 데이터
        // ================================================

        var formData =
                new URLSearchParams(
                    new FormData(form)
                );



        // ================================================
        // BookingController 호출
        // ================================================

        fetch(
            "<%= request.getContextPath() %>/api/bookings/payment-complete",
            {

                method:
                    "POST",


                headers: {

                    "Content-Type":
                        "application/x-www-form-urlencoded; charset=UTF-8"

                },


                body:
                    formData

            }
        )


        .then(
            function(response) {


                return response.json();

            }
        )


        .then(
            function(data) {


                // ========================================
                // 결제 성공
                // ========================================

                if (data.success) {


                    var resultUrl =

                        "<%= request.getContextPath() %>"
                        +
                        "/reservation/ReservationResult.jsp"
                        +
                        "?memberId="
                        +
                        encodeURIComponent(
                            form.querySelector(
                                '[name="memberId"]'
                            ).value
                        )
                        +
                        "&movieId="
                        +
                        encodeURIComponent(
                            form.querySelector(
                                '[name="movieId"]'
                            ).value
                        )
                        +
                        "&screeningId="
                        +
                        encodeURIComponent(
                            form.querySelector(
                                '[name="screeningId"]'
                            ).value
                        )
                        +
                        "&reservationDate="
                        +
                        encodeURIComponent(
                            form.querySelector(
                                '[name="reservationDate"]'
                            ).value
                        )
                        +
                        "&seats="
                        +
                        encodeURIComponent(
                            form.querySelector(
                                '[name="seats"]'
                            ).value
                        )
                        +
                        "&amount="
                        +
                        encodeURIComponent(
                            form.querySelector(
                                '[name="amount"]'
                            ).value
                        );



                    // =================================
                    // 완료 페이지 이동
                    // =================================

                    location.href =
                            resultUrl;


                }


                // ========================================
                // 결제 실패
                // ========================================

                else {


                    message.innerText =
                            data.message
                            ||
                            "결제에 실패했습니다.";


                    message.style.display =
                            "block";


                    button.disabled =
                            false;


                    button.innerText =
                            "결제하기";

                }

            }
        )


        .catch(
            function(error) {


                console.error(
                    error
                );


                message.innerText =
                        "결제 처리 중 오류가 발생했습니다.";


                message.style.display =
                        "block";


                button.disabled =
                        false;


                button.innerText =
                        "결제하기";

            }
        );

    }
);



/* =========================================================
   결제 입력 검사
========================================================= */

function checkPayment() {


    var cardNumber =
            document.getElementById(
                "cardNumber"
            ).value.trim();


    var expiry =
            document.getElementById(
                "expiry"
            ).value.trim();


    var cvc =
            document.getElementById(
                "cvc"
            ).value.trim();



    if (
        !/^[0-9]{16}$/.test(
            cardNumber
        )
    ) {


        alert(
            "카드번호 16자리를 입력해주세요."
        );


        return false;

    }



    if (
        !/^[0-9]{2}\/[0-9]{2}$/.test(
            expiry
        )
    ) {


        alert(
            "유효기간을 MM/YY 형식으로 입력해주세요."
        );


        return false;

    }



    if (
        !/^[0-9]{3}$/.test(
            cvc
        )
    ) {


        alert(
            "CVC 3자리를 입력해주세요."
        );


        return false;

    }



    return true;

}

</script>



</body>

</html>