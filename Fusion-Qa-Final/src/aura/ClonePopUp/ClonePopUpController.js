({
    doInit: function(component, event, helper) {
        console.log(component.get("v.AccountId"));
        component.set("v.isSpinning", true);

        var action = component.get("c.getRelatedOpportunities");
        action.setParams({
            recId: component.get("v.AccountId")
        });

        console.log("1");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("2");
                var results = response.getReturnValue();

                console.log(response.getReturnValue());
                var results = response.getReturnValue();
                component.set("v.OppData", results);
                component.set("v.oppfilterlist", results);
                console.log(component.get("v.OppData"));
                component.set("v.isSpinning", false);
            } else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {
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

    onCheckboxChange: function(component, event, helper) {
        //Gets the checkbox group based on the checkbox id
        var availableCheckboxes = component.find('r0ID');
        var resetCheckboxValue = false;
        if (Array.isArray(availableCheckboxes)) {
            //If more than one checkbox available then individually resets each checkbox
            availableCheckboxes.forEach(function(checkbox) {
                checkbox.set('v.value', resetCheckboxValue);
            });
        } else {
            //if only one checkbox available then it will be unchecked
            availableCheckboxes.set('v.value', resetCheckboxValue);
        }
        //mark the current checkbox selection as checked
        event.getSource().set("v.value", true);
        var opportunityid = event.getSource().get("v.text");
        console.log(opportunityid);
        component.set("v.oppId", opportunityid);
    },

    onCheckboxChange1: function(component, event, helper) {
        //Gets the checkbox group based on the checkbox id
        var availableCheckboxes = component.find('r1ID');
        var resetCheckboxValue = false;
        if (Array.isArray(availableCheckboxes)) {
            //If more than one checkbox available then individually resets each checkbox
            availableCheckboxes.forEach(function(checkbox) {
                checkbox.set('v.value', resetCheckboxValue);
            });
        } else {
            //if only one checkbox available then it will be unchecked
            availableCheckboxes.set('v.value', resetCheckboxValue);
        }
        //mark the current checkbox selection as checked
        event.getSource().set("v.value", true);
        var ContactId = event.getSource().get("v.text");
        console.log(ContactId);
        component.set("v.ConId", ContactId);
    },

    next: function(component, event, helper) {
        var istrue = component.get("v.isopp");
        if (istrue) {
            component.set("v.isSpinning", true);
            var action2 = component.get("c.getRelatedContacts");
            action2.setParams({
                AccId: component.get("v.AccountId")
            });
            action2.setCallback(this, function(response1) {
                var state = response1.getState();
                if (state === "SUCCESS") {
                    console.log("2");
                    var results = response1.getReturnValue();

                    console.log(response1.getReturnValue());
                    var results = response1.getReturnValue();
                    component.set("v.ContactData", results);
                    component.set("v.ContactFilterData", results);
                    component.set("v.isopp", false);
                    component.set("v.isSpinning", false);
                } else if (state === "INCOMPLETE") {

                } else if (state === "ERROR") {
                    var errors = response1.getError();
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
            $A.enqueueAction(action2);

        } else {
            component.set("v.isSpinning", true);
          //  alert("clone records");
            console.log(component.get("v.oppId"));
            console.log(component.get("v.ConId"));
            console.log(component.get("v.QuoteId"));
            var recordsclone = component.get("c.cloneQuote");
            recordsclone.setParams({
                QuoteID: component.get("v.QuoteId"),
                oppId: component.get("v.oppId"),
                ContactId: component.get("v.ConId"),
                Accid : component.get("v.AccountId")
            });
            recordsclone.setCallback(this, function(res) {
                var state = res.getState();
                if (state === "SUCCESS") {
                    console.log("2");
                    var results = res.getReturnValue();
                    console.log(res.getReturnValue());
                    var results = res.getReturnValue();
                    component.set("v.isSpinning", false);
                    if (results != null && results != "") {
                        helper.navigatetoObject(results, component, event);
                    }
                    component.find("overlayLib").notifyClose();
                } else if (state === "INCOMPLETE") {

                } else if (state === "ERROR") {
                    var errors = res.getError();
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
            $A.enqueueAction(recordsclone);

        }




    },
    
    filterSelection :function(component,event,helper){
        let searchText=component.find("searchInput").get("v.value").toLowerCase();
        component.set("v.oppfilterlist",component.get("v.OppData"));  
        let filterList=[];
        let history = component.get("v.oppfilterlist");                           
        if(searchText!='' && searchText!=null ){           
            for(let index in history){
                let thisRecordStr = JSON.stringify(history[index]).toLowerCase();                
                if(thisRecordStr.indexOf(searchText.toLowerCase())>-1){  
                    filterList.push(history[index])
                }
            }
            component.set("v.oppfilterlist",filterList);  
        }         
        
    },
    
    keyPressController : function(component,event,helper){
       let searchText=component.find("searchInput1").get("v.value").toLowerCase();
        component.set("v.ContactFilterData",component.get("v.ContactData"));  
        let filterList=[];
        let history = component.get("v.ContactFilterData");                           
        if(searchText!='' && searchText!=null ){           
            for(let index in history){
                let thisRecordStr = JSON.stringify(history[index]).toLowerCase();                
                if(thisRecordStr.indexOf(searchText.toLowerCase())>-1){  
                    filterList.push(history[index])
                }
            }
            component.set("v.ContactFilterData",filterList);  
        }   
    }

})