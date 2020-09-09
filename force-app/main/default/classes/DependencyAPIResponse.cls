public inherited sharing class DependencyAPIResponse {

    public Integer size {get;set;} 
    public Integer totalSize {get;set;} 
    public Boolean done {get;set;} 
    public Object queryLocator {get;set;} 
    public String entityTypeName {get;set;} 
    public List<MetadataItem> records {get;set;} 
    
    public static DependencyAPIResponse parse(String json){
        return (DependencyAPIResponse) System.JSON.deserialize(json, DependencyAPIResponse.class);
    }	
}
