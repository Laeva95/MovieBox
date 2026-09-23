package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dto.NoticeDTO;
import service.NoticeService;

@WebServlet("/notice/list")
public class NoticeListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NoticeService noticeService = new NoticeService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 서비스로부터 공지사항 목록 가져오기
        List<NoticeDTO> noticeList = noticeService.getNoticeList();

        // 2. request 객체에 목록 담기
        request.setAttribute("noticeList", noticeList);

        // 3. JSP 화면(View)으로 포워딩 (아직 JSP를 안 만들었다면 이따가 만들 경로로 지정)
        request.getRequestDispatcher("/notice/noticeList.jsp").forward(request, response);
    }
}