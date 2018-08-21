({
	doInit : function(component, event, helper) {
		helper.getContacts(component);
    },
    
    selectContact : function(component, event, helper) {
    	console.log(event.target);
        if(event.target.value == "None")
        {
            component.set("v.selectedContact", null);
        }
        else
        {
            component.set("v.selectedContact", event.target.value);
        }
    },
    
    contactNext : function(component, event, helper) {
        	console.log(component.get("v.selectedContact"));
            helper.getOpportunity(component);
    },
    
    selectOpportunity : function(component, event, helper) {
    	console.log(event.target);
        if(event.target.value == "None")
        {
            component.set("v.selectedOpportunity", null);
        }
        else
        {
            component.set("v.selectedOpportunity", event.target.value);
        }
    },
    
    opportunityNext : function(component, event, helper) {
        	console.log(component.get("v.selectedOpportunity"));
            helper.createRecords(component);
    },
     
    filterSelection :function(component,event,helper){
        let searchText=component.find("searchInput").get("v.value").toLowerCase();
        component.set("v.conList",component.get("v.filterconList"));  
        let filterList=[];
        let history = component.get("v.conList");                           
        if(searchText!='' && searchText!=null ){           
            for(let index in history){
                let thisRecordStr = JSON.stringify(history[index]).toLowerCase();                
                if(thisRecordStr.indexOf(searchText.toLowerCase())>-1){  
                    filterList.push(history[index])
                }
            }
            component.set("v.conList",filterList);  
        }         
        
    },
    
    keyPressController : function(component,event,helper){
       let searchText=component.find("searchInput1").get("v.value").toLowerCase();
        component.set("v.oppList",component.get("v.filteroppList"));  
        let filterList=[];
        let history = component.get("v.oppList");                           
        if(searchText!='' && searchText!=null ){           
            for(let index in history){
                let thisRecordStr = JSON.stringify(history[index]).toLowerCase();                
                if(thisRecordStr.indexOf(searchText.toLowerCase())>-1){  
                    filterList.push(history[index])
                }
            }
            component.set("v.oppList",filterList);  
        }   
    }

})