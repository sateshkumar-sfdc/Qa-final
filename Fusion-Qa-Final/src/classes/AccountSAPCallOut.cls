/*
*************************************************************
** Name: AccountSAPCallOut.apxc                        	   **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose:                  							   **
** This class Contains Ship to and Sold To Methods to Call **
**	SAP     											   **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 08/17/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/
public class AccountSAPCallOut {
   
	// Ship To callOut Mapping
    public static ShipToResponse shipToCallOut(Account shipAcc)
    {
        ShipToRequest shipReq = new ShipToRequest();
        shipReq.BUSINESSPARTNER = '';
		shipReq.PARTNERCATEGORY = '2';
        shipReq.PARTNERGROUP = 'SH';
        
        ShipToRequest.CENTRALDATA cData = new ShipToRequest.CENTRALDATA();
        cData.SEARCHTERM1 = shipAcc.Name;//'HENNIESHIP2 - 011';
        shipReq.CENTRALDATA = cData;
        
        ShipToRequest.CENTRALDATAORGANIZATION cDataOrg = new ShipToRequest.CENTRALDATAORGANIZATION();
        cDataOrg.NAME1 = shipAcc.Name;//'HENNIESOLD2-011';
        shipReq.CENTRALDATAORGANIZATION = cDataOrg;
        
        ShipToRequest.ADDRESSDATA aData = new ShipToRequest.ADDRESSDATA();
        aData.STANDARDADDRESS = '';
        aData.CITY = shipAcc.ShippingCity;//'Houston';
        aData.COUNTRY = shipAcc.ShippingCountry;//'US';
        aData.POSTL_COD1 = shipAcc.ShippingPostalCode;//'77084';
        aData.STREET = shipAcc.ShippingStreet;//'2345 E Wherever Dr';
        aData.REGION = shipAcc.ShippingState;//'TX';
        aData.LANGU = 'E';
        shipReq.ADDRESSDATA = aData;
        
        ShipToRequest.TELEFONDATA tData = new ShipToRequest.TELEFONDATA();
        ShipToRequest.Item item1 = new ShipToRequest.Item();
        item1.COUNTRY = shipAcc.ShippingCountry;//'US';
        item1.TELEPHONE = shipAcc.Phone;//'14805554567';
        tData.item = item1;
        shipReq.TELEFONDATA = tData;
        
        ShipToRequest.E_MAILDATA eData = new ShipToRequest.E_MAILDATA();
        ShipToRequest.Item item2 = new ShipToRequest.Item();
        item2.E_MAIL = shipAcc.Email__c;//'newship2@whoknows.com';
        eData.item = item1;
        shipReq.E_MAILDATA = eData;
            
        ShipToRequest.ROLES rData = new ShipToRequest.ROLES();
        ShipToRequest.Item item3 = new ShipToRequest.Item();
        item3.PARTNERROLE = 'FLCU01';
        item3.VALID_FROM = '20180514';
        item3.VALID_TO = '99991231';
        tData.item = item1;
        shipReq.TELEFONDATA = tData;
        
        ShipToRequest.SALES_KEY skData = new ShipToRequest.SALES_KEY();
        skData.SALESORG = '1100';
        skData.DISTR_CHAN = '10';
        skData.DIVISION = '10';
        shipReq.SALES_KEY = skData;
        
        ShipToRequest.SALES_DATA sData = new ShipToRequest.SALES_DATA();
        sData.CUST_STAT_GRP = '1';
        sData.CUST_PRIC_PROC = 'ZI';
        sData.DISTRICT = 'NHOUST';
        sData.PRICE_GROUP = 'YT';
        sData.PLTYP = '01';
        sData.INCO1 = 'FOB';
        sData.INCO2 = 'PRE-PAID';
        sData.PART_DLV = 'C';
        sData.SHP_COND = '02';
        sData.CURRENCY_Z = 'USD';
        sData.PAYT_TERMS = 'NTCC';
        sData.DELIVER_PLANT = '1200';
        sData.SALES_GROUP = 'STD';
        sData.SALES_OFFICE = 'STD';
        ShipReq.SALES_DATA = sData;
        
        ShipToRequest.COMPANY_KEY ckData=  new ShipToRequest.COMPANY_KEY();
		ckData.COMPANY = '1100';
        shipReq.COMPANY_KEY = ckData;
        
        ShipToRequest.COMPANY_DATA coData = new ShipToRequest.COMPANY_DATA();
        coData.RECACCT = '0012100000';
        coData.PAYTERM = 'NTCC';
        shipReq.COMPANY_DATA = coData;
        
        string req = JSON.serialize(shipReq, true);
        req = req.replaceAll('_Z', '');
        system.debug(req);
        
        string response = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_BPMaintain', req, 'POST');    //'{"BUSINESSPARTNER":"0000200371","RETURN":{"item":[{"TYPE":"S","ID":"FSBP_BAPI","NUMBER":"051","MESSAGE":"Instance 0000200371 belonging to object type BusinessPartnerFS was created","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"BusinessPartnerFS","MESSAGE_V2":"0000200371","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":0,"FIELD":"","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"00","NUMBER":"058","MESSAGE":"Entry 1100 1200 does not exist in TVKWZ (check entry)","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":1100,"MESSAGE_V2":"","MESSAGE_V3":1200,"MESSAGE_V4":"TVKWZ","PARAMETER":"","ROW":1,"FIELD":"WERKS","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"CVI_API","NUMBER":"001","MESSAGE":"Plant: Invalid value (foreign key check failed)","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"Plant","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":1,"FIELD":"WERKS","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"F2","NUMBER":644,"MESSAGE":"Sales area 1100 10 is not defined for customers","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":1100,"MESSAGE_V2":"","MESSAGE_V3":10,"MESSAGE_V4":"","PARAMETER":"","ROW":1,"FIELD":"VKORG","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"CVI_API","NUMBER":"007","MESSAGE":"Sales Organization, Distribution Channel, Division: Plausibility check failed","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"Sales Organization, Distribution Channel, Division","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":1,"FIELD":"VKORG","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"F2","NUMBER":712,"MESSAGE":"Office STD is not defined for sales area 1100 10","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"STD","MESSAGE_V2":1100,"MESSAGE_V3":"","MESSAGE_V4":10,"PARAMETER":"","ROW":1,"FIELD":"VKBUR","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"CVI_API","NUMBER":"007","MESSAGE":"Sales Group, Sales Office: Plausibility check failed","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"Sales Group, Sales Office","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":1,"FIELD":"VKGRP","SYSTEM":"DR1CLNT120"}]}}';
        response = response.replaceAll('TYPE', 'TYPE_Z');
        response = response.replaceAll('NUMBER', 'NUMBER_Z');
        response = response.replaceAll('RETURN', 'RETURN_Z');
        system.debug('--->1--'+(shipToResponse) System.JSON.deserialize(response, shipToResponse.class));
        return (shipToResponse) System.JSON.deserialize(response, shipToResponse.class);
        
        
    }
    
    //Sold To callOut Mapping
    public static soldToResponse soldToCallOut(Account soldAcc)
    {
        SoldToRequest soldReq = new SoldToRequest();
        soldReq.BUSINESSPARTNER = '';
		soldReq.PARTNERCATEGORY = '2';
        soldReq.PARTNERGROUP = 'SP';
        
        SoldToRequest.CENTRALDATA cData = new SoldToRequest.CENTRALDATA();
        cData.SEARCHTERM1 = soldAcc.Name;//'HENNIESOLD2-011-U';
        soldReq.CENTRALDATA = cData;
        
        SoldToRequest.CENTRALDATAORGANIZATION cDataOrg = new SoldToRequest.CENTRALDATAORGANIZATION();
        cDataOrg.NAME1 = soldAcc.Name;//'HENNIESOLD2-011-U';
        soldReq.CENTRALDATAORGANIZATION = cDataOrg;
        
        SoldToRequest.ADDRESSDATA aData = new SoldToRequest.ADDRESSDATA();
        aData.STANDARDADDRESS = '';
        aData.CITY = soldAcc.BillingCity;//'Houston';
        aData.COUNTRY = soldAcc.BillingCountry;//'US';
        aData.POSTL_COD1 = soldAcc.BillingPostalCode;//'77084';
        aData.STREET = soldAcc.BillingStreet;//'2345 E Wherever Dr';
        aData.REGION = soldAcc.BillingState;//'TX';
        aData.LANGU = 'E';
        soldReq.ADDRESSDATA = aData;
        
        SoldToRequest.TELEFONDATA tData = new SoldToRequest.TELEFONDATA();
        SoldToRequest.Item item1 = new SoldToRequest.Item();
        item1.COUNTRY = soldAcc.BillingCountry;//'US';
        item1.TELEPHONE = soldAcc.Phone;//'14805554567';
        tData.item = item1;
        soldReq.TELEFONDATA = tData;
        
        SoldToRequest.E_MAILDATA eData = new SoldToRequest.E_MAILDATA();
        SoldToRequest.Item item2 = new SoldToRequest.Item();
        item2.E_MAIL = soldAcc.Email__c;//'newship2@whoknows.com';
        eData.item = item1;
        soldReq.E_MAILDATA = eData;
            
        SoldToRequest.ROLES rData = new SoldToRequest.ROLES();
        SoldToRequest.Item item3 = new SoldToRequest.Item();
        item3.PARTNERROLE = 'FLCU01';
        item3.VALID_FROM = '20180514';
        item3.VALID_TO = '99991231';
        tData.item = item1;
        soldReq.TELEFONDATA = tData;
        
        SoldToRequest.SALES_KEY skData = new SoldToRequest.SALES_KEY();
        skData.SALESORG = '1100';
        skData.DISTR_CHAN = '10';
        skData.DIVISION = '10';
        soldReq.SALES_KEY = skData;
        
        SoldToRequest.SALES_DATA sData = new SoldToRequest.SALES_DATA();
        sData.CUST_STAT_GRP = '1';
        sData.CUST_PRIC_PROC = 'ZI';
        sData.DISTRICT = 'NHOUST';
        sData.PRICE_GROUP = 'YT';
        sData.PLTYP = '01';
        sData.INCO1 = 'FOB';
        sData.INCO2 = 'PRE-PAID';
        sData.PART_DLV = 'C';
        sData.SHP_COND = '02';
        sData.CURRENCY_Z = 'USD';
        sData.PAYT_TERMS = 'NTCC';
        sData.DELIVER_PLANT = '1200';
        sData.SALES_GROUP = 'STD';
        sData.SALES_OFFICE = 'STD';
        soldReq.SALES_DATA = sData;
        
        SoldToRequest.COMPANY_KEY ckData=  new SoldToRequest.COMPANY_KEY();
		ckData.COMPANY = '1100';
        soldReq.COMPANY_KEY = ckData;
        
        SoldToRequest.COMPANY_DATA coData = new SoldToRequest.COMPANY_DATA();
        coData.RECACCT = '0012100000';
        coData.PAYTERM = 'NTCC';
        soldReq.COMPANY_DATA = coData;
        
        string req = JSON.serialize(soldReq, true);
        req = req.replaceAll('_Z', '');
        system.debug(req);
        
        string response = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_BPMaintain', req, 'POST');   //'{"BUSINESSPARTNER":"0000200371","RETURN":{"item":[{"TYPE":"S","ID":"FSBP_BAPI","NUMBER":"051","MESSAGE":"Instance 0000200371 belonging to object type BusinessPartnerFS was created","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"BusinessPartnerFS","MESSAGE_V2":"0000200371","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":0,"FIELD":"","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"00","NUMBER":"058","MESSAGE":"Entry 1100 1200 does not exist in TVKWZ (check entry)","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":1100,"MESSAGE_V2":"","MESSAGE_V3":1200,"MESSAGE_V4":"TVKWZ","PARAMETER":"","ROW":1,"FIELD":"WERKS","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"CVI_API","NUMBER":"001","MESSAGE":"Plant: Invalid value (foreign key check failed)","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"Plant","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":1,"FIELD":"WERKS","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"F2","NUMBER":644,"MESSAGE":"Sales area 1100 10 is not defined for customers","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":1100,"MESSAGE_V2":"","MESSAGE_V3":10,"MESSAGE_V4":"","PARAMETER":"","ROW":1,"FIELD":"VKORG","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"CVI_API","NUMBER":"007","MESSAGE":"Sales Organization, Distribution Channel, Division: Plausibility check failed","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"Sales Organization, Distribution Channel, Division","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":1,"FIELD":"VKORG","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"F2","NUMBER":712,"MESSAGE":"Office STD is not defined for sales area 1100 10","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"STD","MESSAGE_V2":1100,"MESSAGE_V3":"","MESSAGE_V4":10,"PARAMETER":"","ROW":1,"FIELD":"VKBUR","SYSTEM":"DR1CLNT120"},{"TYPE":"E","ID":"CVI_API","NUMBER":"007","MESSAGE":"Sales Group, Sales Office: Plausibility check failed","LOG_NO":"","LOG_MSG_NO":"000000","MESSAGE_V1":"Sales Group, Sales Office","MESSAGE_V2":"","MESSAGE_V3":"","MESSAGE_V4":"","PARAMETER":"","ROW":1,"FIELD":"VKGRP","SYSTEM":"DR1CLNT120"}]}}';
        response = response.replaceAll('TYPE', 'TYPE_Z');
        response = response.replaceAll('NUMBER', 'NUMBER_Z');
        response = response.replaceAll('RETURN', 'RETURN_Z');
        system.debug('---->'+(soldToResponse) System.JSON.deserialize(response, soldToResponse.class));
        return (soldToResponse) System.JSON.deserialize(response, soldToResponse.class);
        
        
    }
   
    // Linking Ship To to Sold To in SAP
    public static void soldShipCallout( string  BUSINESSPARTNER, string PARTNER)
   {
       SoldToShipTo soldShipReq =  new SoldToShipTo();
       soldShipReq.BUSINESSPARTNER = PARTNER;//'0000102166';
       System.debug('Partner -------------->'+soldShipReq.BUSINESSPARTNER);
       
       SoldToShipTo.SALES_KEY skData = new SoldToShipTo.SALES_KEY();
       skData.SALESORG = '1100';
       skData.DISTR_CHAN = '10';
       skData.DIVISION = '10';
       soldShipReq.SALES_KEY = skData;
       
       SoldToShipTo.PARTNERFUNCTIONS pf = new SoldToShipTo.PARTNERFUNCTIONS();
       SoldToShipTo.Item item = new SoldToShipTo.Item();
       
       SoldToShipTo.DATA data = new SoldToShipTo.DATA();
       data.PARTNER = BUSINESSPARTNER;//'0000200371';
        System.debug('BusinessPartner -------------->'+data.PARTNER);
       item.DATA = data;
       
       SoldToShipTo.DATA_KEY dk = new SoldToShipTo.DATA_KEY();
       dk.COUNTER = '002';
       dk.PARTN_ROLE = 'we';
       item.DATA_KEY = dk;
       item.TASK = 'I';
       
       pf.item = item;
       
       string req = JSON.serialize(soldShipReq, true);
       system.debug(req);
       string response = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_BPMaintain', req, 'POST');
       system.debug('---->'+(SoldToShipToResponse) System.JSON.deserialize(response, SoldToShipToResponse.class));
     
       }

}