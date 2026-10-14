package store;

public class StoreDTO {

    private int id;
    private String name;
    private int price;
    private String description;
    private String image;
    private String category; // 상품 카테고리 필드 추가
 // Getter, Setter 작성

    // id
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // 상품명
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // 가격
    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    // 상품 설명
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // 이미지 경로
    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
    
    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}