({
    doInit : function(component, event, helper) {
        component.set('v.headers', [
            {label: 'Date', fieldName: 'CreatedDate', type: 'date', sortable: true},
            {label: 'Field', fieldName: 'Field', type: 'text', sortable: true},
            {label: 'Orignal Value', fieldName: 'OldValue', type: 'Text', sortable: true},
            {label: 'New Value', fieldName: 'NewValue', type: 'Text', sortable: true},
            {label: 'Type', fieldName: 'Type', type: 'Text', sortable: true}
        ]);
        helper.getHistory(component, event, helper);
    },
    filterSelection :function(component,event,helper){
        let searchText=component.find("searchInput").get("v.value").toLowerCase();
        component.set("v.componentHistory",component.get("v.componentHistoryFinalList"));  
        let filterList=[];
        let history = component.get("v.componentHistory");                           
        if(searchText!='' && searchText!=null ){           
            for(let index in history){
                let thisRecordStr = JSON.stringify(history[index]).toLowerCase();                
                if(thisRecordStr.indexOf(searchText.toLowerCase())>-1){  
                    filterList.push(history[index])
                }
            }
            component.set("v.componentHistory",filterList);  
        }         
        
    },
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    }
})