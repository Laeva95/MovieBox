package movie;

public class MovieDTO {
    private int movieId;
    private String title;
    private String genre;
    private String runningTime;
    private String posterUrl;
    private String country;     // 국가 (예: "한국", "미국")
    private String releaseDate; // 개봉일 (예: "2026-09-23")
   
    
    // 생성자
    public MovieDTO(int movieId, String title, String genre,
			    		String runningTime, String posterUrl,
			    		String country, String releaseDate)
    {		       
    	this.movieId = movieId;
        this.title = title;
        this.genre = genre;
        this.runningTime = runningTime;
        this.posterUrl = posterUrl;
        this.country= country;
     
    }


    // Getter & Setter
	public int getMovieId() {return movieId;}
    public String getTitle() {return title;}
    public String getGenre() {return genre;}	
    public String getRunningTime() {return runningTime;}
	public String getPosterUrl() {return posterUrl;}
	public String getCountry() {return country;}
	public String getReleaseDate() {return releaseDate;}

	
	
	
	public void setMovieId(int movieId) {this.movieId = movieId;}
	public void setTitle(String title) {this.title = title;}
	public void setGenre(String genre) {this.genre = genre;}
	public void setRunningTime(String runningTime) {this.runningTime = runningTime;}
	public void setPosterUrl(String posterUrl) {this.posterUrl = posterUrl;}
	public void setCountry(String country) {this.country = country;}
	public void setReleaseDate(String releaseDate) {this.releaseDate = releaseDate;}
	
	
}