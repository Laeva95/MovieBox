package movie;

public class MovieDTO {

    private int movieId;

    private String title;

    private String genre;

    private String runningTime;

    private String posterUrl;

    private String country;

    private String releaseDate;

    private String summary;

    private String director;

    private String actors;


    // ====================================================
    // 기본 생성자
    // ====================================================

    public MovieDTO() {

    }


    // ====================================================
    // 7개짜리 생성자
    // ====================================================

    public MovieDTO(
            int movieId,
            String title,
            String genre,
            String runningTime,
            String posterUrl,
            String country,
            String releaseDate) {

        this.movieId = movieId;
        this.title = title;
        this.genre = genre;
        this.runningTime = runningTime;
        this.posterUrl = posterUrl;
        this.country = country;
        this.releaseDate = releaseDate;
    }


    // ====================================================
    // 10개짜리 생성자
    // MovieDAO에서 사용하는 생성자
    // ====================================================

    public MovieDTO(
            int movieId,
            String title,
            String genre,
            String runningTime,
            String posterUrl,
            String country,
            String releaseDate,
            String summary,
            String director,
            String actors) {

        this.movieId = movieId;
        this.title = title;
        this.genre = genre;
        this.runningTime = runningTime;
        this.posterUrl = posterUrl;
        this.country = country;
        this.releaseDate = releaseDate;
        this.summary = summary;
        this.director = director;
        this.actors = actors;
    }


    // ====================================================
    // movieId
    // ====================================================

    public int getMovieId() {

        return movieId;
    }

    public void setMovieId(int movieId) {

        this.movieId = movieId;
    }


    // ====================================================
    // title
    // ====================================================

    public String getTitle() {

        return title;
    }

    public void setTitle(String title) {

        this.title = title;
    }


    // ====================================================
    // genre
    // ====================================================

    public String getGenre() {

        return genre;
    }

    public void setGenre(String genre) {

        this.genre = genre;
    }


    // ====================================================
    // runningTime
    // ====================================================

    public String getRunningTime() {

        return runningTime;
    }

    public void setRunningTime(String runningTime) {

        this.runningTime = runningTime;
    }


    // ====================================================
    // posterUrl
    // ====================================================

    public String getPosterUrl() {

        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {

        this.posterUrl = posterUrl;
    }


    // ====================================================
    // ★ poster
    // MovieList.jsp에서 사용하는 메서드
    // 기존 posterUrl과 같은 값을 반환
    // ====================================================

    public String getPoster() {

        return posterUrl;
    }

    public void setPoster(String poster) {

        this.posterUrl = poster;
    }


    // ====================================================
    // country
    // ====================================================

    public String getCountry() {

        return country;
    }

    public void setCountry(String country) {

        this.country = country;
    }


    // ====================================================
    // releaseDate
    // ====================================================

    public String getReleaseDate() {

        return releaseDate;
    }

    public void setReleaseDate(String releaseDate) {

        this.releaseDate = releaseDate;
    }


    // ====================================================
    // summary
    // ====================================================

    public String getSummary() {

        return summary;
    }

    public void setSummary(String summary) {

        this.summary = summary;
    }


    // ====================================================
    // director
    // ====================================================

    public String getDirector() {

        return director;
    }

    public void setDirector(String director) {

        this.director = director;
    }


    // ====================================================
    // actors
    // ====================================================

    public String getActors() {

        return actors;
    }

    public void setActors(String actors) {

        this.actors = actors;
    }

}