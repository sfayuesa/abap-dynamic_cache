CLASS zcl_dynamic_cache DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    INTERFACES zif_cache .

    ALIASES clear  FOR zif_cache~clear .
    ALIASES delete FOR zif_cache~delete .
    ALIASES read   FOR zif_cache~read .
    ALIASES size   FOR zif_cache~size .
    ALIASES write  FOR zif_cache~write .

    CLASS-METHODS get_instance
      RETURNING
        VALUE(value) TYPE REF TO zcl_dynamic_cache .
    
  PROTECTED SECTION.
    
  PRIVATE SECTION.
  
    CLASS-DATA self TYPE REF TO zcl_dynamic_cache .

    METHODS get_cache_object
      IMPORTING
        !value              TYPE any
      RETURNING
        VALUE(cache_object) TYPE REF TO zif_cache .
    
ENDCLASS.

CLASS zcl_dynamic_cache IMPLEMENTATION.

  METHOD get_cache_object.

    cache_object ?= SWITCH #( cl_abap_typedescr=>describe_by_data( value )->type_kind
                      WHEN cl_abap_typedescr=>typekind_oref THEN zcl_dynamic_cache__object=>get_instance( )
                      ELSE zcl_dynamic_cache__data=>get_instance( ) ).

  ENDMETHOD.

  METHOD get_instance.

    IF self IS NOT BOUND.
      self = NEW #( ).
    ENDIF.

    value = self.

  ENDMETHOD.

  METHOD zif_cache~clear.

    zcl_dynamic_cache__data=>get_instance( )->clear( ).
    zcl_dynamic_cache__object=>get_instance( )->clear( ).

  ENDMETHOD.

  METHOD zif_cache~delete.

    " to do

  ENDMETHOD.

  METHOD zif_cache~read.

    get_cache_object( value )->read( EXPORTING key = key IMPORTING value = value ).

  ENDMETHOD.

  METHOD zif_cache~size.

    value += zcl_dynamic_cache__data=>get_instance( )->size( ).
    value += zcl_dynamic_cache__object=>get_instance( )->size( ).

  ENDMETHOD.

  METHOD zif_cache~write.

    get_cache_object( value )->write( key = key value = value ).

  ENDMETHOD.

ENDCLASS.
