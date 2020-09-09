public with sharing virtual class MetadataItem {
    @AuraEnabled
    public String MetadataComponentId { get; set; }
    @AuraEnabled
    public String MetadataComponentName { get; set; }
    @AuraEnabled
    public String RefMetadataComponentName { get; set; }
    @AuraEnabled
    public String RefMetadataComponentId { get; set; }
    @AuraEnabled
    public String RefMetadataComponentType { get; set; }
    @AuraEnabled
    public String MetadataComponentType { get; set; }
}
