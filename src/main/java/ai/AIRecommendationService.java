package ai;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;

import movie.MovieDTO;

public class AIRecommendationService {

    // ============================================================
    // OpenRouter API 주소
    // ============================================================

    private static final String API_URL =
            "https://openrouter.ai/api/v1/chat/completions";


    // ============================================================
    // 무료 모델 라우팅
    // ============================================================

    private static final String MODEL =
            "openrouter/free";


    // ============================================================
    // API KEY
    // ============================================================

    private static final String API_KEY =
            getApiKey();


    // ============================================================
    // API KEY 가져오기
    //
    // 1. 환경변수 OPENAI_API_KEY
    // 2. Tomcat JNDI OPENAI_API_KEY
    // ============================================================

    private static String getApiKey() {

        // --------------------------------------------------------
        // 1. 환경변수 확인
        // --------------------------------------------------------

        String apiKey =
                System.getenv("OPENAI_API_KEY");

        if (apiKey != null
                && !apiKey.trim().isEmpty()) {

            System.out.println(
                    "OPENAI_API_KEY 환경변수 사용"
            );

            return apiKey;
        }


        // --------------------------------------------------------
        // 2. Tomcat JNDI 확인
        // --------------------------------------------------------

        try {

            Context initContext =
                    new InitialContext();

            Context envContext =
                    (Context) initContext.lookup(
                            "java:comp/env"
                    );

            apiKey =
                    (String) envContext.lookup(
                            "OPENAI_API_KEY"
                    );

            if (apiKey != null
                    && !apiKey.trim().isEmpty()) {

                System.out.println(
                        "OPENAI_API_KEY JNDI 사용"
                );

                return apiKey;
            }

        } catch (Exception e) {

            System.out.println(
                    "JNDI에서 OPENAI_API_KEY를 찾지 못했습니다."
            );
        }

        return null;
    }


    // ============================================================
    // 영화 추천
    // ============================================================

    public String getRecommendation(
            String prompt,
            List<MovieDTO> movieList)
            throws Exception {


        // --------------------------------------------------------
        // API KEY 확인
        // --------------------------------------------------------

        System.out.println(
                "Tomcat API KEY 확인 = "
                + (API_KEY == null
                        ? "없음"
                        : "정상 / 길이 = "
                        + API_KEY.length())
        );


        if (API_KEY == null
                || API_KEY.trim().isEmpty()) {

            throw new Exception(
                    "OPENAI_API_KEY가 설정되지 않았습니다."
            );
        }


        // --------------------------------------------------------
        // 영화 목록 확인
        // --------------------------------------------------------

        if (movieList == null
                || movieList.isEmpty()) {

            throw new Exception(
                    "DB에 등록된 영화가 없습니다."
            );
        }


        // ========================================================
        // DB 영화 목록
        //
        // 비용을 줄이기 위해
        // 영화 ID / 제목 / 장르만 AI에게 전달
        // ========================================================

        StringBuilder movieInfo =
                new StringBuilder();

        for (MovieDTO movie : movieList) {

            movieInfo.append(
                    movie.getMovieId()
            );

            movieInfo.append("|");

            movieInfo.append(
                    movie.getTitle()
            );

            movieInfo.append("|");

            movieInfo.append(
                    movie.getGenre()
            );

            movieInfo.append("\n");
        }


        // ========================================================
        // AI 프롬프트
        // ========================================================

        String userPrompt =
                "MovieBox 영화 추천 AI입니다.\n"
                + "아래 DB 영화 목록에 있는 영화만 추천하세요.\n"
                + "없는 영화는 절대 추천하지 마세요.\n"
                + "사용자 요청에 가장 적합한 영화를 최대 3개 추천하세요.\n"
                + "형식: 1. 영화 제목 - 추천 이유\n"
                + "추천 이유는 한 줄로 작성하세요.\n"
                + "불필요한 설명과 인사말은 작성하지 마세요.\n"
                + "한국어로 답변하세요.\n\n"
                + "[DB 영화 목록]\n"
                + movieInfo.toString()
                + "\n[사용자 요청]\n"
                + prompt;


        // --------------------------------------------------------
        // 프롬프트 크기 확인
        // --------------------------------------------------------

        System.out.println(
                "AI 프롬프트 글자 수 = "
                + userPrompt.length()
        );


        // ========================================================
        // OpenRouter JSON
        // ========================================================

        String jsonBody =
                "{"
                + "\"model\":\""
                + MODEL
                + "\","
                + "\"max_tokens\":300,"
                + "\"messages\":["
                + "{"
                + "\"role\":\"user\","
                + "\"content\":\""
                + escapeJson(userPrompt)
                + "\""
                + "}"
                + "]"
                + "}";


        // ========================================================
        // HTTP Client
        // ========================================================

        HttpClient client =
                HttpClient.newBuilder()
                        .connectTimeout(
                                Duration.ofSeconds(20)
                        )
                        .build();


        // ========================================================
        // HTTP 요청
        // ========================================================

        HttpRequest request =
                HttpRequest.newBuilder()
                        .uri(
                                URI.create(API_URL)
                        )
                        .timeout(
                                Duration.ofSeconds(60)
                        )
                        .header(
                                "Content-Type",
                                "application/json"
                        )
                        .header(
                                "Authorization",
                                "Bearer " + API_KEY
                        )
                        .header(
                                "HTTP-Referer",
                                "http://localhost"
                        )
                        .header(
                                "X-Title",
                                "MovieBox"
                        )
                        .POST(
                                HttpRequest.BodyPublishers.ofString(
                                        jsonBody,
                                        StandardCharsets.UTF_8
                                )
                        )
                        .build();


        // ========================================================
        // OpenRouter 호출
        // ========================================================

        HttpResponse<String> response =
                client.send(
                        request,
                        HttpResponse.BodyHandlers.ofString(
                                StandardCharsets.UTF_8
                        )
                );


        // ========================================================
        // 상태 코드 출력
        // ========================================================

        System.out.println(
                "OpenRouter 상태 코드 = "
                + response.statusCode()
        );


        // ========================================================
        // 실제 OpenRouter 응답 출력
        // ========================================================

        System.out.println(
                "OpenRouter 응답 = "
                + response.body()
        );


        // ========================================================
        // OpenRouter 오류
        // ========================================================

        if (response.statusCode() < 200
                || response.statusCode() >= 300) {

            throw new Exception(
                    "OpenRouter API 호출 실패 : "
                    + response.statusCode()
            );
        }


        // ========================================================
        // AI 답변 추출
        // ========================================================

        String result =
                extractContent(
                        response.body()
                );


        // ========================================================
        // AI 답변 확인
        // ========================================================

        if (result == null
                || result.trim().isEmpty()) {

            throw new Exception(
                    "AI 응답을 가져오지 못했습니다."
            );
        }


        System.out.println(
                "OpenRouter AI 응답 성공"
        );


        return result;
    }


    // ============================================================
    // JSON 문자열 처리
    // ============================================================

    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        String result = value;

        result = result.replace(
                "\\",
                "\\\\"
        );

        result = result.replace(
                "\"",
                "\\\""
        );

        result = result.replace(
                "\r",
                "\\r"
        );

        result = result.replace(
                "\n",
                "\\n"
        );

        result = result.replace(
                "\t",
                "\\t"
        );

        return result;
    }


    // ============================================================
    // OpenRouter 응답에서 content 추출
    // ============================================================

    private String extractContent(String json) {

        if (json == null
                || json.trim().isEmpty()) {

            return null;
        }


        String target =
                "\"content\":\"";


        int start =
                json.indexOf(target);


        // --------------------------------------------------------
        // content를 찾지 못한 경우
        // --------------------------------------------------------

        if (start == -1) {

            target =
                    "\"content\" : \"";

            start =
                    json.indexOf(target);
        }


        if (start == -1) {

            return null;
        }


        start =
                start + target.length();


        StringBuilder result =
                new StringBuilder();


        boolean escaped =
                false;


        // --------------------------------------------------------
        // content 문자열 끝까지 읽기
        // --------------------------------------------------------

        for (int i = start;
                i < json.length();
                i++) {

            char ch =
                    json.charAt(i);


            if (escaped) {

                if (ch == 'n') {
                    result.append('\n');

                } else if (ch == 'r') {
                    result.append('\r');

                } else if (ch == 't') {
                    result.append('\t');

                } else if (ch == '"') {
                    result.append('"');

                } else if (ch == '\\') {
                    result.append('\\');

                } else {
                    result.append(ch);
                }

                escaped = false;

                continue;
            }


            if (ch == '\\') {

                escaped = true;

                continue;
            }


            if (ch == '"') {

                break;
            }


            result.append(ch);
        }


        return result.toString();
    }
}