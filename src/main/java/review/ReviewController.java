package review;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet({"/review/list.do", "/review/write.do", "/review/delete.do"})
public class ReviewController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	// 비즈니스 로직을 처리할 서비스 객체
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
		
		// 1. 한글 파라미터 인코딩 처리
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		// 2. 요청된 세부 경로(Path) 추출
		String servletPath = request.getServletPath();
		System.out.println("[ReviewController] 요청 경로: " + servletPath);

		HttpSession session = request.getSession();
		
		// =================================
		// [기능 1] 리뷰 등록 요청 (/write.do)
		// =================================
		if (servletPath.equals("/review/write.do")) {
            
			String loginMemberId = (String) session.getAttribute("loginId");
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
			
		// =================================
		// [기능 2] 리뷰 목록 조회 요청 (/list.do)
		// =================================
		} else if (servletPath.equals("/review/list.do")) {

			String movieIdParam = request.getParameter("movieId");
			int movieId = (movieIdParam != null && !movieIdParam.isEmpty()) ? Integer.parseInt(movieIdParam) : 1;

			List<ReviewDTO> reviewList = reviewService.getMovieReviews(movieId);
			double avgRating = reviewService.getMovieAvgRating(movieId);

			String loginId = (String) session.getAttribute("loginId");
			boolean isAudience = false;
			if (loginId != null) {
				isAudience = reviewService.isVerifiedAudience(loginId, movieId);
			}

			request.setAttribute("movieId", movieId);
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("avgRating", avgRating);
			request.setAttribute("isAudience", isAudience);

			
			request.setAttribute("center", "/review/reviewSection.jsp");
			RequestDispatcher rd = request.getRequestDispatcher("/Index.jsp");
			rd.forward(request, response);
            
		// =======================================
		// [기능 3] 리뷰 삭제 요청 (/delete.do)
		// =======================================
		} else if (servletPath.equals("/review/delete.do")) {

			int reviewId = Integer.parseInt(request.getParameter("reviewId"));
			int movieId = Integer.parseInt(request.getParameter("movieId"));

			String loginMemberId = (String) session.getAttribute("loginId");
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
			
		// ===============================
		// 그 외 일치하는 주소가 없을 때
		// ===============================
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "잘못된 요청 경로입니다.");
		}
	}
}