public class SoldToShipTo {
    
    
    public String BUSINESSPARTNER;
    public SALES_KEY SALES_KEY;
    public PARTNERFUNCTIONS PARTNERFUNCTIONS;
    
    public class Item {
		public String TASK;
		public DATA_KEY DATA_KEY;
		public DATA DATA;
	}

	public class DATA {
		public String PARTNER;
	}

	public class DATA_KEY {
		public String PARTN_ROLE;
		public String COUNTER;
	}

	public class PARTNERFUNCTIONS {
		public Item item;
	}

	public class SALES_KEY {
		public String SALESORG;
		public String DISTR_CHAN;
		public String DIVISION;
	}
    
}