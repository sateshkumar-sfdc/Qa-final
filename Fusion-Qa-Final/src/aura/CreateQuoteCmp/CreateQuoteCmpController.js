({
	doInit : function(component, event, helper) {
		helper.onInit(component, event);
    },
    
    selectAccount : function(component, event, helper) {
    	console.log(event.target);
        if(event.target.value == "None")
        {
            component.set("v.selectedAccount", null);
        }
        else
        {
            component.set("v.selectedAccount", event.target.value);
        }
    },
    
    accountNext : function(component, event, helper) {
        console.log(component.get("v.selectedAccount"));
    	if(component.get("v.selectedAccount") == "")
        {
            helper.createRecords(component);
        }
        else
        {
            helper.getContacts(component);
        } 
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
            helper.createRecords(component);
    },
    
     filterSelection :function(component,event,helper){
        let searchText=component.find("searchInput").get("v.value").toLowerCase();
        component.set("v.showList",component.get("v.filteraccList"));  
        let filterList=[];
        let history = component.get("v.showList");                           
        if(searchText!='' && searchText!=null ){           
            for(let index in history){
                let thisRecordStr = JSON.stringify(history[index]).toLowerCase();                
                if(thisRecordStr.indexOf(searchText.toLowerCase())>-1){  
                    filterList.push(history[index])
                }
            }
            component.set("v.showList",filterList);  
        }         
        
    },
    
    keyPressController : function(component,event,helper){
       let searchText=component.find("searchInput1").get("v.value").toLowerCase();
        component.set("v.showList",component.get("v.filterconList"));  
        let filterList=[];
        let history = component.get("v.showList");                           
        if(searchText!='' && searchText!=null ){           
            for(let index in history){
                let thisRecordStr = JSON.stringify(history[index]).toLowerCase();                
                if(thisRecordStr.indexOf(searchText.toLowerCase())>-1){  
                    filterList.push(history[index])
                }
            }
            component.set("v.showList",filterList);  
        }   
    }
})