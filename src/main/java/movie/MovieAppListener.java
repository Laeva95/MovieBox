package movie;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class MovieAppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=========================================");
        System.out.println(" 서버 구동 감지: KMDB 영화 데이터 자동 적재 시작 ");
        System.out.println("=========================================");
        
        try {
            // 여기에 기존 관리자 모드에서 호출하던 DAO나 Service 메서드를 실행합니다.
            MovieDAO dao = new MovieDAO();
            dao.insertMovieListFromAPI(); // 영화 API 호출 및 DB 저장 메서드
            
            System.out.println(" 서버 구동 시 영화 데이터 적재 완료! ");
        } catch (Exception e) {
            System.err.println(" 영화 데이터 자동 적재 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 서버가 종료될 때 실행할 작업 (필요 없으면 비워둬도 됩니다)
    }
}