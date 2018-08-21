({
    doInit: function(component, event, helper) {

        try {
            
            var action = component.get("c.getQuoteDetails"); 
        action.setParams({
            recId : component.get("v.quoteID")
        });
        action.setCallback(this, function(response) {
           console.log(response.getReturnValue());
           var results = response.getReturnValue();
           component.set("v.QuoteObj",results.QuoteObj);
           component.set("v.AccId",results.QuoteObj.Account__c);
            console.log(component.get("v.AccId"));
            component.set("v.OppId",results.QuoteObj.Opportunity__c);
            console.log(component.get("v.OppId"));
            component.set("v.quoteID",results.QuoteObj.Id);
             console.log(component.get("v.quoteID"));
            component.set("v.itemnumber",results.QuoteObj.ItemNumberToCapture__c);
            component.set("v.Access",results.Accessble);
            console.log(component.get("v.Access"));
            var lineitemList = JSON.parse(results.lineList);
             var stockList = [];
        
        var customlist = [];
        var customhardcoolers = [];
            
             for (let i = 0; i < lineitemList.length; i++) {
                    if (lineitemList[i].category__c == "Stock") {
                        stockList.push(lineitemList[i]);
                        component.set("v.Coolerslist", stockList);
                    } else if (lineitemList[i].category__c == "Custom") {
                        customlist.push(lineitemList[i]);
                        component.set("v.Customlist", customlist);
                    } else if (lineitemList[i].category__c == "NonCustom") {
                        customhardcoolers.push(lineitemList[i]);
                        component.set("v.NotCustomlist", customhardcoolers);
                    }
                }
           
           /*component.set("v.QuoteObj", response.getReturnValue()); 
            var obj = component.get("v.QuoteObj");
            console.log(obj.In_Hands_Date__c);
            component.set("v.OppId",results.Account__c);
            component.set("v.AccId",results.Opportunity__c);
            component.set("v.Expiredate",results.ExpireQuote__c);
            component.set("v.Coolerslist",results.Quote_Items__r);
            var updatelist = component.get("v.updatedList");
            for(var i = 0; i < results.Quote_Items__r.length; i++){
                var updateobj = {
                    Name:  results.Quote_Items__r[i].Name,
                    ProductLocation__c : results.Quote_Items__r[i].ProductUrl__c,
                    Description : results.Quote_Items__r[i].Product_Description__c,
                    headerid :  results.Quote_Items__r[i].Quote_Header__c,
                    lineId :  results.Quote_Items__r[i].Id
                }
              updatelist.push(updateobj);  
            }
            component.set("v.updatedList",updatelist);
            console.log("updatelist");
            console.log(component.get("v.updatedList"));*/
            
        });
        $A.enqueueAction(action);
    


            window.addEventListener("message", function(event) {
                console.log(event.data);
                var jsndata = event.data
                if (jsndata.includes("isEdit")) {
                    console.log("testforow" + event.data);
                    var edata = JSON.parse(jsndata);
                    console.log(edata);
                    var itno = component.get("v.CitemNumber");
                    console.log(itno);
                    var side = component.get("v.side");
                    console.log(side);

                    var evdata = edata.editdata;
                    console.log(evdata);

                    var v = evdata.toString();
                    var m = v.replace(' "{ ', "{");
                    var o = m.replace('"{', '{');
                    var n = o.replace(/\\/g, "");

                    console.log("n");
                    console.log(n);

                    var jsn = "[" + n + "]"

                    var custmizerList = [];
                    custmizerList = JSON.parse(jsn);
                    console.log(custmizerList);
                    var cusList = component.get("v.Customlist");
                    console.log(component.get("v.Customlist"));
                    for (var i = 0; i < cusList.length; i++) {
                        if (cusList[i].itemnumber == itno) {
                            for (var j = 0; j < cusList[i].jsondata.length; j++) {
                                // cusList[i].jsondata = custmizerList;
                                console.log(cusList[i].jsondata[j].ramsideloc);
                                if (cusList[i].jsondata[j].ramsideloc != side) {
                                    //cusList[i].jsondata.splice(j, 1);
                                    custmizerList.push(cusList[i].jsondata[j]);
                                    console.log("real logic");
                                    console.log(cusList[i].jsondata[j]);
                                    console.log(custmizerList);
                                }

                                // }else{
                                //     custmizerList.push(cusList[i].jsondata[j]);
                                // }
                            }
                            cusList[i].jsondata = custmizerList;
                        }
                        // cusList[i].jsondata = custmizerList;
                    }
                    console.log(custmizerList);
                    component.set("v.Customlist", cusList);
                    console.log(component.get("v.Customlist"));
                    // component.set("v.CitemNumber",null); 

                } else {
                    console.log(component.get("v.Coolerslist"));
                    console.log(component.get("v.Customlist"));
                    console.log(component.get("v.customProductId"));
                    var v = event.data.toString();
                    var m = v.replace(' "{ ', "{");
                    var o = m.replace('"{', '{');
                    var n = o.replace(/\\/g, "");
                    var jsn = "[" + n + "]"
                    let custmizerList = [];
                    custmizerList = JSON.parse(jsn);
                    console.log(custmizerList);
                    var cusList = component.get("v.Customlist");
                    var StockList = component.get("v.Coolerslist");
                    console.log(cusList);
                    console.log(StockList);
                    for (var i = 0; i < StockList.length; i++) {
                        console.log(StockList[i]);
                        if (StockList[i].itemnumber == component.get("v.customProductId")) {
                            StockList[i].jsondata = custmizerList;
                            StockList[i].category__c = 'Custom';
                            cusList.push(StockList[i]);
                            StockList.splice(i, 1);
                        }
                    }

                    console.log(cusList);
                    console.log(StockList);
                    component.set("v.Customlist", cusList);
                    component.set("v.Coolerslist", StockList);
                    console.log(component.get("v.Customlist"));
                    console.log(component.get("v.Coolerslist"));
                    console.log(component.get("v.insertList"));
                }




            }, false);
        } catch (e) {
            if (e instanceof MyCustomError) {
                // Specific message for MyCustomError
                console.error(e.name + ' (code ' + e.code + '): ' + e.message);
                helper.showToast(component, e.name, "Error", e.message);
            } else {
                // Generic message for other types of error
                // (unreachable code in this sample)
                console.error(e.message);
                helper.showToast(component, "Error", "Error", e.message);
            }
        }


    },




    changeicon: function(component, event, helper) {
        try {
            helper.showsection(component, event);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }


    },

    changeicon1: function(component, event, helper) {
        try {
            helper.showsectioncustom(component, event);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }
    },

    changeicon2: function(component, event, helper) {

        try {
            helper.showsectionnoncustom(component, event);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }

    },

    ToggleTopProducts: function(component, event, helper) {

        try {
            helper.showsectionnonTopProducts(component, event);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }

    },

    handleComponentEvent: function(cmp, event, helper) {
        try {
            helper.recordsFromSearchbar(cmp, event);
        } catch (e) {
            console.error(e.message);
            helper.showToast(cmp, "Error", "Error", e.message);
        }



    },
    handleTopProductevent: function(cmp, event, helper) {
        try {
            helper.recordsFromTopList(cmp, event);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }

    },

    showAll: function(cmp, event, helper) {
        cmp.set("v.cooler", true);
        cmp.set("v.custom", true);
        cmp.set("v.noncustom", true);
    },

    showCoolers: function(cmp, event, helper) {
        cmp.set("v.cooler", true);
        cmp.set("v.custom", false);
        cmp.set("v.noncustom", false);
    },
    showCustom: function(cmp, event, helper) {
        cmp.set("v.cooler", false);
        cmp.set("v.custom", true);
        cmp.set("v.noncustom", false);
    },
    showNonCustom: function(cmp, event, helper) {
        cmp.set("v.cooler", false);
        cmp.set("v.custom", false);
        cmp.set("v.noncustom", true);
    },

    AddEmblishment: function(component, event, helper) {
        var productkey = event.getSource().get("v.name");
        var n = productkey.lastIndexOf('/');
        var HvItemId = productkey.substring(n + 1);
        var UPK = productkey.substring(0, n);
        component.set("v.customProductId", HvItemId);
        var modalBody;
        $A.createComponent("c:ModalContent", {
                "UPK": UPK
            },
            function(content, status) {
                if (status === "SUCCESS") {

                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        header: "ADD EMBELLISHMENT",
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: "slds-modal_large",
                        closeCallback: function() {
                            // alert('You closed the alert!');
                        }
                    }).then(function(overlay) {
                        component.set('v.overlay', overlay);
                    });


                }
            });
    },

    removeLine: function(component, event, helper) {
        console.log(event.target.name);
        console.log(event.target.id);
        if (event.target.name == "Custom") {
            let customlist = component.get("v.Customlist");
            let insrtlist = component.get("v.insertList");

            for (var i = 0; i < customlist.length; i++) {

                if (customlist[i].itemnumber == event.target.id) {

                    customlist.splice(i, 1);
                    component.set("v.Customlist", customlist);
                }
            }
            for (var i = 0; i < insrtlist.length; i++) {

                if (insrtlist[i].itemnumber == event.target.id) {

                    insrtlist.splice(i, 1);
                    component.set("v.insertList", insrtlist);
                }
            }
        } else if (event.target.name == "Stock") {

            let Stocklist = component.get("v.Coolerslist");
            let insrtlist = component.get("v.insertList");

            for (var i = 0; i < Stocklist.length; i++) {

                if (Stocklist[i].itemnumber == event.target.id) {

                    Stocklist.splice(i, 1);
                    component.set("v.Coolerslist", Stocklist);
                }
            }
            for (var i = 0; i < insrtlist.length; i++) {

                if (insrtlist[i].itemnumber == event.target.id) {

                    insrtlist.splice(i, 1);
                    component.set("v.insertList", insrtlist);
                }

            }
        } else if(event.target.name == "NonCustom"){
             let nonCustomlist = component.get("v.NotCustomlist");
            console.log("list");
            console.log(nonCustomlist)
            for (var i = 0; i < nonCustomlist.length; i++) {

                if (nonCustomlist[i].itemnumber == event.target.id) {
                    console.log(nonCustomlist[i].Id);
                    nonCustomlist.splice(i, 1);
                    component.set("v.NotCustomlist", nonCustomlist);
                }
            }
        }
    },

    saveQuoteHeader: function(component, event, helper) {
        try {
            var issave = true;
            helper.saveandcreate(component, event, helper, issave);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }


    },

    saveandContinueQuoteDetails: function(component, event, helper) {
        try {
            var issave = false;
            helper.saveandcreate(component, event, helper, issave);
        } catch (e) {
            console.error(e.message);
            helper.showToast(component, "Error", "Error", e.message);
        }

    },

    deleteItem: function(component, event, helper) {
        console.log(event.target.id);
        console.log(event.target.name);
        if (event.target.name == "Custom") {
            console.log("name");
            let customlist = component.get("v.Customlist");
            console.log(customlist)
            for (var i = 0; i < customlist.length; i++) {

                if (customlist[i].Id == event.target.id) {
                    console.log(customlist[i].Id);
                    customlist.splice(i, 1);
                    component.set("v.Customlist", customlist);
                }
            }
        }else if(event.target.name == "NonCustom"){
             let nonCustomlist = component.get("v.NotCustomlist");
            console.log("list");
            console.log(nonCustomlist)
            for (var i = 0; i < nonCustomlist.length; i++) {

                if (nonCustomlist[i].Id == event.target.id) {
                    console.log(nonCustomlist[i].Id);
                    nonCustomlist.splice(i, 1);
                    component.set("v.NotCustomlist", nonCustomlist);
                }
            }
            
        } 
        
        else {
            let Stock = component.get("v.Coolerslist");
            console.log("list");
            console.log(Stock)
            for (var i = 0; i < Stock.length; i++) {

                if (Stock[i].Id == event.target.id) {
                    console.log(Stock[i].Id);
                    Stock.splice(i, 1);
                    component.set("v.Coolerslist", Stock);
                }
            }

        }

    },

    removeCustomArt: function(component, event, helper) {

        var cusList = component.get("v.Customlist");
        for (var i = 0; i < cusList.length; i++) {
            if (cusList[i].itemnumber == event.target.id) {
                for (var j = 0; j < cusList[i].jsondata.length; j++) {

                    console.log(cusList[i].jsondata[j].ramsideloc);
                    if (cusList[i].jsondata[j].ramsideloc == event.target.name) {
                        cusList[i].jsondata.splice(j, 1);

                    }


                }

            }

        }

        component.set("v.Customlist", cusList);
    },

    editCustomizer: function(component, event, helper) {
        console.log(event.target.name);

        let itmnumber = event.target.id;
        component.set("v.CitemNumber", itmnumber);
        var customList = component.get("v.Customlist");
        var json = [];
        var upk;
        var side = event.target.name;
        component.set("v.side", side);
        for (var i = 0; i < customList.length; i++) {
            if (customList[i].itemnumber == itmnumber) {
                upk = customList[i].UPK__c;
                for (var j = 0; j < customList[i].jsondata.length; j++) {
                    if (customList[i].jsondata[j].ramsideloc == event.target.name) {
                        json.push(customList[i].jsondata[j]);
                    }
                }
            }
        }

        var modalBody;
        $A.createComponent("c:ModalContent", {
                "UPK": upk,
                "jsonData": json,
                "isEdit": "true"

            },
            function(content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        header: "ADD EMBELLISHMENT",
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: "slds-modal_large",
                        closeCallback: function() {
                            //alert('You closed the alert!');
                        }
                    }).then(function(overlay) {
                        component.set('v.overlay', overlay);
                    });
                }
            });

        console.log(json);
    },
    handleCloseEvent: function(component, event, helper) {
        var cmpEvent = event.getParam("eventtoclose");
        console.log("hai there ");
        console.log(cmpEvent);
        // component.find("overlayLib").notifyClose(); 
    },

    handleSapOrgDetails: function(component, event, helper) {
        console.log(event.getParam("sapOrgstr"));
        var prodId = event.getParam("sapOrgstr");
        console.log('this is a handler--->');
        console.log(prodId);
        component.set("v.SapOrgJson", prodId);
    },

    getPricing: function(cmp, event, helper) {
        cmp.set("v.loaded", true);
        var stock = cmp.get("v.Coolerslist");
        var custom = cmp.get("v.Customlist");
        var noncustom = cmp.get("v.NotCustomlist");

        var lineItems = [];
        var stockList = [];
        // cmp.set("v.Coolerslist",stockList);
        var customlist = [];
        var customhardcoolers = [];

        cmp.set("v.insertList", lineItems);
        for (let i in stock) {
            lineItems.push(stock[i])
        }
        for (let i in custom) {
            lineItems.push(custom[i])
        }
        for (let i in noncustom) {
            lineItems.push(noncustom[i])
        }
         if ( cmp.get("v.SapOrgJson") != null && cmp.get("v.SapOrgJson") != "" ){
          
       var OrgObj = JSON.parse(cmp.get("v.SapOrgJson"));
        console.log(OrgObj);
        OrgObj.productMaterial = lineItems;
        console.log(JSON.stringify(OrgObj));
        
           console.log(OrgObj); 
        } else{
            var OrgObj = {
                "salesOrg":"",
                "distribution":"",
                "division":"",
                "companycode":"",
                "salesoffice":"",
                "salesgrp":""
            };
           OrgObj.productMaterial = lineItems;
           
            
        }

        

        var getPricing = cmp.get("c.getProductPricing");
        getPricing.setParams({
            productjson: JSON.stringify(OrgObj)
        });


        getPricing.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                var result = JSON.parse(response.getReturnValue());
                console.log(result);


                for (let i = 0; i < result.length; i++) {

                    for (let j = 0; j < lineItems.length; j++) {

                        if (lineItems[j].itemnumber == parseInt(result[i].ITM_NUMBER)) {

                            console.log(parseInt(result[i].ITM_NUMBER));

                            for (let k = 0; k < result[i].PricingList.length; k++) {
                                console.log("1");
                                if (result[i].PricingList[k].COND_DESC == "Price") {

                                    console.log(result[i].PricingList[k].COND_VALUE);
                                    lineItems[j].unitprice = result[i].PricingList[k].COND_VALUE;

                                }

                                if (result[i].PricingList[k].COND_TYPE == "LTAX") {
                                    lineItems[j].Tax = result[i].PricingList[k].COND_VALUE;
                                }

                                if (result[i].PricingList[k].COND_TYPE == "LTOT") {
                                    lineItems[j].Total = result[i].PricingList[k].COND_VALUE;
                                }
                                if (result[i].PricingList[k].COND_TYPE == "ZD01") {
                                    let d = result[i].PricingList[k].CONDVALUE;
                                   
                                    let dis =  Math.abs(d); 
                                    lineItems[j].Discount = dis.toFixed(2); ;
                                }
                            }

                        }


                    }

                }
                for (let i = 0; i < lineItems.length; i++) {
                    if (lineItems[i].category__c == "Stock") {
                        stockList.push(lineItems[i]);
                        cmp.set("v.Coolerslist", stockList);
                    } else if (lineItems[i].category__c == "Custom") {
                        customlist.push(lineItems[i]);
                        cmp.set("v.Customlist", customlist);
                    } else if (lineItems[i].category__c == "NonCustom") {
                        customhardcoolers.push(lineItems[i]);
                        cmp.set("v.NotCustomlist", customhardcoolers);
                    }
                }

                console.log(lineItems);
                cmp.set("v.insertList", lineItems);

                console.log(cmp.get("v.insertList"));
                console.log(cmp.get("v.Coolerslist"));
                cmp.set("v.loaded", false);
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(getPricing);

    },

    onQuantityChange: function(component, event, helper) {
        console.log(event.target.name);
        console.log(event.target.id);
        console.log(event.target.value);
        if (event.target.name == 'Stock') {
            var Stocklist = component.get("v.Coolerslist");
            for (var i = 0; i < Stocklist.length; i++) {

                if (Stocklist[i].itemnumber == event.target.id) {
                    console.log(Stocklist[i].itemnumber);
                    Stocklist[i].Quantity = event.target.value;
                }
            }
            console.log(Stocklist);
            component.set("v.Coolerslist", Stocklist);
            console.log(component.get("v.Coolerslist"));

        } else if (event.target.name == 'Custom') {
            var CustomList = component.get("v.Customlist");
            for (let i = 0; i < CustomList.length; i++) {
                if (CustomList[i].itemnumber == event.target.id) {
                    CustomList[i].Quantity = event.target.value;
                }
            }
            component.set("v.Customlist", CustomList);
            console.log(component.get("v.Customlist"));

        }
        else if(event.target.name == 'NonCustom') {
            var nonCustomList = component.get("v.NotCustomlist");
            for (let i = 0; i < nonCustomList.length; i++) {
                if (nonCustomList[i].itemnumber == event.target.id) {
                    nonCustomList[i].Quantity = event.target.value;
                }
            }
            component.set("v.NotCustomlist", nonCustomList);
            console.log(component.get("v.NotCustomlist"));

        }

    },
    onDiscountChange: function(component, event, helper) {
        console.log(event.target.name);
        console.log(event.target.id);
        console.log(event.target.value);
        if (event.target.name == 'Stock') {
            var Stocklist = component.get("v.Coolerslist");
            for (var i = 0; i < Stocklist.length; i++) {

                if (Stocklist[i].itemnumber == event.target.id) {
                    console.log(Stocklist[i].itemnumber);
                    Stocklist[i].Discount = event.target.value;
                }
            }
            console.log(Stocklist);
            component.set("v.Coolerslist", Stocklist);
            console.log(component.get("v.Coolerslist"));

        } else if (event.target.name == 'Custom') {
            var CustomList = component.get("v.Customlist");
            for (let i = 0; i < CustomList.length; i++) {
                if (CustomList[i].itemnumber == event.target.id) {
                    CustomList[i].Discount = event.target.value;
                }
            }
            component.set("v.Customlist", CustomList);
            console.log(component.get("v.Customlist"));

        }
        else if (event.target.name == 'NonCustom') {
            var nonCustomList = component.get("v.NotCustomlist");
            for (let i = 0; i < nonCustomList.length; i++) {
                if (nonCustomList[i].itemnumber == event.target.id) {
                    nonCustomList[i].Discount = event.target.value;
                }
            }
            component.set("v.NotCustomlist", nonCustomList);
            console.log(component.get("v.NotCustomlist"));

        }

    },

    changeMeasures: function(component, event, helper) {

        var key = event.target.name;
        var n = key.lastIndexOf('/');
        var category = key.substring(0, n);
        var measures = key.substring(n + 1);
        if (category == 'Stock') {
            var StockList = component.get("v.Coolerslist");
            for (let i = 0; i < StockList.length; i++) {
                if (StockList[i].itemnumber == event.target.id) {
                    StockList[i].measure = measures;
                }
            }
            component.set("v.Coolerslist", StockList);
            console.log(component.get("v.Coolerslist"));
        } else if (category == 'Custom') {
            var CustomList = component.get("v.Customlist");
            for (let i = 0; i < CustomList.length; i++) {
                if (CustomList[i].itemnumber == event.target.id) {
                    CustomList[i].measure = measures;
                }
            }
            component.set("v.Customlist", CustomList);
            console.log(component.get("v.Customlist"));

        }
        
        else {
            var nonCustomList = component.get("v.NotCustomlist");
            for (let i = 0; i < nonCustomList.length; i++) {
                if (nonCustomList[i].itemnumber == event.target.id) {
                    nonCustomList[i].measure = measures;
                }
            }
            component.set("v.NotCustomlist", nonCustomList);
            console.log(component.get("v.NotCustomlist"));

        }

    },

    changeDiscount: function(component, event, helper) {
        
        var key = event.target.name;
        var n = key.lastIndexOf('/');
        var category = key.substring(0, n);
        var discount = key.substring(n + 1);
        console.log(category);
        if (category == 'Stock') {
            var StockList = component.get("v.Coolerslist");
            for (let i = 0; i < StockList.length; i++) {
                if (StockList[i].itemnumber == event.target.id) {
                    StockList[i].Discountmeasure = discount;
                }
            }
            component.set("v.Coolerslist", StockList);
            console.log(component.get("v.Coolerslist"));
        } else if (category == 'Custom') {
            var CustomList = component.get("v.Customlist");
            for (let i = 0; i < CustomList.length; i++) {
                if (CustomList[i].itemnumber == event.target.id) {
                    CustomList[i].Discountmeasure = discount;
                }
            }
            component.set("v.Customlist", CustomList);
            console.log(component.get("v.Customlist"));

        }
        else  {
            console.log("entered");
            var nonCustomList = component.get("v.NotCustomlist");
            for (let i = 0; i < nonCustomList.length; i++) {
                if (nonCustomList[i].itemnumber == event.target.id) {
                    nonCustomList[i].Discountmeasure = discount;
                }
            }
            component.set("v.NotCustomlist", nonCustomList);
            console.log(component.get("v.NotCustomlist"));

        }
    },
    
     navigatetoobject: function(component, event, helper) {
         console.log("test");
        try {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.quoteID")
               
            });
            navEvt.fire();
        } catch (Err) {
            console.log(Err);
        }
    },
    

})