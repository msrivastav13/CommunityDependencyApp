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
                return data.records;
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
