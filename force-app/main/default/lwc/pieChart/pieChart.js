import { LightningElement, wire, track } from 'lwc';
import getRecordList from '@salesforce/apex/PieChartWork.getRecordList'; 
export default class PieChart extends LightningElement {
 @track value;
  @track opp;
	@track error;
	@track size =[];		
		
			    get options() {
        return [
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
    }

	@wire(getRecordList)
		lwcRecords ({ error, data })
		{
       if (data) {
           this.opp = data; 
		   console.log('Pie Chart -->'+this.opp);
		   console.log('Pie Chart length 1 -->'+this.opp[0]);

            var i;
                for(i=0; i<1; i++){
                    console.log(this.opp[i]);
                }
					     for(i=0; i<this.opp.length; i++){
                this.size.push({
                        label : ""+this.opp[i]+"",
                        value : "'"+this.opp[i]+"'"
                    },);
									 console.log('Arreay of object -->'+this.size);
                }
					 
            
			 }
			else  if(error){ 
          this.error = error;  
     } 
		}
		    handleChange(event) {
        this.value = event.detail.value;
    }

}