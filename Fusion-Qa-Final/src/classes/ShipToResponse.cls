public class ShipToResponse {
    
    public class Item {
        public String TYPE_Z; // in json: TYPE
        public String ID; 
        public String NUMBER_Z; // in json: NUMBER
        public String MESSAGE; 
        public String LOG_NO; 
        public String LOG_MSG_NO; 
        public String MESSAGE_V1; 
        public String MESSAGE_V2; 
        public String MESSAGE_V3; 
        public String MESSAGE_V4; 
        public String PARAMETER; 
        public Integer ROW; 
        public String FIELD; 
        public String SYSTEM_Z; // in json: SYSTEM
    }
    
    public class RETURN_Z {
        public List<Item> item; 
    }
    
    public String BUSINESSPARTNER; 
    public RETURN_Z RETURN_Z; // in json: RETURN
    
}