package movie;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import java.sql.Connection;
import java.sql.Date;
import javax.sql.DataSource;
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
    // 1. context.xml에서 불러오는 JNDI 데이터소스 및 KMDb API 키
    // =========================================================
    private javax.sql.DataSource dataSource;
    private String serviceKey;

    // =========================================================
    // 2. KMDb API KEY (context.xml에서 불러오기)
    // =========================================================
    // 생성자에서 context.xml의 KMDb API 키를 읽어옴
    // 생성자
    public MovieDAO() {
        try {
            javax.naming.Context initContext = new javax.naming.InitialContext();
            javax.naming.Context envContext = (javax.naming.Context) initContext.lookup("java:comp/env");

            // KMDb API 키 로드
            this.serviceKey = (String) envContext.lookup("kmdb/serviceKey");

            // ★ context.xml의 데이터소스를 dataSource에 연결!
            this.dataSource = (javax.sql.DataSource) envContext.lookup("jdbc/moviebox");

        } catch (Exception e) {
            e.printStackTrace();
            
        }
    }
    // =========================================================
    // 3. KMDb API → 영화 목록 가져오기
    // =========================================================
	//  역할: kMDb API 서버에 HTTP 연결을 요청하고, 전달받은 JSON 데이터(영화 목록 및 포스터 URL 문자열)를 파싱하여 
	//  	 Java 안으로 가져오는 시동을 거는 메소드입니다.
	
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
                    "http://api.koreafilm.or.kr" 	// KMDb API 서버 주소
                    + "/openapi-data2/wisenut/search_api/search_json2.jsp" //	 KMDb API 엔드포인트
                    + "?collection=kmdb_new2"  // 컬렉션 이름
                    + "&ServiceKey=" + serviceKey	// KMDb API 키
                    + "&detail=Y"	// 상세 정보 포함
                    + "&query=" + query	// 검색어
                    + "&releaseDts=" + releaseDtsParam	// 개봉일 범위
                    + "&use=" + useParam	// 극장용 영화만
                    + "&listCount=500";	// 한 번에 가져올 영화 수 (최대 500편)


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
			/*
			 * • 역할: API가 준 거대한 문자열 덩어리에서 영화 제목, 포스터 주소 같은 필요한 데이터만 쏙쏙 추출(파싱)해내는 구글 라이브러리
			 * 메소드입니다.
			 */


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
  
                    String summary =
                            getPlot(movie);
                    
                    String director =
                            getDirector(movie);


                    String actors =
                            getActors(movie);

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
 
                    data.summary =
                            summary;
                    
                    data.director =
                            director;

                    data.actors =
                            actors;


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
                          
                                data.summary,
                               
                                data.director,

                                data.actors

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
    
        String summary;
        
        String director;

        String actors;


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

    
	/*
	 * • 역할: API로 수집한 포스터 주소와 영화 정보들을 MySQL 데이터베이스에 영구적으로 채워 넣기 위해 INSERT INTO movie
	 * ... SQL 쿼리문을 실행하는 메소드입니다.
	 */

    public int insertMovie(
            MovieDTO movie
    ) {

        String sql =
                "INSERT ignore INTO movie "
                + "(title, genre, running_time, release_date, "
                + "poster, summary, director, actors, country) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";


        try (
                Connection conn = dataSource.getConnection(); // 변경됨!

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
            pstmt.setString(
                    3,
                    movie.getRunningTime()
            );


            // ★ release_date는 MySQL DATE
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
			/*
			 * ㄴ> 역할: Java가 준비한 INSERT 쿼리문을 실제 MySQL DB 서버로 
			 * 			전송하여 데이터를 완전히 저장시키는 순수 JDBC 메소드입니다.		
			 */

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

        try (
                Connection conn = dataSource.getConnection(); // 변경됨!

                PreparedStatement pstmt =
                        conn.prepareStatement(sql);

                ResultSet rs =
                        pstmt.executeQuery()
        ) {


            while (rs.next()) {

                MovieDTO movie =
                        new MovieDTO(rs.getInt("movie_id"),
	                        		 rs.getString("title"),
	                                 rs.getString("genre"),
	                                 rs.getString("running_time"),
	                                 rs.getString("poster"),
	                                 rs.getString("country"),
	                                 rs.getString("release_date"),
	                                 rs.getString("summary"),
	                                 rs.getString("director"),
	                                 rs.getString("actors")
                        );

                list.add(movie);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    // =========================================================
    // 14. 영화 상세정보 [추가] DB에서 특정 영화 ID로 상세 정보 조회하기
    // =========================================================

    public MovieDTO getMovieDetails(int movieId) {
        MovieDTO movie = null;
        
        String sql = "SELECT * FROM movie WHERE movie_id = ?";
        
        try (Connection conn = this.dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, movieId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    movie = new MovieDTO(); 
                    movie.setMovieId(rs.getInt("movie_id"));
                    movie.setTitle(rs.getString("title"));
                    movie.setGenre(rs.getString("genre"));
                    movie.setCountry(rs.getString("country"));
                    movie.setReleaseDate(rs.getString("release_date"));
                    movie.setPoster(rs.getString("poster"));
                    
                    // =========================================================
                    // ★ [이 부분을 추가해야 화면의 null이 해결됩니다!]
                    // =========================================================
                    movie.setRunningTime(rs.getString("running_time"));
                    movie.setSummary(rs.getString("summary")); 
                    movie.setDirector(rs.getString("director"));
                    movie.setActors(rs.getString("actors"));                
                    // ※ 만약 MovieDTO에 정의된 메소드명이 setSummary가 아니라 setPlot 등 
                    // 다른 이름이라면 본인의 DTO 메소드명에 맞게 변경해 주세요!
                    // =========================================================
                }
            }
        } catch (SQLException e) {
            System.out.println("getMovieDetails 조회 중 SQL 에러 발생");
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return movie;
    }


 // =========================================================
 // 15. 국가 + 장르 + 정렬
 // =========================================================

 // 기존 메소드
 // 기존 Controller에서 사용하던 메소드 이름은 그대로 유지
 public List<MovieDTO> getFilteredAndSortedMovieList(
         String country,
         String genre,
         String sort
 ) {

     // 검색어가 없는 경우
     return getFilteredAndSortedMovieList(
             country,
             genre,
             sort,
             ""
     );
 }


 // =========================================================
 // 16. 국가 + 장르 + 검색어 + 정렬
 // =========================================================

 public List<MovieDTO> getFilteredAndSortedMovieList(
         String country,
         String genre,
         String sort,
         String searchKeyword
 ) {

     // DB에서 현재 영화 목록 가져오기
     List<MovieDTO> list = getMovieList();

     List<MovieDTO> result = new ArrayList<>();


     // 검색어 앞뒤 공백 제거
     if (searchKeyword == null) {
         searchKeyword = "";
     }

     searchKeyword = searchKeyword.trim();


     for (MovieDTO movie : list) {


         // =====================================================
         // ① 국가 조건
         // =====================================================

         boolean matchCountry =
                 country == null
                 || country.isEmpty()
                 || country.equals("all")
                 || (
                     movie.getCountry() != null
                     && movie.getCountry().contains(country)
                 );


         // =====================================================
         // ② 장르 조건
         // =====================================================

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


         // =====================================================
         // ③ 영화 제목 검색
         // =====================================================

         boolean matchSearch = true;

         if (!searchKeyword.isEmpty()) {

             if (movie.getTitle() == null) {

                 matchSearch = false;

             } else {

                 matchSearch =
                         movie.getTitle()
                                 .toLowerCase()
                                 .contains(searchKeyword.toLowerCase());
             }
         }


         // =====================================================
         // ④ 모든 조건을 만족하면 결과에 추가
         // =====================================================

         if (matchCountry
                 && matchGenre
                 && matchSearch) {

             result.add(movie);
         }
     }


     // =========================================================
     // ⑤ 최신순
     // =========================================================

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


     // =========================================================
     // ⑥ 제목순
     // =========================================================

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

 // =========================================================
 // 17. 영화 찜 기능
 // =========================================================

 /**
  * 영화 찜 추가
  *
  * memberId : 현재 로그인한 회원 아이디
  * movieId  : 찜하려는 영화 번호
  *
  * 이미 찜한 영화라면 INSERT IGNORE 때문에 중복 저장되지 않음
  */
 public int addFavorite(String memberId, int movieId) {

     String sql =
             "INSERT IGNORE INTO movie_favorite "
           + "(member_id, movie_id) "
           + "VALUES (?, ?)";

     try (
             Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)
     ) {

         pstmt.setString(1, memberId);
         pstmt.setInt(2, movieId);

         return pstmt.executeUpdate();

     } catch (SQLException e) {

         System.out.println("영화 찜 추가 중 오류 발생");
         e.printStackTrace();
     }

     return 0;
 }


 /**
  * 영화 찜 삭제
  */
 public int removeFavorite(String memberId, int movieId) {

     String sql =
             "DELETE FROM movie_favorite "
           + "WHERE member_id = ? "
           + "AND movie_id = ?";

     try (
             Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)
     ) {

         pstmt.setString(1, memberId);
         pstmt.setInt(2, movieId);

         return pstmt.executeUpdate();

     } catch (SQLException e) {

         System.out.println("영화 찜 삭제 중 오류 발생");
         e.printStackTrace();
     }

     return 0;
 }


 /**
  * 현재 회원이 해당 영화를 찜했는지 확인
  *
  * true  = 찜함 ❤️
  * false = 찜하지 않음 ♡
  */
 public boolean isFavorite(String memberId, int movieId) {

     String sql =
             "SELECT COUNT(*) "
           + "FROM movie_favorite "
           + "WHERE member_id = ? "
           + "AND movie_id = ?";

     try (
             Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)
     ) {

         pstmt.setString(1, memberId);
         pstmt.setInt(2, movieId);

         try (ResultSet rs = pstmt.executeQuery()) {

             if (rs.next()) {

                 return rs.getInt(1) > 0;
             }
         }

     } catch (SQLException e) {

         System.out.println("영화 찜 여부 확인 중 오류 발생");
         e.printStackTrace();
     }

     return false;
 }


 /**
  * 현재 로그인한 회원이 찜한 영화 ID 목록 가져오기
  *
  * 영화 목록 화면에서
  * "이 영화는 찜했는지"를 표시하기 위해 사용
  */
 public List<Integer> getFavoriteMovieIds(String memberId) {

     List<Integer> favoriteMovieIds =
             new ArrayList<>();

     String sql =
             "SELECT movie_id "
           + "FROM movie_favorite "
           + "WHERE member_id = ?";

     try (
             Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)
     ) {

         pstmt.setString(1, memberId);

         try (ResultSet rs = pstmt.executeQuery()) {

             while (rs.next()) {

                 favoriteMovieIds.add(
                         rs.getInt("movie_id")
                 );
             }
         }

     } catch (SQLException e) {

         System.out.println("찜한 영화 목록 조회 중 오류 발생");
         e.printStackTrace();
     }

     return favoriteMovieIds;
 }


}
 
