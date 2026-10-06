package ai;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import movie.MovieDAO;
import movie.MovieDTO;

/*
 * ============================================================
 * AI 영화 추천 Controller
 * ============================================================
 *
 * 역할
 *
 * 1. JSP에서 사용자의 영화 추천 요청을 받는다.
 * 2. MovieDAO를 이용해서 DB에 등록된 영화 목록을 가져온다.
 * 3. 사용자 요청 + DB 영화 목록을 AI Service에 전달한다.
 * 4. AI가 DB 영화 목록 안에서 영화를 추천한다.
 * 5. AI 추천 결과를 JSP로 돌려준다.
 *
 * 흐름
 *
 * booking.jsp
 *      ↓
 * AIRecommendationController
 *      ↓
 * MovieDAO
 *      ↓
 * DB
 *      ↓
 * AIRecommendationService
 *      ↓
 * OpenRouter
 *      ↓
 * AI 추천 결과
 *      ↓
 * booking.jsp
 *
 * ============================================================
 */

@WebServlet("/ai/recommendation")
public class AIRecommendationController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * ========================================================
     * POST 요청
     * ========================================================
     */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ----------------------------------------------------
        // 한글 요청 처리
        // ----------------------------------------------------

        request.setCharacterEncoding("UTF-8");

        response.setCharacterEncoding("UTF-8");

        response.setContentType(
                "text/plain; charset=UTF-8"
        );

        try {

            // ------------------------------------------------
            // 1. JSP에서 사용자 요청 받기
            // ------------------------------------------------

            String prompt =
                    request.getParameter("prompt");


            // ------------------------------------------------
            // 입력값 확인
            // ------------------------------------------------

            if (prompt == null
                    || prompt.trim().isEmpty()) {

                response.getWriter().write(
                        "어떤 영화를 원하는지 입력해주세요."
                );

                return;
            }


            // ------------------------------------------------
            // 2. MovieDAO 생성
            // ------------------------------------------------

            MovieDAO movieDAO =
                    new MovieDAO();


            // ------------------------------------------------
            // 3. DB에 등록된 영화 목록 가져오기
            // ------------------------------------------------

            List<MovieDTO> movieList =
                    movieDAO.getMovieList();


            // ------------------------------------------------
            // DB에 영화가 없는 경우
            // ------------------------------------------------

            if (movieList == null
                    || movieList.isEmpty()) {

                response.getWriter().write(
                        "현재 DB에 등록된 영화가 없습니다."
                );

                return;
            }


            // ------------------------------------------------
            // 4. AI 추천 Service 생성
            // ------------------------------------------------

            AIRecommendationService service =
                    new AIRecommendationService();


            // ------------------------------------------------
            // 5. 사용자 요청 + DB 영화 목록 전달
            // ------------------------------------------------

            String result =
                    service.getRecommendation(
                            prompt,
                            movieList
                    );


            // ------------------------------------------------
            // 6. AI 결과를 JSP로 전달
            // ------------------------------------------------

            response.getWriter().write(result);

        } catch (Exception e) {

            // ------------------------------------------------
            // 오류 확인
            // ------------------------------------------------

            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().write(
                    "AI 영화 추천 중 오류가 발생했습니다.\n"
                    + e.getMessage()
            );
        }
    }
}