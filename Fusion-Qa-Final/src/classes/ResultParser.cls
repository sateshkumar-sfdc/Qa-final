public class ResultParser {

	public class ItemR {
		public String TYPE_Z {get;set;} // in json: TYPE
		public String ID {get;set;} 
		public String NUMBER_Z {get;set;} // in json: NUMBER
		public String MESSAGE {get;set;} 
		public String LOG_NO {get;set;} 
		public String LOG_MSG_NO {get;set;} 
		public String MESSAGE_V1 {get;set;} 
		public String MESSAGE_V2 {get;set;} 
		public String MESSAGE_V3 {get;set;} 
		public String MESSAGE_V4 {get;set;} 
		public String PARAMETER {get;set;} 
		public Integer ROW {get;set;} 
		public String FIELD {get;set;} 
		public String SYSTEM_Z {get;set;} // in json: SYSTEM

	}
	
	public class RETURN_Z {
		public List<ItemR> item {get;set;} 
	}
	
	public String PRODUCT_LIST {get;set;} 
	public RETURN_Z RETURN_Z {get;set;} // in json: RETURN


}