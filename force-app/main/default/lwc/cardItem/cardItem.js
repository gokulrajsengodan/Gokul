import { LightningElement,api } from 'lwc';

export default class CardItem extends LightningElement {
    @api item;
    handleDelete(){
        const deleteEve = new CustomEvent(
            'delete',
            {
                detail : this.item.Id
            }
        );
        this.dispatchEvent(deleteEve);
    }
}