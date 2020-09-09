@isTest
private class TestMetadataDependencyController {
    @isTest
    static void getSites() {
        Test.startTest();
        MetadataDependencyController.getSites();
        Test.stopTest();
    }
    @isTest
    static void getMetadataComponentDependency() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String communityId = 'XYZ1234444';
        List<MetadataItem> lstResponse = MetadataDependencyController.getMetadataComponentDependency(
            communityId
        );
        System.assertEquals(
            2,
            lstResponse.size(),
            'The returned response has error'
        );
    }

    @isTest
    static void increaseCoverage() {
        DependencyAPIResponse apiResponse = new DependencyAPIResponse();
        apiResponse.size = 12;
        apiResponse.totalSize = 12;
        apiResponse.done = true;
        apiResponse.queryLocator = null;
        apiResponse.entityTypeName = 'MetadataComponentDependency';
        // Metadata Item
        MetadataItem item = new MetadataItem();
        item.MetadataComponentId = 'XYZ';
        item.MetadataComponentName = 'XYZ';
        item.MetadataComponentType = 'XYZ';
        item.RefMetadataComponentId = 'YZY';
        item.RefMetadataComponentName = 'Test';
        item.RefMetadataComponentType = 'YZZ';

        List<MetadataItem> lstMetadataItem = new List<MetadataItem>();
        lstMetadataItem.add(item);
        apiResponse.records = lstMetadataItem;
    }
}
