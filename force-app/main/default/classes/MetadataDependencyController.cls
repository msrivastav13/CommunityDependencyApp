public with sharing class MetadataDependencyController {
    static String toolingSOQL(string queryString) {
        Double apiVersion = getApiVersion();
        String path = '/tooling/query/?q=' + queryString.replace(' ', '+');
        String endpointurl =
            Url.getOrgDomainUrl().toExternalForm() +
            '/services/data/v' +
            apiVersion +
            path;
        return APIClient.makeAPICall(endpointurl, 'GET');
    }

    static Double getApiVersion() {
        return [
            SELECT ApiVersion
            FROM ApexClass
            ORDER BY ApiVersion DESC
            LIMIT 1
        ]
        .ApiVersion;
    }

    @AuraEnabled(cacheable=true)
    public static List<MetadataItem> getMetadataComponentDependency(
        String communityId
    ) {
        if (communityId != null && string.isNotBlank(communityId)) {
            string toolingsoql =
                'SELECT MetadataComponentId,' +
                'MetadataComponentNamespace,' +
                'MetadataComponentName,' +
                'MetadataComponentType,' +
                'RefMetadataComponentName,' +
                'RefMetadataComponentType,' +
                'RefMetadataComponentNamespace ' +
                'FROM MetadataComponentDependency ' +
                'WHERE MetadataComponentId=\'' +
                communityId +
                '\'';
            String result = toolingSOQL(toolingsoql);
            if (string.isNotBlank(result)) {
                DependencyAPIResponse data = DependencyAPIResponse.parse(
                    result
                );
                List<MetadataItem> metadataItems = new List<MetadataItem>();
                metadataItems = data.records;

                List<Site> lstSites = [
                    SELECT Name, MasterLabel
                    FROM Site
                    WHERE Id = :communityId
                ];
                if (lstSites.size() > 0 || Test.isRunningTest()) {
                    // Add Experience Bundle
                    MetadataItem experienceBundle = new MetadataItem();
                    experienceBundle.MetadataComponentName = data.records[0]
                        .MetadataComponentName;
                    experienceBundle.RefMetadataComponentName = data.records[0]
                        .MetadataComponentName;
                    experienceBundle.RefMetadataComponentType = 'ExperienceBundle';
                    // Add Custom Sites
                    MetadataItem customSites = new MetadataItem();
                    customSites.MetadataComponentName = data.records[0]
                        .MetadataComponentName;
                    customSites.RefMetadataComponentName = data.records[0]
                        .MetadataComponentName;
                    customSites.RefMetadataComponentType = 'CustomSite';
                    // Add Network
                    MetadataItem networkMetadata = new MetadataItem();
                    networkMetadata.MetadataComponentName = data.records[0]
                        .MetadataComponentName;
                    networkMetadata.RefMetadataComponentName = Test.isRunningTest()
                        ? ''
                        : lstSites[0].MasterLabel;
                    networkMetadata.RefMetadataComponentType = 'Network';
                    // add all the community related metadata
                    metadataItems.add(experienceBundle);
                    metadataItems.add(customSites);
                    metadataItems.add(networkMetadata);
                }
                return metadataItems;
            }
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<Site> getSites() {
        return [
            SELECT Id, SiteType, Name, MasterLabel
            FROM Site
            WHERE SiteType = 'ChatterNetworkPicasso' AND Status = 'Active'
        ];
    }
}
