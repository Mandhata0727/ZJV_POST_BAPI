CLASS zcl_jv_post_bapi DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA:lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
         wa_je_deep LIKE LINE OF lt_je_deep,
         w2         LIKE LINE OF wa_je_deep-%param-_withholdingtaxitems,
         w3         LIKE LINE OF w2-_currencyamount.

    TYPES : BEGIN OF ty_payl,
              srno                         TYPE i,
*              documentreferenceid          TYPE i_journalentrytp-documentreferenceid,
              documentreferenceid(100)     TYPE c,
               AcountDocumentType       TYPE i_journalentrytp-accountingdocumenttype,
*              accountingdocumenttype       TYPE i_journalentrytp-accountingdocumenttype,
              AcountDocumentHeaderText  TYPE i_journalentrytp-accountingdocumentheadertext,
*              accountingdocumentheadertext TYPE i_journalentrytp-accountingdocumentheadertext,
*              glaccountlineitem(6)         TYPE c,
               GL_AccountLineItem(6)         TYPE c,
              customer                     TYPE i_customer-customer,
              supplier                     TYPE i_supplier-supplier,
              businessplace                TYPE i_operationalacctgdocitem-businessplace,
              currencyrole                 TYPE i_operationalacctgdocitem-amountintransactioncurrency,
              journalentryitemamount       TYPE i_operationalacctgdocitem-amountintransactioncurrency,
              currency(3)                  TYPE c,
              gl_account                    TYPE i_operationalacctgdocitem-GLAccount,
              costcenter                   TYPE i_operationalacctgdocitem-costcenter,
              debitcreditindicator         TYPE i_operationalacctgdocitem-debitcreditcode,
              companycode                  TYPE i_operationalacctgdocitem-companycode,
              postingdate(10)              TYPE c,
              documentdate(10)             TYPE c,
              specialgl(1)                 TYPE c,
              profitcenter                 TYPE i_operationalacctgdocitem-profitcenter,
              taxcode                      LIKE w2-withholdingtaxcode,
              taxtype                      LIKE w2-withholdingtaxtype,
*             tdsamount                    LIKE w3-taxamount,
              TDSAmount                    LIKE w3-taxamount,
              tdsbase                      LIKE w3-taxbaseamount,
              housebank                    TYPE hbkid,
              housebankaccount             TYPE hbkid,
                      WBSelement(15)                  TYPE C,
               DocumentItemText      TYPE i_operationalacctgdocitem-DocumentItemText,
               AssignmentReference  TYPE i_operationalacctgdocitem-AssignmentReference,
            END OF ty_payl.

    CLASS-DATA:
      lv_cid     TYPE abp_behv_cid,
      it_pay     TYPE TABLE OF ty_payl,
      wa_pay     TYPE ty_payl,
      i_responce TYPE TABLE OF string.

*    CLASS-DATA:BEGIN OF w_head,
*               aTableItem LIKE  it_pay ,
*               END OF w_head.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_JV_POST_BAPI IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.



    DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).


    DATA(body)  = request->get_text(  )  .
    xco_cp_json=>data->from_string( body )->write_to( REF #(  it_pay ) ).

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    DATA(it_head) = it_pay[].
    SORT it_head BY srno.
    DELETE ADJACENT DUPLICATES FROM it_head COMPARING srno.
    SORT it_pay BY srno GL_AccountLineItem.

    DATA:doc      TYPE string,
         error    TYPE string,
         responce TYPE string.

    DATA:gl_item        LIKE wa_je_deep-%param-_glitems[],
         ar_item        LIKE wa_je_deep-%param-_aritems[],
         ap_item        LIKE wa_je_deep-%param-_apitems[],
         with_hold_item LIKE wa_je_deep-%param-_withholdingtaxitems[].

    CLEAR:gl_item , ar_item , ap_item , with_hold_item , doc , error , responce.

    LOOP AT it_head INTO DATA(wa_head).

      DATA(posting_dt)  = wa_head-postingdate+0(4)  && wa_head-postingdate+5(2)  && wa_head-postingdate+8(2).
      DATA(document_dt) = wa_head-documentdate+0(4) && wa_head-documentdate+5(2) && wa_head-documentdate+8(2).

      wa_je_deep-%cid   = lv_cid.
      wa_je_deep-%param = VALUE #( companycode                  = wa_head-companycode
                                   documentreferenceid          = wa_head-documentreferenceid
                                   createdbyuser                = 'TESTER'
                                   businesstransactiontype      = 'RFBU'
                                   accountingdocumenttype       = wa_head-AcountDocumentType
                                   documentdate                 = document_dt
                                   postingdate                  = posting_dt
                                   accountingdocumentheadertext = wa_head-AcountDocumentHeaderText
                                    ).

      LOOP AT it_pay INTO wa_pay WHERE srno = wa_head-srno.

        wa_pay-supplier   = |{ wa_pay-supplier   ALPHA = IN }|.
        wa_pay-customer   = |{ wa_pay-customer   ALPHA = IN }|.
        wa_pay-gl_account  = |{ wa_pay-gl_account  ALPHA = IN }|.
        wa_pay-costcenter = |{ wa_pay-costcenter ALPHA = IN }|.

        IF wa_pay-supplier IS NOT INITIAL.

          ap_item =  VALUE #( (
                                glaccountlineitem  = wa_pay-GL_AccountLineItem
                                specialglcode      = wa_pay-specialgl
                                supplier           = wa_pay-supplier
                                housebank          = wa_pay-housebank
                                housebankaccount   = wa_pay-housebankaccount
                                businessplace      = wa_pay-businessplace
                                profitcenter       = wa_pay-profitcenter
                                WBSElement         = wa_pay-wbselement
                                DocumentItemText   = wa_pay-documentitemtext
                                AssignmentReference = wa_pay-assignmentreference
                                _currencyamount    = VALUE #( ( currencyrole           = '00'
                                                                journalentryitemamount = wa_pay-journalentryitemamount
                                                                currency               = wa_pay-currency   ) ) ) ).
          APPEND LINES OF ap_item  TO wa_je_deep-%param-_apitems.

        ELSEIF wa_pay-gl_account IS NOT INITIAL."lineitem

          gl_item =  VALUE #( ( glaccountlineitem  = wa_pay-GL_AccountLineItem
                                glaccount          = wa_pay-gl_account
                                businessplace      = wa_pay-businessplace
                                housebank          = wa_pay-housebank
                                housebankaccount   = wa_pay-housebankaccount
                                costcenter         = wa_pay-costcenter
                                profitcenter       = wa_pay-profitcenter
                                WBSElement         = wa_pay-wbselement
                                DocumentItemText   = wa_pay-documentitemtext
                                AssignmentReference = wa_pay-assignmentreference
                                _currencyamount    = VALUE #( ( currencyrole           = '00'
                                                                journalentryitemamount = wa_pay-journalentryitemamount
                                                                currency               = wa_pay-currency   ) ) ) ).
          APPEND LINES OF gl_item TO wa_je_deep-%param-_glitems.

        ELSEIF wa_pay-customer IS NOT INITIAL
        .
          ar_item =  VALUE #( ( glaccountlineitem  = wa_pay-GL_AccountLineItem
                                specialglcode      = wa_pay-specialgl
                                customer           = wa_pay-customer
                                housebank          = wa_pay-housebank
                                housebankaccount   = wa_pay-housebankaccount
                                businessplace      = wa_pay-businessplace
                                AssignmentReference = wa_pay-assignmentreference
                                DocumentItemText   = wa_pay-documentitemtext
                                _currencyamount    = VALUE #( ( currencyrole           = '00'
                                                                journalentryitemamount = wa_pay-journalentryitemamount
                                                                currency               = wa_pay-currency   ) ) ) ).
          APPEND LINES OF ar_item  TO wa_je_deep-%param-_aritems.


        ENDIF.

        IF wa_pay-supplier IS NOT INITIAL OR wa_pay-customer IS NOT INITIAL.

          IF wa_pay-taxcode IS NOT INITIAL OR wa_pay-tdsamount IS NOT INITIAL.

            with_hold_item =  VALUE #( ( glaccountlineitem         = wa_pay-GL_AccountLineItem
                                         withholdingtaxcode        = wa_pay-taxcode
                                         withholdingtaxtype        = wa_pay-taxtype
                                         _currencyamount           = VALUE #( ( currencyrole  = '00'
                                                                                taxamount     = wa_pay-TDSAmount
                                                                                taxbaseamount = wa_pay-tdsbase

                                                                                currency      = wa_pay-currency   ) ) ) ).

            APPEND LINES OF with_hold_item  TO wa_je_deep-%param-_withholdingtaxitems.

          ENDIF.

        ENDIF.

      ENDLOOP.

      APPEND wa_je_deep TO lt_je_deep.
      CLEAR:wa_je_deep,gl_item,ap_item,ar_item.

      MODIFY ENTITIES OF i_journalentrytp
      ENTITY journalentry
      EXECUTE post FROM lt_je_deep
      FAILED DATA(ls_failed_deep)
      REPORTED DATA(ls_reported_deep)
      MAPPED DATA(ls_mapped_deep).



      IF ls_failed_deep IS NOT INITIAL.
       LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
          IF sy-tabix <> 1.
            IF <ls_reported_deep>-%msg->if_t100_dyn_msg~msgty = 'E'.
             DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_longtext( ).
              CONCATENATE '$$$$ Error :-' lv_result INTO responce .
              APPEND responce TO i_responce.
              CLEAR responce.
           ENDIF.
          ENDIF.
        ENDLOOP.
      ELSE.
        COMMIT ENTITIES BEGIN
        RESPONSE OF i_journalentrytp
        FAILED DATA(lt_commit_failed)
       REPORTED DATA(lt_commit_reported).
        ...
       COMMIT ENTITIES END.
       LOOP AT lt_commit_reported-journalentry INTO DATA(w).
          IF w-%msg->if_t100_dyn_msg~msgty = 'S'.
            responce  = |$$$$ Document :-{ w-%msg->if_t100_dyn_msg~msgv2+0(10) } Generated|.
            APPEND responce TO i_responce.
            CLEAR responce.
          ENDIF.
       ENDLOOP.
     ENDIF.

      CLEAR:wa_je_deep,gl_item,ap_item,ar_item,lt_je_deep,with_hold_item.

    ENDLOOP.



    DATA:json TYPE REF TO if_xco_cp_json_data.
    CLEAR:responce.

    xco_cp_json=>data->from_abap(
      EXPORTING
        ia_abap      = i_responce
      RECEIVING
        ro_json_data = json   ).
    json->to_string(
      RECEIVING
        rv_string =  responce ).

    response->set_text( responce ).
  ENDMETHOD.
ENDCLASS.
