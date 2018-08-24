public class ProductSearchResponse {

	public PRODUCT_LIST PRODUCT_LIST;

	public class PRICING {
		public List<Item> item;
	}

    public class Item {
		public String COND_TYPE;
		public String COND_DESC;
		public Double COND_VALUE;
		public String CALC_TYPE;
		public String CONDVALUE;
	}
    
	public class PRODUCT_LIST {
		public List<Item_Z> item;
	}

	public class Item_Z {
		public String ITM_NUMBER;
		public Integer PLANT;
		public String STGE_LOC;
		public Long MATERIAL;
		public String SHORT_TEXT;
		public String QTY_AVAILABLE;
		public PRICING PRICING;
	}


}