<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="movie.MovieDTO" %>
<%@ page import="movie.MovieDAO" %>

<%

    // ====================================================
    // 영화 DAO
    // ====================================================

    MovieDAO dao = new MovieDAO();



    // ====================================================
    // 영화 목록 가져오기
    // ====================================================

    List<MovieDTO> movieList =
            dao.getMovieList();



    // ====================================================
    // URL에서 선택한 영화 번호 받기
    // ====================================================

    String movieIdStr =
            request.getParameter("movie_id");

    MovieDTO selectedMovie = null;


    if (movieIdStr != null
            && !movieIdStr.isEmpty()) {

        try {

            int movieId =
                    Integer.parseInt(movieIdStr);

            selectedMovie =
                    dao.getMovieDetails(movieId);

        } catch (NumberFormatException e) {

            selectedMovie = null;

        }

    }



    // ====================================================
    // 로그인 회원 ID
    // ====================================================

    String memberId = "";

    Object loginMemberId =
            session.getAttribute("id");


    if (loginMemberId != null) {

        memberId =
                loginMemberId.toString();

    }



    // ====================================================
    // contextPath
    // ====================================================

    String contextPath =
            request.getContextPath();



    // ====================================================
    // 예약 날짜
    // 오늘 날짜를 기본으로 표시
    // ====================================================

    java.time.LocalDate today =
            java.time.LocalDate.now();



    // ====================================================
    // 예약 가능 날짜
    // 오늘부터 7일 뒤까지만 예약 가능
    // ====================================================

    java.time.LocalDate maxDate =
            today.plusDays(7);

%>


<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">


<meta name="viewport"
      content="width=device-width, initial-scale=1.0">


<title>
    영화 예매 - Movie Box
</title>



<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css">



<style>

/* =========================================================
   전체
========================================================= */

* {

    box-sizing: border-box;

}


body {

    margin: 0;

    background:
        linear-gradient(
            180deg,
            #0d0d0d 0%,
            #151515 45%,
            #0d0d0d 100%
        );

    color: #fff;

    font-family:
        Arial,
        "Noto Sans KR",
        sans-serif;

    min-height: 100vh;

}



/* =========================================================
   전체 컨테이너
========================================================= */

.booking-container {

    width: 1200px;

    max-width:
        calc(100% - 40px);

    margin:
        50px auto 80px;

}



/* =========================================================
   상단 제목
========================================================= */

.booking-header {

    margin-bottom: 35px;

}


.booking-header .sub-title {

    color: #e50914;

    font-size: 13px;

    font-weight: bold;

    letter-spacing: 2px;

    margin-bottom: 8px;

}


.booking-header h1 {

    margin: 0;

    font-size: 34px;

    font-weight: 700;

}


.booking-header p {

    margin:
        12px 0 0;

    color: #999;

    font-size: 14px;

}



/* =========================================================
   진행 단계
========================================================= */

.booking-step {

    display: flex;

    align-items: center;

    margin-bottom: 35px;

    padding: 18px 22px;

    background-color: #191919;

    border: 1px solid #2b2b2b;

    border-radius: 10px;

}


.step-item {

    display: flex;

    align-items: center;

    gap: 9px;

    color: #777;

    font-size: 14px;

    font-weight: bold;

}


.step-item.active {

    color: #fff;

}


.step-number {

    width: 28px;

    height: 28px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 50%;

    background-color: #333;

    color: #999;

    font-size: 12px;

}


.step-item.active .step-number {

    background-color: #e50914;

    color: #fff;

}


.step-line {

    flex: 1;

    height: 1px;

    margin: 0 18px;

    background-color: #333;

}



/* =========================================================
   영화 선택 영역
========================================================= */

.movie-select-area {

    margin-bottom: 30px;

}


.section-title {

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 18px;

}


.section-title h2 {

    margin: 0;

    font-size: 19px;

}


.section-title span {

    color: #777;

    font-size: 13px;

}



/* =========================================================
   영화 목록
========================================================= */

.movie-list {

    display: grid;

    grid-template-columns:
        repeat(5, 1fr);

    gap: 16px;

}



/* =========================================================
   영화 카드
========================================================= */

.movie-card {

    overflow: hidden;

    background-color: #1a1a1a;

    border: 1px solid #2c2c2c;

    border-radius: 10px;

    cursor: pointer;

    transition:
        transform 0.2s,
        border-color 0.2s,
        box-shadow 0.2s;

}


.movie-card:hover {

    transform: translateY(-4px);

    border-color: #777;

}


.movie-card.selected {

    border: 2px solid #e50914;

    box-shadow:
        0 0 0 1px #e50914,
        0 8px 25px rgba(
            229,
            9,
            20,
            0.18
        );

}



/* =========================================================
   포스터
========================================================= */

.movie-poster {

    display: block;

    width: 100%;

    height: 270px;

    object-fit: cover;

    background-color: #222;

}



/* =========================================================
   영화 이름
========================================================= */

.movie-name {

    padding:
        13px 13px 5px;

    font-size: 15px;

    font-weight: bold;

    white-space: nowrap;

    overflow: hidden;

    text-overflow: ellipsis;

}



/* =========================================================
   영화 정보
========================================================= */

.movie-meta {

    padding:
        0 13px 14px;

    color: #777;

    font-size: 12px;

}



/* =========================================================
   영화가 없을 경우
========================================================= */

.no-movie {

    padding: 50px 20px;

    text-align: center;

    background-color: #181818;

    border: 1px solid #2b2b2b;

    border-radius: 10px;

    color: #777;

}



/* =========================================================
   AI 영화 추천
========================================================= */

.ai-recommendation {

    margin-bottom: 30px;

    padding: 25px;

    background-color: #191919;

    border: 1px solid #2c2c2c;

    border-radius: 10px;

}


.ai-recommendation-header {

    display: flex;

    align-items: center;

    justify-content: space-between;

    margin-bottom: 18px;

}


.ai-recommendation-title {

    display: flex;

    align-items: center;

    gap: 9px;

}


.ai-recommendation-title h2 {

    margin: 0;

    font-size: 19px;

}


.ai-badge {

    padding:
        4px 8px;

    border-radius: 5px;

    background-color: #2a2a2a;

    color: #e50914;

    font-size: 11px;

    font-weight: bold;

}


.ai-recommendation-header p {

    margin: 0;

    color: #777;

    font-size: 12px;

}



/* =========================================================
   AI 입력
========================================================= */

.ai-input-area {

    display: flex;

    gap: 10px;

}


.ai-input {

    flex: 1;

    height: 46px;

    padding:
        0 14px;

    border: 1px solid #3a3a3a;

    border-radius: 6px;

    outline: none;

    background-color: #101010;

    color: #fff;

    font-size: 14px;

}


.ai-input:focus {

    border-color: #e50914;

}


.ai-input::placeholder {

    color: #666;

}


.ai-button {

    width: 110px;

    height: 46px;

    border: none;

    border-radius: 6px;

    background-color: #e50914;

    color: #fff;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

}


.ai-button:hover {

    background-color: #b20710;

}


.ai-button:disabled {

    background-color: #444;

    color: #888;

    cursor: not-allowed;

}



/* =========================================================
   추천 예시 버튼
========================================================= */

.ai-examples {

    display: flex;

    flex-wrap: wrap;

    gap: 8px;

    margin-top: 12px;

}


.ai-example {

    padding:
        7px 11px;

    border: 1px solid #333;

    border-radius: 20px;

    background-color: #111;

    color: #999;

    font-size: 12px;

    cursor: pointer;

}


.ai-example:hover {

    border-color: #777;

    color: #fff;

}



/* =========================================================
   AI 결과
========================================================= */

.ai-result {

    display: none;

    margin-top: 20px;

    padding: 18px;

    border:
        1px solid #2f2f2f;

    border-radius: 7px;

    background-color: #101010;

    white-space: pre-wrap;

    line-height: 1.7;

    color: #ddd;

    font-size: 14px;

}


.ai-result.show {

    display: block;

}


.ai-result-title {

    margin-bottom: 10px;

    color: #e50914;

    font-size: 13px;

    font-weight: bold;

}



/* =========================================================
   선택 정보 + 예매 설정
========================================================= */

.booking-content {

    display: grid;

    grid-template-columns:
        minmax(0, 1fr)
        390px;

    gap: 22px;

}



/* =========================================================
   선택한 영화
========================================================= */

.selected-movie {

    display: flex;

    gap: 25px;

    min-height: 310px;

    padding: 25px;

    background-color: #191919;

    border: 1px solid #2c2c2c;

    border-radius: 10px;

}


.selected-poster {

    width: 180px;

    height: 260px;

    object-fit: cover;

    border-radius: 7px;

    background-color: #222;

}


.selected-info {

    padding-top: 4px;

}


.selected-info .selected-label {

    color: #e50914;

    font-size: 12px;

    font-weight: bold;

    margin-bottom: 10px;

}


.selected-info h2 {

    margin:
        0 0 22px;

    font-size: 26px;

}


.selected-info p {

    margin: 10px 0;

    color: #aaa;

    font-size: 14px;

}


.selected-info p strong {

    display: inline-block;

    width: 55px;

    color: #777;

}



/* =========================================================
   예매 설정 카드
========================================================= */

.booking-option {

    padding: 25px;

    background-color: #191919;

    border: 1px solid #2c2c2c;

    border-radius: 10px;

}


.option-title {

    margin-bottom: 20px;

}


.option-title h3 {

    margin: 0;

    font-size: 17px;

}


.option-title p {

    margin:
        7px 0 0;

    color: #777;

    font-size: 12px;

}



/* =========================================================
   날짜
========================================================= */

.date-select {

    margin-bottom: 25px;

}


.date-select label {

    display: block;

    margin-bottom: 10px;

    color: #bbb;

    font-size: 13px;

    font-weight: bold;

}


.date-input-wrap {

    position: relative;

    width: 100%;

}


.date-select input {

    width: 100%;

    height: 46px;

    padding:
        0 45px 0 12px;

    border:
        1px solid #3a3a3a;

    border-radius: 6px;

    outline: none;

    background-color: #101010;

    color: #fff;

    font-size: 14px;

    color-scheme: dark;

}


.date-select input:focus {

    border-color: #e50914;

}


.date-select input::-webkit-calendar-picker-indicator {

    opacity: 0;

    cursor: pointer;

}



/* =========================================================
   달력 버튼
========================================================= */

.calendar-button {

    position: absolute;

    right: 8px;

    top: 50%;

    transform:
        translateY(-50%);

    width: 34px;

    height: 34px;

    padding: 0;

    border: none;

    border-radius: 5px;

    background: transparent;

    color: #fff;

    cursor: pointer;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 19px;

}


.calendar-button:hover {

    background-color: #252525;

}



/* =========================================================
   상영시간
========================================================= */

.time-select {

    margin-bottom: 25px;

}


.time-select > label {

    display: block;

    margin-bottom: 10px;

    color: #bbb;

    font-size: 13px;

    font-weight: bold;

}


.select-box {

    display: grid;

    grid-template-columns:
        repeat(2, 1fr);

    gap: 9px;

}


.select-box input {

    display: none;

}


.select-box label {

    padding: 12px 10px;

    text-align: center;

    border: 1px solid #3a3a3a;

    border-radius: 6px;

    background-color: #101010;

    color: #aaa;

    font-size: 14px;

    cursor: pointer;

    transition: 0.2s;

}


.select-box label:hover {

    border-color: #777;

    color: #fff;

}


.select-box input:checked
+ label {

    background-color: #e50914;

    border-color: #e50914;

    color: #fff;

    font-weight: bold;

}



/* =========================================================
   지난 시간
========================================================= */

.select-box input:disabled
+ label {

    background-color: #222;

    border-color: #2c2c2c;

    color: #555;

    cursor: not-allowed;

    text-decoration: line-through;

}



/* =========================================================
   좌석 선택 버튼
========================================================= */

.button-area {

    margin-top: 5px;

}


.button-area button {

    width: 100%;

    height: 52px;

    border: none;

    border-radius: 7px;

    background-color: #e50914;

    color: #fff;

    font-size: 15px;

    font-weight: bold;

    cursor: pointer;

    transition:
        background-color 0.2s,
        transform 0.2s;

}


.button-area button:hover {

    background-color: #b20710;

    transform: translateY(-1px);

}



/* =========================================================
   영화 미선택 상태
========================================================= */

.empty-content {

    margin-top: 10px;

    padding: 60px 20px;

    background-color: #191919;

    border: 1px solid #2c2c2c;

    border-radius: 10px;

    text-align: center;

    color: #666;

}



/* =========================================================
   반응형
========================================================= */

@media (max-width: 1000px) {

    .movie-list {

        grid-template-columns:
            repeat(3, 1fr);

    }


    .booking-content {

        grid-template-columns: 1fr;

    }

}



@media (max-width: 650px) {

    .booking-container {

        max-width:
            calc(100% - 20px);

        margin-top: 25px;

    }


    .booking-header h1 {

        font-size: 27px;

    }


    .booking-step {

        padding: 14px;

    }


    .step-line {

        margin: 0 8px;

    }


    .step-item {

        font-size: 12px;

        gap: 5px;

    }


    .step-number {

        width: 24px;

        height: 24px;

    }


    .movie-list {

        grid-template-columns:
            repeat(2, 1fr);

    }


    .movie-poster {

        height: 220px;

    }


    .selected-movie {

        flex-direction: column;

        align-items: center;

        text-align: center;

    }


    .selected-info p strong {

        width: auto;

        margin-right: 5px;

    }


    .ai-input-area {

        flex-direction: column;

    }


    .ai-button {

        width: 100%;

    }

}

</style>

</head>



<body>



<div class="booking-container">



    <!-- =================================================
         상단 제목
    ================================================== -->

    <div class="booking-header">

        <div class="sub-title">

            MOVIE BOX

        </div>


        <h1>

            영화 예매

        </h1>


        <p>

            원하는 영화와 날짜, 상영시간을 선택해주세요.

        </p>

    </div>



    <!-- =================================================
         진행 단계
    ================================================== -->

    <div class="booking-step">


        <div class="step-item active">

            <div class="step-number">

                1

            </div>

            영화 선택

        </div>



        <div class="step-line">

        </div>



        <div class="step-item active">

            <div class="step-number">

                2

            </div>

            날짜 선택

        </div>



        <div class="step-line">

        </div>



        <div class="step-item active">

            <div class="step-number">

                3

            </div>

            상영시간 선택

        </div>



        <div class="step-line">

        </div>



        <div class="step-item">

            <div class="step-number">

                4

            </div>

            좌석 선택

        </div>


    </div>



    <!-- =================================================
         1. 영화 선택
    ================================================== -->

    <div class="movie-select-area">


        <div class="section-title">


            <h2>

                1. 영화 선택

            </h2>


            <span>

                영화를 선택하세요

            </span>


        </div>



        <div class="movie-list">



<%

    if (movieList != null

            && !movieList.isEmpty()) {


        for (MovieDTO movie : movieList) {


            boolean selected =
                    false;


            if (
                selectedMovie != null
                &&
                selectedMovie.getMovieId()
                ==
                movie.getMovieId()
            ) {

                selected =
                        true;

            }



            // =========================================
            // 포스터 경로
            // =========================================

            String posterUrl =
                    movie.getPosterUrl();


            String posterPath =
                    posterUrl;


            if (
                posterUrl != null
                &&
                !posterUrl.trim().isEmpty()
            ) {


                posterUrl =
                        posterUrl.trim();


                if (
                    posterUrl.startsWith(
                        "http://"
                    )
                    ||
                    posterUrl.startsWith(
                        "https://"
                    )
                ) {

                    posterPath =
                            posterUrl;

                }


                else if (
                    posterUrl.startsWith(
                        contextPath + "/"
                    )
                ) {

                    posterPath =
                            posterUrl;

                }


                else if (
                    posterUrl.startsWith("/")
                ) {

                    posterPath =
                            contextPath
                            +
                            posterUrl;

                }


                else if (
                    posterUrl.startsWith(
                        "poster/"
                    )
                ) {

                    posterPath =
                            contextPath
                            +
                            "/"
                            +
                            posterUrl;

                }


                else {

                    posterPath =
                            contextPath
                            +
                            "/poster/"
                            +
                            posterUrl;

                }

            }

%>



            <!-- 영화 카드 -->

            <div

                class="movie-card
                    <%= selected
                        ? "selected"
                        : "" %>"


                onclick="selectMovie(
                    <%= movie.getMovieId() %>
                )">


                <img

                    class="movie-poster"

                    src="<%= posterPath %>"

                    alt="<%= movie.getTitle() %>">


                <div class="movie-name">

                    <%= movie.getTitle() %>

                </div>


                <div class="movie-meta">

                    <%= movie.getGenre() %>

                    ·

                    <%= movie.getCountry() %>

                </div>


            </div>



<%

        }

    }

    else {

%>



        <div class="no-movie">

            등록된 영화가 없습니다.

        </div>



<%

    }

%>



        </div>


    </div>




<%

    // ====================================================
    // 영화가 선택된 경우
    // ====================================================

    if (selectedMovie != null) {



        String selectedPosterUrl =
                selectedMovie.getPosterUrl();


        String selectedPosterPath =
                selectedPosterUrl;



        if (
            selectedPosterUrl != null
            &&
            !selectedPosterUrl.trim().isEmpty()
        ) {


            selectedPosterUrl =
                    selectedPosterUrl.trim();


            if (
                selectedPosterUrl.startsWith(
                    "http://"
                )
                ||
                selectedPosterUrl.startsWith(
                    "https://"
                )
            ) {

                selectedPosterPath =
                        selectedPosterUrl;

            }


            else if (
                selectedPosterUrl.startsWith(
                    contextPath + "/"
                )
            ) {

                selectedPosterPath =
                        selectedPosterUrl;

            }


            else if (
                selectedPosterUrl.startsWith("/")
            ) {

                selectedPosterPath =
                        contextPath
                        +
                        selectedPosterUrl;

            }


            else if (
                selectedPosterUrl.startsWith(
                    "poster/"
                )
            ) {

                selectedPosterPath =
                        contextPath
                        +
                        "/"
                        +
                        selectedPosterUrl;

            }


            else {

                selectedPosterPath =
                        contextPath
                        +
                        "/poster/"
                        +
                        selectedPosterUrl;

            }

        }

%>



    <!-- =================================================
         선택한 영화 + 예매 설정
    ================================================== -->

    <form

        action="${pageContext.request.contextPath}/reservation/seat"

        method="get">



        <!-- 회원 ID -->

        <input

            type="hidden"

            name="memberId"

            value="<%= memberId %>">



        <!-- 영화 ID -->

        <input

            type="hidden"

            name="movieId"

            value="<%= selectedMovie.getMovieId() %>">



        <div class="booking-content">



            <!-- =========================================
                 선택한 영화
            ========================================== -->

            <div class="selected-movie">



                <img

                    class="selected-poster"

                    src="<%= selectedPosterPath %>"

                    alt="<%= selectedMovie.getTitle() %>">



                <div class="selected-info">


                    <div class="selected-label">

                        SELECTED MOVIE

                    </div>



                    <h2>

                        <%= selectedMovie.getTitle() %>

                    </h2>



                    <p>

                        <strong>

                            장르

                        </strong>

                        <%= selectedMovie.getGenre() %>

                    </p>



                    <p>

                        <strong>

                            국가

                        </strong>

                        <%= selectedMovie.getCountry() %>

                    </p>



                    <p>

                        <strong>

                            개봉일

                        </strong>

                        <%= selectedMovie.getReleaseDate() %>

                    </p>



                    <p>

                        <strong>

                            러닝타임

                        </strong>

                        <%= selectedMovie.getRunningTime() %>

                    </p>


                </div>


            </div>



            <!-- =========================================
                 예매 설정
            ========================================== -->

            <div

                class="booking-option"

                id="nextSelectArea">



                <div class="option-title">


                    <h3>

                        예매 정보 선택

                    </h3>


                    <p>

                        날짜와 상영시간을 선택해주세요.

                    </p>


                </div>



                <!-- =====================================
                     날짜 선택
                ====================================== -->

                <div class="date-select">


                    <label for="reservationDate">

                        2. 예매 날짜

                    </label>



                    <div class="date-input-wrap">


                        <input

                            type="date"

                            id="reservationDate"

                            name="reservationDate"

                            value="<%= today %>"

                            min="<%= today %>"

                            max="<%= maxDate %>"

                            required>



                        <button

                            type="button"

                            class="calendar-button"

                            onclick="openCalendar()"

                            aria-label="달력 열기">

                            📅

                        </button>


                    </div>


                </div>



                <!-- =====================================
                     상영시간 선택
                ====================================== -->

                <div class="time-select">


                    <label>

                        3. 상영시간

                    </label>



                    <div class="select-box">



                        <!-- 10:00 -->

                        <input

                            type="radio"

                            name="screeningId"

                            value="1"

                            id="time1"

                            data-time="10:00"

                            required>


                        <label for="time1">

                            10:00

                        </label>



                        <!-- 13:00 -->

                        <input

                            type="radio"

                            name="screeningId"

                            value="2"

                            id="time2"

                            data-time="13:00">


                        <label for="time2">

                            13:00

                        </label>



                        <!-- 16:00 -->

                        <input

                            type="radio"

                            name="screeningId"

                            value="3"

                            id="time3"

                            data-time="16:00">


                        <label for="time3">

                            16:00

                        </label>



                        <!-- 19:00 -->

                        <input

                            type="radio"

                            name="screeningId"

                            value="4"

                            id="time4"

                            data-time="19:00">


                        <label for="time4">

                            19:00

                        </label>


                    </div>


                </div>



                <!-- =====================================
                     좌석 선택
                ====================================== -->

                <div class="button-area">


                    <button type="submit">

                        좌석 선택

                    </button>


                </div>


            </div>


        </div>


    </form>



<%

    }

    else {

%>



    <!-- =================================================
         영화 미선택
    ================================================== -->

    <div class="empty-content">

        위에서 예매할 영화를 선택해주세요.

    </div>



<%

    }

%>



</div>



<script>

/* =========================================================
   영화 선택
========================================================= */

function selectMovie(movieId) {


    var contextPath =
            "${pageContext.request.contextPath}";


    location.href =

            contextPath

            + "/movie/booking.jsp?movie_id="

            + movieId;

}



/* =========================================================
   AI 입력 예시
========================================================= */

function setAIPrompt(text) {


    var input =
            document.getElementById(
                "aiPrompt"
            );


    if (!input) {

        return;

    }


    input.value =
            text;


    input.focus();

}



/* =========================================================
   AI 영화 추천
========================================================= */

function getAIRecommendation() {


    var input =
            document.getElementById(
                "aiPrompt"
            );


    var button =
            document.getElementById(
                "aiButton"
            );


    var result =
            document.getElementById(
                "aiResult"
            );


    var resultText =
            document.getElementById(
                "aiResultText"
            );



    if (!input
            || !button
            || !result
            || !resultText) {

        return;

    }



    var prompt =
            input.value.trim();



    /* 입력 확인 */

    if (prompt === "") {


        alert(
            "어떤 영화를 원하는지 입력해주세요."
        );


        input.focus();


        return;

    }



    /* 버튼 비활성화 */

    button.disabled =
            true;


    button.innerText =
            "추천 중...";



    /* 기존 결과 숨기기 */

    result.classList.remove(
        "show"
    );


    resultText.innerText =
            "";



    var contextPath =
            "${pageContext.request.contextPath}";


    var url =
            contextPath
            +
            "/ai/recommendation";



    /* ====================================================
       Controller로 전송
       application/x-www-form-urlencoded 방식
       ==================================================== */

    fetch(

        url,

        {

            method:
                "POST",


            headers: {

                "Content-Type":
                    "application/x-www-form-urlencoded; charset=UTF-8"

            },


            body:

                "prompt="
                +
                encodeURIComponent(prompt)

        }

    )

    .then(

        function(response) {


            if (!response.ok) {

                throw new Error(
                    "AI 추천 요청에 실패했습니다."
                );

            }


            return response.text();

        }

    )

    .then(

        function(data) {


            resultText.innerText =
                    data;


            result.classList.add(
                "show"
            );

        }

    )

    .catch(

        function(error) {


            console.error(
                error
            );


            resultText.innerText =
                    "AI 영화 추천 중 오류가 발생했습니다.";


            result.classList.add(
                "show"
            );

        }

    )

    .finally(

        function() {


            button.disabled =
                    false;


            button.innerText =
                    "추천받기";

        }

    );

}



/* =========================================================
   엔터키로 AI 추천
========================================================= */

var aiPrompt =
        document.getElementById(
            "aiPrompt"
        );


if (aiPrompt) {


    aiPrompt.addEventListener(

        "keydown",

        function(event) {


            if (
                event.key
                ===
                "Enter"
            ) {


                event.preventDefault();


                getAIRecommendation();

            }

        }

    );

}



/* =========================================================
   현재 날짜 YYYY-MM-DD
========================================================= */

function getTodayString() {


    var today =
            new Date();


    var year =
            today.getFullYear();


    var month =
            String(
                today.getMonth() + 1
            ).padStart(2, "0");


    var day =
            String(
                today.getDate()
            ).padStart(2, "0");


    return year

            + "-"

            + month

            + "-"

            + day;

}



/* =========================================================
   지난 상영시간 비활성화
========================================================= */

function checkPastTime() {


    var dateInput =
            document.getElementById(
                "reservationDate"
            );


    if (!dateInput) {

        return;

    }


    var selectedDate =
            dateInput.value;


    var todayString =
            getTodayString();


    var timeInputs =
            document.querySelectorAll(
                'input[name="screeningId"]'
            );


    var now =
            new Date();


    var currentHour =
            now.getHours();


    var currentMinute =
            now.getMinutes();


    timeInputs.forEach(
        function(input) {


            var showTime =
                    input.getAttribute(
                        "data-time"
                    );


            var time =
                    showTime.split(":");


            var showHour =
                    parseInt(
                        time[0]
                    );


            var showMinute =
                    parseInt(
                        time[1]
                    );



            /* 오늘 */

            if (
                selectedDate
                ===
                todayString
            ) {


                if (

                    showHour < currentHour

                    ||

                    (
                        showHour
                        ===
                        currentHour

                        &&

                        showMinute
                        <=
                        currentMinute
                    )

                ) {


                    input.disabled =
                            true;


                    input.checked =
                            false;

                }


                else {


                    input.disabled =
                            false;

                }

            }


            /* 미래 */

            else {


                input.disabled =
                        false;

            }

        }
    );

}



/* =========================================================
   날짜 변경
========================================================= */

var reservationDate =

        document.getElementById(

            "reservationDate"

        );


if (reservationDate) {


    reservationDate.addEventListener(

        "change",

        function() {


            checkPastTime();


        }

    );

}



/* =========================================================
   달력 열기
========================================================= */

function openCalendar() {


    var dateInput =

            document.getElementById(

                "reservationDate"

            );


    if (!dateInput) {

        return;

    }


    /* Chrome / Edge */

    if (
        typeof dateInput.showPicker
        ===
        "function"
    ) {


        dateInput.showPicker();


    }


    /* showPicker를 지원하지 않는 경우 */

    else {


        dateInput.focus();

        dateInput.click();

    }

}



/* =========================================================
   페이지 로딩
========================================================= */

window.onload =

    function() {


        checkPastTime();


        // =========================================
        // 영화를 선택한 경우
        // 다음 선택창으로 이동
        // =========================================

        var movieId =

                "${param.movie_id}";


        var nextSelectArea =

                document.getElementById(

                    "nextSelectArea"

                );


        if (

            movieId != null

            &&

            movieId != ""

            &&

            nextSelectArea

        ) {


            setTimeout(

                function() {


                    nextSelectArea.scrollIntoView({

                        behavior:
                            "smooth",

                        block:
                            "start"

                    });


                },

                200

            );

        }

    };

</script>



</body>

</html>