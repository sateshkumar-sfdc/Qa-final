({   
     enableDisableDependancies : function(component){
            component.find("salesgroupId").set("v.disabled", true); 
    },
    onSalesGroupCHangeEvent : function(component, event, helper){
        //var ev = event.getSource();
        console.log('-->');
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
        cmpEvent1.fire();
        
        
    },
	 nullifyDependants : function(component,eventId){
        if(eventId === 'salesorgId') {
            component.find("distributionchannelId").set("v.value","");
            component.find("divisionId").set("v.value","");
        	component.set("v.resultDistChanList", null);
            component.set("v.divisionList", null);
            component.find("salesofficeId").set("v.value","");
            component.find("salesgroupId").set("v.disabled", true); 
            component.set("v.salesOffList", null);
            component.set("v.salesgrpList", null);
        }
        else if(eventId === 'distributionchannelId') {
            console.log('disble sales');
            component.find("divisionId").set("v.value","10");
            component.find("salesofficeId").set("v.value","");
            component.find("salesgroupId").set("v.disabled", true); 
            component.set("v.salesOffList", null);
            component.set("v.salesgrpList", null);
        }
            else if(eventId === 'divisionId') {
                component.find("salesgroupId").set("v.disabled", true);  
                component.find("salesofficeId").set("v.value","");
                component.find("salesgroupId").set("v.value","");
                component.set("v.salesOffList", null);
                component.set("v.salesgrpList", null);
            }
                else if(eventId === 'salesofficeId') {
                    component.find("salesgroupId").set("v.disabled", true);
                    component.find("salesgroupId").set("v.value","");
                    component.set("v.salesgrpList", null);
                }
    },
    setCompany : function(component){
        var JSONStr = component.get("v.SeedDataWrapper");
        var country = component.get("v.userCountry");
        var slsOrg = component.find("salesorgId").get("v.value");
        
		var cmpId = JSONStr.salesOrgCompanyCodeMap[slsOrg].Company_Code__c;
        
         
        console.log('---->'+slsOrg);
        if(cmpId != null && cmpId != undefined)
		component.find("companycodeId").set("v.value",cmpId);           
    },
    fetchDependants : function(component,dep){
        console.log('dep-->'+dep);
        component.set("v.Spinner",true);
        var string123 = component.get("v.SeedDataWrapper");
        //var string123 = JSON.stringify(component.get("v.SeedDataWrapper"));
        // console.log('str123--->'+string123);
        var controllingData ;
        var dependant ;
        var controllingSalesOrgData = component.find("salesorgId").get("v.value");
        var controllingDistChanData = component.find("distributionchannelId").get("v.value");
        var controllingDivisionData = component.find("divisionId").get("v.value");
        var controllingSalesOfcData = component.find("salesofficeId").get("v.value");
        
		
        //var controllingSalesGrpData = component.find("salesgroupId").get("v.value");
        console.log('seed data values'+controllingSalesOrgData+controllingDistChanData+controllingDivisionData+controllingSalesOfcData);
        var dependantlist = [];
        if(dep == 'Init')
        {
            controllingData = controllingSalesOrgData; 
            dependant = 'DISTR_CHAN';
            dependantlist = this.evaluateDependents(component,controllingData,dependant,dependantlist);
            component.set("v.resultDistChanList", dependantlist);
                    component.set("v.distString",dependantlist[0].FieldValue__c);
                    console.log(component.get("v.resultDistChanList"));
                    console.log(component.find("distributionchannelId").get("v.value"));
                    component.find("distributionchannelId").set("v.disabled", false);
                    console.log('1');
             dependantlist = [];
                    console.log('2-->'+controllingDistChanData);
                    dependant = 'DIVISION';
                    if(controllingSalesOrgData != '1710'){
                    controllingData = controllingSalesOrgData +'-'+controllingDistChanData;
                        console.log('check check-->'+controllingData);
                    this.evaluateDependents(component,controllingData,dependant,dependantlist);
                    component.set("v.divisionList", dependantlist);
                    component.set("v.divString",dependantlist[0].FieldValue__c);
                       // controllingDivisionData = dependantlist[0].FieldValue__c;
                    component.find("divisionId").set("v.disabled", false);
                    console.log('plant info1-->'+dependantlist);
                    console.log('3');
                    dependantlist = [];
                    console.log('4');
                    dependant = 'SALES_OFFICE';
                    console.log('5'+dependantlist);
                    controllingData = controllingSalesOrgData +'-'+controllingDistChanData+'-'+controllingDivisionData;
                        console.log('5 controllingData---'+controllingData);
                    this.evaluateDependents(component,controllingData,dependant,dependantlist);
                    console.log('6');
                    component.set("v.salesOffList", dependantlist);
                        console.log('6.1'+'--'+dependantlist);
                    component.set("v.salesofficeString","STD");
                        console.log('6.1.2');
                    console.log(dependantlist);
                   // component.set("v.salesofficeString",dependantlist[0].FieldValue__c);
                    console.log('8');
                    component.find("salesofficeId").set("v.disabled", false);
                        console.log('plant info-->'+dependantlist);
                    dependantlist = [];
                    console.log('4');
                    dependant = 'SALES_GROUP';
                        controllingData = 'STD';
                        this.evaluateDependents(component,controllingData,dependant,dependantlist);
                    console.log('6');
                    component.set("v.salesgrpList", dependantlist);
                        console.log('6.1'+'--'+dependantlist);
                    component.set("v.salesgroupString","STD");
                        component.find("salesgroupId").set("v.disabled", false);
                    }
                    else{
                        component.find("divisionId").set("v.disabled", true);
            			component.find("salesofficeId").set("v.disabled", true);
                    }
            dep = '';
        }
       
        else{
        
        if(controllingDistChanData != '' && controllingDivisionData != '' && controllingSalesOfcData !='' && controllingDistChanData != 'undefined' && controllingDivisionData != 'undefined' && controllingSalesOfcData !='undefined' )
        {
            controllingData = controllingSalesOfcData;
            //controllingData = controllingSalesOrgData+'-'+'10'+'-'+'10'+'-'+'10';   
            dependant = 'SALES_GROUP';
        }
        else if(controllingDistChanData != '' && controllingDivisionData != '' && controllingDistChanData != 'undefined' && controllingDivisionData != 'undefined')
        {											
            controllingData = controllingSalesOrgData+'-'+controllingDistChanData+'-'+controllingDivisionData;
            //controllingData = controllingSalesOrgData+'-'+'10'+'-'+'10';   
            dependant = 'SALES_OFFICE';
        }
            else if(controllingDistChanData != '' && controllingDistChanData != 'undefined' )
            {
                controllingData = controllingSalesOrgData+'-'+controllingDistChanData;
                // controllingData = controllingSalesOrgData+'-'+'10';
                dependant = 'DIVISION';
            }
                else if(controllingSalesOrgData != '' && controllingSalesOrgData != 'undefined')
                {
                    controllingData = controllingSalesOrgData;
                    dependant = 'DISTR_CHAN';
                }
        
        console.log('controlling and dep-->'+controllingData+dependant);
        
        if(controllingSalesOrgData == '1710' && dependant == 'DIVISION')
        {
            console.log('helloooooo');
            alert('Division Seed data incorrect');
            component.find("divisionId").set("v.disabled", true);
            component.find("salesofficeId").set("v.disabled", true);
            component.find("salesgroupId").set("v.disabled", true);
            component.set("v.salesOffList", null);
            component.set("v.salesgrpList", null);
        }
        else{
           
       dependantlist = this.evaluateDependents(component,controllingData,dependant,dependantlist);
        /*var AccountSequenceName = string123.seedDataAccSeqFieldsMap_wrapper[dependant];
        var Position = string123.SeedDataFieldNamePositionMap_wrapper[dependant];
        var AccountSequenceDataValues = string123.seedDataAccSeqDataMap_wrapper[AccountSequenceName];
        
        for(var name in AccountSequenceDataValues)
        {
         	var AccDataValueString = AccountSequenceDataValues[name];   
            //console.log('-->'+AccDataValueString);
            if(AccDataValueString.includes(controllingData))
            {
                
                var value = AccDataValueString.split('-')[Position];
                dependantlist.push(string123.seedDataKeyFieldValuesMap_wrapper[dependant+value]);
                
            }
            //console.log('value-->'+value);
        }*/
        console.log('Dep List-->'+dependantlist);
        //console.log('Acc Seq Data-->'+AccountSequenceDataValues);
       // console.log('Dependant-->'+string123.seedDataAccSeqFieldsMap_wrapper[dependant]+Position);
            if(dependant == 'DISTR_CHAN')
                {
                   component.set("v.resultDistChanList", dependantlist);
                    component.set("v.distString",dependantlist[0].FieldValue__c);
                    console.log(component.get("v.resultDistChanList"));
                    console.log(component.find("distributionchannelId").get("v.value"));
                    component.find("distributionchannelId").set("v.disabled", false);
                    console.log('1');
                    
                    controllingData = controllingSalesOrgData+'-'+dependantlist[0].FieldValue__c;
                    dependantlist = [];
                    console.log('2-->'+controllingDistChanData);
                    dependant = 'DIVISION';
                    if(controllingSalesOrgData != '1710'){
                        console.log('check check-->'+controllingData);
                    this.evaluateDependents(component,controllingData,dependant,dependantlist);
                    component.set("v.divisionList", dependantlist);
                    component.set("v.divString",dependantlist[0].FieldValue__c);
                    component.find("divisionId").set("v.disabled", false);
                    console.log('plant info1-->'+dependantlist);
                    console.log('3');
                        controllingData = controllingData+'-'+dependantlist[0].FieldValue__c;
                    dependantlist = [];
                    console.log('4');
                    dependant = 'SALES_OFFICE';
                    console.log('5---->'+dependantlist);
                    //controllingData = controllingSalesOrgData +'-'+controllingDistChanData+'-'+controllingDivisionData;
                    this.evaluateDependents(component,controllingData,dependant,dependantlist);
                    console.log('6');
                    component.set("v.salesOffList", dependantlist);
                    console.log(dependantlist);
                    component.set("v.salesofficeString","STD");
                    console.log('8');
                    component.find("salesofficeId").set("v.disabled", false);
                        console.log('plant info-->'+dependantlist);
                    
                    
                    }
                    else{
                        component.find("divisionId").set("v.disabled", true);
            			component.find("salesofficeId").set("v.disabled", true);
                    }

                }
                else if(dependant == 'DIVISION')
                {
                    console.log('Test div');
                    component.set("v.divisionList", dependantlist);
                    component.set("v.divString",dependantlist[0].FieldValue__c);
                    console.log('Test div1'+component.get("v.divString"));
                    component.find("divisionId").set("v.disabled", false);
                    console.log('Test div2');
                }
                    else if(dependant == 'SALES_OFFICE')
                    {
                        component.set("v.salesOffList", dependantlist);
                        component.find("salesofficeId").set("v.disabled", false);

                    }
                        else if(dependant == 'SALES_GROUP')
                        {
                            component.set("v.salesgrpList", dependantlist);
                            component.find("salesgroupId").set("v.disabled", false);
                        }}	 }
                component.set("v.Spinner",false);
          
    },
    
    evaluateDependents : function(component,controllingData,dependant,dependantlist)
    {
        console.log('Test for function'+dependant+controllingData+dependantlist);
        var JSONString = component.get("v.SeedDataWrapper");
        var AccountSequenceName = JSONString.seedDataAccSeqFieldsMap_wrapper[dependant];
        var Position = JSONString.SeedDataFieldNamePositionMap_wrapper[dependant];
        var AccountSequenceDataValues = JSONString.seedDataAccSeqDataMap_wrapper[AccountSequenceName];
        //var loadlist = [];
        console.log('Function values-->'+AccountSequenceName+Position+AccountSequenceDataValues);
        for(var name in AccountSequenceDataValues)
        {
         	var AccDataValueString = AccountSequenceDataValues[name];   
            console.log('-->'+AccDataValueString.includes(controllingData));
            if(AccDataValueString.includes(controllingData))
            {   
                var value = AccDataValueString.split('-')[Position];
                console.log('string test'+JSONString.seedDataKeyFieldValuesMap_wrapper[dependant+value]);
                if(JSONString.seedDataKeyFieldValuesMap_wrapper[dependant+value] != undefined)
                dependantlist.push(JSONString.seedDataKeyFieldValuesMap_wrapper[dependant+value]);
                
            }
           
        }
         console.log('Function value deplist-->');
        console.log(dependantlist);
            return dependantlist;
    },
     enableDisableDependancies : function(component,editRecId){
       		component.find("distributionchannelId").set("v.disabled", true);
            component.find("divisionId").set("v.disabled", true);
            component.find("salesofficeId").set("v.disabled", true);
            //component.find("salesgroupId").set("v.disabled", true); 
        	
        	
    }, 
    validateinputs : function(component,isError)
    {
    	 var salesOrgn = component.find("salesorgId");
        var salesOrgValue = salesOrgn.get('v.value');
        if(salesOrgValue == '' || salesOrgValue == null ||  salesOrgValue == 'undefined'){
            salesOrgn.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.salesorg", salesOrgValue);      
        }
    
    var plant = component.find("plantId");
        var plantValue = salesOrgn.get('v.value');
        if(plantValue == '' || plantValue == null ||  plantValue == 'undefined'){
            plant.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.plant", plantValue);      
        }
        
        var distChan = component.find("distributionchannelId");
        var distChanValue = distChan.get('v.value');
        if(distChanValue == '' || distChanValue == null ||  distChanValue == 'undefined'){
            distChan.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.distributionchannel", salesOrgValue);      
        }
        var divsn = component.find("divisionId");
        var divsnValue = divsn.get('v.value');
        if(divsnValue == '' || divsnValue == null ||  divsnValue == 'undefined'){
            divsn.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.division", divsnValue);      
        }
        var salesOfc = component.find("salesofficeId");
        var salesOfcValue = salesOfc.get('v.value');
        if(salesOfcValue == '' || salesOfcValue == null ||  salesOfcValue == 'undefined'){
            salesOfc.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.salesoffice", salesOfcValue);      
        }
        
        var salesGrp = component.find("salesgroupId");
        var salesGrpValue = salesGrp.get('v.value');
        if(salesGrpValue == '' || salesGrpValue == null ||  salesGrpValue == 'undefined'){
            salesGrp.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.salesgroup", salesGrpValue);      
        }			
        
        var salesDst = component.find("salesdistrictId");
        var salesDstValue = salesOrgn.get('v.value');
        if(salesDstValue == '' || salesDstValue == null ||  salesDstValue == 'undefined'){
            salesDst.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.district", salesOrgValue);      
        }
        var payterm = component.find("paymentTermsId");
        var paytermValue = payterm.get('v.value');
        if(paytermValue == '' || paytermValue == null ||  paytermValue == 'undefined'){
            payterm.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.paymentterms", paytermValue);      
        }
        
        var prgrp = component.find("pricinggroupId");
        var prgrpValue = prgrp.get('v.value');
        if(prgrpValue == '' || prgrpValue == null ||  prgrpValue == 'undefined'){
            prgrp.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.pricegrp", prgrpValue);      
        }		
        
        var pricproc = component.find("priceprocedureId");
        var pricprocValue = pricproc.get('v.value');
        if(pricprocValue == '' || pricprocValue == null ||  pricprocValue == 'undefined'){
            pricproc.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.priceprocedure", pricprocValue);      
        }
        var priclst = component.find("pricelistId");
        var priclstValue = priclst.get('v.value');
        if(priclstValue == '' || priclstValue == null ||  priclstValue == 'undefined'){
            priclst.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.pricelist", priclstValue);      
        }
        
         var shipcond = component.find("shipconditionId");
        var shipcondValue = shipcond.get('v.value');
        if(shipcondValue == '' || shipcondValue == null ||  shipcondValue == 'undefined'){
            shipcond.showHelpMessageIfInvalid();
            isError = true;
        }
        else {
            component.set("v.shippingcondition", shipcondValue);      
        }
return isError;
}
})