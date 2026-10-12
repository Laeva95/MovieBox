package review;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import movie.MovieDAO;
import movie.MovieDTO;

@WebServlet({"/review/main.do", "/review/list.do", "/review/write.do", "/review/delete.do", "/review/update.do", "/review/like.do"})
public class ReviewController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private ReviewService reviewService = new ReviewService();
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}
	
	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String servletPath = request.getServletPath();
		HttpSession session = request.getSession();
		
		// ===============================================
		// 리뷰 메인 화면 (/review/main.do)
		// ===============================================
		if (servletPath.equals("/review/main.do")) {
			MovieDAO movieDAO = new MovieDAO();
			List<MovieDTO> movieList = movieDAO.getMovieList(); // 전체 상영작 목록
			
			// 1. 영화별 평균 평점 계산 및 맵 저장
			Map<Integer, Double> ratingMap = new HashMap<>();
			if (movieList != null) {
				for (MovieDTO m : movieList) {
					ratingMap.put(m.getMovieId(), reviewService.getMovieAvgRating(m.getMovieId()));
				}
				
				// 2. 평균 별점 높은 순으로 영화 목록 정렬 (내림차순)
				movieList.sort((m1, m2) -> {
					Double score1 = ratingMap.getOrDefault(m1.getMovieId(), 0.0);
					Double score2 = ratingMap.getOrDefault(m2.getMovieId(), 0.0);
					return Double.compare(score2, score1);
				});
			}
			
			// 3. 전체 최신 리뷰 목록 10개
			List<ReviewDTO> recentReviews = reviewService.getRecentReviews(10);
			
			request.setAttribute("movieList", movieList);
			request.setAttribute("ratingMap", ratingMap);
			request.setAttribute("recentReviews", recentReviews);
			
			request.setAttribute("center", "/review/reviewMain.jsp");
			RequestDispatcher rd = request.getRequestDispatcher("/Index.jsp");
			rd.forward(request, response);
			
		// ===============================================
		// [기능 1] 개별 영화 리뷰 상세 목록 (/review/list.do)
		// ===============================================
		} else if (servletPath.equals("/review/list.do")) {
			String movieIdParam = request.getParameter("movieId");
			int movieId = (movieIdParam != null && !movieIdParam.isEmpty()) ? Integer.parseInt(movieIdParam) : 1;

			//정렬 피라미터(sort) 수신 (전달값이 없거나 잘못되면 기본값 recent)
			String sort = request.getParameter("sort");
			if (sort == null || (!sort.equals("likes") && !sort.equals("recent"))) {
					sort = "recent";
			}
			
			MovieDAO movieDAO = new MovieDAO();
			MovieDTO movie = movieDAO.getMovieDetails(movieId);

			List<ReviewDTO> reviewList = reviewService.getMovieReviews(movieId, sort);
			double avgRating = reviewService.getMovieAvgRating(movieId);

			String loginId = getLoginMemberId(session);
			boolean isAudience = false;
			boolean hasReviewed = false;
			if (loginId != null) {
				isAudience = reviewService.isVerifiedAudience(loginId, movieId);
				hasReviewed = reviewService.hasUserReviewed(loginId, movieId);
			}

			request.setAttribute("movie", movie);
			request.setAttribute("movieId", movieId);
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("avgRating", avgRating);
			request.setAttribute("isAudience", isAudience);
			request.setAttribute("hasReviewed", hasReviewed);

			//화면에서 [최신순]/[공감순] 중 어느 탭이 활성화되어 있는지 알 수 있도록 전달
			request.setAttribute("currentSort", sort);
			
			request.setAttribute("center", "/review/reviewSection.jsp");
			RequestDispatcher rd = request.getRequestDispatcher("/Index.jsp");
			rd.forward(request, response);
            
		// ===============================================
		// [기능 2] 리뷰 등록 (/review/write.do)
		// ===============================================
		} else if (servletPath.equals("/review/write.do")) {
			String loginMemberId = getLoginMemberId(session);
			if (loginMemberId == null) {
			    PrintWriter out = response.getWriter();
			    out.println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='" + request.getContextPath() + "/member/Login.do';</script>");
			    return;
			}

			int movieId = Integer.parseInt(request.getParameter("movieId"));
			int rating = Integer.parseInt(request.getParameter("rating"));
			String content = request.getParameter("content");

			ReviewDTO dto = new ReviewDTO(movieId, loginMemberId, rating, content);
			boolean isSuccess = reviewService.addReview(dto);

			if (isSuccess) {
				response.sendRedirect(request.getContextPath() + "/review/list.do?movieId=" + movieId);
			} else {
				PrintWriter out = response.getWriter();
				out.println("<script>alert('리뷰 등록에 실패했습니다.'); history.back();</script>");
			}
			
		// ===============================================
		// [기능 3] 리뷰 삭제 (/review/delete.do)
		// ===============================================
		} else if (servletPath.equals("/review/delete.do")) {
			int reviewId = Integer.parseInt(request.getParameter("reviewId"));
			int movieId = Integer.parseInt(request.getParameter("movieId"));

			String loginMemberId = getLoginMemberId(session);
			if (loginMemberId == null) {
				PrintWriter out = response.getWriter();
				out.println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='" + request.getContextPath() + "/member/Login.do';</script>");
				return;
			}

			boolean isDeleted = reviewService.removeReview(reviewId, loginMemberId);
			if (isDeleted) {
				response.sendRedirect(request.getContextPath() + "/review/list.do?movieId=" + movieId);
			} else {
				PrintWriter out = response.getWriter();
				out.println("<script>alert('삭제 권한이 없거나 실패했습니다.'); history.back();</script>");
			}

		// ===============================================
		// [기능 4] 리뷰 수정 처리 (/review/update.do)
		// ===============================================	
		} else if (servletPath.equals("/review/update.do")) {

			String loginMemberId = getLoginMemberId(session);
			if (loginMemberId == null) {
				PrintWriter out = response.getWriter();
				out.println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='" + request.getContextPath() + "/member/Login.do';</script>");
				return;
			}

			int reviewId = Integer.parseInt(request.getParameter("reviewId"));
			int movieId = Integer.parseInt(request.getParameter("movieId"));
			int rating = Integer.parseInt(request.getParameter("rating"));
			String content = request.getParameter("content");

			ReviewDTO dto = new ReviewDTO();
			dto.setReviewId(reviewId);
			dto.setMovieId(movieId);
			dto.setMemberId(loginMemberId);
			dto.setRating(rating);
			dto.setContent(content);

			boolean isModified = reviewService.modifyReview(dto);

			if (isModified) {
				response.sendRedirect(request.getContextPath() + "/review/list.do?movieId=" + movieId);
			} else {
				PrintWriter out = response.getWriter();
				out.println("<script>alert('수정 권한이 없거나 실패했습니다.'); history.back();</script>");
			}

		//====================================================
	    // [기능 5] 관람평 좋아요 비동기(AJAX) 처리 (/review/like.do)
		//====================================================
		} else if (servletPath.equals("/review/like.do")) {	
			response.setContentType("application/json; charset=UTF-8");
			PrintWriter out = response.getWriter();

			//로그인 확인 (비로그인 상태면 차단)
			String loginMemberId = getLoginMemberId(session);
			if (loginMemberId == null) {
				out.print("{\"status\":\"need_login\"}");
				out.flush();
				return;
			}

			String reviewIdParam = request.getParameter("reviewId");
			int reviewId = (reviewIdParam != null && !reviewIdParam.isEmpty()) ? Integer.parseInt(reviewIdParam) : 0;
	
			//세션에서 사용자가 이미 공감을 누른 리뷰 번호 집합(Set)을 꺼냄
			@SuppressWarnings("unchecked")
			Set<Integer> likedReviews = (Set<Integer>) session.getAttribute("likedReviews");
			if (likedReviews == null) {
				likedReviews = new HashSet<>();
				session.setAttribute("likedReviews", likedReviews); //처음 누를 때 세션 생성
			}
			
			//이미 누른 적이 있는 리뷰라면 DB 증가 없이 차단
			if (likedReviews.contains(reviewId)) {
				out.print("{\"status\":\"already_liked\"}");
				out.flush();
				return;
			}
			
			//신규 클릭인 경우 : DB의 좋아요 수 1 증가
			int newLikes = reviewService.likeReview(reviewId);
			if (newLikes >= 0) {
				likedReviews.add(reviewId); //세션에 기록하여 재클릭 방지
				out.print("{\"status\":\"success\", \"likeCount\":" + newLikes + "}");
			} else {
				out.print("{\"status\":\"fail\"}");
			}
			
			out.flush();
			return;
			
		// ===============================================
		// 그 외 잘못된 요청 경로
		// ===============================================
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "잘못된 요청 경로입니다.");
		}
	}
	
    private String getLoginMemberId(HttpSession session) {
        if (session == null) return null;
        String[] keys = {"id", "member_id", "memberId", "loginId", "userId"};
        for (String key : keys) {
            Object val = session.getAttribute(key);
            if (val instanceof String && !((String) val).trim().isEmpty()) {
                return (String) val;
            }
        }
        Object memberObj = session.getAttribute("member");
        if (memberObj != null) {
            try {
                java.lang.reflect.Method m = null;
                try {
                    m = memberObj.getClass().getMethod("getId");
                } catch (NoSuchMethodException e) {
                    try {
                        m = memberObj.getClass().getMethod("getMember_id");
                    } catch (NoSuchMethodException e2) {
                        m = memberObj.getClass().getMethod("getMemberId");
                    }
                }
                if (m != null) {
                    Object res = m.invoke(memberObj);
                    if (res != null) return res.toString();
                }
            } catch (Exception ignored) {}
        }
        return null;
    }
}