import { LightningElement, wire } from 'lwc';
import getAccountType from "@salesforce/apex/UtilClass.getAccountTypePicklistValues";

export default class GetPicklistValuesLWC extends LightningElement {

    picklistTypeOptions;    // HOLD PICKLIST DATA TO SHOW IN THE COMBOBOX
    picklistTypeValue;      // HOLD COMBOBOX VALUE

    connectedCallback() {
        getAccountType({}).then(result=>{
            if (result) {
               this.mapPickListValue(result); 
            }
        })
    }

    // MAPING PICKLIST VALUE IN THE FORM KEY VALUE
    mapPickListValue(result) {
        this.picklistTypeOptions = result.map((item, index) => ({
            label: item,
            value: item
        }))
    }
    
    // HANDLE COMBOBOX VALUE
    handleComboboxValueChange(event) {
        this.picklistTypeValue = event.detail.value;
    }
}
