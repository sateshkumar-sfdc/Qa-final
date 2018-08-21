({
	CallServer : function(component,upfile,fileContents) {
		var action = component.get("c.saveTheFile"); 
        	action.setParams({"parentId" : "" , "fileName" : upfile.name , "base64Data" : encodeURIComponent(fileContents) , "contentType" : upfile.type });
            action.setCallback(this, function(fileDataResponse) {
            var fileDataState = fileDataResponse.getState();
           	//console.log('Status-->1'+fileDataState);
            });
   		 $A.enqueueAction(action); 
	}
})