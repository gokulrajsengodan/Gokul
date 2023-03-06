import { LightningElement,api } from 'lwc';
import {si} from 'c/javaScriptChild';
export default class ParentCompon extends LightningElement {
		@api p;
		@api t;
		@api r;
		handleClick(){
				this.template.querySelector('c-child-compon').childMethod;
				alert('worked');
		}
	
	handleChange(){
				const sim=si(this.p,this.t,this.r);
				console.log('check',sim);
		}
}