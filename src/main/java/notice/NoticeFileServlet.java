package notice;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/notice/file")
public class NoticeFileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String UPLOAD_PATH = "C:\\file_repo";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("fileName");
        String mode = request.getParameter("mode");

        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 파일명으로 다른 경로에 접근하지 못하도록 처리
        fileName = new File(fileName).getName();

        File file = new File(UPLOAD_PATH, fileName);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 파일 종류 확인
        String contentType = getServletContext().getMimeType(file.getName());

        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        response.setContentLengthLong(file.length());

        // 보기
        if ("view".equals(mode)) {

            response.setHeader(
                "Content-Disposition",
                "inline; filename=\"" +
                URLEncoder.encode(file.getName(), "UTF-8") +
                "\""
            );

        // 다운로드
        } else {

            response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"" +
                URLEncoder.encode(file.getName(), "UTF-8") +
                "\""
            );
        }

        try (
            FileInputStream fis = new FileInputStream(file);
            OutputStream os = response.getOutputStream()
        ) {

            byte[] buffer = new byte[4096];
            int length;

            while ((length = fis.read(buffer)) != -1) {
                os.write(buffer, 0, length);
            }
        }
    }
}