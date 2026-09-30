package movie;

public class MovieDTO {
    private int movieId;
    private String title;
    private String genre;
    private String runningTime;
    private String poster;
    private String country;     // 국가 (예: "한국", "미국")
    private String releaseDate; // 개봉일 (예: "2026-09-23")
    private String directors;
    private String actors;
    private String summary;
   
    
    
    
    
    
    // 생성자
    public MovieDTO(int movieId, String title, String genre,
			    		String runningTime, String poster,
			    		String country, String releaseDate,
			    		String director, String actors, String summary)
    {		       
    	this.movieId = movieId;
        this.title = title;
        this.genre = genre;
        this.runningTime = runningTime;
        this.poster = poster;
        this.country= country;
        this.releaseDate = releaseDate; // 7번째가 개봉일!
        this.directors= director;
        this.actors= actors;
        this.summary= summary;
    }

    public MovieDTO() {}
    
    

    // Getter & Setter
	public int getMovieId() {return movieId;}
    public String getTitle() {return title;}
    public String getGenre() {return genre;}	
    public String getRunningTime() {return runningTime;}
	public String getPoster() {return poster;}
	public String getCountry() {return country;}
	public String getReleaseDate() {return releaseDate;}
	public String getDirector() {return directors;}
	public String getActors() {return actors;}
	public String getSummary() {return summary;}

	
	
	
	public void setMovieId(int movieId) {this.movieId = movieId;}
	public void setTitle(String title) {this.title = title;}
	public void setGenre(String genre) {this.genre = genre;}
	public void setRunningTime(String runningTime) {this.runningTime = runningTime;}
	public void setPoster(String poster) {this.poster = poster;}
	public void setCountry(String country) {this.country = country;}
	public void setReleaseDate(String releaseDate) {this.releaseDate = releaseDate;}
	public void setDirector(String director) {this.directors = director;}
	public void setActors(String actors) {this.actors = actors;}
	public void setSummary(String summary) {this.summary = summary;}

	
	
	
	
	
	
	
}