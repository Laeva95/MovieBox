package ai;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import movie.MovieDTO;

public class AIRecommendationService {

    // ============================================================
    // OpenRouter API 주소
    // ============================================================

    private static final String API_URL =
            "https://openrouter.ai/api/v1/chat/completions";


    // ============================================================
    // 사용할 AI 모델
    // ============================================================

    private static final String MODEL =
            "openai/gpt-chat-latest";


    // ============================================================
    // API KEY
    //
    // 실제 API KEY를 코드에 직접 작성하지 않는다.
    // Windows 환경변수 OPENAI_API_KEY에서 가져온다.
    // ============================================================

    private static final String API_KEY =
            System.getenv("OPENAI_API_KEY");


    // ============================================================
    // 영화 추천
    //
    // prompt    = 사용자가 입력한 추천 조건
    // movieList = MovieBox DB에 등록된 영화 목록
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
                        : "정상 / 길이 = " + API_KEY.length())
        );


        // --------------------------------------------------------
        // API KEY가 없는 경우
        // --------------------------------------------------------

        if (API_KEY == null
                || API_KEY.trim().isEmpty()) {

            throw new Exception(
                    "OPENAI_API_KEY 환경변수가 설정되지 않았습니다."
            );
        }


        // --------------------------------------------------------
        // DB 영화 목록 확인
        // --------------------------------------------------------

        if (movieList == null
                || movieList.isEmpty()) {

            throw new Exception(
                    "DB에 등록된 영화가 없습니다."
            );
        }


        // ========================================================
        // DB 영화 목록 만들기
        //
        // 토큰을 줄이기 위해
        // 영화 ID + 제목 + 장르만 AI에게 전달한다.
        // ========================================================

        StringBuilder movieInfo =
                new StringBuilder();


        for (MovieDTO movie : movieList) {

            movieInfo.append(
                    "ID: "
            );

            movieInfo.append(
                    movie.getMovieId()
            );

            movieInfo.append(
                    " / 제목: "
            );

            movieInfo.append(
                    movie.getTitle()
            );

            movieInfo.append(
                    " / 장르: "
            );

            movieInfo.append(
                    movie.getGenre()
            );

            movieInfo.append("\n");
        }


        // ========================================================
        // AI에게 전달할 프롬프트
        // ========================================================

        String userPrompt =

                "당신은 MovieBox 영화 추천 AI입니다.\n\n"

                // ------------------------------------------------
                // DB 영화만 사용하도록 제한
                // ------------------------------------------------

                + "아래 영화 목록은 현재 MovieBox DB에 "
                + "실제로 등록되어 있는 영화입니다.\n\n"

                + "반드시 아래 영화 목록에 있는 영화만 추천하세요.\n"

                + "아래 목록에 없는 영화는 절대로 추천하지 마세요.\n"

                + "영화 제목은 아래 목록에 있는 제목을 "
                + "그대로 사용하세요.\n"

                + "일반적인 영화 지식을 이용해서 "
                + "DB에 없는 영화를 추가하지 마세요.\n\n"


                // ------------------------------------------------
                // 추천 개수
                // ------------------------------------------------

                + "사용자의 취향을 분석해서 "
                + "가장 적합한 영화를 최대 3개 추천하세요.\n\n"


                // ------------------------------------------------
                // 출력 형식
                // ------------------------------------------------

                + "각 영화마다 추천 이유를 한 줄로 설명하세요.\n"

                + "추천 결과는 반드시 다음 형식으로 작성하세요.\n"

                + "1. 영화 제목 - 추천 이유\n"

                + "2. 영화 제목 - 추천 이유\n"

                + "3. 영화 제목 - 추천 이유\n"

                + "반드시 영화 제목을 먼저 표시하세요.\n"

                + "추천 영화가 3개보다 적으면 존재하는 영화만 표시하세요.\n"

                + "영화 제목 대신 영화 ID를 표시하지 마세요.\n"

                + "불필요한 설명이나 인사말은 작성하지 마세요.\n"

                + "답변은 한국어로 작성하세요.\n\n"


                // ------------------------------------------------
                // DB 영화 목록
                // ------------------------------------------------

                + "===== MovieBox DB 영화 목록 =====\n"

                + movieInfo.toString()

                + "===== 영화 목록 끝 =====\n\n"


                // ------------------------------------------------
                // 사용자 요청
                // ------------------------------------------------

                + "사용자 요청:\n"

                + prompt;


        // --------------------------------------------------------
        // 프롬프트 크기 확인
        // --------------------------------------------------------

        System.out.println(
                "AI 프롬프트 글자 수 = "
                + userPrompt.length()
        );


        // ========================================================
        // OpenRouter에 보낼 JSON
        // ========================================================

        String jsonBody =

                "{"

                + "\"model\":\""

                + MODEL

                + "\","

                + "\"max_tokens\":500,"

                + "\"messages\":["

                + "{"

                + "\"role\":\"user\","

                + "\"content\":\""

                + escapeJson(userPrompt)

                + "\""

                + "}"

                + "]"

                + "}";


        System.out.println(
                "OpenRouter 요청 시작"
        );


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
        // OpenRouter API 호출
        // ========================================================

        HttpResponse<String> response =

                client.send(

                        request,

                        HttpResponse.BodyHandlers.ofString(
                                StandardCharsets.UTF_8
                        )

                );


        // ========================================================
        // 응답 확인
        // ========================================================

        System.out.println(
                "OpenRouter 상태 코드 = "
                + response.statusCode()
        );


        // ========================================================
        // API 오류
        // ========================================================

        if (response.statusCode() < 200
                || response.statusCode() >= 300) {

            System.out.println(
                    "OpenRouter API 오류"
            );

            System.out.println(
                    "상태 코드 = "
                    + response.statusCode()
            );

            System.out.println(
                    "응답 = "
                    + response.body()
            );

            throw new Exception(
                    "OpenRouter API 호출 실패 : "
                    + response.statusCode()
            );
        }


        // ========================================================
        // 정상 응답에서 AI 답변 추출
        // ========================================================

        String result =
                extractText(
                        response.body()
                );


        // ========================================================
        // AI 답변이 없는 경우
        // ========================================================

        if (result == null
                || result.trim().isEmpty()) {

            System.out.println(
                    "OpenRouter 원본 응답 = "
                    + response.body()
            );

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
    // JSON 문자열 특수문자 처리
    // ============================================================

    private String escapeJson(String value) {

        if (value == null) {

            return "";
        }

        return value

                .replace("\\", "\\\\")

                .replace("\"", "\\\"")

                .replace("\r", "\\r")

                .replace("\n", "\\n")

                .replace("\t", "\\t");
    }


    // ============================================================
    // OpenRouter 응답에서 content 추출
    // ============================================================

    private String extractText(String json) {

        if (json == null
                || json.trim().isEmpty()) {

            return null;
        }


        Pattern pattern =

                Pattern.compile(

                        "\"content\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"",

                        Pattern.DOTALL
                );


        Matcher matcher =

                pattern.matcher(json);


        if (matcher.find()) {

            return unescapeJson(
                    matcher.group(1)
            );
        }


        return null;
    }


    // ============================================================
    // JSON 특수문자 복원
    // ============================================================

    private String unescapeJson(String value) {

        if (value == null) {

            return null;
        }

        return value

                .replace("\\n", "\n")

                .replace("\\r", "\r")

                .replace("\\t", "\t")

                .replace("\\\"", "\"")

                .replace("\\\\", "\\");
    }
}