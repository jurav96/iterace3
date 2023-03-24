import { LightningElement, wire } from 'lwc';
import getUdalosti from '@salesforce/apex/UdalostiController.getUdalosti';
import getMojeUdalosti from '@salesforce/apex/UdalostiController.getMojeUdalosti';
import prihlasitSeNaUdalost from '@salesforce/apex/UdalostiController.prihlasitSeNaUdalost';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';

export default class UdálostiLWC extends LightningElement {
    columns = [
        { label: 'Název', fieldName: 'udalostName' },
        { label: 'Lokace', fieldName: 'lokaceName' },
        { label: 'Datum', fieldName: 'udalostDate', type: 'date' }
    ];
    
    mojeUdalostiData;
    @wire(getUdalosti) udalosti;
    
    @wire(getMojeUdalosti) 
    mojeUdalosti(result){
       this.mojeUdalostiData = result;
       const {error,data} = result;  
       if(data){
       this.myEventData =  JSON.parse(JSON.stringify(data));
    }
    else if(error){
        console.log(error);
    }
        
    };

    selectedUdalost;

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length > 0) {
            this.selectedUdalost = selectedRows[0].udalostId;
        } else {
            this.selectedUdalost = null;
        }
    }
    

    prihlasitSeNaUdalost() {
        if (this.selectedUdalost) {
            prihlasitSeNaUdalost({ udalostId: this.selectedUdalost })
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Úspěch',
                            message: 'Byl jste úspěšně přihlášen na událost',
                            variant: 'success'
                        })
                    ).then(() =>  refreshApex(this.mojeUdalostiData));
                })
                .catch((error) => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Chyba',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        }
    }
}