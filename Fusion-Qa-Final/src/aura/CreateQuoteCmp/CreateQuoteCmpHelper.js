({
    onInit : function(component, event) {
        component.set("v.isSpinner",true);
        var action = component.get("c.checkAccount");
        action.setParams({recId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var acclist = response.getReturnValue();
                if(acclist.length > 0){
                    var accList = response.getReturnValue();
                    var showList = [];
                    component.set("v.accList", accList);
                    component.set("v.flowControl",1);
                    console.log(component.get("v.accList"));
                    for(var i = 0; i<200 ; i++)
                    {
                        showList.push(accList[i]);
                        if(i == accList.length - 1)
                        {
                            component.set("v.disableNxt", true);
                            break;
                        }
                    }
                    component.set("v.showList", showList);
                    component.set("v.filteraccList", showList);
                    component.set("v.isSpinner",false);
                }
                else
                {
                    this.createRecords(component);
                }
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            //$A.get("e.force:closeQuickAction").fire()
        });
        $A.enqueueAction(action);
    },
    
    getContacts : function(component){
        component.set("v.isSpinner",true);
    	var action = component.get("c.checkContact");
        action.setParams({
            accId : component.get("v.selectedAccount")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var conList = response.getReturnValue();
                if(conList.length > 0){
                    var conList = response.getReturnValue();
                    var showList = [];
                    component.set("v.conList",conList);
                    component.set("v.flowControl",2);
                    console.log(component.get("v.conList"));
                    for(var i = 0; i<200 ; i++)
                    {
                        showList.push(conList[i]);
                        if(i == conList.length - 1)
                        {
                            component.set("v.disableNxt", true);
                            break;
                        }
                    }
                    component.set("v.showList", showList);
                    component.set("v.filterconList", showList);
                    component.set("v.isSpinner",false);
                }
                else
                {
                    this.createRecords(component);
                }
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    createRecords : function(component){
        component.set("v.isSpinner",true);
    	var action = component.get("c.convertLead");
        action.setParams({
            recId : component.get("v.recordId"),
            accId : component.get("v.selectedAccount"),
            conId : component.get("v.selectedContact")
        });
        console.log('createRecords');
        action.setCallback(this, function(response) {
            console.log('response ' + response);
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                component.set("v.flowControl",0);
                console.log('Test--?>>>>>>>>>>>>>>>>>>');
                console.log('Test--?>'+response.getReturnValue());
                component.set("v.QuoteId", response.getReturnValue());
                component.set("v.isSpinner",false);
               /* var showToast = $A.get("e.force:showToast"); 
                            showToast.setParams({ 
                                message: 'Lead Converted',
                                duration: '5000',
                                type: 'success',
                                mode: 'dismissible'
                            }); 
                            showToast.fire(); 
                            $A.get("e.force:closeQuickAction").fire();*/
                this.navigateToEditScreen(component, event, helper);
                
            }
            else if (state === "INCOMPLETE") {
                console.log('Incomplete');
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log(errors[0].pageErrors);
                    if (errors) {
                        if (errors[0].pageErrors && errors[0].pageErrors[0]) {
                  				console.log("Error message: " + 
                                        errors[0].pageErrors[0].message);
                            var showToast = $A.get("e.force:showToast"); 
                            showToast.setParams({ 
                            	message : errors[0].pageErrors[0].message,
                                duration: '5000',
                                type: 'error',
                                mode: 'dismissible'
                            }); 
                            showToast.fire(); 
                            $A.get("e.force:closeQuickAction").fire();
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
      //  $A.get("e.force:closeQuickAction").fire()
	},
    
   navigateToEditScreen :function(component, event, helper) {
   var quoteHeader1 = component.get("v.simpleRecord");
    //  alert("test");
     // console.log(quoteHeader1);
   var evt = $A.get("e.force:navigateToComponent");
      evt.setParams({
          componentDef:"c:CreateOuote_YETI",
           componentAttributes: {
              quoteID : component.get("v.QuoteId")
          }
      });
      evt.fire();
  }
})