
package store;

import java.util.List;

public class StoreService {

    public List<StoreDTO> findItemsByCategory(
            String category, String sort) {

        StoreDAO storeDAO = new StoreDAO();

        try {
            // 카테고리가 없으면 전체 상품 조회
            if (category == null
                    || category.trim().isEmpty()
                    || "all".equals(category)) {
                category = "전체";
            }

            // 정렬 기준이 없으면 추천순
            if (sort == null || sort.trim().isEmpty()) {
                sort = "recommend";
            }

            // 카테고리와 정렬 기준을 함께 전달
            return storeDAO.getSortedStoreList(category, sort);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(
                    "상품 목록을 불러오는 중 오류가 발생했습니다.", e);
        }
    }
}
