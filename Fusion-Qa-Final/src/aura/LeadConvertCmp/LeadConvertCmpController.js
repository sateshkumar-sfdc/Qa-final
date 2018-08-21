({
	doInit : function(component, event, helper) {
        component.set("v.Spinner",true);
		helper.onInit(component, event);
        component.set("v.Spinner",false);
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
            component.set("v.page",0);
            component.set("v.disablePrev", true);
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
    
    nextRecords  : function(component, event, helper) {
        var page = component.get("v.page") + 1;
        var showList = [];
        component.set("v.page",page);
        console.log(component.get("v.page"));
        if(component.get("v.flowControl") == 1)
        {
            var accList = component.get("v.accList");
            for(var i = page * 3; i < page * 3 + 3 ; i++)
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
        else if(component.get("v.flowControl") == 2)
        {
            var conList = component.get("v.conList");
            for(var i = page * 3; i < page * 3 + 3 ; i++)
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
        component.set("v.disablePrev", false);
    },
    
    prevRecords  : function(component, event, helper) {
        var page = component.get("v.page") - 1;
        var showList = [];
        component.set("v.page",page);
        console.log(component.get("v.page"));
        if(component.get("v.flowControl") == 1)
        {
            var accList = component.get("v.accList");
            for(var i = page * 3 + 2; i >= page * 3; i--)
            {
                showList.push(accList[i]);
                if(i == 0)
                {
                    component.set("v.disablePrev", true);
                    break;
                }
            }
            component.set("v.showList", showList);
        }
        else if(component.get("v.flowControl") == 2)
        {
            var conList = component.get("v.conList");
            for(var i = page * 3 + 2; i >= page * 3; i--)
            {
                showList.push(conList[i]);
                if(i == 0)
                {
                    component.set("v.disablePrev", true);
                    break;
                }
            }
            component.set("v.showList", showList);
        }
        component.set("v.disableNxt", false);
    }
})