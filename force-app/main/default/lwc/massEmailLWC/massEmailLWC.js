import { LightningElement, wire, api, track } from 'lwc';
import getObjectList from '@salesforce/apex/MassEmailCmpController.getObjectList';
import getObjectTabelData from '@salesforce/apex/MassEmailCmpController.getObjectTabelData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import ContactMobile from '@salesforce/schema/Case.ContactMobile';


export default class MassEmailLWC extends LightningElement {
    @track recordList;
    @track recordListCopy;
    @track isLoaded = false;
    @track columns;
    @track sortBy;
    @track sortDirection;
    searchKey = '';
    objectList;
    inputClass;
    boxClass;
    selectedObjectLabel;
    selectedObjectLabelInList;
    listOfFields;
    isValueSelected;
    open = false;
    iconName;
    objectApiName;
    error;
    searchRecordLabel;
    recordSearchKey;
    openFilterPanel = false;
    recordsSize;
    openModal = false;
    selectRecordList;
    selectRecordListFinal;
    loadSpinner = true;
    value;
    emailFieldScreen = false;
    options = [];
    objectRecordResult;

    renderedCallback() {
        this.isLoaded = true;
    }

    @wire(getObjectList)
    wiredRecords({ error, data }) {
        if (data) {
            console.log('this.listOfFields  -->' + JSON.stringify(data));
            this.listOfFields = data;
            this.objectList = data;
            this.loadSpinner = false;
        } else if (error) {
            console.log(error);
        }
    }


    handleClick() {
        this.searchKey = '';
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
        this.open = true;
    }

    handleRemove() {
        if (!this.isValueSelected) {
            this.open = false;
        }
    }

    handleRemovePill() {
        this.isValueSelected = false;
        this.listOfFields = this.objectList;
    }

    onChange(event) {
        this.searchKey = event.target.value;
        console.log(' on change -->' + event.target.value);
        if (event.target.value != '') {
            console.log(' on change 2-->' + event.target.value);
            this.listOfFields = this.objectList.filter(item => {
                return item.label.includes(event.target.value);
            });
            console.log('this.listOfFields -->' + this.listOfFields);
        } else {
            this.listOfFields = this.objectList;
        }
    }

    searchRecordName(event) {
        this.recordSearchKey = event.target.value;
        if (event.target.value != '') {
            console.log(' on record change -->' + event.target.value);
            this.recordList = this.recordListCopy.filter(item => {
                console.log(' on record change 1-->' + event.target.value);
                return item.Name.includes(event.target.value);
            });
        } else {
            this.recordList = this.recordListCopy;
        }
        this.recordsSize = this.recordList.length;
    }

    onChangeFilter() {
        this.openFilterPanel = !this.openFilterPanel;
    }

    handleModalBox(event) {
        this.selectRecordList = this.template.querySelector('lightning-datatable').getSelectedRows();
        console.log('Selected Rows 1-->' + JSON.stringify(this.selectRecordList));
        console.log('Selected Rows Email Value -->' + this.selectRecordList)
        if (this.selectRecordList.length) {
            if (this.emailFieldScreen) {
                this.template.querySelector(`c-modal[data-id="composeEmailModal1stSCreen"]`).displayModal(true);
            } else {
                this.handleNextPage();
            }
        } else {
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Please select the rows',
                variant: 'error',
                autoClose: true
            });
            this.dispatchEvent(event);
        }
    }

    handleCloseModal(event) {
        const id = event.target.dataset.modalId;
        console.log('event.target.dataset.modalId-->' + event.target.dataset.modalId);
        this.template
            .querySelector(`c-modal[data-id="${id}"]`)
            .displayModal(false);
    }

    handleNextPage(event) {
        const value = this.value;
        const found = this.selectRecordList.find(element => !element[value]);
        const found1 = this.selectRecordList.find(element => element[value]);
        console.log('Value -->'+value);
        console.log('found -->'+JSON.stringify(found));
        console.log('found 1 -->'+JSON.stringify(found1));
        if (found) {
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Please verify you select field value available in select the rows',
                variant: 'error',
                autoClose: true
            });
            this.dispatchEvent(event);
        }else {
            this.selectRecordListFinal = [];
            for(let field of this.selectRecordList){
                this.selectRecordListFinal.push({ "name": field.Name, "recodId": field.Id, "email": field[value]},);
            }
            console.log(' this.selectRecordList -->'+ JSON.stringify(this.selectRecordList));
            console.log(' this.selectRecordListFinal -->'+ JSON.stringify(this.selectRecordListFinal));
            this.template.querySelector(`c-modal[data-id="composeEmailModal1stSCreen"]`).displayModal(false);
            this.template.querySelector(`c-modal[data-id="composeEmailModal"]`).displayModal(true);
        }
    }

    sendMail(event) {
        this.template.querySelector('c-email-composer').sendMail();
    }

    handleCloseModalOnSuccess(event) {
        this.handleCloseModal(event);
    }

    onSelect(event) {
        this.selectedObjectLabel = event.currentTarget.dataset.name;
        this.selectedObjectLabelInList = "List of " + event.currentTarget.dataset.name;
        this.iconName = event.currentTarget.dataset.icon;
        this.objectApiName = event.currentTarget.dataset.id;
        console.log('Object Api Name -->' + event.currentTarget.dataset.id);
        this.isValueSelected = true;
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        if (this.objectApiName != '') {
            this.handleImperative();
            this.isLoaded = false;
            this.searchRecordLabel = 'Search ' + event.currentTarget.dataset.name + ' Records';
        }
    }


    handleChange(event) {
        this.value = event.detail.value;
        console.log('value -->' + this.value);
    }




    handleSortdata(event) {

        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {

        let parseData = JSON.parse(JSON.stringify(this.recordList));
        console.log('parseData -->'+parseData);
        let keyValue = (a) => {
            return a[fieldname];
        };
        console.log('a -->'+keyValue);

        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            console.log('a -->'+keyValue(x));
            y = keyValue(y) ? keyValue(y) : '';
            console.log('a -->'+keyValue(y));
            return isReverse * ((x > y) - (y > x));
        });
        this.recordList = parseData;

    }


    /*   handleKeyUp(evt) {
   
           const isEnterKey = evt.keyCode === 13;
           if (isEnterKey) {
   
               if (this.searchKey !== evt.target.value) {
                   this.isDataLoaded = false;
                   this.searchKey = evt.target.value;
                   this.isShowTable = true;
               }
           }
       }    */

    handleImperative() {
        getObjectTabelData({ objectApiName: this.objectApiName })
            .then(result => {
                console.log('Result -->' + JSON.stringify(result));
                this.objectRecordResult = result;
                this.recordList = result.objectDataList;
                this.recordListCopy = result.objectDataList;
                this.recordsSize = result.objectDataList.length;
                const found = result.dataTableColumnsList.find(element => element.type == "EMAIL");
                const emailFields = result.dataTableColumnsList.filter(element => { return element.type == "EMAIL" });
                console.log('emailFields size -->' + emailFields.length);
                let modalContent = this.template.querySelector('[data-Id="MassEmail"]');
                this.options=[];
                if (found) {
                    console.log('modalContent -->' + modalContent.disabled);
                    modalContent.disabled = false;
                    if (emailFields.length > 1) {
                        this.emailFieldScreen = true;
                        for (let field of emailFields) {
                            this.options.push({ "label": field.label, "value": field.fieldName },);
                            console.log(field.label);
                        }
                    } else {
                        this.value = emailFields[0].fieldName;
                        this.emailFieldScreen = false;
                    }
                } else {
                    modalContent.disabled = true;
                }
                console.log('this.recordList  -->' + JSON.stringify(this.recordList));
                this.columns = result.dataTableColumnsList;
                this.isLoaded = true;
            })
            .catch(error => {
                this.error = error;
                console.log('error -->' + JSON.stringify(error));
                this.isLoaded = true;
            });
    }

    handleSave(event) {
        this.saveDraftValues = event.detail.draftValues;
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records Updated Successfully!!',
                    variant: 'success'
                })
            );
            this.saveDraftValues = [];
            return this.handleImperative();
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An Error Occured!!',
                    variant: 'error'
                })
            );
        }).finally(() => {
            this.saveDraftValues = [];
        });
    }

    async refresh() {
        console.log('Refresh Method');
        await refreshApex(this.objectRecordResult);
    }


}