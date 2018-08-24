/*
*************************************************************
** Name: SoldToRequest.apxc                        	       **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose:                  							   **
** Sold To Request structure from Json                     **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 08/17/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/

public class SoldToRequest {
       public class TELEFONDATA {
        public Item item;
    }

    public class CENTRALDATA {
        public String SEARCHTERM1;
    }

    public class COMPANY_KEY {
        public String COMPANY;
    }

    public class SALES_DATA {
        public String CUST_STAT_GRP;
        public String CUST_PRIC_PROC;
        public String DISTRICT;
        public String PRICE_GROUP;
        public String PLTYP;
        public String INCO1;
        public String INCO2;
        public String PART_DLV;
        public String SHP_COND;
        public String CURRENCY_Z;    //need to replace with 'currency' after creating json
        public String PAYT_TERMS;
        public String DELIVER_PLANT;
        public String SALES_GROUP;
        public String SALES_OFFICE;
    }

    public String BUSINESSPARTNER;
    public String PARTNERCATEGORY;
    public String PARTNERGROUP;
    public CENTRALDATA CENTRALDATA;
    public CENTRALDATAORGANIZATION CENTRALDATAORGANIZATION;
    public ADDRESSDATA ADDRESSDATA;
    public TELEFONDATA TELEFONDATA;
    public E_MAILDATA E_MAILDATA;
    public ROLES ROLES;
    public SALES_KEY SALES_KEY;
    public SALES_DATA SALES_DATA;
    public COMPANY_KEY COMPANY_KEY;
    public COMPANY_DATA COMPANY_DATA;

    public class Item {
        public String COUNTRY;
        public String TELEPHONE;
        public String E_MAIL;
        public String PARTNERROLE;
        public String VALID_FROM;
        public String VALID_TO;
    }

    public class ROLES {
        public Item item;
    }

    public class CENTRALDATAORGANIZATION {
        public String NAME1;
    }

    public class E_MAILDATA {
        public Item item;
    }

    public class COMPANY_DATA {
        public String RECACCT;
        public String PAYTERM;
    }

    public class ADDRESSDATA {
        public String STANDARDADDRESS;
        public String CITY;
        public String POSTL_COD1;
        public String STREET;
        public String COUNTRY;
        public String REGION;
        public String LANGU;
    }

    public class SALES_KEY {
        public String SALESORG;
        public String DISTR_CHAN;
        public String DIVISION;
    }

}