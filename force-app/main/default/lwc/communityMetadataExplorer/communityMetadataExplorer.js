import { LightningElement, track, wire } from 'lwc';
import fetchSites from '@salesforce/apex/MetadataDependencyController.getSites';
import fetchComponentDependency from '@salesforce/apex/MetadataDependencyController.getMetadataComponentDependency';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export const COLUMNS_DEFINITION = [
    {
         type: 'text',
         fieldName: 'MetadataComponentName',
         label: 'Metadata Name',
         initialWidth: 300,
     },
     {
         type: 'text',
         fieldName: 'RefMetadataComponentType',
         label: 'Ref Metadata Type',
     },
     {
         type: 'text',
         fieldName: 'RefMetadataComponentName',
         label: 'Reference Metadata Name',
     },
 ];

export default class CommunityMetadataExplorer extends LightningElement {

    
    selectedCommunityId = '';

    startSpinning = false;

    @track gridData= [];
    @track columns=COLUMNS_DEFINITION;

    // Needs explicit track due to nested data
    @track
    searchOptions = [];

    error;
    errorMsg;

    // Wire a custom Apex method
    @wire(fetchSites)
    getCommunity({ error, data }) {
        if (data) {
            this.searchOptions = data.map((type) => {
                return { label: type.MasterLabel, value: type.Id };
            });
            this.searchOptions.unshift({ label: 'None', value: '' });
        } else if (error) {
            this.searchOptions = undefined;
            this.error = error;
            console.log(error);
        }
    }

    @wire(fetchComponentDependency, {communityId : '$selectedCommunityId'})
    getComponents({ error, data }) {
        if (data) {
            this.gridData=data;
            this.startSpinning = false;
        } else if (error) {
            this.errorMsg = error;
            this.startSpinning = false;
            const evt = new ShowToastEvent({
                title: 'Metadata Component Dependency API Failed',
                message: error,
                variant: 'error'
            });
            this.dispatchEvent(evt);
        }
    }

    handleOptionChange(event) {
        this.selectedCommunityId = event.detail.value;
        this.startSpinning = true;
    }

    handleFileDownload() {
        if(this.gridData) {
            let csvContent = "data:text/csv;charset=utf-8,";
            this.gridData.forEach(function(rowArray) {
                let row = rowArray.MetadataComponentName+","+rowArray.RefMetadataComponentType+","+rowArray.RefMetadataComponentName+",";
                csvContent += row + "\r\n";
            });
            const encodedUri = encodeURI(csvContent);
            const link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", "File.csv");
            document.body.appendChild(link); 
            link.click();
        }
    }
}