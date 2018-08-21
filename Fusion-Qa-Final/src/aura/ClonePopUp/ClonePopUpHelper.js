({
    navigatetoObject: function(objectId, component, event) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": objectId,

        });
        navEvt.fire();
    }
})