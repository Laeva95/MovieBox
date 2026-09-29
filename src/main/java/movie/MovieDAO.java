package movie;

import java.util.ArrayList;
import java.util.List;

public class MovieDAO {

    
	// 1. 영화 목록 조회 (가짜 데이터 30개 반환)
    public List<MovieDTO> getMovieList() {
        List<MovieDTO> list = new ArrayList<>();
        
       /* try {
            // 1. KMDb API 주소와 발급받은 인증키 조합
            String serviceKey = "발급받은_인증키를_여기에_넣으세요";
            String urlStr = "http://api.koreafilm.or.kr/openapi-data2/wise"
            		+ "nut/search_json2/search_json.xml?collection=kmdb_new2&ServiceKey=" 
            		+ serviceKey;
            // 2. API 호출 및 응답 데이터 읽기 (HttpURLConnection 등 활용)
            // ... (API 연결 및 데이터 수신 코드)
        
            // 3. 받아온 JSON 데이터를 파싱하여 MovieDTO 객체로 만든 뒤 list에 담기
            // for (json 데이터 반복) {
            //     MovieDTO dto = new MovieDTO(...);
            //     list.add(dto);
            // }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
         2026-09-23  API받으면 주석 해제하기 @@@@@@@@@@@@@@@@@@@@@@   
      */      
            
            
       
        list.add(new MovieDTO(1, "범죄도시 4", "액션/범죄", "109분", "범죄도시4.webp", "한국","2024-04-24"));
        list.add(new MovieDTO(2, "인사이드 아웃 2", "애니메이션", "96분", "인사이드아웃2.webp", "미국", "2024-06-12"));
        list.add(new MovieDTO(3, "파묘", "미스터리/스릴러", "134분", "poster3.jpg", "한국", "2024-02-22"));
        list.add(new MovieDTO(4, "원더랜드", "SF/드라마", "113분", "poster4.jpg", "한국", "2024-06-05"));
        list.add(new MovieDTO(5, "퓨리오사: 매드맥스 사가", "액션/SF", "148분", "poster5.jpg", "미국", "2024-05-22"));
        list.add(new MovieDTO(6, "하이재킹", "액션/드라마", "100분", "poster6.jpg", "한국", "2024-06-21"));
        list.add(new MovieDTO(7, "데드풀과 울버린", "액션/SF/코미디", "127분", "poster7.jpg", "미국", "2024-07-24"));
        list.add(new MovieDTO(8, "파일럿", "코미디", "111분", "poster8.jpg", "한국", "2024-07-31"));
        list.add(new MovieDTO(9, "베테랑 2", "액션/범죄", "118분", "poster9.jpg", "한국", "2024-09-13"));
        list.add(new MovieDTO(10, "글래디에이터 2", "액션/드라마", "148분", "poster10.jpg", "미국", "2024-11-15"));
        list.add(new MovieDTO(11, "아바타: 물의 길", "SF/모험", "192분", "poster11.jpg", "미국", "2022-12-14"));
        list.add(new MovieDTO(12, "스파이더맨: 어크로스 더 유니버스", "애니메이션", "140분", "poster12.jpg", "미국", "2023-06-21"));
        list.add(new MovieDTO(13, "오펜하이머", "전기/드라마", "180분", "poster13.jpg", "미국", "2023-08-15"));
        list.add(new MovieDTO(14, "콘크리트 유토피아", "재난/드라마", "130분", "poster14.jpg", "한국", "2023-08-09"));
        list.add(new MovieDTO(15, "밀수", "범죄/액션", "129분", "poster15.jpg", "한국", "2023-07-26"));
        list.add(new MovieDTO(16, "서울의 봄", "드라마/역사", "141분", "poster16.jpg", "한국", "2023-11-22"));
        list.add(new MovieDTO(17, "외계+인 2부", "SF/액션", "122분", "poster17.jpg", "한국", "2024-01-10"));
        list.add(new MovieDTO(18, "시민덕희", "코미디/범죄", "113분", "poster18.jpg", "한국", "2024-01-24"));
        list.add(new MovieDTO(19, "댓글부대", "범죄/드라마", "109분", "poster19.jpg", "한국", "2024-03-27"));
        list.add(new MovieDTO(20, "원더랜드", "SF", "113분", "poster20.jpg", "한국", "2024-06-05"));
        list.add(new MovieDTO(21, "인디아나 존스: 운명의 다이얼", "액션/모험", "154분", "poster21.jpg", "미국", "2023-06-28"));
        list.add(new MovieDTO(22, "미션 임파서블: 데드 레코닝", "액션/스릴러", "163분", "poster22.jpg", "미국", "2023-07-12"));
        list.add(new MovieDTO(23, "더 마블스", "액션/SF", "105분", "poster23.jpg", "미국", "2023-11-08"));
        list.add(new MovieDTO(24, "가디언즈 오브 갤럭시: Volume 3", "액션/SF", "150분", "poster24.jpg", "미국", "2023-05-03"));
        list.add(new MovieDTO(25, "엘리멘탈", "애니메이션", "109분", "poster25.jpg", "미국", "2023-06-14"));
        list.add(new MovieDTO(26, "스즈메의 문단속", "애니메이션", "122분", "poster26.jpg", "일본", "2023-03-08"));
        list.add(new MovieDTO(27, "더 문", "SF/드라마", "137분", "poster27.jpg", "한국", "2023-08-02"));
        list.add(new MovieDTO(28, "B급 주공", "코미디", "100분", "poster28.jpg", "한국", "2023-09-01"));
        list.add(new MovieDTO(29, "타겟", "스릴러", "101분", "poster29.jpg", "한국", "2023-08-30"));
        list.add(new MovieDTO(30, "화란", "누아르/드라마", "124분", "poster30.jpg", "한국", "2023-10-11"));
        return list;
    }

    // 2. 영화 상세 정보 조회 (ID에 맞는 영화 찾기)
    public MovieDTO getMovieDetails(int movieId) {
        List<MovieDTO> list = getMovieList();
        for (MovieDTO movie : list) {
            if (movie.getMovieId() == movieId) {
                return movie;
            }
        }
        return null;
    }

	// 3. 영화 정렬해서 조회 (국가,장르,정렬방식)
    public List<MovieDTO> getFilteredAndSortedMovieList(String country, String genre, String sort) {
        List<MovieDTO> list = getMovieList(); // 전체 30개 영화 데이터 가져오기
        List<MovieDTO> result = new ArrayList<>();
        
        // 3.1. 조건에 맞는 영화 필터링 (국가, 장르)
        for (MovieDTO m : list) {
            boolean matchCountry = (country == null || country.isEmpty() || country.equals("all") || m.getCountry().equals(country));
            boolean matchGenre = (genre == null || genre.isEmpty() || genre.equals("all") || m.getGenre().contains(genre));
            
            if (matchCountry && matchGenre) {
                result.add(m);
            }
        }
        
        // 3.2. 정렬 조건 처리 (개봉순 또는 가나다순)
        if ("date".equals(sort)) {
            result.sort((m1, m2) -> m1.getReleaseDate().compareTo(m2.getReleaseDate()));
        } else if ("title".equals(sort)) {
            result.sort((m1, m2) -> m1.getTitle().compareTo(m2.getTitle()));
        }
        
        return result;
    }
    
    
    
    
    
}