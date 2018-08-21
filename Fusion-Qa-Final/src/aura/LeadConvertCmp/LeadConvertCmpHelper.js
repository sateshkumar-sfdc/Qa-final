({
    onInit : function(component, event) {
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
    	var action = component.get("c.convertLead");
        action.setParams({
            recId : component.get("v.recordId"),
            accId : component.get("v.selectedAccount"),
            conId : component.get("v.selectedContact")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.flowControl",0);
                 var showToast = $A.get("e.force:showToast"); 
                            showToast.setParams({ 
                                message: 'Lead Converted',
                                duration: '5000',
                                type: 'success',
                                mode: 'dismissible'
                            }); 
                            showToast.fire(); 
                            $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0].pageErrors && errors[0].pageErrors[0]) {
                            console.log("Error message: " + 
                                        errors[0].pageErrors && errors[0].pageErrors[0]);
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
	}
})