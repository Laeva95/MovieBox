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

    private static final String API_URL =
            "https://openrouter.ai/api/v1/chat/completions";

    private static final String MODEL =
            "nvidia/nemotron-3-ultra-550b-a55b:free";

    private static final int MAX_RETRY = 3;

    private static final String API_KEY =
            getApiKey();

    private static String getApiKey() {

        try {

            Context initContext =
                    new InitialContext();

            Context envContext =
                    (Context) initContext.lookup(
                            "java:comp/env"
                    );

            String apiKey =
                    (String) envContext.lookup(
                            "OPENAI_API_KEY"
                    );

            if (apiKey != null
                    && !apiKey.trim().isEmpty()) {

                System.out.println(
                        "OPENAI_API_KEY context.xml 사용"
                );

                return apiKey;
            }

        } catch (Exception e) {

            System.out.println(
                    "context.xml에서 OPENAI_API_KEY를 가져오지 못했습니다."
            );

            e.printStackTrace();
        }

        return null;
    }

    public String getRecommendation(
            String prompt,
            List<MovieDTO> movieList)
            throws Exception {

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

        if (movieList == null
                || movieList.isEmpty()) {

            throw new Exception(
                    "DB에 등록된 영화가 없습니다."
            );
        }

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

        String userPrompt =
                "영화 3개를 추천하세요.\n"
                + "아래 DB 영화만 사용하세요.\n"
                + "형식:\n"
                + "1. 제목 - 짧은 이유\n"
                + "2. 제목 - 짧은 이유\n"
                + "3. 제목 - 짧은 이유\n"
                + "한국어로만 답하세요.\n"
                + "DB 영화:\n"
                + movieInfo
                + "사용자 요청:"
                + prompt;

        System.out.println(
                "AI 프롬프트 글자 수 = "
                + userPrompt.length()
        );

        String jsonBody =
                "{"
                + "\"model\":\""
                + MODEL
                + "\","
                + "\"max_tokens\":120,"
                + "\"temperature\":0.3,"
                + "\"reasoning\":{"
                + "\"enabled\":false"
                + "},"
                + "\"messages\":["
                + "{"
                + "\"role\":\"user\","
                + "\"content\":\""
                + escapeJson(userPrompt)
                + "\""
                + "}"
                + "]"
                + "}";

        HttpClient client =
                HttpClient.newBuilder()
                        .connectTimeout(
                                Duration.ofSeconds(20)
                        )
                        .build();

        Exception lastException = null;

        for (int attempt = 1;
                attempt <= MAX_RETRY;
                attempt++) {

            try {

                System.out.println(
                        "OpenRouter 요청 시도 = "
                        + attempt
                        + "/"
                        + MAX_RETRY
                );

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

                HttpResponse<String> response =
                        client.send(
                                request,
                                HttpResponse.BodyHandlers.ofString(
                                        StandardCharsets.UTF_8
                                )
                        );

                System.out.println(
                        "OpenRouter 상태 코드 = "
                        + response.statusCode()
                );

                System.out.println(
                        "OpenRouter 응답 = "
                        + response.body()
                );

                int statusCode =
                        response.statusCode();

                String responseBody =
                        response.body();

                if (statusCode >= 200
                        && statusCode < 300) {

                    if (responseBody == null
                            || responseBody.trim().isEmpty()) {

                        throw new Exception(
                                "OpenRouter 응답 내용이 없습니다."
                        );
                    }

                    if (responseBody.contains(
                            "\"error\""
                    )) {

                        if (isRetryableError(
                                responseBody
                        )
                                && attempt < MAX_RETRY) {

                            waitBeforeRetry(attempt);

                            continue;
                        }

                        throw new Exception(
                                "OpenRouter에서 AI 응답을 받지 못했습니다."
                        );
                    }

                    String result =
                            extractContent(
                                    responseBody
                            );

                    if (result != null
                            && !result.trim().isEmpty()) {

                        System.out.println(
                                "OpenRouter AI 응답 성공"
                        );

                        return result.trim();
                    }

                    throw new Exception(
                            "AI 응답을 가져오지 못했습니다."
                    );
                }

                if (isRetryableStatus(
                        statusCode
                )
                        && attempt < MAX_RETRY) {

                    waitBeforeRetry(attempt);

                    continue;
                }

                throw new Exception(
                        "OpenRouter API 호출 실패 : "
                        + statusCode
                );

            } catch (Exception e) {

                lastException = e;

                if (attempt >= MAX_RETRY) {
                    break;
                }

                String message =
                        e.getMessage();

                if (message != null
                        && (
                            message.contains("503")
                            || message.contains("429")
                            || message.contains("500")
                            || message.contains("502")
                            || message.contains("504")
                        )) {

                    waitBeforeRetry(attempt);

                } else {

                    break;
                }
            }
        }

        if (lastException != null) {

            throw lastException;
        }

        throw new Exception(
                "OpenRouter AI 요청에 실패했습니다."
        );
    }

    private boolean isRetryableStatus(
            int statusCode) {

        return statusCode == 429
                || statusCode == 500
                || statusCode == 502
                || statusCode == 503
                || statusCode == 504;
    }

    private boolean isRetryableError(
            String responseBody) {

        if (responseBody == null) {
            return false;
        }

        return responseBody.contains(
                    "provider_overloaded"
                )
                || responseBody.contains(
                    "\"code\":503"
                )
                || responseBody.contains(
                    "\"code\":429"
                )
                || responseBody.contains(
                    "temporarily overloaded"
                )
                || responseBody.contains(
                    "rate limit"
                );
    }

    private void waitBeforeRetry(
            int attempt) {

        try {

            long waitTime =
                    attempt == 1
                            ? 2000
                            : 4000;

            System.out.println(
                    "OpenRouter 일시적 오류"
                    + " → "
                    + (waitTime / 1000)
                    + "초 후 재시도"
            );

            Thread.sleep(
                    waitTime
            );

        } catch (InterruptedException e) {

            Thread.currentThread().interrupt();
        }
    }

    private String escapeJson(
            String value) {

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

    private String extractContent(
            String json) {

        if (json == null
                || json.trim().isEmpty()) {

            return null;
        }

        String target =
                "\"content\":\"";

        int start =
                json.indexOf(target);

        if (start == -1) {

            target =
                    "\"content\": \"";

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

