package notice;

import java.io.IOException; 
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/notice/list")
public class NoticeListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NoticeService noticeService = new NoticeService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	// 0. 한글 깨짐 방지 (검색어가 한글일 때 필수!)
        request.setCharacterEncoding("UTF-8");
    	
        // 1. 검색어 파라미터 받아오기
        String keyword = request.getParameter("keyword");
        
        // 2. 서비스로부터 검색어가 포함된 공지사항 목록 가져오기
        List<NoticeDTO> noticeList = noticeService.getNoticeList(keyword);

        // 3. request 객체에 목록 담기
        request.setAttribute("noticeList", noticeList);

        // 4. JSP 화면(View)으로 포워딩
        request.getRequestDispatcher("/notice/noticeList.jsp").forward(request, response);
    }
}