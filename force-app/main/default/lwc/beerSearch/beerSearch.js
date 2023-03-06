import { LightningElement,track } from 'lwc';

export default class BeerSearch extends LightningElement {
    @track searchVal;
    handleChange(event){
        const value=event.target.value;
        const searchEvent = new CustomEvent(
            'search',{
                detail :value
            }
        );
        this.dispatchEvent(searchEvent);
    }
}