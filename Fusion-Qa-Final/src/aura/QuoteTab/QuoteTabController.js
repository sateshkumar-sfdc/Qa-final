({
	doInit : function(component, event, helper) {
		console.log(component.get("v.recordId"));
        var stocklist = component.get("v.Stock");
        var CustomList = component.get("v.CustomProducts");
        var NonCustomList = component.get("v.CustomHardCoolers");
        var action = component.get("c.getRelatedLineItems");
        action.setParams({
            QuoteId : component.get("v.recordId") 
        });
        
        action.setCallback(this, function(response) {
            var results =  response.getReturnValue();
            console.log(results);
            for(var i=0; i<results.length; i++ ){
                if(results[i].CategorySection__c == 'Stock'){
                   stocklist.push(results[i]); 
                } else if(results[i].CategorySection__c == 'Custom'){
                    CustomList.push(results[i]); 
                } else if(results[i].CategorySection__c == 'NonCustom'){
                    NonCustomList.push(results[i]);
                } 
            }
            
            component.set("v.Stock",stocklist);
            component.set("v.CustomProducts",CustomList);
            component.set("v.CustomHardCoolers",NonCustomList);
            
        });
        	
        $A.enqueueAction(action);

	},
    
      changeicon: function(component, event, helper) {
        try {
            helper.showsection(component, event);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }


    },

    changeicon1: function(component, event, helper) {
        try {
            helper.showsectioncustom(component, event);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }
    },

    changeicon2: function(component, event, helper) {

        try {
            helper.showsectionnoncustom(component, event);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }

    },
    showCoolers: function(cmp, event, helper) {
        cmp.set("v.cooler", true);
        cmp.set("v.custom", false);
        cmp.set("v.noncustom", false);
    },
    showCustom: function(cmp, event, helper) {
        cmp.set("v.cooler", false);
        cmp.set("v.custom", true);
        cmp.set("v.noncustom", false);
    },
    showNonCustom: function(cmp, event, helper) {
        cmp.set("v.cooler", false);
        cmp.set("v.custom", false);
        cmp.set("v.noncustom", true);
    },
    showAll: function(cmp, event, helper) {
        cmp.set("v.cooler", true);
        cmp.set("v.custom", true);
        cmp.set("v.noncustom", true);
    },
    
   cloneQuote : function(component, event, helper) {
        var quoteHeader = component.get("v.simpleRecord"); 
        console.log(quoteHeader.Account__c);
        var modalBody;
        $A.createComponent("c:ClonePopUp", {
            AccountId : quoteHeader.Account__c,
            QuoteId : component.get("v.recordId")
        },
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Please select One Option",
                       body: modalBody, 
                       showCloseButton: true,
                       cssClass: "mymodal",
                       closeCallback: function() {
                          // alert('You closed the alert!');
                       }
                   })
               }                               
           });
		
	},
    
    expireQuote : function(component, event, helper) {
        alert("hai");
        component.set("v.loaded",true);
        console.log(event.target);
       var quoteHeaderobj = component.get("v.simpleRecord");
       var action = component.get("c.changeQuoteStatus");
        action.setParams({
            QuoteId : quoteHeaderobj.Id
        })
        action.setCallback(this, function(response) {
             var state = response.getState();
               if (state === "SUCCESS") {
                   if(response.getReturnValue() == "SUCCESS"){ 
                       console.log("status changed");
                       $A.get('e.force:refreshView').fire();
                       component.set("v.loaded",false);
                       $A.get('e.force:refreshView').fire();
                      
                   }else{
                       console.log(response.getReturnValue());
                        $A.get('e.force:refreshView').fire();
                   }
            }
            else if (state === "INCOMPLETE") {
               $A.get('e.force:refreshView').fire(); 
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
    
    navigateToEditScreen :function(component, event, helper) {
     var quoteHeader1 = component.get("v.simpleRecord");
       // alert("test");
        console.log(quoteHeader1);
     var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef:"c:EditQuoteScreen",
             componentAttributes: {
                quoteID : component.get("v.recordId"),
                
            }
           
        });
        evt.fire();
    },
    
    
    
    
})