@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Description'
define root view entity zSupp_description as select from I_Supplier as a

{ key a.Supplier,
      a.SupplierName,
      a.SupplierFullName
    
}
