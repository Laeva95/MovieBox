<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="movie.MovieDAO" %>
<%@ page import="movie.MovieDTO" %>
<%@ page import="java.net.URLEncoder" %>

<%

    // ====================================================
    // 예매 정보 받기
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
    // 영화 제목
    // ====================================================

    String movieTitle =
            "영화 정보 없음";


    try {

        int movieNo =
                Integer.parseInt(
                        movieId
                );


        MovieDAO movieDAO =
                new MovieDAO();


        MovieDTO movie =
                movieDAO.getMovieDetails(
                        movieNo
                );


        if (movie != null) {

            movieTitle =
                    movie.getTitle();

        }

    } catch (Exception e) {

        movieTitle =
                "영화 정보 없음";

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

                screeningTime =
                        "10:00";

                break;


            case 2:

                screeningTime =
                        "13:00";

                break;


            case 3:

                screeningTime =
                        "16:00";

                break;


            case 4:

                screeningTime =
                        "19:00";

                break;

        }

    } catch (Exception e) {

        screeningTime =
                "-";

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


    // ====================================================
    // 회원 이름
    // ====================================================

    String memberName =
            memberId;


    Object sessionName =
            session.getAttribute("name");


    if (sessionName != null) {

        memberName =
                sessionName.toString();

    }


    // ====================================================
    // 예매번호 생성
    // ====================================================

    String ticketKey =

            reservationDate
            +
            memberId
            +
            movieId
            +
            screeningId
            +
            seats;


    int ticketHash =

            Math.abs(
                ticketKey.hashCode()
            );


    String ticketNumber =

            "MB-"
            +
            reservationDate.replace(
                    "-",
                    ""
            )
            +
            "-"
            +
            Integer.toHexString(
                    ticketHash
            ).toUpperCase();


    // ====================================================
    // QR 데이터
    // ====================================================

    String qrData =

            "MOVIE BOX"
            +
            "\n영화: "
            +
            movieTitle
            +
            "\n날짜: "
            +
            reservationDate
            +
            "\n시간: "
            +
            screeningTime
            +
            "\n상영관: "
            +
            screeningId
            +
            "관"
            +
            "\n좌석: "
            +
            seats
            +
            "\n예매번호: "
            +
            ticketNumber;


    String encodedQrData =
            "";


    try {

        encodedQrData =
                URLEncoder.encode(
                        qrData,
                        "UTF-8"
                );

    } catch (Exception e) {

        encodedQrData =
                "";

    }

%>


<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>모바일 티켓 - Movie Box</title>


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
            #181818 50%,
            #0d0d0d 100%
        );

    color: white;

    font-family:
        Arial,
        "Noto Sans KR",
        sans-serif;

}


.ticket-container {

    width: 620px;

    max-width:
        calc(100% - 30px);

    margin: 60px auto 80px;

}


/* =========================================
   제목
========================================= */

.page-header {

    text-align: center;

    margin-bottom: 28px;

}


.page-header .brand {

    margin-bottom: 8px;

    color: #e50914;

    font-size: 13px;

    font-weight: bold;

    letter-spacing: 3px;

}


.page-header h1 {

    margin: 0;

    font-size: 30px;

}


.page-header p {

    margin: 10px 0 0;

    color: #888;

    font-size: 13px;

}


/* =========================================
   티켓
========================================= */

.ticket {

    overflow: hidden;

    background-color: #f5f5f5;

    color: #111;

    border-radius: 18px;

    box-shadow:
        0 20px 50px rgba(
            0,
            0,
            0,
            0.45
        );

}


/* =========================================
   티켓 상단
========================================= */

.ticket-top {

    padding: 24px 28px;

    background:
        linear-gradient(
            135deg,
            #e50914,
            #b20710
        );

    color: white;

}


.ticket-brand {

    display: flex;

    justify-content: space-between;

    align-items: center;

}


.ticket-brand strong {

    font-size: 24px;

    letter-spacing: 1px;

}


.ticket-number {

    text-align: right;

}


.ticket-number span {

    display: block;

    margin-bottom: 4px;

    font-size: 11px;

    opacity: 0.8;

}


.ticket-number strong {

    font-size: 13px;

}


/* =========================================
   티켓 본문
========================================= */

.ticket-body {

    padding: 28px;

}


/* =========================================
   영화 제목
========================================= */

.movie-title {

    margin-bottom: 25px;

}


.movie-title .label {

    margin-bottom: 5px;

    color: #888;

    font-size: 12px;

}


.movie-title h2 {

    margin: 0;

    font-size: 25px;

}


/* =========================================
   예매 정보
========================================= */

.info-grid {

    display: grid;

    grid-template-columns: 1fr 1fr;

    border-top:
        1px solid #ddd;

}


.info-item {

    min-height: 75px;

    padding: 15px 10px;

    border-bottom:
        1px solid #ddd;

}


.info-item:nth-child(odd) {

    border-right:
        1px solid #ddd;

}


.info-label {

    margin-bottom: 7px;

    color: #888;

    font-size: 11px;

}


.info-value {

    color: #111;

    font-size: 15px;

    font-weight: bold;

}


.price {

    color: #e50914;

    font-size: 18px;

}


/* =========================================
   절취선
========================================= */

.ticket-line {

    position: relative;

    border-top:
        2px dashed #ccc;

}


.ticket-line::before {

    content: "";

    position: absolute;

    left: -12px;

    top: -13px;

    width: 24px;

    height: 24px;

    border-radius: 50%;

    background-color: #181818;

}


.ticket-line::after {

    content: "";

    position: absolute;

    right: -12px;

    top: -13px;

    width: 24px;

    height: 24px;

    border-radius: 50%;

    background-color: #181818;

}


/* =========================================
   QR
========================================= */

.qr-section {

    padding: 30px;

    text-align: center;

}


.qr-section img {

    display: block;

    width: 210px;

    height: 210px;

    margin: 0 auto;

    padding: 10px;

    background-color: white;

    border: 1px solid #ddd;

}


.qr-title {

    margin-top: 18px;

    color: #222;

    font-size: 15px;

    font-weight: bold;

}


.qr-description {

    margin-top: 7px;

    color: #888;

    font-size: 11px;

    line-height: 1.5;

}


/* =========================================
   티켓 하단
========================================= */

.ticket-bottom {

    padding: 18px 28px;

    background-color: #eee;

    text-align: center;

    color: #666;

    font-size: 11px;

}


.ticket-bottom strong {

    color: #e50914;

}


/* =========================================
   버튼
========================================= */

.button-area {

    display: flex;

    gap: 10px;

    margin-top: 22px;

}


.button {

    flex: 1;

    height: 48px;

    border-radius: 7px;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

}


.history-button {

    border: none;

    background-color: #e50914;

    color: white;

}


.home-button {

    border: 1px solid #333;

    background-color: #111;

    color: white;

}


.history-button:hover {

    background-color: #b20710;

}


.home-button:hover {

    background-color: #222;

}


@media (max-width: 650px) {

    .ticket-container {

        width: 95%;

        margin-top: 30px;

    }


    .ticket-top {

        padding: 20px;

    }


    .ticket-body {

        padding: 20px;

    }


    .ticket-brand strong {

        font-size: 20px;

    }


    .movie-title h2 {

        font-size: 21px;

    }


    .qr-section {

        padding: 25px 15px;

    }


    .button-area {

        flex-direction: column;

    }

}

</style>

</head>


<body>


<div class="ticket-container">


    <!-- =========================================
         제목
    ========================================== -->

    <div class="page-header">


        <div class="brand">

            MOVIE BOX

        </div>


        <h1>

            모바일 티켓

        </h1>


        <p>

            예매 정보를 확인해주세요.

        </p>


    </div>


    <!-- =========================================
         모바일 티켓
    ========================================== -->

    <div class="ticket">


        <!-- =========================================
             티켓 상단
        ========================================== -->

        <div class="ticket-top">


            <div class="ticket-brand">


                <strong>

                    MOVIE BOX

                </strong>


                <div class="ticket-number">


                    <span>

                        예매번호

                    </span>


                    <strong>

                        <%= ticketNumber %>

                    </strong>


                </div>


            </div>


        </div>


        <!-- =========================================
             티켓 본문
        ========================================== -->

        <div class="ticket-body">


            <div class="movie-title">


                <div class="label">

                    영화

                </div>


                <h2>

                    <%= movieTitle %>

                </h2>


            </div>


            <div class="info-grid">


                <div class="info-item">


                    <div class="info-label">

                        예매자

                    </div>


                    <div class="info-value">

                        <%= memberName %>

                    </div>


                </div>


                <div class="info-item">


                    <div class="info-label">

                        날짜

                    </div>


                    <div class="info-value">

                        <%= reservationDate %>

                    </div>


                </div>


                <div class="info-item">


                    <div class="info-label">

                        상영시간

                    </div>


                    <div class="info-value">

                        <%= screeningTime %>

                    </div>


                </div>


                <div class="info-item">


                    <div class="info-label">

                        상영관

                    </div>


                    <div class="info-value">

                        <%= screeningId %>관

                    </div>


                </div>


                <div class="info-item">


                    <div class="info-label">

                        좌석

                    </div>


                    <div class="info-value">

                        <%= seats %>

                    </div>


                </div>


                <div class="info-item">


                    <div class="info-label">

                        결제금액

                    </div>


                    <div class="info-value price">

                        <%= String.format(
                                "%,d",
                                totalAmount
                        ) %>원

                    </div>


                </div>


            </div>


        </div>


        <!-- =========================================
             절취선
        ========================================== -->

        <div class="ticket-line"></div>


        <!-- =========================================
             QR 코드
        ========================================== -->

        <div class="qr-section">


            <img

                src="https://api.qrserver.com/v1/create-qr-code/?size=210x210&data=<%= encodedQrData %>"

                alt="예매 QR 코드">


            <div class="qr-title">

                입장용 QR 코드

            </div>


            <div class="qr-description">

                영화관 입장 시 QR 코드를 제시해주세요.<br>

                예매번호와 예매 정보를 함께 확인할 수 있습니다.

            </div>


        </div>


        <!-- =========================================
             하단
        ========================================== -->

        <div class="ticket-bottom">


            <strong>

                MOVIE BOX

            </strong>


            <br>


            즐거운 영화 관람 되세요.

        </div>


    </div>


    <!-- =========================================
         이동 버튼
    ========================================== -->

    <div class="button-area">


        <button

            type="button"

            class="button history-button"

            onclick="location.href='<%= request.getContextPath() %>/reservation/check';">

            예매 확인

        </button>


        <button

            type="button"

            class="button home-button"

            onclick="location.href='<%= request.getContextPath() %>/Index.jsp';">

            홈으로

        </button>


    </div>


</div>


</body>

</html>