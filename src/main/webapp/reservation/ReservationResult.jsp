<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="movie.MovieDAO" %>
<%@ page import="movie.MovieDTO" %>

<%

    // ====================================================
    // 예매 정보
    // ====================================================

    String memberId =
            request.getParameter("memberId");


    String movieIdStr =
            request.getParameter("movieId");


    String screeningIdStr =
            request.getParameter("screeningId");


    String reservationDate =
            request.getParameter("reservationDate");


    String seats =
            request.getParameter("seats");


    String amountStr =
            request.getParameter("amount");



    // ====================================================
    // 필수 정보 확인
    // ====================================================

    boolean hasReservation =
            memberId != null
            &&
            !memberId.trim().isEmpty()
            &&
            movieIdStr != null
            &&
            !movieIdStr.trim().isEmpty()
            &&
            screeningIdStr != null
            &&
            !screeningIdStr.trim().isEmpty()
            &&
            reservationDate != null
            &&
            !reservationDate.trim().isEmpty()
            &&
            seats != null
            &&
            !seats.trim().isEmpty();



    // ====================================================
    // 영화 정보
    // ====================================================

    MovieDTO movie =
            null;


    int movieId =
            0;


    if (movieIdStr != null) {


        try {

            movieId =
                    Integer.parseInt(
                            movieIdStr
                    );


            MovieDAO movieDAO =
                    new MovieDAO();


            movie =
                    movieDAO.getMovieDetails(
                            movieId
                    );


        } catch (Exception e) {

            movie =
                    null;

        }

    }



    // ====================================================
    // 영화 제목
    // ====================================================

    String movieTitle =
            "영화";


    if (movie != null
            && movie.getTitle() != null) {

        movieTitle =
                movie.getTitle();

    }



    // ====================================================
    // 상영시간
    // ====================================================

    String screeningTime =
            "-";


    try {

        int screeningId =
                Integer.parseInt(
                        screeningIdStr
                );


        switch (screeningId) {

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

        screeningTime =
                "-";

    }



    // ====================================================
    // 금액
    // ====================================================

    int amount =
            0;


    try {

        amount =
                Integer.parseInt(
                        amountStr
                );

    } catch (Exception e) {

        amount =
                0;

    }



    // ====================================================
    // 회원 이름
    // ====================================================

    String memberName =
            memberId;


    Object sessionName =
            session.getAttribute("name");


    if (
            sessionName != null
            &&
            !sessionName.toString().trim().isEmpty()
    ) {

        memberName =
                sessionName.toString();

    }

%>


<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">


<title>

    예매 완료 - Movie Box

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



.result-container {

    width: 650px;

    max-width:
        calc(100% - 30px);

    margin:
        60px auto;

}



.result-box {

    padding: 35px;

    background-color: #191919;

    border:
        1px solid #2c2c2c;

    border-radius: 10px;

    text-align: center;

}



/* =========================================================
   완료 표시
========================================================= */

.success-icon {

    width: 65px;

    height: 65px;

    margin:
        0 auto 20px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 50%;

    background-color: #e50914;

    color: #fff;

    font-size: 30px;

    font-weight: bold;

}


.result-box h1 {

    margin:
        0 0 10px;

    font-size: 28px;

}


.result-message {

    margin:
        0 0 30px;

    color: #888;

    font-size: 14px;

}



/* =========================================================
   예약 정보
========================================================= */

.reservation-info {

    padding: 20px;

    background-color: #101010;

    border:
        1px solid #2c2c2c;

    border-radius: 8px;

    text-align: left;

}


.info-row {

    display: flex;

    justify-content: space-between;

    gap: 20px;

    padding: 13px 0;

    border-bottom:
        1px solid #242424;

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

    font-size: 14px;

    font-weight: bold;

    text-align: right;

    word-break: break-word;

}


.price {

    color: #e50914;

    font-size: 18px;

}



/* =========================================================
   버튼
========================================================= */

.home-button {

    display: block;

    width: 100%;

    height: 50px;

    margin-top: 25px;

    line-height: 50px;

    border-radius: 7px;

    background-color: #e50914;

    color: #fff;

    text-decoration: none;

    font-size: 15px;

    font-weight: bold;

}


.home-button:hover {

    background-color: #b20710;

}



/* =========================================================
   안내
========================================================= */

.notice {

    margin-top: 20px;

    color: #666;

    font-size: 11px;

    line-height: 1.6;

}



@media (max-width: 600px) {

    .result-container {

        margin:
            25px auto;

    }


    .result-box {

        padding: 25px 18px;

    }


    .info-row {

        flex-direction: column;

        gap: 5px;

    }


    .info-value {

        text-align: left;

    }

}

</style>

</head>



<body>



<div class="result-container">


    <div class="result-box">



<%

    if (hasReservation) {

%>



        <!-- =============================================
             성공
        ============================================== -->

        <div class="success-icon">

            ✓

        </div>



        <h1>

            예매가 완료되었습니다.

        </h1>



        <p class="result-message">

            가상 결제가 정상적으로 처리되었습니다.

        </p>



        <!-- =============================================
             예매 정보
        ============================================== -->

        <div class="reservation-info">



            <div class="info-row">


                <span class="info-label">

                    예매자

                </span>


                <span class="info-value">

                    <%= memberName %>

                </span>


            </div>



            <div class="info-row">


                <span class="info-label">

                    영화

                </span>


                <span class="info-value">

                    <%= movieTitle %>

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

                    좌석

                </span>


                <span class="info-value">

                    <%= seats %>

                </span>


            </div>



            <div class="info-row">


                <span class="info-label">

                    결제 금액

                </span>


                <span class="info-value price">

                    <%= String.format(
                            "%,d",
                            amount
                    ) %>원

                </span>


            </div>



        </div>



        <!-- =============================================
             홈
        ============================================== -->

        <a

            href="<%= request.getContextPath() %>/"

            class="home-button">

            홈

        </a>



        <div class="notice">

            예매 내역은 마이페이지의 예매내역에서
            확인할 수 있습니다.

        </div>



<%

    }

    else {

%>



        <!-- =============================================
             예매 정보 없음
        ============================================== -->

        <div class="success-icon">

            !

        </div>



        <h1>

            예매가 완료되었습니다.

        </h1>



        <p class="result-message">

            예매 정보를 확인할 수 없습니다.

        </p>



        <a

            href="<%= request.getContextPath() %>/"

            class="home-button">

            홈

        </a>



<%

    }

%>



    </div>

</div>



</body>

</html>