import { LightningElement } from 'lwc';  
 export default class GetLookupRecord extends LightningElement {  
    accountName;  
    accountRecordId;  

   onAccountSelection(event){  
   this.accountName = event.detail.selectedValue;  
   this.accountRecordId = event.detail.selectedRecordId;  
   }  
 }  
