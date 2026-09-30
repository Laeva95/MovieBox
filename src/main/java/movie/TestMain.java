package movie;

public class TestMain {

    public static void main(String[] args) {

        MovieDAO dao = new MovieDAO();

        // KMDb API에서 영화를 가져와
        // MySQL movie 테이블에 저장
        int count = dao.insertMovieListFromAPI();

        System.out.println(
            "DB에 저장된 영화 수 : " + count
        );
    }
}