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
                Integer.parseInt(movieId);


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

%>


<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>예매 완료 - Movie Box</title>


<style>

* {
    box-sizing: border-box;
}


body {

    margin: 0;

    min-height: 100vh;

    background-color: #111;

    color: white;

    font-family:
        Arial,
        "Noto Sans KR",
        sans-serif;

}


.result-container {

    width: 600px;

    max-width:
        calc(100% - 30px);

    margin: 70px auto;

}


.result-box {

    padding: 40px;

    background-color: #1c1c1c;

    border-radius: 12px;

    text-align: center;

}


.success-icon {

    width: 70px;

    height: 70px;

    margin: 0 auto 25px;

    border-radius: 50%;

    background-color: #e50914;

    color: white;

    font-size: 40px;

    line-height: 70px;

    font-weight: bold;

}


.result-box h1 {

    margin: 0 0 10px;

    font-size: 30px;

}


.result-message {

    margin-bottom: 30px;

    color: #aaa;

}


.info-box {

    padding: 20px;

    background-color: #111;

    border-radius: 8px;

    text-align: left;

}


.info-row {

    display: flex;

    justify-content: space-between;

    padding: 12px 0;

    border-bottom:
        1px solid #292929;

}


.info-row:last-child {

    border-bottom: none;

}


.label {

    color: #777;

}


.value {

    color: white;

    font-weight: bold;

}


.price {

    color: #e50914;

    font-size: 20px;

}


/* =========================================
   모바일 티켓 버튼
========================================= */

.ticket-button {

    width: 100%;

    height: 52px;

    margin-top: 25px;

    border: none;

    border-radius: 7px;

    background-color: #e50914;

    color: white;

    font-size: 16px;

    font-weight: bold;

    cursor: pointer;

}


.ticket-button:hover {

    background-color: #b20710;

}


/* =========================================
   예매 확인 버튼
========================================= */

.check-button {

    width: 100%;

    height: 48px;

    margin-top: 10px;

    border:
        1px solid #444;

    border-radius: 7px;

    background-color: #111;

    color: #bbb;

    font-size: 14px;

    cursor: pointer;

}


.check-button:hover {

    color: white;

    border-color: #666;

}


/* =========================================
   홈 버튼
========================================= */

.home-button {

    width: 100%;

    height: 48px;

    margin-top: 10px;

    border: none;

    border-radius: 7px;

    background-color: #252525;

    color: #aaa;

    font-size: 14px;

    cursor: pointer;

}


.home-button:hover {

    color: white;

}

</style>

</head>


<body>


<div class="result-container">


    <div class="result-box">


        <!-- =========================================
             완료 표시
        ========================================== -->

        <div class="success-icon">

            ✓

        </div>


        <h1>

            예매가 완료되었습니다.

        </h1>


        <div class="result-message">

            <%= memberName %>님,

            예매해주셔서 감사합니다.

        </div>


        <!-- =========================================
             예매 정보
        ========================================== -->

        <div class="info-box">


            <div class="info-row">

                <span class="label">

                    영화

                </span>


                <span class="value">

                    <%= movieTitle %>

                </span>

            </div>


            <div class="info-row">

                <span class="label">

                    예매 날짜

                </span>


                <span class="value">

                    <%= reservationDate %>

                </span>

            </div>


            <div class="info-row">

                <span class="label">

                    상영시간

                </span>


                <span class="value">

                    <%= screeningTime %>

                </span>

            </div>


            <div class="info-row">

                <span class="label">

                    좌석

                </span>


                <span class="value">

                    <%= seats %>

                </span>

            </div>


            <div class="info-row">

                <span class="label">

                    결제 금액

                </span>


                <span class="value price">

                    <%= String.format(
                            "%,d",
                            totalAmount
                    ) %>원

                </span>

            </div>


        </div>


        <!-- =========================================
             모바일 티켓
        ========================================== -->

        <button

            type="button"

            class="ticket-button"

            onclick="openMobileTicket();">

            모바일 티켓 보기

        </button>


        <!-- =========================================
             예매 확인
        ========================================== -->

        <button

            type="button"

            class="check-button"

            onclick="location.href='<%= request.getContextPath() %>/reservation/check';">

            예매 확인

        </button>


        <!-- =========================================
             홈
        ========================================== -->

        <button

            type="button"

            class="home-button"

            onclick="location.href='<%= request.getContextPath() %>/Index.jsp';">

            홈으로

        </button>


    </div>

</div>


<script>

function openMobileTicket() {


    var url =

        "<%= request.getContextPath() %>"
        +
        "/member/MobileTicket.do"
        +
        "?memberId="
        +
        encodeURIComponent(
            "<%= memberId %>"
        )
        +
        "&movieId="
        +
        encodeURIComponent(
            "<%= movieId %>"
        )
        +
        "&screeningId="
        +
        encodeURIComponent(
            "<%= screeningId %>"
        )
        +
        "&reservationDate="
        +
        encodeURIComponent(
            "<%= reservationDate %>"
        )
        +
        "&seats="
        +
        encodeURIComponent(
            "<%= seats %>"
        )
        +
        "&amount="
        +
        encodeURIComponent(
            "<%= amount %>"
        );


    location.href = url;

}

</script>


</body>

</html>