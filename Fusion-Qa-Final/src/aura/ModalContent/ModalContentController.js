({
	afterLoad : function(component, event, helper) {
        if(component.get("v.isEdit")){
            
            var editmessage = {
                UPK :component.get("v.UPK"),
                jsondata : component.get("v.jsonData")
            }
            var message1 = JSON.stringify(editmessage);
            
     var vfWindow = component.find("vfFrame").getElement().contentWindow;
     // console.log(vfWindow);	
      vfWindow.postMessage(message1, '*');
            
        }else{  
     
     var message = component.get("v.UPK");
     var vfWindow = component.find("vfFrame").getElement().contentWindow;
     // console.log(vfWindow);	
      vfWindow.postMessage(message, '*');
        
        }
        
        window.addEventListener("message", function(event) {
      // console.log('show json');
            if(event.data.includes("isEdit")){
              // console.log("hai there here to "); 
            var popup = window.open(location, '_self', '');
           // console.log(popup);   
            popup.close();    
            } else{
            //  var compEvent = component.getEvent("eventtoclosemodal");
         //compEvent.setParams({"eventtoclose" : "data" });
       // compEvent.fire();
        var popup = window.open(location, '_self', '');
           // console.log(popup);   
            popup.close();   
            }    
      
            
        } , false);
	},
    
    doInit : function(component, event, helper) {
    
    window.addEventListener("jsonstring", function(event) {
     console.log("hello how are you");  
    } , false);
       //   console.log('show json');
         // console.log(event.data);
          //component.destroy();
        // var CustomizerData = event.data;
      // helper.helperMethod(component, event ,event.data);
        /*if(CustomizerData.includes("jsondata")){
            
            var popup = window.open(location, '_self', '');
            console.log(popup);	
             //popup.close();
        }
        else{
            //helper.helperMethod(component, event,  event.data); 
          var popup = window.open(location, '_self', '');
            console.log(popup);
             popup.close();
        }
       
//        var popup = window.open(location, '_self', '');
     //   popup.close();
     // 
    //component.find('overlayLib').destroy();
    component.find("overlayLib").notifyClose();  
    } , false); */
        
    },     
  
    handleCloseEvent : function(component, event, helper) {
         var cmpEvent  = event.getParam("eventtoclose");
        console.log("hai there ");
        console.log(cmpEvent);
       component.find("overlayLib").notifyClose(); 
    },
    
    handleApplicationEvent : function(component, event, helper) {
        var message = event.getParam("destroymodal");
        console.log(message);
	
    },
    
    handleClose : function(component, event, helper) {
         var cmpEvent1  = event.getParam("toclose");
        console.log("hai there ");
        console.log(cmpEvent1);
      // component.find("overlayLib").notifyClose(); 
    },
})