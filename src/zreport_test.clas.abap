CLASS zreport_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZREPORT_TEST IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA:lt_current_output TYPE TABLE OF ztesting_report.
    DATA:wa1 TYPE ztesting_report.
    DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
    DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields)        = io_request->get_requested_elements( ).
    DATA(lt_sort)          = io_request->get_sort_elements( ).

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.

    DATA(lr_material)     =  VALUE #( lt_filter_cond[ name   = 'MATERIAL' ]-range OPTIONAL ).
    DATA(lr_plant)        =  VALUE #( lt_filter_cond[ name   = 'PLANT' ]-range OPTIONAL ).
    DATA(lr_postingdate)  =  VALUE #( lt_filter_cond[ name   = 'POSTINGDATE' ]-range OPTIONAL ).

    SELECT * FROM zfi_n_ygstr2_new
    INTO TABLE @DATA(i_data) UP TO 100 ROWS.

    LOOP AT i_data INTO DATA(wa_tab) .
      MOVE-CORRESPONDING wa_tab TO wa1.
      APPEND wa1 TO lt_current_output .
      CLEAR : wa_tab, wa1.
    ENDLOOP.

    TRY.

*_Paging implementation
*        IF lv_top < 0  .
*          lv_top = lv_top * -1 .
*        ENDIF.
*        DATA(lv_start) = lv_skip + 1.
*        DATA(lv_end)   = lv_top + lv_skip.
*        APPEND LINES OF lt_response FROM lv_start TO lv_end TO lt_current_output.
*
        io_response->set_total_number_of_records( lines( lt_current_output ) ).
        io_response->set_data( lt_current_output ).
      CATCH cx_root INTO DATA(lv_exception).
        DATA(lv_exception_message) = cl_message_helper=>get_latest_t100_exception( lv_exception )->if_message~get_longtext( ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
