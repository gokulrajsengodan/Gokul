import { LightningElement,api } from 'lwc';
export default class ChildCompon extends LightningElement {
		
		@api message;
		@api pageno;
		@api date = new date();
		childMethod(){
				this.date;
		}
}