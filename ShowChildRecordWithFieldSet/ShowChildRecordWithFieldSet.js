import { LightningElement, api,track } from 'lwc';
import getfieldSetsData from "@salesforce/apex/getFieldSetAndObjectApiNames.getfieldSetsData";

export default class ShowChildRecordWithFieldSet extends LightningElement {
    @api childObject ;
    @api fieldSetName;
    @api recordId;
    @api relationshipField;
   @track data=[];
   @track columns;
   
   
    async connectedCallback() {
     const resdata=await getfieldSetsData({obj:this.childObject,fieldsetname:this.fieldSetName,parentrecordId:this.recordId,relationshipField:this.relationshipField}) 
     this.data=resdata.lstdata;
     console.log(JSON.stringify(this.data));
     this.columns=resdata.lstcoloms;
  }
    async showChildRecords(event){
     
    }
}
