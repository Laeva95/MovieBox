package notice;

import java.io.File; 
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("/notice/*") // /notice/ 이하의 모든 요청을 이 컨트롤러가 받음
public class NoticeController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NoticeService noticeService = new NoticeService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        process(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        process(request, response);
    }

    private void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 한글 인코딩 처리 (모든 요청 공통)
        request.setCharacterEncoding("UTF-8");

        // 요청 경로 파악 (예: /notice/list -> /list, /notice/detail -> /detail)
        String command = request.getPathInfo();
        
        System.out.println("command : " + command);
        
        
        if (command == null) {
            command = "/list"; // 기본값은 목록 화면
        }

        switch (command) {
            case "/list": // 공지사항 목록
                listNotice(request, response);
                break;
                
            case "/detail": // 상세 보기
                detailNotice(request, response);
                break;
                
            case "/write": // 글쓰기 화면 이동
                writeForm(request, response);
                break;
                
            case "/writeOk": // 글 등록 처리 (POST)
                writeOk(request, response);
                break;
                
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    // 1. 목록 조회 로직 (기존 NoticeController 내용)
    private void listNotice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageParam = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        
        int page = 1; // 기본값은 1페이지
        
		if (pageParam != null && !pageParam.isEmpty()) {
				page = Integer.parseInt(pageParam);
		}
		
		 // 한 페이지에 보여줄 게시글 수
	    int pageSize = 10;
	    
	    // 전체 게시글 개수
	    int totalCount = noticeService.getNoticeCount(keyword);

	    // 전체 페이지 수 계산
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
		// 기존 목록 조회
        List<NoticeDTO> noticeList = noticeService.getNoticeList(keyword, page);
        
        // JSP에 전달
        request.setAttribute("noticeList", noticeList);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        
        
        request.getRequestDispatcher("/notices/Notice.jsp").forward(request, response);
    }

    // 2. 상세 보기 로직 (기존 NoticeDetailController 내용)
    private void detailNotice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int noticeId = Integer.parseInt(idParam);
                NoticeDTO notice = noticeService.getNoticeDetail(noticeId);
                request.setAttribute("notice", notice);
                request.getRequestDispatcher("/notices/NoticeDetail.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("list");
    }

    // 3. 글쓰기 폼 이동 로직
    private void writeForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/notices/NoticeWrite.jsp").forward(request, response);
    }

    // 4. 글 등록 처리 로직 (파일 업로드 대응 버전)
    private void writeOk(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 파일을 저장할 폴더
        String uploadPath = "C:\\file_repo";

        // 폴더가 없으면 자동으로 생성
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 최대 업로드 크기: 10MB
        int maxSize = 10 * 1024 * 1024;

        try {
            // COS로 multipart/form-data 요청 처리
            MultipartRequest multi = new MultipartRequest(
                    request,
                    uploadPath,
                    maxSize,
                    "UTF-8",
                    new DefaultFileRenamePolicy()
            );

            // 일반 폼 데이터
            String title = multi.getParameter("Title");
            String writer = multi.getParameter("noticeWriter");
            String content = multi.getParameter("noticeContent");

            // 업로드된 파일 이름
            String fileName = multi.getFilesystemName("uploadFile");

            System.out.println("전달받은 제목: " + title);
            System.out.println("전달받은 글쓴이: " + writer);
            System.out.println("전달받은 글내용: " + content);
            System.out.println("첨부파일: " + fileName);

            // DTO에 담기
            NoticeDTO notice = new NoticeDTO();

            notice.setTitle(title);
            notice.setWriter(writer);
            notice.setContent(content);
            notice.setFileName(fileName);

            // DB에 저장
            noticeService.registerNotice(notice);

            // 등록 후 목록으로 이동
            response.sendRedirect(request.getContextPath() + "/notice/list");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}