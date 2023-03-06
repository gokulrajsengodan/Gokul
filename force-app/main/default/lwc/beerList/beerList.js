import { LightningElement, track, wire,api } from 'lwc';
import cartIco from '@salesforce/resourceUrl/cartIco';
import searchBeer from '@salesforce/apex/BeerController.searchBeer';
import getCartId from '@salesforce/apex/BeerController.getCartId';
import createCartItems from '@salesforce/apex/BeerController.createCartItems';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
export default class BeerList extends NavigationMixin(LightningElement) {

    @api beerRecord;
    @track errros;
    @track cart = cartIco;
    @track cartId;
    @track itemsinCart = 0;

    @wire(searchBeer)
        wiredRecords({error, data}){
            console.log(' Data ', data);
            this.beerRecord = data;
            this.errors = error;
        }

    handleEvent(event){
        const eventVal = event.detail;
        console.log(' Search Param ', eventVal);
        searchBeer({
            searchParam : eventVal
        })
        .then(result => {
            console.log(' Beer Records ', result);
            this.beerRecord = result;
            this.errros = undefined;
        })
        .catch(error => {
            console.log(' Errors ', error);
            this.errors = error;
            this.beerRecord = undefined;
        })
    }
    connectedCallback(){
        this.defaultCartId();
    } 

    defaultCartId(){
        getCartId()
        .then(data => {
            const wrapper = JSON.parse(data);
            if ( wrapper ){
                this.itemsinCart = wrapper.Count;
                this.cartId = wrapper.CartId;
                console.log('getcardId Check');
            }
        })
        .catch(error => {
            this.cartId = undefined;
            console.log(error);
            console.log('getcardId Error');
        });
    }
    navigateToCartDetail(){
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Card_Detail' // Cart Detail
            },
            state : {
                c__cartId : this.cartId
            }
        });
    }
    addToCart(event){
        const selectBeerId = event.detail;
        console.log('Button Check');
        const selectBeerRecord = this.beerRecord.find(
            record => record.Id === selectBeerId
        );
        /*
            for(Beer__c beer : beerRecords ){
                if(beer.Id == selectBeerId ){
                    return beer;
                }
            }
        */
        createCartItems({
            CartId : this.cartId,
            BeerId : selectBeerId,
            Amount : selectBeerRecord.Price__c
        })
        console.log('cartitems')
        .then(data => {
            console.log(' Cart Item Id ', data);
            this.itemsinCart = this.itemsinCart + 1;
            const toast = new ShowToastEvent({
                'title' : 'Success!!',
                "message" : selectBeerRecord.Name +' Added into Cart!',
                "variant" : "success", 
            });
            this.dispatchEvent(toast);
        })
        .catch(error => {
            console.log('Error',error);
            const toast = new ShowToastEvent({
                'title' : 'Error!!',
                "message" : JSON.stringify(error),
                "variant" : "error", 
            });
            this.dispatchEvent(toast);
        });
    }
}