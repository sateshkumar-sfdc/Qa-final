({
    //MAX_FILE_SIZE: 750 000, /* 1 000 000 * 3/4 to account for base64 */
	
    
    readFile : function(component,helper) {
        var fileInput = component.find("upButton").getElement();
    	var upfile = fileInput.files[0];
   
        if (upfile.size > 4500000) {
            alert('File size cannot exceed 4500000 bytes.\n' +
    	          'Selected file size: ' + upfile.size);
    	    return;
        }
    
        var fr = new FileReader();
        
        var self = this;
         
       	fr.onload = $A.getCallback(function() {
            var fileContents = fr.result;
			//alert('fileContents===>'+fileContents);
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

            fileContents = fileContents.substring(dataStart);
          //  alert('Testing 1'+fileContents+'File name--'+upfile.name+'Type--'+upfile.type);
          //  alert('Testing 2'+'File name--'+upfile.name+'Type--'+upfile.type);
          //  alert('Testing 3'+'Type--'+upfile.type);
            //self.CallServer(component,upfile,fileContents);
           /**/ var action = component.get("c.saveTheFile"); 
        	action.setParams({"parentId" : "" , "fileName" : upfile.name , "base64Data" : encodeURIComponent(fileContents) , "contentType" : upfile.type });
            action.setCallback(this, function(fileDataResponse) {
            var fileDataState = fileDataResponse.getState();
           	//console.log('Status-->1'+fileDataState);
                
                if (fileDataState === "SUCCESS") {
                var fileDataValues = fileDataResponse.getReturnValue(); 
           // console.log('Response data--->');  
           // console.log(fileDataValues);    
                component.set("v.FileDataWrapperList",fileDataValues);
                }
                
            
            });
   		 	$A.enqueueAction(action); 
            
        });
       fr.readAsDataURL(upfile);
    },
        save : function(component) {
            	var quoteId = component.get("v.FileDataWrapperList")[0].quoteHeader;
            	console.log(quoteId);
            	var wrapString = JSON.stringify(component.get("v.FileDataWrapperList"));
            	var uploadItems = component.get("c.uploadQuoteItems"); 
                uploadItems.setParams({"recId" : quoteId , "fileWrapper" : wrapString  });
                uploadItems.setCallback(this, function(uploadItemsResonse) {
                var uploadItemsState = uploadItemsResonse.getState();
               // console.log('Status-->1'+fileDataState);
                });
             $A.enqueueAction(uploadItems); 
        }
            
   
})