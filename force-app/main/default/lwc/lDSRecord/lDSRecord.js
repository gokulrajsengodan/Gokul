import { LightningElement,api } from 'lwc';
export default class LDSRecord extends LightningElement {
		@api recordId;
		@api objectApiName;
}