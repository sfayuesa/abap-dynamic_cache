CLASS zcl_dynamic_cache__data DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE

  GLOBAL FRIENDS zcl_dynamic_cache .

  PUBLIC SECTION.

    INTERFACES zif_cache .

    TYPES:
      BEGIN OF cache_entry,
        key   TYPE string,
        value TYPE REF TO data,
      END OF cache_entry .
      
  PROTECTED SECTION.
  
  PRIVATE SECTION.
    CLASS-DATA self TYPE REF TO zcl_dynamic_cache__data .
    DATA cache TYPE HASHED TABLE OF cache_entry WITH UNIQUE KEY key .

    CLASS-METHODS get_instance
      RETURNING
        VALUE(value) TYPE REF TO zif_cache .

ENDCLASS.

CLASS zcl_dynamic_cache__data IMPLEMENTATION.

  METHOD get_instance.

    IF self IS NOT BOUND.
      self = NEW #( ).
    ENDIF.

    value = self.

  ENDMETHOD.

  METHOD zif_cache~clear.

    CLEAR cache.

  ENDMETHOD.

  METHOD zif_cache~delete.

    " to do

  ENDMETHOD.

  METHOD zif_cache~read.

    READ TABLE cache REFERENCE INTO DATA(cache_entry) WITH KEY key = key.
    IF sy-subrc EQ 0.
      ASSIGN cache_entry->*-value->* TO FIELD-SYMBOL(<value>).
      value = <value>.
    ELSE.
      RAISE EXCEPTION TYPE cx_entry_not_found.
    ENDIF.

  ENDMETHOD.

  METHOD zif_cache~size.

    value = lines( cache ).

  ENDMETHOD.

  METHOD zif_cache~write.

    CHECK key IS NOT INITIAL.

    DATA(typedescr) = cl_abap_typedescr=>describe_by_data( value ).
    CHECK typedescr IS BOUND.

    IF typedescr->type_kind EQ cl_abap_typedescr=>typekind_oref.
      RAISE EXCEPTION TYPE cx_parameter_invalid_type.
    ENDIF.

    TRY.
        DATA cache_entry TYPE cache_entry.
        DATA(datadescr) = CAST cl_abap_datadescr( typedescr ).
        CREATE DATA cache_entry-value TYPE HANDLE datadescr.
        cache_entry-key = key.
        cache_entry-value->* = value.
        INSERT cache_entry INTO TABLE cache.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.
  
ENDCLASS.
