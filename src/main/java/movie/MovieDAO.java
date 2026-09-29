package movie;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
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

/**
 * KMDb API에서 영화 데이터를 가져오는 DAO입니다.
 *
 * 핵심 변경점
 * 1) KMDb 검색 조건에 use=극장용을 추가합니다.
 * 2) 공연/콘서트/VR/실황 등 비영화성 콘텐츠를 제목 기준으로 한 번 더 방어적으로 제외합니다.
 * 3) 같은 영화가 여러 번 들어오는 경우 제목 + 개봉일 기준으로 중복 제거합니다.
 * 4) 기존의 등급, 올해 개봉, 포스터, 상세정보 추출 로직은 유지합니다.
 *
 * 주의:
 * KMDb만으로 네이버의 실시간 극장별 상영시간표와 100% 동일한 목록을 만드는 것은 아닙니다.
 * 여기서는 "극장용 영화"를 최대한 깔끔하게 가져오는 방향입니다.
 */
public class MovieDAO {

    /**
     * 최대 30개의 영화 목록을 반환합니다.
     *
     * 처리 순서
     * API 조회 -> JSON 파싱 -> 영화별 필터링 -> 중복 제거 -> 최신순 정렬 -> 30개 DTO 생성
     */
    public List<MovieDTO> getMovieList() {

        // 최종적으로 반환할 DTO 리스트
        List<MovieDTO> list = new ArrayList<>();

        /*
         * 중복 제거용 Map입니다.
         * key: 영화 제목 + 개봉일
         * value: 임시 영화 데이터
         *
         * LinkedHashMap을 사용하면 입력 순서도 유지됩니다.
         */
        Map<String, MovieData> movieMap = new LinkedHashMap<>();

        try {

            // 현재 사용 중인 KMDb API 서비스 키
            // 실제 배포 환경에서는 환경변수나 설정 파일로 분리하는 것을 권장합니다.
            String serviceKey = "E2R512K63ELVY49O4AF4";

            // 전체 검색을 위해 빈 검색어를 사용합니다.
            String query = URLEncoder.encode("", "UTF-8");

            // 오늘 날짜
            LocalDate today = LocalDate.now();

            // 올해 연도
            int currentYear = today.getYear();

            // 오늘 날짜를 yyyyMMdd 형식으로 변경
            String todayStr = today.format(
                    DateTimeFormatter.ofPattern("yyyyMMdd")
            );

            // 올해 1월 1일 ~ 오늘까지의 개봉일 검색 범위
            // 예: 20260101~20260929
            String releaseDtsParam = currentYear + "0101~" + todayStr;

            // KMDb의 "용도 구분" 값입니다.
            // 한글이 URL에서 깨지지 않도록 인코딩합니다.
            String useParam = URLEncoder.encode("극장용", "UTF-8");

            /*
             * KMDb API 요청 URL
             *
             * 여기서 가장 중요한 변경은
             *     &use=극장용
             * 입니다.
             *
             * type=극영화를 강제로 걸지 않은 이유:
             * 애니메이션/다큐멘터리처럼 실제 극장에서 상영되는 영화까지 빠질 수 있기 때문입니다.
             * 따라서 type은 응답을 받은 뒤 필요한 경우 보조적으로 검사할 수 있게 남겨둡니다.
             */
            String urlStr =
                    "http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp"
                    + "?collection=kmdb_new2"
                    + "&ServiceKey=" + serviceKey
                    + "&detail=Y"
                    + "&query=" + query
                    + "&releaseDts=" + releaseDtsParam
                    + "&use=" + useParam
                    + "&listCount=500";

            System.out.println("KMDb API 요청 기간 : " + releaseDtsParam);
            System.out.println("KMDb API 요청 조건 : use=극장용");

            // 문자열 주소를 URL 객체로 변환
            URL url = new URL(urlStr);

            // 실제 HTTP 연결 생성
            HttpURLConnection conn =
                    (HttpURLConnection) url.openConnection();

            // GET 방식으로 데이터 조회
            conn.setRequestMethod("GET");

            // JSON 응답을 요청
            conn.setRequestProperty("Content-type", "application/json");

            // 연결 대기 최대 5초
            conn.setConnectTimeout(5000);

            // 응답 읽기 최대 10초
            conn.setReadTimeout(10000);

            // 서버 응답 코드 확인
            int responseCode = conn.getResponseCode();
            System.out.println("KMDb 서버 응답 코드 : " + responseCode);

            BufferedReader rd;

            if (responseCode >= 200 && responseCode < 300) {
                // 정상 응답을 읽습니다.
                rd = new BufferedReader(
                        new InputStreamReader(
                                conn.getInputStream(),
                                "UTF-8"
                        )
                );
            } else {
                // 오류 응답을 읽습니다.
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

            // 서버 응답 전체를 하나의 문자열로 모읍니다.
            StringBuilder sb = new StringBuilder();
            String line;

            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }

            // 스트림과 연결을 정리합니다.
            rd.close();
            conn.disconnect();

            // 최종 JSON 문자열
            String jsonResult = sb.toString();

            // 응답이 없으면 빈 리스트 반환
            if (jsonResult.isEmpty()) {
                return list;
            }

            // HTTP 오류면 빈 리스트 반환
            if (responseCode < 200 || responseCode >= 300) {
                return list;
            }

            // 문자열 JSON을 Gson 객체로 파싱
            JsonObject root =
                    JsonParser.parseString(jsonResult)
                              .getAsJsonObject();

            // 예상한 Data 항목이 없으면 종료
            if (!root.has("Data")) {
                return list;
            }

            JsonArray dataArray =
                    root.getAsJsonArray("Data");

            if (dataArray.size() == 0) {
                return list;
            }

            // Data의 첫 번째 객체
            JsonObject dataObject =
                    dataArray.get(0).getAsJsonObject();

            // Result 항목이 없으면 종료
            if (!dataObject.has("Result")) {
                return list;
            }

            // 실제 영화 목록
            JsonArray resultArray =
                    dataObject.getAsJsonArray("Result");

            /*
             * 영화 데이터를 하나씩 검사합니다.
             */
            for (JsonElement element : resultArray) {

                try {

                    if (!element.isJsonObject()) {
                        continue;
                    }

                    // 현재 영화 한 편의 JSON 객체
                    JsonObject movie = element.getAsJsonObject();

                    // =====================================================
                    // 1. 제목 확인
                    // =====================================================
                    String title = getString(movie, "title");

                    // KMDb 검색 하이라이트 태그 제거
                    title = title
                            .replace("!HS", "")
                            .replace("!HE", "")
                            .trim();

                    // 제목이 없으면 제외
                    if (title.isEmpty()) {
                        continue;
                    }

                    // =====================================================
                    // 2. use 값 방어 검사
                    // =====================================================
                    String use = getString(movie, "use");

                    /*
                     * API 요청에서 이미 use=극장용을 넣었지만
                     * 응답에 use 값이 명확하게 존재하는 경우 한 번 더 검사합니다.
                     *
                     * use가 빈 값인 경우는 다른 필드 구조 때문에 누락됐을 가능성이 있으므로
                     * 무조건 버리지는 않습니다.
                     */
                    if (!use.isEmpty() && !use.contains("극장용")) {
                        continue;
                    }

  
 
                    // =====================================================
                    // 3. 개봉일 추출
                    // =====================================================
                    String releaseDate = getReleaseDate(movie);

                    if (releaseDate.isEmpty()) {
                        continue;
                    }

                    LocalDate movieDate;

                    try {
                        movieDate = LocalDate.parse(releaseDate);
                    } catch (Exception e) {
                        // 잘못된 날짜인 영화 한 편만 제외
                        continue;
                    }

                    // 올해 1월 1일
                    LocalDate startDate =
                            LocalDate.of(currentYear, 1, 1);

                    /*
                     * 올해 개봉작만 남기고,
                     * 아직 개봉하지 않은 미래 영화는 제외합니다.
                     */
                    if (movieDate.isBefore(startDate)
                            || movieDate.isAfter(today)) {
                        continue;
                    }

                    // =====================================================
                    // 4. 포스터 필터
                    // =====================================================
                    String posterUrl = getString(movie, "posters");

                    if (posterUrl.isEmpty()) {
                        continue;
                    }

                    // 포스터가 여러 개면 첫 번째 URL만 사용
                    if (posterUrl.contains("|")) {
                        posterUrl =
                                posterUrl.split("\\|")[0].trim();
                    }

                    if (posterUrl.isEmpty()) {
                        continue;
                    }

                    // =====================================================
                    // 5. 상세 정보 추출
                    // =====================================================
                    String genre = getString(movie, "genre");
                    String country = getString(movie, "nation");
                    String runningTime = getString(movie, "runtime");
                    String director = getDirector(movie);
                    String plot = getPlot(movie);
                    String actor = getActors(movie);

                    // =====================================================
                    // 6. 임시 영화 객체 생성
                    // =====================================================
                    MovieData movieData = new MovieData();

                    movieData.title = title;
                    movieData.genre = genre;
                    movieData.runningTime = runningTime;
                    movieData.posterUrl = posterUrl;
                    movieData.country = country;
                    movieData.releaseDate = releaseDate;
                    movieData.director = director;
                    movieData.plot = plot;
                    movieData.actor = actor;

                    // =====================================================
                    // 7. 중복 제거
                    // =====================================================
                    String uniqueKey = title + "|" + releaseDate;

                    // 이미 동일 영화가 있으면 기존 값을 유지합니다.
                    movieMap.putIfAbsent(uniqueKey, movieData);

                } catch (Exception e) {
                    // 특정 영화 데이터에 문제가 있어도 전체 목록은 계속 처리합니다.
                    continue;
                }
            }

            // Map의 값만 List로 변환
            List<MovieData> tempList =
                    new ArrayList<>(movieMap.values());

            // 최신 개봉일이 먼저 오도록 내림차순 정렬
            tempList.sort(
                    Comparator.comparing(
                            (MovieData m) -> m.releaseDate,
                            Comparator.reverseOrder()
                    )
            );

            // 화면에서 사용할 영화 번호
            int movieId = 1;

            // 최대 갯수 30(8)개까지만 DTO 생성
            for (MovieData data : tempList) {

                if (list.size() >= 30) {
                    break;
                }

                // 임시 객체를 실제 프로젝트의 MovieDTO로 변환
                MovieDTO dto = new MovieDTO(
                        movieId++,
                        data.title,
                        data.genre,
                        data.runningTime,
                        data.posterUrl,
                        data.country,
                        data.releaseDate,
                        data.director,
                        data.actor,
                        data.plot
                );

                list.add(dto);
            }

            System.out.println(
                    "최종 완성된 극장용 영화 개수 : "
                    + list.size()
                    + "편"
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    /**
     * 영화 데이터를 최종 MovieDTO로 만들기 전 임시로 담아두는 내부 클래스입니다.
     */
    private static class MovieData {
        String title;
        String genre;
        String runningTime;
        String posterUrl;
        String country;
        String releaseDate;
        String director;
        String plot;
        String actor;
    }


    /**
     * JSON 객체에서 문자열 값을 안전하게 꺼냅니다.
     * 값이 없거나 null이면 빈 문자열을 반환합니다.
     */
    private String getString(JsonObject object, String key) {

        try {
            if (object.has(key) && !object.get(key).isJsonNull()) {
                return object.get(key).getAsString().trim();
            }
        } catch (Exception e) {
            // 값이 예상과 다른 타입이어도 빈 문자열 처리
        }

        return "";
    }



 

    /**
     * 영화의 개봉일을 찾아 yyyy-MM-dd 형태로 반환합니다.
     *
     * 1순위: movie.releaseDate
     * 2순위: ratings.rating[].releaseDate
     */
    private String getReleaseDate(JsonObject movie) {

        try {

            String releaseDate = getString(movie, "releaseDate");
            String validDate = extractValidDate(releaseDate);

            if (!validDate.isEmpty()) {
                return validDate;
            }

            if (movie.has("ratings")
                    && movie.get("ratings").isJsonObject()) {

                JsonObject ratings =
                        movie.getAsJsonObject("ratings");

                if (ratings.has("rating")
                        && ratings.get("rating").isJsonArray()) {

                    JsonArray ratingArray =
                            ratings.getAsJsonArray("rating");

                    for (JsonElement element : ratingArray) {

                        try {

                            if (!element.isJsonObject()) {
                                continue;
                            }

                            JsonObject rating =
                                    element.getAsJsonObject();

                            releaseDate =
                                    getString(rating, "releaseDate");

                            validDate =
                                    extractValidDate(releaseDate);

                            if (!validDate.isEmpty()) {
                                return validDate;
                            }

                        } catch (Exception e) {
                            // 현재 rating만 건너뜁니다.
                        }
                    }
                }
            }

        } catch (Exception e) {
            // 날짜 정보가 없으면 빈 문자열 반환
        }

        return "";
    }


    /**
     * 날짜 문자열에서 실제로 사용할 수 있는 날짜 하나를 추출합니다.
     * 예: 20260929 -> 2026-09-29
     */
    private String extractValidDate(String date) {

        if (date == null || date.trim().isEmpty()) {
            return "";
        }

        String[] dates = date.split("\\|");

        for (String oneDate : dates) {

            oneDate = oneDate.trim();

            if (oneDate.matches("\\d{8}")) {

                try {

                    int year = Integer.parseInt(oneDate.substring(0, 4));
                    int month = Integer.parseInt(oneDate.substring(4, 6));
                    int day = Integer.parseInt(oneDate.substring(6, 8));

                    LocalDate parsedDate =
                            LocalDate.of(year, month, day);

                    return parsedDate.toString();

                } catch (Exception e) {
                    // 잘못된 날짜면 다음 날짜를 확인합니다.
                    continue;
                }
            }
        }

        return "";
    }


    /**
     * directors.director[]의 첫 번째 감독 이름을 가져옵니다.
     */
    private String getDirector(JsonObject movie) {

        try {

            if (movie.has("directors")
                    && movie.get("directors").isJsonObject()) {

                JsonObject directors =
                        movie.getAsJsonObject("directors");

                if (directors.has("director")
                        && directors.get("director").isJsonArray()) {

                    JsonArray dirArray =
                            directors.getAsJsonArray("director");

                    if (dirArray.size() > 0) {
                        return getString(
                                dirArray.get(0).getAsJsonObject(),
                                "directorNm"
                        );
                    }
                }
            }

        } catch (Exception e) {
            // 감독 정보가 없으면 빈 문자열
        }

        return "";
    }


    /**
     * plots.plot[]의 첫 번째 plotText를 가져옵니다.
     */
    private String getPlot(JsonObject movie) {

        try {

            if (movie.has("plots")
                    && movie.get("plots").isJsonObject()) {

                JsonObject plots =
                        movie.getAsJsonObject("plots");

                if (plots.has("plot")
                        && plots.get("plot").isJsonArray()) {

                    JsonArray plotArray =
                            plots.getAsJsonArray("plot");

                    if (plotArray.size() > 0) {
                        return getString(
                                plotArray.get(0).getAsJsonObject(),
                                "plotText"
                        );
                    }
                }
            }

        } catch (Exception e) {
            // 줄거리 정보가 없으면 빈 문자열
        }

        return "";
    }


    /**
     * 배우를 최대 5명까지 가져와 하나의 문자열로 만듭니다.
     */
    private String getActors(JsonObject movie) {

        try {

            if (movie.has("actors")
                    && movie.get("actors").isJsonObject()) {

                JsonObject actors =
                        movie.getAsJsonObject("actors");

                if (actors.has("actor")
                        && actors.get("actor").isJsonArray()) {

                    JsonArray actorArray =
                            actors.getAsJsonArray("actor");

                    StringBuilder sb = new StringBuilder();

                    int limit = Math.min(actorArray.size(), 5);

                    for (int i = 0; i < limit; i++) {

                        String name = getString(
                                actorArray.get(i).getAsJsonObject(),
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
            // 배우 정보가 없으면 빈 문자열
        }

        return "";
    }


    /**
     * 영화 ID로 현재 목록의 특정 영화를 찾습니다.
     */
    public MovieDTO getMovieDetails(int movieId) {

        List<MovieDTO> list = getMovieList();

        for (MovieDTO movie : list) {
            if (movie.getMovieId() == movieId) {
                return movie;
            }
        }

        return null;
    }


    /**
     * 국가와 장르로 필터링하고 선택한 기준으로 정렬합니다.
     *
     * sort = "date"  -> 최신 개봉일 순
     * sort = "title" -> 제목 순
     */
    public List<MovieDTO> getFilteredAndSortedMovieList(
            String country,
            String genre,
            String sort
    ) {

        List<MovieDTO> list = getMovieList();
        List<MovieDTO> result = new ArrayList<>();

        for (MovieDTO movie : list) {

            // 국가 조건
            boolean matchCountry =
                    country == null
                    || country.isEmpty()
                    || country.equals("all")
                    || (movie.getCountry() != null
                        && movie.getCountry().contains(country));

            // 장르 조건 (대소문자, 공백, 영어/한글 차이까지 유연하게 잡아내는 안전한 방식)
            boolean matchGenre = true;
            if (genre != null && !genre.isEmpty() && !genre.equals("all")) {
                if (movie.getGenre() == null) {
                    matchGenre = false;
                } else {
                    String dbGenre = movie.getGenre().replaceAll("\\s+", "").toLowerCase();
                    String targetGenre = genre.replaceAll("\\s+", "").toLowerCase();
                    matchGenre = dbGenre.contains(targetGenre) || targetGenre.contains(dbGenre);
                }
            }

            // 국가와 장르를 모두 만족해야 결과에 들어갑니다.
            if (matchCountry && matchGenre) {
                result.add(movie);
            }
        }

        // =============================================================
        // 정렬
        // =============================================================
        if ("date".equals(sort)) {

            result.sort((m1, m2) -> {

                String d1 = m1.getReleaseDate();
                String d2 = m2.getReleaseDate();

                // 날짜가 없는 값은 뒤로
                if (d1 == null) return 1;
                if (d2 == null) return -1;

                // 최신 날짜가 먼저 오도록 내림차순
                return d2.compareTo(d1);
            });

        } else if ("title".equals(sort)) {

            result.sort((m1, m2) -> {

                String t1 = m1.getTitle();
                String t2 = m2.getTitle();

                if (t1 == null) return 1;
                if (t2 == null) return -1;

                return t1.compareTo(t2);
            });
        }

        return result;
    }
}
