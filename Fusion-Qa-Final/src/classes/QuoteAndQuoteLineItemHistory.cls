public class QuoteAndQuoteLineItemHistory {
    
    @AuraEnabled
    public static  map<string,object> getHistory( string historyParentId){
        map<string,object>returnObj=new map<string,object>();
        set<id>parentIds=new set<id>();
        list<Quote_Header__History> quoteHeaderHistory=new list<Quote_Header__History>([SELECT CreatedById,CreatedBy.Name,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,Parent.Name FROM Quote_Header__History where parentId=:historyParentId]);
        if(quoteHeaderHistory.size()>0){
            for(Quote_Header__History  ob:quoteHeaderHistory ){
                parentIds.add(ob.ParentId );
            }
        }
        list<Quote_Item_Level__History> quoteLevelHeaderHistory=new list<Quote_Item_Level__History>([SELECT CreatedById,CreatedBy.Name,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,Parent.Name FROM Quote_Item_Level__History where parent.Quote_Header__c IN: parentIds]);
        returnObj.put('quoteHeaderHistory',quoteHeaderHistory);
        returnObj.put('quoteLevelHeaderHistory',quoteLevelHeaderHistory);    
        return returnObj;    
        
    }

}