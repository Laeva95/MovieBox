package movie;

import java.time.Duration;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class MovieAppListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    // 한국 시간대
    private static final ZoneId ZONE =
            ZoneId.of("Asia/Seoul");

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=========================================");
        System.out.println(" 서버 구동: KMDB 영화 데이터 갱신 시작 ");
        System.out.println("=========================================");

        // 기존 기능: 서버 시작 시 1회 갱신
        try {
            MovieDAO dao = new MovieDAO();
            dao.insertMovieListFromAPI();

            System.out.println("서버 시작 시 영화 데이터 갱신 완료!");
        } catch (Exception e) {
            System.err.println("초기 영화 데이터 갱신 실패");
            e.printStackTrace();
        }

        // 추가 기능: 매일 00시 자동 갱신
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduleNextRefresh();
    }

    private void scheduleNextRefresh() {
        if (scheduler == null || scheduler.isShutdown()) {
            return;
        }

        ZonedDateTime now = ZonedDateTime.now(ZONE);

        // 다음 실행 시각: 매일 오전 9시 정각
        ZonedDateTime next = now
                .withHour(0)
                .withMinute(0)
                .withSecond(0)
                .withNano(0);

        // 오늘 00시 지났다면 내일로 설정
        if (!next.isAfter(now)) {
            next = next.plusDays(1);
        }

        long delay = Duration.between(now, next).toMillis();

        System.out.println(
                "다음 영화 데이터 갱신 예정: " + next
        );

        scheduler.schedule(() -> {
            try {
                System.out.println(
                        "정기 영화 데이터 갱신 시작: "
                        + ZonedDateTime.now(ZONE)
                );

                MovieDAO dao = new MovieDAO();
                dao.insertMovieListFromAPI();

                System.out.println("정기 영화 데이터 갱신 완료!");

            } catch (Exception e) {
                System.err.println("정기 영화 데이터 갱신 실패");
                e.printStackTrace();

            } finally {
                // 다음 실행 시각 예약
                scheduleNextRefresh();
            }
        }, delay, TimeUnit.MILLISECONDS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 웹 애플리케이션 종료 시 예약 작업 정리
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }
}