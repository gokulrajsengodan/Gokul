import { LightningElement,wire,track } from 'lwc';
import getRecordList from '@salesforce/apex/lwcClass.getRecordList'; 
import getUpdateRecords from '@salesforce/apex/lwcClass.getUpdateRecords'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import NAME_FIELD from '@salesforce/schema/LWC_Obj__c.Name';
import { refreshApex } from '@salesforce/apex';
export default class LWC_Obj extends NavigationMixin(LightningElement) {
		
		@track record;
		@track records;
		@track error;
		@track head;
		@track checkBox1;
		@track checkBox2;
		@track ids;
		@track openModal=false;
		openEditModal = false;
		@track modalBox=false;
		@track objectApiName="LWC_Obj__c";
		fields=[NAME_FIELD];
		totalResult;
		
		@wire(getRecordList)
		lwcRecords (result)
		{
			this.totalResult = result;
       if (result.data) {
           this.record = result.data; 
					 const a=result.data[0].Heading__c;
					 const b=result.data[2].Heading__c;
					 this.head=[a,b];
					 console.log(this.head);
      } 
			else  if(result.error){ 
          this.error = result.error;  
     } 
		}
		
		handleCheckBox1(event){
				this.checkBox1=event.target.checked;
				this.ids=event.target.dataset.id;
				this.callImperativeMethod();
				console.log('handleCheckBox1');
				console.log(this.checkBox1);
				console.log(this.ids);
		}
		
		handleCheckBox2(event){
				this.checkBox2=event.target.checked;
				this.ids=event.target.dataset.id;
				this.callImperativeMethod();
				console.log('handleCheckBox2');
		}
		
/*	navigateToRecordViewPage(event){
				console.log('Inside Navigate');
				 this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.recid,
                objectApiName: 'LWC_Obj__c',
                actionName: 'edit'
            }
        });
		}  */
		
		showModal(event) {
        this.openModal = true;
				console.log('Call Modal Box');
				this.records=event.currentTarget.dataset.recid;
				console.log(this.records);
				console.log(event.currentTarget.dataset.recid);
    }
		showEditModal(event){
				this.openEditModal = true;
				console.log('Call Modal Box');
				this.records=event.currentTarget.dataset.recid;
				console.log(this.records);
				console.log(event.currentTarget.dataset.recid);
		}
		    closeModal() {
        this.openModal = false;
						this.openEditModal = false;
    } 
		
		handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }
    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
				this.openEditModal = false;
				const eve = new ShowToastEvent({
                        title: 'Success',
                        message: "Records Successfully Updated",
                        variant: 'success'
                    });
				this.dispatchevent(eve);
				        console.log('before refresh');

						//refreshApex(this.totalResult);
		}
		 
		
		modal(){
				this.modalBox=true;
				console.log('call initial modal ');
				console.log(this.modalBox);
		}
		
		callImperativeMethod(){
		 getUpdateRecords({ ids : this.ids,checkBox1: this.checkBox1,checkBox2 : this.checkBox2 })
            .then(result => {
									  this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: "Records Successfully Updated",
                        variant: 'success'
                    })
                ); 
		 console.log('ImperativeMethod');
		 })
}
}