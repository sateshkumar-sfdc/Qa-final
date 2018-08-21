public class FileController {
    
      
    @AuraEnabled
    public static List<FileDataWrapper> saveTheFile(String parentId, String fileName, String base64Data, String contentType) { 
        System.debug('fileName==>'+fileName);
        System.debug('contentType==>'+contentType);
        system.debug('base64Data----->'+base64Data);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        String[] filelines = new String[]{};
        string nameFile ;
         List<FileDataWrapper> fileDataWrapperList = new List<FileDataWrapper>();
        
            nameFile= blobToString(EncodingUtil.base64Decode(base64Data),'ISO 8859-1');      
            filelines = nameFile.split('\n');       
             
            for(Integer i=1;i<filelines.size();i++){
               
              String[] inputvalues = new String[]{};            
               inputvalues = filelines[i].split(',');
               system.debug('%%%%%%% each Line::::: '+inputvalues[1] );
                FileDataWrapper fdw = new FileDataWrapper();
                fdw.productName = inputvalues[0];
                fdw.productCode = inputvalues[1];
                fdw.description = inputvalues[2];
                fdw.productUrl = inputvalues[3];
                fdw.quoteHeader = inputvalues[4];
               /* fdw.artCategory = inputvalues[4];
                fdw.licensingOrg = inputvalues[5];
                fdw.siteCategory = inputvalues[6];
                fdw.royaltyRate = inputvalues[7];
                fdw.itemKeyId = inputvalues[8];*/
                fileDataWrapperList.add(fdw);
                system.debug('wrapper list-->'+fileDataWrapperList.size());
            }
             system.debug('wrapper list 1-->'+fileDataWrapperList.size());
             return fileDataWrapperList;
    }
    
     @AuraEnabled
        public static string uploadQuoteItems(String recId,string fileWrapper)
        {
            system.debug('hello--->'+fileWrapper);
             List<FileDataWrapper> fileList = (List<FileDataWrapper>)JSON.deserialize(fileWrapper,List<FileDataWrapper>.class);
            for(FileDataWrapper fdw : fileList)
            {
                system.debug('--list--'+fdw);
            }
            return null;
        }
    
    public static String blobToString(Blob input, String inCharset){ 
    String hex = EncodingUtil.convertToHex(input); 
    System.assertEquals(0, hex.length() & 1);
    final Integer bytesCount = hex.length() >> 1; 
    String[] bytes = new String[bytesCount]; 
    for(Integer i = 0; i < bytesCount; ++i) bytes[i] = hex.mid(i << 1, 2); 
    return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset); }
    
    public class FileDataWrapper 
    {
        @AuraEnabled Public String productName {get;set;}
        @AuraEnabled Public String productCode {get;set;}
        @AuraEnabled Public String description {get;set;}     
        @AuraEnabled Public String productUrl {get;set;} 
        @AuraEnabled Public String quoteHeader {get;set;}
       /* @AuraEnabled Public String artCategory {get;set;}      
		@AuraEnabled Public String licensingOrg {get;set;}
        @AuraEnabled Public String siteCategory {get;set;}     
        @AuraEnabled Public String royaltyRate {get;set;}     
        @AuraEnabled Public String itemKeyId {get;set;}*/

    }

    
}