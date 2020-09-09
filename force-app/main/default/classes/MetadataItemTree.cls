public with sharing class MetadataItemTree extends MetadataItem {
    @AuraEnabled
    public List<MetadataItemTree> children { get; set; }
}
