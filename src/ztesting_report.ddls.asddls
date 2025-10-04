
@EndUserText.label: 'RESPONCE CDS'
//@EndUserText.label: 'Root'
@Metadata.allowExtensions: true
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZREPORT_TEST'
    }
}

define root custom entity ZTESTING_REPORT 

{

      @UI.lineItem   : [{ position: 10 }]
      @UI.selectionField : [{position: 10}]
      @UI.identification: [{position: 10}]
      @EndUserText.label: 'Plant' 
 key  DOCUMENT          : abap.char( 4 );
        @UI.lineItem   : [{ position: 130 }]
      @UI.selectionField : [{position: 130}]
      @UI.identification: [{position: 130}]

key FiscalYear          : abap.char( 4 );  
   @UI.lineItem   : [{ position: 20 }]
      @UI.selectionField : [{position: 20}]
      @UI.identification: [{position: 20}]
      @EndUserText.label: 'Material'          
 key  CompanyCode       :abap.char( 4 ) ;  
      @UI.lineItem   : [{ position: 30 }]
      @UI.selectionField : [{position: 30}]
      @UI.identification: [{position: 30}]
       @EndUserText.label: 'Unit'          
 key  zunit          : abap.unit( 3 ) ;  
      @UI.lineItem   : [{ position: 40 }]
      @UI.selectionField : [{position: 40}]
      @UI.identification: [{position: 40}]
       @EndUserText.label: 'Std Prod/HR'        
       
 key  FiDocumentItem    : abap.numc( 6 );  
      @UI.lineItem   : [{ position: 50 }]
      @UI.selectionField : [{position: 50}]
      @UI.identification: [{position: 50}]
      @EndUserText.label: 'Work Center'
      
 key DocumentDate : abap.dats ;
       @UI.lineItem   : [{ position: 60 }]
      @UI.selectionField : [{position: 60}]
      @UI.identification: [{position: 60}]
      @EndUserText.label: 'Start Time'
      
 key TransactionCurrency : abap.char( 10 ) ;
 
      @UI.lineItem   : [{ position: 70 }]
      @UI.selectionField : [{position: 70}]
      @UI.identification: [{position: 70}]
      @EndUserText.label: 'End Time'
      
 key Mironumber : abap.tims ;
      @UI.lineItem   : [{ position: 80 }]
      @UI.selectionField : [{position: 80}]
      @UI.identification: [{position: 80}]
      @EndUserText.label: 'Unit'
      
 key MiroYear : abap.char( 10 ) ;
      @UI.lineItem   : [{ position: 90 }]
      @UI.selectionField : [{position: 90}]
      @UI.identification: [{position: 90}]
      @Semantics.quantity.unitOfMeasure : 'zunit'
//      @EndUserText.quickInfo: 'Actual Production'
      @EndUserText.label: 'Actual Production'
      
 key Refrence_No : abap.quan(8,3) ;
    @UI.lineItem   : [{ position: 100 }]
      @UI.selectionField : [{position: 100}]
      @UI.identification: [{position: 100}]
      @EndUserText.label: 'Running Hrs'
 
 key AccountingDocumentType : abap.timn ;

     @UI.lineItem   : [{ position: 100 }]
      @UI.selectionField : [{position: 100}]
      @UI.identification: [{position: 100}]
      @EndUserText.label: 'Unit Hrs'
 
 key PostingDate : abap.char (10) ; 
      @UI.lineItem   : [{ position: 100 }]
      @UI.selectionField : [{position: 100}]
      @UI.identification: [{position: 100}]
      @EndUserText.label: 'Running Hrs'
      @Semantics.quantity.unitOfMeasure : 'Zunit' 
      
 key HsnCode : abap.quan(5,2) ;

      @UI.lineItem   : [{ position: 110 }]
      @UI.selectionField : [{position: 110}]
      @UI.identification: [{position: 110}]
      @Semantics.quantity.unitOfMeasure : 'zunit' 
      @EndUserText.label: 'Targrt Production'
 key AssignmentReference : abap.quan(8,0) ;
 
 
       @UI.lineItem   : [{ position: 120 }]
      @UI.selectionField : [{position: 120}]
      @UI.identification: [{position: 120}]
      @EndUserText.label: 'Work Center'
key InvoceValue : abap.char( 10 ) ;
       @UI.lineItem   : [{ position: 130 }]
      @UI.selectionField : [{position: 130}]
      @UI.identification: [{position: 130}]
      @EndUserText.label: 'BraekDown Reason'
key TaxableValue : abap.char( 10 );      

       @UI.lineItem   : [{ position: 140 }]
      @UI.selectionField : [{position: 140}]
      @UI.identification: [{position: 140}]
      @Semantics.quantity.unitOfMeasure : 'zunit' 
      @EndUserText.label: 'BraekDown Hrs'      
key InvoceValue_actual  : abap.quan(5,2) ;
       @UI.lineItem   : [{ position: 150 }]
      @UI.selectionField : [{position: 150}]
      @UI.identification: [{position: 150}]
      @EndUserText.label: 'Plant Available Hrs'
       
key Gross_amount : abap.numc(10) ;
       @UI.lineItem   : [{ position: 160 }]
      @UI.selectionField : [{position: 160}]
      @UI.identification: [{position: 160}]
      @EndUserText.label: 'Plant Run Time Effi%'
       
key TaxCode : abap.numc(10) ;

       @UI.lineItem   : [{ position: 170 }]
      @UI.selectionField : [{position: 170}]
      @UI.identification: [{position: 170}]
      @EndUserText.label: 'WBS Element  '
       
key WBSelement  : abap.numc(8) ;
      }
