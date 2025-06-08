public with sharing class  getFieldSetAndObjectApiNames {
   
   @AuraEnabled(cacheable=true)
    public  static DataResponse getfieldSetsData(String obj,string fieldsetname,Id parentrecordId,string relationshipField){
         obj = 'Contact';
         fieldsetname='community_fieldset';
        string finalfieldstring='Id';
        string queryString;
       String[] types = new String[]{obj};
        list<Datatablecoloms> datacolumns = new list<Datatablecoloms>();
          if(string.isBlank(obj)){
              throw new AuraHandledException('Invalid or missing parameter');
          }
      list<Schema.FieldSetMember> fsmbr = new list<Schema.FieldSetMember>();
      List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res:results){
           Map<String, Schema.FieldSet> fieldSets = res.fieldSets.getMap();
            if(res.fields.getMap().get(relationshipField)==null){
               continue; 
            }
            Schema.FieldSet getfldsetwithname= fieldSets.get(fieldsetname);
            fsmbr=getfldsetwithname.getFields();  
        }
        if(!fsmbr.isempty()&& fsmbr!=null){
        for(Schema.FieldSetMember fsm:fsmbr){
            if(fsm.getSObjectField().getDescribe().isAccessible()){
            finalfieldstring= finalfieldstring+','+ fsm.getFieldPath(); 
            Datatablecoloms  dtc= new Datatablecoloms(fsm.getLabel(),fsm.getFieldPath(),String.valueOf(fsm.getType()));
             datacolumns.add(dtc);
        }      
            queryString = 'SELECT '+finalfieldstring+' from '+obj+' where '+relationshipField+'='+'\''+parentrecordId+'\''+' order by Createddate desc limit 10';       
        }
    
        list<sObject> returnlist= Database.query(queryString);
         system.debug(Database.query(queryString));
         DataResponse Datares= new DataResponse();
         Datares.lstdata =returnlist;
         Datares.lstcoloms=datacolumns;
         system.debug(Datares.lstcoloms);
         return Datares;
    }else {
        return null;
    }
    }
    public class Datatablecoloms{
        @AuraEnabled
           public string label {get;set;}
        @AuraEnabled
        public string fieldName {get;set;}
        @AuraEnabled
        public string type {get;set;}
        public Datatablecoloms(String label,String fieldName,String type){
             this.label=label;
             this.fieldName=fieldName;
             this.type=type.toLowerCase();
        }
    }
    public class DataResponse{
             @AuraEnabled
             public list<Datatablecoloms> lstcoloms {get;set;}
             @AuraEnabled
             public list<sObject> lstdata {get;set;}
    }
}
