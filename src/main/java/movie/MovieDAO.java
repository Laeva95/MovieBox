package movie;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;


public class MovieDAO {

    // =========================================================
    // 1. MySQL DB 연결 정보
    // =========================================================

    private final String URL =
            "jdbc:mysql://localhost:3306/moviebox"
            + "?serverTimezone=Asia/Seoul"
            + "&characterEncoding=UTF-8";

    private final String USER = "teamid";

    private final String PASS = "teampass";


    // =========================================================
    // 2. KMDb API KEY
    // =========================================================

    private final String SERVICE_KEY =
            "E2R512K63ELVY49O4AF4";


    // =========================================================
    // 3. KMDb API → 영화 목록 가져오기
    // =========================================================

    public List<MovieDTO> getMovieListFromAPI() {

        List<MovieDTO> list = new ArrayList<>();

        Map<String, MovieData> movieMap =
                new LinkedHashMap<>();

        try {

            // -------------------------------------------------
            // 오늘 날짜
            // -------------------------------------------------

            LocalDate today = LocalDate.now();

            int currentYear = today.getYear();

            String todayStr =
                    today.format(
                            DateTimeFormatter.ofPattern("yyyyMMdd")
                    );


            // -------------------------------------------------
            // 올해 1월 1일 ~ 오늘
            // -------------------------------------------------

            String releaseDtsParam =
                    currentYear + "0101~" + todayStr;


            // -------------------------------------------------
            // KMDb API 검색 조건
            // -------------------------------------------------

            String query =
                    URLEncoder.encode("", "UTF-8");

            String useParam =
                    URLEncoder.encode("극장용", "UTF-8");


            // -------------------------------------------------
            // API URL
            // -------------------------------------------------

            String urlStr =
                    "http://api.koreafilm.or.kr"
                    + "/openapi-data2/wisenut/search_api/search_json2.jsp"
                    + "?collection=kmdb_new2"
                    + "&ServiceKey=" + SERVICE_KEY
                    + "&detail=Y"
                    + "&query=" + query
                    + "&releaseDts=" + releaseDtsParam
                    + "&use=" + useParam
                    + "&listCount=500";


            System.out.println(
                    "================================="
            );

            System.out.println(
                    "KMDb API 요청"
            );

            System.out.println(
                    "개봉일 : " + releaseDtsParam
            );

            System.out.println(
                    "================================="
            );


            // -------------------------------------------------
            // HTTP 연결
            // -------------------------------------------------

            URL url = new URL(urlStr);

            HttpURLConnection conn =
                    (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("GET");

            conn.setRequestProperty(
                    "Content-type",
                    "application/json"
            );

            conn.setConnectTimeout(5000);

            conn.setReadTimeout(10000);


            int responseCode =
                    conn.getResponseCode();


            System.out.println(
                    "KMDb 응답 코드 : " + responseCode
            );


            BufferedReader rd;


            if (responseCode >= 200
                    && responseCode < 300) {

                rd = new BufferedReader(
                        new InputStreamReader(
                                conn.getInputStream(),
                                "UTF-8"
                        )
                );

            } else {

                if (conn.getErrorStream() == null) {

                    return list;
                }

                rd = new BufferedReader(
                        new InputStreamReader(
                                conn.getErrorStream(),
                                "UTF-8"
                        )
                );
            }


            // -------------------------------------------------
            // JSON 문자열 생성
            // -------------------------------------------------

            StringBuilder sb =
                    new StringBuilder();

            String line;

            while ((line = rd.readLine()) != null) {

                sb.append(line);

            }

            rd.close();

            conn.disconnect();


            String jsonResult =
                    sb.toString();


            if (jsonResult.isEmpty()) {

                return list;
            }


            if (responseCode < 200
                    || responseCode >= 300) {

                System.out.println(
                        "KMDb API 오류 : "
                        + jsonResult
                );

                return list;
            }


            // -------------------------------------------------
            // JSON 파싱
            // -------------------------------------------------

            JsonObject root =
                    JsonParser
                            .parseString(jsonResult)
                            .getAsJsonObject();


            if (!root.has("Data")) {

                return list;
            }


            JsonArray dataArray =
                    root.getAsJsonArray("Data");


            if (dataArray.size() == 0) {

                return list;
            }


            JsonObject dataObject =
                    dataArray
                            .get(0)
                            .getAsJsonObject();


            if (!dataObject.has("Result")) {

                return list;
            }


            JsonArray resultArray =
                    dataObject
                            .getAsJsonArray("Result");


            // =================================================
            // 영화 하나씩 처리
            // =================================================

            for (JsonElement element : resultArray) {

                try {

                    if (!element.isJsonObject()) {

                        continue;
                    }


                    JsonObject movie =
                            element.getAsJsonObject();


                    // -------------------------------------------------
                    // 제목
                    // -------------------------------------------------

                    String title =
                            getString(
                                    movie,
                                    "title"
                            );


                    title = title
                            .replace("!HS", "")
                            .replace("!HE", "")
                            .trim();


                    if (title.isEmpty()) {

                        continue;
                    }


                    // -------------------------------------------------
                    // 극장용 영화
                    // -------------------------------------------------

                    String use =
                            getString(
                                    movie,
                                    "use"
                            );


                    if (!use.isEmpty()
                            && !use.contains("극장용")) {

                        continue;
                    }


                    // -------------------------------------------------
                    // 개봉일
                    // -------------------------------------------------

                    String releaseDate =
                            getReleaseDate(movie);


                    if (releaseDate.isEmpty()) {

                        continue;
                    }


                    LocalDate movieDate;

                    try {

                        movieDate =
                                LocalDate.parse(
                                        releaseDate
                                );

                    } catch (Exception e) {

                        continue;
                    }


                    LocalDate startDate =
                            LocalDate.of(
                                    currentYear,
                                    1,
                                    1
                            );


                    // 올해 영화만
                    if (movieDate.isBefore(startDate)
                            || movieDate.isAfter(today)) {

                        continue;
                    }


                    // -------------------------------------------------
                    // 포스터
                    // -------------------------------------------------

                    String poster =
                            getString(
                                    movie,
                                    "posters"
                            );


                    if (poster.isEmpty()) {

                        continue;
                    }


                    // 포스터가 여러 개라면 첫 번째 사용
                    if (poster.contains("|")) {

                        poster =
                                poster
                                        .split("\\|")[0]
                                        .trim();
                    }


                    // -------------------------------------------------
                    // 기본 정보
                    // -------------------------------------------------

                    String genre =
                            getString(
                                    movie,
                                    "genre"
                            );


                    String country =
                            getString(
                                    movie,
                                    "nation"
                            );


                    String runningTime =
                            getString(
                                    movie,
                                    "runtime"
                            );


                    // -------------------------------------------------
                    // 상세 정보
                    // -------------------------------------------------

                    String director =
                            getDirector(movie);


                    String actors =
                            getActors(movie);


                    String summary =
                            getPlot(movie);


                    // -------------------------------------------------
                    // 임시 객체
                    // -------------------------------------------------

                    MovieData data =
                            new MovieData();


                    data.title =
                            title;

                    data.genre =
                            genre;

                    data.runningTime =
                            runningTime;

                    data.poster =
                            poster;

                    data.country =
                            country;

                    data.releaseDate =
                            releaseDate;

                    data.director =
                            director;

                    data.actors =
                            actors;

                    data.summary =
                            summary;


                    // -------------------------------------------------
                    // 중복 제거
                    // -------------------------------------------------

                    String uniqueKey =
                            title + "|" + releaseDate;


                    movieMap.putIfAbsent(
                            uniqueKey,
                            data
                    );


                } catch (Exception e) {

                    // 영화 한 편에 오류가 있어도
                    // 다른 영화는 계속 처리
                    continue;
                }
            }


            // =========================================================
            // 최신 개봉일 순 정렬
            // =========================================================

            List<MovieData> tempList =
                    new ArrayList<>(
                            movieMap.values()
                    );


            tempList.sort(
                    Comparator.comparing(
                            (MovieData m)
                                    -> m.releaseDate,
                            Comparator.reverseOrder()
                    )
            );


            // =========================================================
            // MovieDTO 생성
            // =========================================================

            int movieId = 1;


            for (MovieData data : tempList) {

                if (list.size() >= 50) {

                    break;
                }


                MovieDTO dto =
                        new MovieDTO(

                                movieId++,

                                data.title,

                                data.genre,

                                data.runningTime,

                                data.poster,

                                data.country,

                                data.releaseDate,

                                data.director,

                                data.actors,

                                data.summary
                        );


                list.add(dto);
            }


            System.out.println(
                    "KMDb 영화 "
                    + list.size()
                    + "편 가져오기 완료"
            );


        } catch (Exception e) {

            e.printStackTrace();
        }


        return list;
    }


    // =========================================================
    // 4. 임시 영화 데이터 클래스
    // =========================================================

    private static class MovieData {

        String title;

        String genre;

        String runningTime;

        String poster;

        String country;

        String releaseDate;

        String director;

        String actors;

        String summary;
    }


    // =========================================================
    // 5. JSON String 가져오기
    // =========================================================

    private String getString(
            JsonObject object,
            String key
    ) {

        try {

            if (object.has(key)
                    && !object.get(key).isJsonNull()) {

                return object
                        .get(key)
                        .getAsString()
                        .trim();
            }

        } catch (Exception e) {

        }

        return "";
    }


    // =========================================================
    // 6. 개봉일 가져오기
    // =========================================================

    private String getReleaseDate(
            JsonObject movie
    ) {

        try {

            String releaseDate =
                    getString(
                            movie,
                            "releaseDate"
                    );


            String validDate =
                    extractValidDate(
                            releaseDate
                    );


            if (!validDate.isEmpty()) {

                return validDate;
            }


            if (movie.has("ratings")
                    && movie.get("ratings")
                            .isJsonObject()) {

                JsonObject ratings =
                        movie.getAsJsonObject(
                                "ratings"
                        );


                if (ratings.has("rating")
                        && ratings.get("rating")
                                .isJsonArray()) {

                    JsonArray ratingArray =
                            ratings.getAsJsonArray(
                                    "rating"
                            );


                    for (JsonElement element
                            : ratingArray) {

                        if (!element.isJsonObject()) {

                            continue;
                        }


                        JsonObject rating =
                                element.getAsJsonObject();


                        releaseDate =
                                getString(
                                        rating,
                                        "releaseDate"
                                );


                        validDate =
                                extractValidDate(
                                        releaseDate
                                );


                        if (!validDate.isEmpty()) {

                            return validDate;
                        }
                    }
                }
            }

        } catch (Exception e) {

        }

        return "";
    }


    // =========================================================
    // 7. 날짜 변환
    // =========================================================

    private String extractValidDate(
            String date
    ) {

        if (date == null
                || date.trim().isEmpty()) {

            return "";
        }


        String[] dates =
                date.split("\\|");


        for (String oneDate : dates) {

            oneDate =
                    oneDate.trim();


            if (oneDate.matches("\\d{8}")) {

                try {

                    int year =
                            Integer.parseInt(
                                    oneDate.substring(0, 4)
                            );

                    int month =
                            Integer.parseInt(
                                    oneDate.substring(4, 6)
                            );

                    int day =
                            Integer.parseInt(
                                    oneDate.substring(6, 8)
                            );


                    LocalDate parsedDate =
                            LocalDate.of(
                                    year,
                                    month,
                                    day
                            );


                    return parsedDate.toString();

                } catch (Exception e) {

                    continue;
                }
            }
        }


        return "";
    }


    // =========================================================
    // 8. 감독
    // =========================================================

    private String getDirector(
            JsonObject movie
    ) {

        try {

            if (movie.has("directors")
                    && movie.get("directors")
                            .isJsonObject()) {


                JsonObject directors =
                        movie.getAsJsonObject(
                                "directors"
                        );


                if (directors.has("director")
                        && directors.get("director")
                                .isJsonArray()) {


                    JsonArray array =
                            directors.getAsJsonArray(
                                    "director"
                            );


                    if (array.size() > 0) {

                        return getString(
                                array.get(0)
                                        .getAsJsonObject(),
                                "directorNm"
                        );
                    }
                }
            }

        } catch (Exception e) {

        }

        return "";
    }


    // =========================================================
    // 9. 줄거리
    // =========================================================

    private String getPlot(
            JsonObject movie
    ) {

        try {

            if (movie.has("plots")
                    && movie.get("plots")
                            .isJsonObject()) {


                JsonObject plots =
                        movie.getAsJsonObject(
                                "plots"
                        );


                if (plots.has("plot")
                        && plots.get("plot")
                                .isJsonArray()) {


                    JsonArray array =
                            plots.getAsJsonArray(
                                    "plot"
                            );


                    if (array.size() > 0) {

                        return getString(
                                array.get(0)
                                        .getAsJsonObject(),
                                "plotText"
                        );
                    }
                }
            }

        } catch (Exception e) {

        }

        return "";
    }


    // =========================================================
    // 10. 배우
    // =========================================================

    private String getActors(
            JsonObject movie
    ) {

        try {

            if (movie.has("actors")
                    && movie.get("actors")
                            .isJsonObject()) {


                JsonObject actors =
                        movie.getAsJsonObject(
                                "actors"
                        );


                if (actors.has("actor")
                        && actors.get("actor")
                                .isJsonArray()) {


                    JsonArray array =
                            actors.getAsJsonArray(
                                    "actor"
                            );


                    StringBuilder sb =
                            new StringBuilder();


                    int limit =
                            Math.min(
                                    array.size(),
                                    5
                            );


                    for (int i = 0;
                            i < limit;
                            i++) {


                        String name =
                                getString(
                                        array.get(i)
                                                .getAsJsonObject(),
                                        "actorNm"
                                );


                        if (!name.isEmpty()) {

                            if (sb.length() > 0) {

                                sb.append(", ");
                            }

                            sb.append(name);
                        }
                    }


                    return sb.toString();
                }
            }

        } catch (Exception e) {

        }

        return "";
    }


    // =========================================================
    // 11. ★ API에서 가져온 영화를 DB에 1편 저장
    // =========================================================

    public int insertMovie(
            MovieDTO movie
    ) {

        String sql =
                "INSERT ignore INTO movie "
                + "(title, genre, running_time, release_date, "
                + "poster, summary, director, actors, country) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";


        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver"
            );


            try (
                    Connection conn =
                            DriverManager.getConnection(
                                    URL,
                                    USER,
                                    PASS
                            );

                    PreparedStatement pstmt =
                            conn.prepareStatement(sql)
            ) {


                // 제목
                pstmt.setString(
                        1,
                        movie.getTitle()
                );


                // 장르
                pstmt.setString(
                        2,
                        movie.getGenre()
                );


                // ★ 러닝타임
                // 이제 DB도 VARCHAR이므로 setString()
                pstmt.setString(
                        3,
                        movie.getRunningTime()
                );


                // ★ release_date는 MySQL DATE
                // Java에서는 String 그대로 유지하고
                // DB에 넣을 때 Date로 변환
                if (movie.getReleaseDate() != null
                        && !movie.getReleaseDate().isEmpty()) {

                    pstmt.setDate(
                            4,
                            Date.valueOf(
                                    movie.getReleaseDate()
                            )
                    );

                } else {

                    pstmt.setNull(
                            4,
                            java.sql.Types.DATE
                    );
                }


                // 포스터
                pstmt.setString(
                        5,
                        movie.getPoster()
                );


                // 줄거리
                pstmt.setString(
                        6,
                        movie.getSummary()
                );


                // 감독
                pstmt.setString(
                        7,
                        movie.getDirector()
                );


                // 배우
                pstmt.setString(
                        8,
                        movie.getActors()
                );


                // 국가
                pstmt.setString(
                        9,
                        movie.getCountry()
                );


                return pstmt.executeUpdate();
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return 0;
    }


    // =========================================================
    // 12. ★ KMDb → DB 전체 저장
    // =========================================================

    public int insertMovieListFromAPI() {

        // ① KMDb에서 영화 가져오기
        List<MovieDTO> movieList =
                getMovieListFromAPI();


        int successCount = 0;


        // ② DB에 하나씩 저장
        for (MovieDTO movie : movieList) {

            int result =
                    insertMovie(movie);


            if (result > 0) {

                successCount++;
            }
        }


        System.out.println(
                "DB 저장 완료 : "
                + successCount
                + "편"
        );


        return successCount;
    }


    // =========================================================
    // 13. ★ DB에서 영화 목록 가져오기
    // =========================================================

    public List<MovieDTO> getMovieList() {

        List<MovieDTO> list =
                new ArrayList<>();


        String sql =
                "SELECT * FROM movie "
                + "ORDER BY release_date DESC"
                + " LIMIT 30";


        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver"
            );


            try (
                    Connection conn =
                            DriverManager.getConnection(
                                    URL,
                                    USER,
                                    PASS
                            );

                    PreparedStatement pstmt =
                            conn.prepareStatement(sql);

                    ResultSet rs =
                            pstmt.executeQuery()
            ) {


                int movieId = 1;


                while (rs.next()) {

                    MovieDTO movie =
                            new MovieDTO(

                                    movieId++,

                                    rs.getString(
                                            "title"
                                    ),

                                    rs.getString(
                                            "genre"
                                    ),

                                    rs.getString(
                                            "running_time"
                                    ),

                                    rs.getString(
                                            "poster"
                                    ),

                                    rs.getString(
                                            "country"
                                    ),

                                    rs.getString(
                                            "release_date"
                                    ),

                                    rs.getString(
                                            "director"
                                    ),

                                    rs.getString(
                                            "actors"
                                    ),

                                    rs.getString(
                                            "summary"
                                    )
                            );


                    list.add(movie);
                }
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return list;
    }


    // =========================================================
    // 14. 영화 상세정보
    // =========================================================

    public MovieDTO getMovieDetails(
            int movieId
    ) {

        List<MovieDTO> list =
                getMovieList();


        for (MovieDTO movie : list) {

            if (movie.getMovieId()
                    == movieId) {

                return movie;
            }
        }


        return null;
    }


    // =========================================================
    // 15. 국가 + 장르 + 정렬
    // =========================================================

    public List<MovieDTO>
    getFilteredAndSortedMovieList(
            String country,
            String genre,
            String sort
    ) {

        List<MovieDTO> list =
                getMovieList();


        List<MovieDTO> result =
                new ArrayList<>();


        for (MovieDTO movie : list) {


            boolean matchCountry =
                    country == null
                    || country.isEmpty()
                    || country.equals("all")
                    || (
                        movie.getCountry() != null
                        && movie.getCountry()
                                .contains(country)
                    );


            boolean matchGenre = true;


            if (genre != null
                    && !genre.isEmpty()
                    && !genre.equals("all")) {


                if (movie.getGenre() == null) {

                    matchGenre = false;

                } else {

                    String dbGenre =
                            movie.getGenre()
                                    .replaceAll("\\s+", "")
                                    .toLowerCase();


                    String targetGenre =
                            genre
                                    .replaceAll("\\s+", "")
                                    .toLowerCase();


                    matchGenre =
                            dbGenre.contains(targetGenre)
                            || targetGenre.contains(dbGenre);
                }
            }


            if (matchCountry
                    && matchGenre) {

                result.add(movie);
            }
        }


        // 최신순
        if ("date".equals(sort)) {

            result.sort(
                    (m1, m2) -> {

                        String d1 =
                                m1.getReleaseDate();

                        String d2 =
                                m2.getReleaseDate();


                        if (d1 == null
                                && d2 == null) {

                            return 0;
                        }

                        if (d1 == null) {

                            return 1;
                        }

                        if (d2 == null) {

                            return -1;
                        }


                        return d2.compareTo(d1);
                    }
            );
        }


        // 제목순
        else if ("title".equals(sort)) {

            result.sort(
                    (m1, m2) -> {

                        String t1 =
                                m1.getTitle();

                        String t2 =
                                m2.getTitle();


                        if (t1 == null) {

                            return 1;
                        }

                        if (t2 == null) {

                            return -1;
                        }


                        return t1.compareTo(t2);
                    }
            );
        }


        return result;
    }

}