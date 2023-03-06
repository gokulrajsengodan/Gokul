import { LightningElement,api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

export default class SendMassEmailLwc extends NavigationMixin(LightningElement) {
		@api recordList;

		renderedCallback(){
				console.log('calll');
				console.log('recordList',this.recordList);
				this.template
						.querySelector(`c-modal[data-id="composeEmailModal"]`)
						.displayModal(true);
		}
		handleCloseModal(event) {
				const id = event.target.dataset.modalId;
				this.template
						.querySelector(`c-modal[data-id="${id}"]`)
						.displayModal(false);
		}
		sendMail(event) {
				this.template.querySelector('c-email-composer').sendMail();
		}
		handleCloseModalOnSuccess(){
			this[NavigationMixin.Navigate]({
				type: 'standard__objectPage',
				attributes: {
					objectApiName: 'Candidate__c',
					actionName: 'list'
				},
				state: {       
					filterName: 'Recent' 
				}
			});
		}
}