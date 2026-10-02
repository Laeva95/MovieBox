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

<title>영화 예매 - Movie Box</title>


<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css">


<style>

/* =========================================
   전체
========================================= */

.booking-container {

    width: 1000px;

    margin: 40px auto 80px;

    padding: 40px;

    background-color: white;

    border: 1px solid #ddd;

    border-radius: 10px;
}


/* =========================================
   제목
========================================= */

.booking-title {

    text-align: center;

    margin-bottom: 40px;
}


/* =========================================
   영화 선택
========================================= */

.movie-select-area {

    margin-bottom: 40px;
}


.movie-select-area h2 {

    margin-bottom: 20px;
}


/* =========================================
   영화 목록
========================================= */

.movie-list {

    display: grid;

    grid-template-columns: repeat(5, 1fr);

    gap: 15px;
}


/* =========================================
   영화 카드
========================================= */

.movie-card {

    border: 2px solid #ddd;

    border-radius: 8px;

    overflow: hidden;

    cursor: pointer;

    background-color: white;

    transition: 0.2s;
}


.movie-card:hover {

    transform: translateY(-5px);

    border-color: #e50914;
}


.movie-card.selected {

    border-color: #e50914;

    box-shadow: 0 0 0 2px #e50914;
}


/* =========================================
   포스터
========================================= */

.movie-poster {

    width: 100%;

    height: 230px;

    object-fit: cover;

    display: block;
}


/* =========================================
   영화 이름
========================================= */

.movie-name {

    padding: 10px;

    font-size: 15px;

    font-weight: bold;
}


/* =========================================
   영화 정보
========================================= */

.movie-meta {

    padding: 0 10px 10px;

    color: #777;

    font-size: 12px;
}


/* =========================================
   선택된 영화 정보
========================================= */

.selected-movie {

    display: flex;

    gap: 25px;

    padding: 25px;

    margin-bottom: 35px;

    background-color: #f8f8f8;

    border: 1px solid #ddd;

    border-radius: 8px;
}


.selected-poster {

    width: 140px;

    height: 200px;

    object-fit: cover;

    border-radius: 6px;
}


.selected-info {

    padding-top: 10px;
}


.selected-info h2 {

    margin-bottom: 20px;
}


.selected-info p {

    margin: 8px 0;
}


/* =========================================
   선택 영역
========================================= */

.select-area {

    margin-top: 30px;

    scroll-margin-top: 30px;
}


.select-area h3 {

    margin-bottom: 15px;
}


/* =========================================
   날짜 선택
========================================= */

.date-select {

    display: flex;

    align-items: center;

    gap: 15px;

    margin-bottom: 30px;
}


.date-select label {

    font-size: 16px;

    font-weight: bold;
}


.date-select input {

    width: 190px;

    height: 45px;

    padding: 0 12px;

    border: 1px solid #ccc;

    border-radius: 5px;

    font-size: 14px;

    background-color: white;
}


/* =========================================
   선택 버튼
========================================= */

.select-box {

    display: flex;

    gap: 10px;

    flex-wrap: wrap;
}


.select-box input {

    display: none;
}


.select-box label {

    display: inline-block;

    padding: 12px 20px;

    border: 1px solid #ccc;

    border-radius: 5px;

    cursor: pointer;

    background-color: white;
}


.select-box input:checked + label {

    background-color: #e50914;

    color: white;

    border-color: #e50914;
}


/* =========================================
   지난 시간
========================================= */

.select-box input:disabled + label {

    background-color: #eeeeee;

    color: #999;

    border-color: #ddd;

    cursor: not-allowed;

    text-decoration: line-through;
}


/* =========================================
   버튼
========================================= */

.button-area {

    text-align: center;

    margin-top: 50px;
}


.button-area button {

    width: 250px;

    padding: 15px;

    border: none;

    border-radius: 5px;

    background-color: #e50914;

    color: white;

    font-size: 16px;

    cursor: pointer;
}


.button-area button:hover {

    background-color: #b20710;
}


/* =========================================
   영화 없음
========================================= */

.no-movie {

    text-align: center;

    padding: 30px;

    color: #777;
}

</style>

</head>


<body>


<div class="booking-container">


    <!-- =========================================
         제목
    ========================================== -->

    <h1 class="booking-title">

        영화 예매

    </h1>


    <!-- =========================================
         1. 영화 선택
    ========================================== -->

    <div class="movie-select-area">

        <h2>

            1. 영화 선택

        </h2>


        <div class="movie-list">


<%

    if (movieList != null
            && !movieList.isEmpty()) {


        for (MovieDTO movie : movieList) {


            boolean selected = false;


            if (selectedMovie != null
                    && selectedMovie.getMovieId()
                    == movie.getMovieId()) {

                selected = true;
            }


            // ====================================
            // 포스터 경로
            // ====================================

            String posterUrl =
                    movie.getPosterUrl();

            String posterPath =
                    posterUrl;


            if (posterUrl != null
                    && !posterUrl.trim().isEmpty()) {


                posterUrl =
                        posterUrl.trim();


                if (posterUrl.startsWith("http://")
                        || posterUrl.startsWith("https://")) {

                    posterPath =
                            posterUrl;

                }

                else if (posterUrl.startsWith(
                        contextPath + "/")) {

                    posterPath =
                            posterUrl;

                }

                else if (posterUrl.startsWith("/")) {

                    posterPath =
                            contextPath
                            + posterUrl;

                }

                else if (posterUrl.startsWith("poster/")) {

                    posterPath =
                            contextPath
                            + "/"
                            + posterUrl;

                }

                else {

                    posterPath =
                            contextPath
                            + "/poster/"
                            + posterUrl;
                }
            }

%>


            <!-- 영화 카드 -->

            <div class="movie-card <%= selected ? "selected" : "" %>"
                 onclick="selectMovie(<%= movie.getMovieId() %>)">


                <img class="movie-poster"
                     src="<%= posterPath %>"
                     alt="<%= movie.getTitle() %>">


                <div class="movie-name">

                    <%= movie.getTitle() %>

                </div>


                <div class="movie-meta">

                    <%= movie.getGenre() %>

                    |

                    <%= movie.getCountry() %>

                </div>


            </div>


<%

        }


    } else {

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


        if (selectedPosterUrl != null
                && !selectedPosterUrl.trim().isEmpty()) {


            selectedPosterUrl =
                    selectedPosterUrl.trim();


            if (selectedPosterUrl.startsWith("http://")
                    || selectedPosterUrl.startsWith("https://")) {

                selectedPosterPath =
                        selectedPosterUrl;

            }

            else if (selectedPosterUrl.startsWith(
                    contextPath + "/")) {

                selectedPosterPath =
                        selectedPosterUrl;

            }

            else if (selectedPosterUrl.startsWith("/")) {

                selectedPosterPath =
                        contextPath
                        + selectedPosterUrl;

            }

            else if (selectedPosterUrl.startsWith("poster/")) {

                selectedPosterPath =
                        contextPath
                        + "/"
                        + selectedPosterUrl;

            }

            else {

                selectedPosterPath =
                        contextPath
                        + "/poster/"
                        + selectedPosterUrl;
            }
        }

%>


    <!-- =========================================
         2. 선택한 영화 정보
    ========================================== -->

    <div class="selected-movie">


        <img class="selected-poster"
             src="<%= selectedPosterPath %>"
             alt="<%= selectedMovie.getTitle() %>">


        <div class="selected-info">


            <h2>

                <%= selectedMovie.getTitle() %>

            </h2>


            <p>

                장르 :

                <%= selectedMovie.getGenre() %>

            </p>


            <p>

                국가 :

                <%= selectedMovie.getCountry() %>

            </p>


            <p>

                개봉일 :

                <%= selectedMovie.getReleaseDate() %>

            </p>


            <p>

                러닝타임 :

                <%= selectedMovie.getRunningTime() %>

            </p>


        </div>

    </div>



    <!-- =========================================
         3. 예매 정보 선택
    ========================================== -->

    <form
        action="${pageContext.request.contextPath}/reservation/seat"
        method="get">


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
            value="<%= selectedMovie.getMovieId() %>">


        <!-- =====================================
             날짜 선택
        ====================================== -->

        <div class="select-area">


            <h3>

                2. 예매 날짜 선택

            </h3>


            <div class="date-select">


                <label for="reservationDate">

                    날짜

                </label>


                <input
                    type="date"
                    id="reservationDate"
                    name="reservationDate"
                    value="<%= today %>"
                    min="<%= today %>"
                    max="<%= maxDate %>"
                    required>


            </div>

        </div>



        <!-- =====================================
             상영시간 선택
        ====================================== -->

        <div class="select-area" id="selectArea">


            <h3>

                3. 상영시간 선택

            </h3>


            <div class="select-box">


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



                <input
                    type="radio"
                    name="screeningId"
                    value="2"
                    id="time2"
                    data-time="13:00">


                <label for="time2">

                    13:00

                </label>



                <input
                    type="radio"
                    name="screeningId"
                    value="3"
                    id="time3"
                    data-time="16:00">


                <label for="time3">

                    16:00

                </label>



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
             좌석 선택 버튼
        ====================================== -->

        <div class="button-area">


            <button type="submit">

                좌석 선택

            </button>


        </div>


    </form>



<%

    } else {

%>


    <!-- =========================================
         영화 미선택
    ========================================== -->

    <div class="no-movie">

        위에서 예매할 영화를 선택해주세요.

    </div>


<%

    }

%>


</div>



<script>


/* =========================================
   영화 선택
========================================= */

function selectMovie(movieId) {

    var contextPath =
            "${pageContext.request.contextPath}";


    location.href =
            contextPath
            + "/movie/booking.jsp?movie_id="
            + movieId;
}


/* =========================================
   현재 날짜를 YYYY-MM-DD 형식으로 가져오기
========================================= */

function getTodayString() {

    var today =
            new Date();


    var year =
            today.getFullYear();


    var month =
            String(today.getMonth() + 1).padStart(2, "0");


    var day =
            String(today.getDate()).padStart(2, "0");


    return year + "-" + month + "-" + day;
}


/* =========================================
   지난 상영시간 비활성화
========================================= */

function checkPastTime() {

    var dateInput =
            document.getElementById("reservationDate");


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


    timeInputs.forEach(function(input) {


        var showTime =
                input.getAttribute("data-time");


        var time =
                showTime.split(":");


        var showHour =
                parseInt(time[0]);


        var showMinute =
                parseInt(time[1]);


        /*
         * 오늘 날짜인 경우
         * 현재 시간보다 이전인 상영시간은 비활성화
         */

        if (selectedDate === todayString) {


            if (
                showHour < currentHour
                ||
                (
                    showHour === currentHour
                    &&
                    showMinute <= currentMinute
                )
            ) {

                input.disabled = true;

                input.checked = false;

            }

            else {

                input.disabled = false;

            }


        }

        /*
         * 미래 날짜라면
         * 모든 상영시간 선택 가능
         */

        else {

            input.disabled = false;

        }

    });
}


/* =========================================
   날짜 변경
========================================= */

var reservationDate =
        document.getElementById("reservationDate");


if (reservationDate) {

    reservationDate.addEventListener(
        "change",
        checkPastTime
    );
}


/* =========================================
   페이지 로딩
========================================= */

window.onload = function() {


    checkPastTime();


    var selectArea =
            document.getElementById("selectArea");


    if (selectArea) {

        selectArea.scrollIntoView({

            behavior: "smooth",

            block: "start"

        });
    }

};


</script>


</body>

</html>