import { LightningElement,api} from 'lwc';

export default class BeerTile extends LightningElement {
    @api beerRecord;
    handleChange(){
       // const serachEvent = new CustomEvent(
         //   'value',
        //    {
           //    detail : this.beerRecord.Id
         //   });
        this.dispatchEvent(new CustomEvent(
            'value',
            {
               detail :this.beerRecord.Id
            })); 
        console.log('Check of beerTile');   
    }
		
		productView(event){
			let	modal = this.template.querySelector('div[data-id="myModal"]');
				console.log('modal ',modal);
    let  img = this.template.querySelector('img[data-id="myImg"]');
				console.log('img ',img);
   let    modalImg = this.template.querySelector('img[data-id="img01"]');
		let		captionText = this.template.querySelector('div[data-id="caption"]');
    modal.style.display = "block";
  modalImg.src = img.src;
  captionText.innerHTML = img.alt;
}
		closeImageModal(event){
				let span = this.template.querySelector('spam[class="close"]');
				let	modal = this.template.querySelector('div[data-id="myModal"]');
            modal.style.display = "none";
		}
		
}