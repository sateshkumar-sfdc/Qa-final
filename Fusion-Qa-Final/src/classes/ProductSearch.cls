public class ProductSearch {
	public String CUSTOMER;
	public String PRICE_DATE;
	public String SALES_GRP;
	public String SALES_OFF;
	public String SALES_ORG;
	public String DISTR_CHAN;
	public String DIVISION;
    public PRODUCTS PRODUCTS;
	public class PRODUCTS {
		public List<Item> item;
	}
    public class Item {
		public String MATERIAL;
		public String PLANT;
	}

}