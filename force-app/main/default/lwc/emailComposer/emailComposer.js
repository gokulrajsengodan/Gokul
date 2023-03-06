import {LightningElement, wire, api } from 'lwc';
import sendMailMethod from '@salesforce/apex/EmailMessageCtrl.sendMailMethod';
import getEmailTempaltes from '@salesforce/apex/EmailMessageCtrl.getEmailTempaltes';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmailComposer  extends LightningElement {
		subject = '';
		emailbody = '';
		templateId;
		emailTemplateList = [];
		emailTemplateOptions = [];
		loaded = false;
		emailList = [];
		fromAddressOptions = [];
		fromAddress = 'Current User';
		ccAddress = '';

		@api
		fromChannel = " ";
		@api
		selectedRecords;

		connectedCallback(){
				this.emailList = this.selectedRecords.map(
						(obj) => {
							console.log('Obj -->'+JSON.stringify(obj));
								return {
										label: obj.email
								};
						}
				);
		}

		@wire(getEmailTempaltes)
		getEmailTempaltes(result) {
			if(result.data){
				var data = result.data;
				this.fromAddressOptions = data.fromAddressOptions;
				this.emailTemplateList = data.emailTemplateList;
				this.emailTemplateOptions = this.emailTemplateList.map(
				(obj) => {
					return {
					label: obj.emailTemplatename,
					value: obj.emailTemplateId
					};
					}
				);
			}
		}

		handleEmailRemove(event) {
				let removedName = event.detail.item;
				console.log('T-name' + JSON.stringify(removedName));
				console.log('T-this.students[0]-' + JSON.stringify(this.selectedRecords[0]));
				this.selectedRecords = this.selectedRecords.filter(
					//	selectedStudent => selectedStudent.email ? selectedStudent.email : selectedStudent.Email !== removedName.label
				    selectedStudent => {return selectedStudent.email !== removedName.label}	
				);
				this.emailList = this.emailList.filter(obj => {return obj.label !== removedName.label});
				console.log(JSON.stringify(this.selectedRecords));
				console.log(JSON.stringify(this.emailList));

		}


		@api
		async sendMail() {

				const allValid = [
						...this.template.querySelectorAll('lightning-input'),
						...this.template.querySelectorAll('lightning-combobox')
				].reduce((validSoFar, inputCmp) => {
						inputCmp.reportValidity();
						return validSoFar && inputCmp.checkValidity();
				}, true);

				if (allValid && this.selectedRecords.length > 0) {
						this.loaded = true;
						console.log('T-Inside sendMail');
						await sendMailMethod({
								selectedRecordStr: JSON.stringify(this.selectedRecords),
								subject: this.subject,
								emailbody: this.emailbody,
								templateId: this.templateId,
								ccAddress: this.ccAddress,
								fromAddress: this.fromAddress
						}).then(result => {
								const event = new ShowToastEvent({
										title: 'Success',
										message: 'Mail Sent Successfully.',
										variant: 'success',
										autoClose: true
								});
								this.dispatchEvent(event);
								this.loaded = false;
								this.dispatchEvent(new CustomEvent('closecomposeronsuccess'));
						})
								.catch(error => {
									this.loaded = false;
								const event = new ShowToastEvent({
										title: 'Error',
										message: error,
										variant: 'error',
										autoClose: true
								});
								console.log('error -->'+JSON.stringify(error));
								this.dispatchEvent(event);
						});
				} else {
						const event = new ShowToastEvent({
								title: 'Error',
								message: 'Please fill required entries.',
								variant: 'error',
								autoClose: true
						});
						this.dispatchEvent(event);
				}
		}

		handleChange(evt) {
				const { name, value } = evt.target;
				this[name] = value;
		}  

		handleSubjectChange(event) {
				this.subject = event.target.value;
		}

		handleEmailBodyChange(event) {
				this.emailbody = event.target.value;
		}
		onSelectFromAddress(event) {
			this.fromAddress = event.detail.value;
		}

		handleCcAddressChange(event){
			this.ccAddress = event.target.value;
		}

		onSelectEmailTemplate(event) {
				console.log('event.detail.value' + event.detail.value);
				const selectedTemplate = this.emailTemplateList.find(
						({ emailTemplateId }) => emailTemplateId === event.detail.value
				);
				console.log('selectedTemplate' + selectedTemplate);
				console.log('selectedTemplate value' + event.detail.value);
				if (selectedTemplate) {
						this.subject = selectedTemplate.emailSubject;
						this.emailbody = selectedTemplate.emailbody;
				} else {
						this.subject = '';
						this.emailbody = '';
				}
				this.templateId = event.detail.value;
		}

}