@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL Description'
define root view entity zgl_description as select from I_GLAccountTextRawData as a

{ key a.GLAccount,
  a.GLAccountName,
  a.GLAccountLongName
  
    
}
where a.Language = 'E'
