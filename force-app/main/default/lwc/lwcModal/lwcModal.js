import { LightningElement,api,track } from 'lwc';
export default class LwcModal extends LightningElement {
		
		@api lwc; 
		@api openModal; 
		
		
		showModal(){
        this.openModal = true;
				console.log('Call Modal Box');
           }
    closeModal() {
        this.openModal = false;
		}		
}