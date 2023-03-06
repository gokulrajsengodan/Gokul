import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import csvFileRead from '@salesforce/apex/OpportunityCSVProcessor.csvFileRead';
import { loadStyle } from 'lightning/platformResourceLoader';
import multilineToastCSS from '@salesforce/resourceUrl/multilineToastCSS';
import { NavigationMixin } from 'lightning/navigation';

export default class FileUpload extends NavigationMixin(LightningElement) {
    @api recordId;
    @track error;
    @track data;
		spinner = true;
		uploadFiles;

    // accepted parameters
    get acceptedCSVFormats() {
        return ['.csv','.png'];
    }

    renderedCallback() {
        Promise.all([
            loadStyle( this, multilineToastCSS )
            ]).then(() => {
                console.log( 'Files loaded' );
						this.spinner = false;
            })
            .catch(error => {
                console.log( error.body.message );
        });
    }
    
    uploadFileHandler(event) {
        // Get the list of records from the uploaded files
        const uploadedFiles = event.detail.files;
				this.uploadedFiles = event.detail.files;
				            console.log('uploadedFiles: ',uploadedFiles);
				console.log('documentId: ',uploadedFiles[0].documentId);

				this.spinner = true;
        // calling apex class csvFileread method
        csvFileRead({contentDocumentId : uploadedFiles[0].documentId})
        .then(result => {
            var wrapper = result;
            window.console.log('result ===> '+result);
            console.log('Status: '+wrapper.status);

            if(wrapper.status!=null && wrapper.status!=''){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error!',
                        message: wrapper.status,
                        variant: 'error',
                        mode: 'sticky'
                    }),
                );
								this.spinner = false;
            }
            else{
								this.spinner = false;
								this.dispatchEvent(
										new ShowToastEvent({
												title: 'Success',
												message: 'Upload File Processed Successfully. If there is any failure, You will receive failed rows in mail.',
												variant: 'success',
										}),
								);
								this[NavigationMixin.Navigate]({
										type: 'standard__objectPage',
										attributes: {
												objectApiName: 'Opportunity',
												actionName: 'list'
										},
										state: {
												filterName: 'Recent'
										},
								});
            }
        })
        .catch(error => {
            console.log('error : ', error);
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!',
                    message: JSON.stringify(error),
                    variant: 'error',
                }),
            );     
        })

    }
}