import { LightningElement,api } from 'lwc';
export default class ViewResouceResume extends LightningElement {
		@api recordId
		viewResume(){
				window.open('/apex/ResourceResumePage?id='+this.recordId);
		}
}