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
                
            case "/edit": // 수정 화면 이동
                editForm(request, response);
                break;
                
            case "/editOk": // 수정 처리 (POST)
                editOk(request, response);
                break;
                
            case "/deleteOk": // 삭제 처리
                deleteOk(request, response);
                break;
                
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    // 1. 목록 조회 로직 
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
	    List<NoticeDTO> pinnedList = noticeService.getPinnedNoticeList(); // 고정글 목록
	    List<NoticeDTO> noticeList = noticeService.getNoticeList(keyword, page); // 일반 글 목록 (페이징)
        
        // JSP에 전달
	    request.setAttribute("pinnedList", pinnedList);
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
            
            // 체크박스 값 받아오기 (체크되면 "1" 또는 지정한 값, 안 되면 null)
            String isPinnedStr = multi.getParameter("is_pinned");
            int isPinned = (isPinnedStr != null) ? 1 : 0; // 체크되었으면 1, 아니면 0

            // 업로드된 파일 이름
            String fileName = multi.getFilesystemName("uploadFile");

            System.out.println("전달받은 제목: " + title);
            System.out.println("전달받은 글쓴이: " + writer);
            System.out.println("전달받은 글내용: " + content);
            System.out.println("상단 고정 여부: " + isPinned);
            System.out.println("첨부파일: " + fileName);

            // DTO에 담기
            NoticeDTO notice = new NoticeDTO();

            notice.setTitle(title);
            notice.setWriter(writer);
            notice.setContent(content);
            notice.setFileName(fileName);
            notice.setIsPinned(isPinned);

            // DB에 저장
            noticeService.registerNotice(notice);

            // 등록 후 목록으로 이동
            response.sendRedirect(request.getContextPath() + "/notice/list");

        } catch (Exception e) {
            e.printStackTrace();}
        }
        
     // 수정 화면으로 이동
        private void editForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            try {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    int noticeId = Integer.parseInt(idParam);
                    
                    // 1. 서비스나 DAO를 통해 해당 글 정보 가져오기
                    NoticeDTO notice = noticeService.getNoticeDetail(noticeId);
                    
                    // 2. request에 담아서 jsp로 보내기
                    request.setAttribute("notice", notice);
                    request.getRequestDispatcher("/notices/NoticeEdit.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("list");
        }
        
        // 글 수정 처리 로직
        private void editOk(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String uploadPath = "C:\\file_repo";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            int maxSize = 10 * 1024 * 1024;

            try {
                MultipartRequest multi = new MultipartRequest(
                        request,
                        uploadPath,
                        maxSize,
                        "UTF-8",
                        new DefaultFileRenamePolicy()
                );

                // 폼에서 넘어온 데이터 받기 (hidden으로 보낸 noticeId 포함!)
                int noticeId = Integer.parseInt(multi.getParameter("noticeId"));
                String title = multi.getParameter("Title");
                String content = multi.getParameter("noticeContent");
                
                String isPinnedStr = multi.getParameter("is_pinned");
                int isPinned = (isPinnedStr != null) ? 1 : 0;

                String fileName = multi.getFilesystemName("uploadFile");
                
                // 만약새로 파일을 올리지 않았다면 기존 파일명을 유지하거나 처리하는 로직이 필요할 수 있습니다.
                // 일단 DTO에 담기
                NoticeDTO notice = new NoticeDTO();
                notice.setNoticeId(noticeId);
                notice.setTitle(title);
                notice.setContent(content);
                notice.setFileName(fileName);
                notice.setIsPinned(isPinned);

                // DB 업데이트 서비스/DAO 호출 (아직 안 만들었다면 3번 단계 참고)
                noticeService.updateNotice(notice);

                // 수정 완료 후 상세 페이지나 목록으로 이동
                response.sendRedirect(request.getContextPath() + "/notice/detail?id=" + noticeId);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 삭제 처리 로직
        private void deleteOk(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            try {
                String idParam = request.getParameter("id");
                System.out.println("삭제하려 넘어온 id 파라미터: " + idParam); 
                
                if (idParam != null && !idParam.isEmpty()) {
                    int noticeId = Integer.parseInt(idParam);
                    
                    // DAO 또는 Service에 삭제 메서드 호출 (예: noticeService.deleteNotice(noticeId);)
                    noticeService.deleteNotice(noticeId);
                    System.out.println("삭제 서비스 호출 완료!");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            // 삭제 후 목록으로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/notice/list");
    }
}