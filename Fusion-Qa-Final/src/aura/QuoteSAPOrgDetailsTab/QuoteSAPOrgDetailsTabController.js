({
	doInit : function(component, event, helper) {
       // helper.enableDisableDependancies(component);
        component.find("salesgroupId").set("v.disabled", true);
        var getSeedData = component.get("c.getRawSeedData");
        getSeedData.setCallback(this, function(getSeedResponse) {
            var seedstate = getSeedResponse.getState();
            console.log('test sap'+seedstate);
            if (seedstate === "SUCCESS") {
                var seedResponse = getSeedResponse.getReturnValue();
                console.log(seedResponse.countrySeedDataMap);
                component.set("v.userCountry", seedResponse.userCountry);
                var cntry = seedResponse.userCountry;
                if(seedResponse.userCountry == 'US')
                {		cntry = seedResponse.userCountry +'-1100';
                 		console.log(cntry);
                 	   component.set("v.salesorgValue",seedResponse.countrySeedDataMap[cntry].Sales_Org__c);
                }
                else
                {
                    component.set("v.salesorgValue",seedResponse.countrySeedDataMap[seedResponse.userCountry].Sales_Org__c);
                }
               	//var distDivVal = $A.get("$Label.c.Default_SalesOffice_SalesOrg");
                
               //console.log('distt-->'+distDivVal);
                //component.set("v.resultSalesOrgList",seedResponse.countrySeedDataMap);
                console.log(seedResponse.seedDataKeyValuesMap_wrapper["SALESORG"]);
                component.set("v.resultSalesOrgList",seedResponse.seedDataKeyValuesMap_wrapper["SALESORG"]);
                component.set("v.SeedDataWrapper", seedResponse); 
                
                console.log(seedResponse.countrySeedDataMap["CAN"]);
                
                //component.set("v.salesorgValue","1500");
                var initVal = "10";
                component.find("distributionchannelId").set("v.value",initVal);
            	//component.find("divisionId").set("v.value",initVal);
                
                component.set("v.distString",initVal);
                //component.set("v.divString",initVal); salesofficeString
               
                helper.setCompany(component);
                var dep = 'Init';
                //helper.evaluateDependents(component,'1100','DISTR_CHAN',dependantlist);
                helper.fetchDependants(component,dep);
                //helper.initialLoad(component);
               // component.set("v.salesofficeString",distDivVal);
                //component.set("v.salesgroupString",distDivVal);
                 
                var disp = component.get("v.distString");
                console.log("test disp"+disp);
            }
        }); 
        
        $A.enqueueAction(getSeedData);
      
	},
     getDependantValues : function(component, event, helper) {
        var event = event.getSource();
        var eventId = event.getLocalId();
        //console.log('onchange event'+eventId);
        helper.nullifyDependants(component, eventId);
        var sod = component.find("salesorgId").get("v.value");
        console.log('salesorg'+sod); 
         if(sod!= '' && sod!= 'undefined'){
                helper.setCompany(component);
            helper.fetchDependants(component,'');}
         console.log('t'+component.find("distributionchannelId").get("v.value"));
         helper.onSalesGroupCHangeEvent(component, event, helper);
    },
    save : function(component, event, helper)
    {	var isError = false;
       isError = helper.validateinputs(component,isError);
     console.log(isError);
     if(isError!=true)
     {
         console.log('no error');
     }
     else
     {
         console.log('Error present');
     }
    
    },
    
    onSalesGroupChange : function(component, event, helper)
    {
        helper.onSalesGroupCHangeEvent(component, event, helper);
       /* console.log('-->'+event.getSource());
        var sapOrdObj_salesOrg = component.find("salesorgId").get("v.value");
        
        var sapOrdObj = {
            "salesOrg" : component.find("salesorgId").get("v.value"),
            "distribution" : component.find("distributionchannelId").get("v.value"),
            "division" : component.find("divisionId").get("v.value"),
            "companycode" : component.find("companycodeId").get("v.value"),
            "salesoffice" : component.find("salesofficeId").get("v.value"),
            "salesgrp" : component.find("salesgroupId").get("v.value")
        };
        var jsonstr = JSON.stringify(sapOrdObj);
        console.log('salesorg-->');
        console.log(jsonstr);
        var cmpEvent1 = component.getEvent("sapOrgDetailEvent");
        cmpEvent1.setParams({
            "sapOrgstr" : jsonstr  });
        cmpEvent1.fire();*/
    },
    	handleSapOrgDetails : function(component, event, helper) {
		var prodId = event.getParam("sapOrgstr");
        console.log('this is a handler--->');
        console.log(prodId);
	}
})