// GETTING ACCOUNT TYPE PICKLIST VALUE
import { LightningElement, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';       // UI API
import ACCOUNT_TYPE_FIELD from '@salesforce/schema/Account.Type';    // GET ACCOUNT TYPE DETAILS 

export default class GetPicklistValuesLWC extends LightningElement {

    picklistTypeOptions;            // STORE ALL PICKLIST VALUES TO SHOW IN THE COMBOBOX
    picklistTypeValue;              // STORE COMBOBOX VALUE

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: ACCOUNT_TYPE_FIELD })
    wiredPicklistValues({ data, error }) {
        console.log('wiredPicklistValues called');
        if (data) {
            this.picklistTypeOptions = data.values.map(item => ({ label: item.label, value: item.value }));
        } else if (error) {
            console.error('Error loading picklist values', error);
        }
    }

    handleComboboxValueChange(event) {
        this.picklistTypeValue = event.detail.value;
        console.log(this.picklistTypeValue);
    }

    // Note:- {
    //     a). @wire Decorator: - wire decorator to call the getPicklistValues.
    //     b).wiredPicklistValues Function:: - This is the callback function for the wire adapter.It will be executed when the 
    //                                         wire adapter fetches data function name could be anything.
    //                 If there's an error during data retrieval, the error parameter will be populated with the error message.
    //                 If data is successfully retrieved, the data parameter will contain the picklist values.
    //      }
}
