package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.NoticeDTO;
import service.NoticeService;

@WebServlet("/notice/detail")
public class NoticeDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NoticeService noticeService = new NoticeService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. 브라우저에서 보낸 글 번호(id) 파라미터 받기 (예: /notice/detail?id=1)
            String idParam = request.getParameter("id");
            
            if (idParam != null && !idParam.isEmpty()) {
                int noticeId = Integer.parseInt(idParam);

                // 2. 서비스로부터 해당 글의 상세 정보 가져오기
                NoticeDTO notice = noticeService.getNoticeDetail(noticeId);

                // 3. request 객체에 데이터 담기
                request.setAttribute("notice", notice);

                // 4. 상세 보기 JSP 화면으로 이동
                request.getRequestDispatcher("/notice/NoticeDetail.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // 파라미터가 잘못되었거나 오류가 나면 목록으로 리다이렉트
        response.sendRedirect("list");
    }
}