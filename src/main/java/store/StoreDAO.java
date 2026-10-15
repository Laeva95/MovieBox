package store;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.InitialContext; 
import javax.sql.DataSource;

public class StoreDAO {
	// 커넥션풀 (DB 연결을 미리 여러 개 만들어 둔 보관함)
	private DataSource ds;
	
	//-----------------------------------
	// 생성자
	//-----------------------------------
	public StoreDAO() {
	    try {
	        InitialContext ctx = new InitialContext();
	        ds = (DataSource) ctx.lookup("java:comp/env/jdbc/moviebox");
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	// 기존 상품 전체 조회 코드
	public List<StoreDTO> getStoreList() {
	    List<StoreDTO> storeList = new ArrayList<>();


		String sql =
		    "SELECT id, name, price, description, image, category " +
		    "FROM store ORDER BY id";


	    try (
	        Connection conn = ds.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        ResultSet rs = pstmt.executeQuery()
	    ) {
	        while (rs.next()) {
	            StoreDTO store = new StoreDTO();

	            store.setId(rs.getInt("id"));
	            store.setName(rs.getString("name"));
	            store.setPrice(rs.getInt("price"));
	            store.setDescription(rs.getString("description"));
	            store.setImage(rs.getString("image"));
	            store.setCategory(rs.getString("category"));


	            storeList.add(store);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return storeList;
	}
	
	// 전체 상품 조회 (필터링용)
	public List<StoreDTO> getAllItems() {
	    return getStoreList();
	}

    // 상품 정렬 및 카테고리 조회
    public List<StoreDTO> getSortedStoreList(
            String category, String sort) {

        List<StoreDTO> list = new ArrayList<>();

        // 정렬 기준은 허용된 값만 사용
        String orderBy;

        if ("popular".equals(sort)) {
            orderBy = "COALESCE(sales.total_sold, 0) DESC, s.id ASC";
        } else if ("low-price".equals(sort)) {
            orderBy = "s.price ASC, s.id ASC";
        } else if ("high-price".equals(sort)) {
            orderBy = "s.price DESC, s.id ASC";
        } else {
            // 추천순: 기본 상품 순서
            orderBy = "s.id ASC";
            sort = "recommend";
        }

        StringBuilder sql = new StringBuilder();

        sql.append(
            "SELECT s.id, s.name, s.price, ");
        sql.append(
            "s.description, s.image, s.category ");
        sql.append(
            "FROM store s ");

        // 주문 상품별 누적 판매 수량
        sql.append(
            "LEFT JOIN ( ");
        sql.append(
            "SELECT product_id, SUM(quantity) AS total_sold ");
        sql.append(
            "FROM store_order_items ");
        sql.append(
            "GROUP BY product_id ");
        sql.append(
            ") sales ON s.id = sales.product_id ");

        boolean filterCategory =
                category != null
                && !category.isEmpty()
                && !"전체".equals(category);

        if (filterCategory) {
            sql.append("WHERE s.category = ? ");
        }

        sql.append("ORDER BY ");
        sql.append(orderBy);

        if (ds == null) {
            System.err.println("DB 연결 실패: DataSource가 null입니다.");
            return list;
        }

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt =
                     conn.prepareStatement(sql.toString())) {

            if (filterCategory) {
                pstmt.setString(1, category);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    StoreDTO store = new StoreDTO();

                    store.setId(rs.getInt("id"));
                    store.setName(rs.getString("name"));
                    store.setPrice(rs.getInt("price"));
                    store.setDescription(
                            rs.getString("description"));
                    store.setImage(rs.getString("image"));
                    store.setCategory(rs.getString("category"));
                    
                   

                    list.add(store);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
	
 // 상품 ID로 상품 한 개 조회
 	public StoreDTO getStoreById(int id) {
 	    StoreDTO product = null;

 	    // category 컬럼 추가
 	    String sql =
 	        "SELECT id, name, price, description, image, category " +
 	        "FROM store WHERE id = ?";

 	    if (ds == null) {
 	        System.err.println(
 	            "DB 연결 실패: DataSource(ds)가 null입니다."
 	        );
 	        return null;
 	    }

 	    try (
 	        Connection conn = ds.getConnection();
 	        PreparedStatement pstmt = conn.prepareStatement(sql)
 	    ) {
 	        pstmt.setInt(1, id);

 	        try (ResultSet rs = pstmt.executeQuery()) {
 	            if (rs.next()) {
 	                product = new StoreDTO();

 	                product.setId(rs.getInt("id"));
 	                product.setName(rs.getString("name"));
 	                product.setPrice(rs.getInt("price"));
 	                product.setDescription(
 	                    rs.getString("description")
 	                );
 	                product.setImage(rs.getString("image"));
 	                product.setCategory(rs.getString("category")); // 카테고리 추가
 	            }
 	        }

 	    } catch (SQLException e) {
 	        System.err.println("상품 조회 중 DB 오류 발생");
 	        e.printStackTrace();
 	    }

 	    return product;
 	}

	// 주문 생성 처리
	public int createOrder(String memberId, Map<Integer, Integer> cart)
	        throws SQLException {

	    if (ds == null) {
	        throw new SQLException("데이터베이스 연결이 설정되지 않았습니다.");
	    }

	    if (memberId == null || memberId.isEmpty()
	            || cart == null || cart.isEmpty()) {
	        throw new SQLException("회원 정보 또는 장바구니가 비어 있습니다.");
	    }

	    try (Connection conn = ds.getConnection()) {
	        conn.setAutoCommit(false);

	        try {
	            List<StoreDTO> products = new ArrayList<>();
	            int totalPrice = 0;

	            String selectSql =
	                    "SELECT id, name, price FROM store WHERE id = ?";

	            try (PreparedStatement pstmt =
	                    conn.prepareStatement(selectSql)) {

	                for (Map.Entry<Integer, Integer> entry
	                        : cart.entrySet()) {

	                    int productId = entry.getKey();
	                    int quantity = entry.getValue();

	                    if (productId <= 0 || quantity <= 0) {
	                        throw new SQLException("잘못된 상품 정보입니다.");
	                    }

	                    pstmt.setInt(1, productId);

	                    try (ResultSet rs = pstmt.executeQuery()) {
	                        if (!rs.next()) {
	                            throw new SQLException(
	                                    "존재하지 않는 상품입니다: " + productId);
	                        }

	                        StoreDTO product = new StoreDTO();
	                        product.setId(rs.getInt("id"));
	                        product.setName(rs.getString("name"));
	                        product.setPrice(rs.getInt("price"));

	                        products.add(product);
	                        totalPrice += product.getPrice() * quantity;
	                    }
	                }
	            }

	            String orderSql =
	                    "INSERT INTO store_orders "
	                    + "(member_id, total_price) VALUES (?, ?)";

	            int orderId;

	            try (PreparedStatement pstmt = conn.prepareStatement(
	                    orderSql, Statement.RETURN_GENERATED_KEYS)) {

	                pstmt.setString(1, memberId);
	                pstmt.setInt(2, totalPrice);
	                pstmt.executeUpdate();

	                try (ResultSet rs = pstmt.getGeneratedKeys()) {
	                    if (!rs.next()) {
	                        throw new SQLException("주문 번호를 생성하지 못했습니다.");
	                    }

	                    orderId = rs.getInt(1);
	                }
	            }

	            String itemSql =
	                    "INSERT INTO store_order_items "
	                    + "(order_id, product_id, product_name, quantity, price) "
	                    + "VALUES (?, ?, ?, ?, ?)";

	            try (PreparedStatement pstmt =
	                    conn.prepareStatement(itemSql)) {

	                for (StoreDTO product : products) {
	                    int quantity = cart.get(product.getId());

	                    pstmt.setInt(1, orderId);
	                    pstmt.setInt(2, product.getId());
	                    pstmt.setString(3, product.getName());
	                    pstmt.setInt(4, quantity);
	                    pstmt.setInt(5, product.getPrice());

	                    pstmt.addBatch();
	                }

	                pstmt.executeBatch();
	            }

	            conn.commit();
	            return orderId;

	        } catch (SQLException e) {
	            conn.rollback();
	            throw e;
	        }
	    }
	}
}