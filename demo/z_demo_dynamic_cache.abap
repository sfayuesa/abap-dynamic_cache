REPORT sy-repid.

DATA(dynamic_cache) = zcl_dynamic_cache=>get_instance( ).

"--------------------------------------------------------------------*
" cache->write(data)
"--------------------------------------------------------------------*
TRY.
    DATA(matnr_in) = NEW matnr( '1' ).
    cl_demo_output=>write( |matnr_in: { matnr_in->* }| ).
    dynamic_cache->write( key = 'KEY1' value = matnr_in ).
    matnr_in->* = '2'.
  CATCH cx_root INTO DATA(exception).
    cl_demo_output=>display( exception->get_text( ) ).
ENDTRY.

"--------------------------------------------------------------------*
" cache->read:data
"--------------------------------------------------------------------*
TRY.
    DATA(matnr_out) = NEW matnr( ).
    dynamic_cache->read( EXPORTING key = 'KEY1' IMPORTING value = matnr_out ).
    cl_demo_output=>write( |matnr_out: { matnr_out->* }| ).
  CATCH cx_root INTO exception.
    cl_demo_output=>display( exception->get_text( ) ).
ENDTRY.

"--------------------------------------------------------------------*
" cache->write(object)
"--------------------------------------------------------------------*
TRY.
    SELECT * FROM t100 UP TO 33 ROWS INTO TABLE @DATA(demo_data).
    cl_salv_table=>factory( IMPORTING r_salv_table = DATA(salv_in) CHANGING t_table = demo_data ).
    dynamic_cache->write( key = 'KEY2' value = salv_in ).
  CATCH cx_root INTO exception.
    cl_demo_output=>display( exception->get_text( ) ).
ENDTRY.

"--------------------------------------------------------------------*
" cache->read:object
"--------------------------------------------------------------------*
TRY.
    DATA salv_out TYPE REF TO cl_salv_table.
    dynamic_cache->read( EXPORTING key = 'KEY2' IMPORTING value = salv_out ).
    salv_out->display( ).
  CATCH cx_root INTO exception.
    cl_demo_output=>display( exception->get_text( ) ).
ENDTRY.

"--------------------------------------------------------------------*
" cache->size:value
" cache->clear
"--------------------------------------------------------------------*
cl_demo_output=>write( |size: { dynamic_cache->size( ) }| ).
dynamic_cache->clear( ).
cl_demo_output=>write( |size: { dynamic_cache->size( ) }| ).

"--------------------------------------------------------------------*
cl_demo_output=>display( ).
