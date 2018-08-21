({
    getHistory : function(component, event, helper){
        var action = component.get("c.getHistory");
        action.setParams({
            historyParentId: component.get("v.recordId")    
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                let history=[];
                let results = response.getReturnValue();
                for(let i=0;i<results['quoteHeaderHistory'].length;i++){
                    let ob={                        
                        CreatedDate:results['quoteHeaderHistory'][i].CreatedDate,
                        Id:results['quoteHeaderHistory'][i].Id,
                        NewValue:''+this.capitalize(results['quoteHeaderHistory'][i].NewValue),
                        Field:results['quoteHeaderHistory'][i].hasOwnProperty('Field')?this.capitalize(results['quoteHeaderHistory'][i].Field.replace('__c','')):'',
                        OldValue:''+(results['quoteHeaderHistory'][i].hasOwnProperty('OldValue')?this.capitalize(results['quoteHeaderHistory'][i].OldValue):''),
                        Type:'Quote Header'
                    };                    
                    history.push(ob);
                }
                for(let i=0;i<results['quoteLevelHeaderHistory'].length;i++){
                    let ob={
                        CreatedDate:results['quoteLevelHeaderHistory'][i].CreatedDate,
                        Id:results['quoteLevelHeaderHistory'][i].Id,
                        NewValue:''+this.capitalize(results['quoteLevelHeaderHistory'][i].NewValue),
                        Field:results['quoteLevelHeaderHistory'][i].hasOwnProperty('Field')?this.capitalize(results['quoteLevelHeaderHistory'][i].Field.replace('__c','')):'',                       
                        OldValue:''+(results['quoteLevelHeaderHistory'][i].hasOwnProperty('OldValue')?this.capitalize(results['quoteLevelHeaderHistory'][i].OldValue):''),
                        Type:'Quote Header Line Item'
                    };
                    history.push(ob);
                }
                component.set("v.componentHistoryFinalList",history);  
                component.set("v.componentHistory",history);
                
            } else if (status === "INCOMPLETE") {
                //console.log("No response from server or client is offline.");
                this.showToast(component, "Error", "Error", "Incomplete Transaction Try again.");
                // Show offline error
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // console.log("Error message: " + errors[0].message);
                        this.showToast(component, "Error", "Error", errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    this.showToast(component, "Error", "Error", "Unknown error Occurred Try After SomeTime.");
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function (cmp, fieldName, sortDirection) {
        
        var data = cmp.get("v.componentHistory");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.componentHistory", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    capitalize :function(str) {      
        if(str!=undefined && str!='' && isNaN(str)){            
            return str.charAt(0).toUpperCase() + str.slice(1);
        }else{
            return str;
        }
    }
})