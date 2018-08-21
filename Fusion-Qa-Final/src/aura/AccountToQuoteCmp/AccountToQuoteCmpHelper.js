({
	getContacts : function(component){
    	var action = component.get("c.checkContact");
        action.setParams({
            accId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var conList = response.getReturnValue();
                if(conList.length > 0){
                    component.set("v.conList",response.getReturnValue());
                    component.set("v.filterconList",response.getReturnValue());
                    
                    component.set("v.flowControl",0);
                    console.log(component.get("v.conList"));
                }
                else
                {
                    this.getOpportunity(component);
                     //component.set("v.flowControl",1);
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
    
    getOpportunity : function(component){
    	var action = component.get("c.checkOpportunity");
        action.setParams({
            accId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var conList = response.getReturnValue();
                if(conList.length > 0){
                    component.set("v.oppList",response.getReturnValue());
                    component.set("v.filteroppList",response.getReturnValue());
                    
                    component.set("v.flowControl",1);
                    console.log(component.get("v.oppList"));
                }
                else
                {
                    this.createRecords(component);
                     //component.set("v.flowControl",1);
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
    	var action = component.get("c.createRecords");
        action.setParams({
            accId : component.get("v.recordId"),
            conId : component.get("v.selectedContact"),
            oppId : component.get("v.selectedOpportunity")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.flowControl",3);
                var idList = [];
               idList =  response.getReturnValue();
                this.navigatetoQuoteScreen(component, event, helper, idList);
                
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
    
    navigatetoQuoteScreen : function(component, event, helper, idList){
      var evt = $A.get("e.force:navigateToComponent");
      evt.setParams({
          componentDef:"c:CreateOuote_YETI",
           componentAttributes: {
              OppId : component.get("v.value"),
               AccId : component.get("v.recordId"),
               quoteID : idList[3]
          }
       
      });
      evt.fire();
      $A.get("e.force:closeQuickAction").fire();
  }
})