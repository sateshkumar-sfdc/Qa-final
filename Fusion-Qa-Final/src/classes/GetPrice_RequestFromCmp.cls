public class GetPrice_RequestFromCmp {

    public class ProductMaterial {
        public String MaterialID;
        public String itemnumber;
        public Integer Quantity;
        public Decimal Discount;
        public String measure;
        public String Discountmeasure;        
        public List<Jsondata> jsondata;
    }

    public String salesOrg;
    public String distribution;
    public String division;
    public String companycode;
    public String salesoffice;
    public String salesgrp;
    public List<ProductMaterial> productMaterial;

    public class Prepared {
        public String itemid;
        public String itemkeyid;
        public String itembasekey;
        public Boolean premium;
    }

    public class Jsondata {
        public String version;
        public String customtype;
        public String ramsideloc;
        public String productkey;
        public String ramvertloc;
        public String ramorientation;
        public String custpreview;
        public String warpedpreview;
        public String laserimage;
        public Prepared prepared;
    }

}