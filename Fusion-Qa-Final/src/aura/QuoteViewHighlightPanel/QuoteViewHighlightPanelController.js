({
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
    margeCall : function(component, event, helper) {
       console.log('marge');
       var action = component.get("c.margeCallout");
       action.setParams({qutoeHeaderId : component.get("v.recordId")});
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
               var showToast = $A.get("e.force:showToast");
                           showToast.setParams({
                               message: 'Callout Successfull',
                               duration: '5000',
                               type: 'success',
                               mode: 'dismissible'
                           });
                           showToast.fire()
           }
           else{
               var showToast = $A.get("e.force:showToast");
                           showToast.setParams({
                               message: 'Callout Fail',
                               duration: '5000',
                               type: 'error',
                               mode: 'dismissible'
                           });
                           showToast.fire()
           }
       });
       $A.enqueueAction(action);
   }
})