package movie;

public class MovieDTO { //
    private int movieId; 		// 영화 고유 ID
    private String title;		// 영화 제목
    private String genre;		// 영화 장르 (예: "액션", "코미디", "드라마")
    private String runningTime;	// 영화 상영 시간 (예: "120분")
    private String poster;		// 영화 포스터 이미지 URL
    private String country;     // 국가 (예: "한국", "미국")
    private String releaseDate; // 개봉일 (예: "2026-09-23")
    private String summary;		// 영화 줄거리 (예: "이 영화는 ...")
    private String directors;	// 영화 감독 (예: "봉준호")
    private String actors;		// 영화 배우 (예: "송강호, 이선균")
   
    
    public MovieDTO() {}  
	/*
	 * 	💡 public MovieDTO() { }를 명시하는 이유 요약 
	 * 	1. 기본 생성자 부활: 이미 다른 생성자가 존재하더라도 newMovieDTO() 형태로 빈 객체를 생성할 수 있게 허용하기 위함입니다. 
	 * 	2. 유연한 데이터 세팅: 빈 객체를 먼저 안전하게 생성해 두고, 데이터베이스(DB)에서 rs.next()를 통해
	 * 	   꺼내오는 값들만 movie.setTitle(), movie.setPoster()처럼 필요한 것만 콕 집어서 차례대로 담기 위함입니다.
	 *
	 * 모루겟어
	 * 3줄 요약 
	 * • MovieDTO() 기본 생성자: 값이 비어있는 객체(가방)를 생성하는 역할만 합니다. 
	 * • rs.getString("컬럼명"): DB에서 데이터를 꺼내는 역할입니다. 
	 * • movie.setPoster(...): 꺼낸 DB 데이터를 가방에 집어넣는 진짜 주인공입니다.  		
	 */
    
    
    
    //	MovieDTO 객체를 생성할 때 필요한 모든 정보를 매개변수로 받아 초기화
    public MovieDTO(int movieId, String title, String genre,
			    		String runningTime, String poster,
			    		String country, String releaseDate,
			    		String summary, String director, String actors)	
    {		       
    	this.movieId = movieId;			// 1번째가 영화 고유 ID!
        this.title = title;				// 2번째가 제목!
        this.genre = genre;				// 3번째가 장르!
        this.runningTime = runningTime; // 4번째가 상영시간!
        this.poster = poster;			// 5번째가 포스터!
        this.country= country;			// 6번째가 국가!
        this.releaseDate = releaseDate; // 7번째가 개봉일!
        this.summary = summary;			// 8번째가 줄거리!
        this.directors = director;		// 9번째가 감독!
        this.actors = actors;			// 10번째가 배우!
    }

   

    // Getter & Setter  
    
    // 영화 고유 ID를 반환
	public int getMovieId() {return movieId;} 
	// 영화 제목을 반환
    public String getTitle() {return title;}
    // 영화 장르를 반환
    public String getGenre() {return genre;}		
    // 영화 상영 시간을 반환
    public String getRunningTime() {return runningTime;}
    // 영화 포스터 이미지 URL을 반환
    // 2. 다른 클래스에서 변수 값을 꺼내갈 수 있도록 통로를 열어준 Getter 메소드
    // ★ 바로 이 메소드가 질문하신 movie.getPoster()의 진짜 정체입니다!
	public String getPoster() {return poster;}	
	// 영화 국가를 반환
	public String getCountry() {return country;}	
	// 영화 개봉일을 반환
	public String getReleaseDate() {return releaseDate;}	
	// 영화 줄거리를 반환
	public String getSummary() {return summary;}	
	// 영화 감독을 반환
	public String getDirector() {return directors;}	
	// 영화 배우를 반환
	public String getActors() {return actors;}	


	
	
	// 영화 고유 ID를 설정
	public void setMovieId(int movieId) {this.movieId = movieId;}	
	// 영화 제목을 설정
	public void setTitle(String title) {this.title = title;}	
	// 영화 장르를 설정
	public void setGenre(String genre) {this.genre = genre;}	
	// 영화 상영 시간을 설정
	public void setRunningTime(String runningTime) {this.runningTime = runningTime;} 
	// 영화 포스터 이미지 URL을 설정
	// 3. 변수에 값을 저장하는 Setter 메소드
	public void setPoster(String poster) {this.poster = poster;}	
	// 영화 국가를 설정
	public void setCountry(String country) {this.country = country;}	
	// 영화 개봉일을 설정
	public void setReleaseDate(String releaseDate) {this.releaseDate = releaseDate;} 
	// 영화 줄거리를 설정
	public void setSummary(String summary) {this.summary = summary;}
	// 영화 감독을 설정
	public void setDirector(String director) {this.directors = director;}
	// 영화 배우를 설정
	public void setActors(String actors) {this.actors = actors;}
}