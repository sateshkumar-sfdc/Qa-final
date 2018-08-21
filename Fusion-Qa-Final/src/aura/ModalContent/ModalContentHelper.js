({
	helperMethod : function(component, event, data ) {
	component.find("overlayLib").notifyClose();	
	//component.destroy();
	//var popup = window.open(location, '_self', '');
    //popup.close();
    /*var compEvent = component.getEvent("eventtoclosemodal");
         compEvent.setParams({"eventtoclose" : data });
        compEvent.fire();*/
	}
})