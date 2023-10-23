import { LightningElement, track, wire, api } from "lwc";
import findRecords from "@salesforce/apex/LwcLookupController.findRecords";
export default class LookupInLwc extends LightningElement {
    recordsList;
    searchKey = "";
    @api selectedValue;
    @api selectedRecordId;
    @api objectApiName;
    @api iconName;
    @api lookupLabel;
    message;

    // ONCE WE SELECT THE RECORD OF COMBO BOX 
    onRecordSelection(event) {
        this.selectedRecordId = event.target.dataset.key;
        this.selectedValue = event.target.dataset.name;
        this.searchKey = "";
        this.onSeletedRecordUpdate();
    }

    // HANDLE INPUT BOX
    handleKeyChange(event) {
        const searchKey = event.target.value;
        this.searchKey = searchKey;
        this.getLookupResult();
    }

    // REMOVE THE RECORD FROM THE INPUTBOX AT ONCE THROUGH CROSS BUTTON
    removeRecordOnLookup(event) {
        this.searchKey = "";
        this.selectedValue = null;
        this.selectedRecordId = null;
        this.recordsList = null;
        this.onSeletedRecordUpdate();
    }

    // GET LOOKUP RECORD ONCE WE SEARCH
    getLookupResult() {
        findRecords({ searchKey: this.searchKey, objectName: this.objectApiName })
            .then((result) => {
                if (result.length === 0) {
                    this.recordsList = [];
                    this.message = "No Records Found";
                } else {
                    this.recordsList = result;
                    this.message = "";
                }
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.recordsList = undefined;
            });
    }

    // RETURN DATA 
    onSeletedRecordUpdate() {
        const passEventr = new CustomEvent('recordselection', {
            detail: { selectedRecordId: this.selectedRecordId, selectedValue: this.selectedValue }
        });
        this.dispatchEvent(passEventr);
    }
}  
