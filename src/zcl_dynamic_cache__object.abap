CLASS zcl_dynamic_cache__object DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE

  GLOBAL FRIENDS zcl_dynamic_cache .

  PUBLIC SECTION.

    INTERFACES zif_cache .

    TYPES:
      BEGIN OF cache_entry,
        key   TYPE string,
        value TYPE REF TO object,
      END OF cache_entry .
      
  PROTECTED SECTION.
  
  PRIVATE SECTION.

    CLASS-DATA self TYPE REF TO zcl_dynamic_cache__object .
    DATA cache TYPE HASHED TABLE OF cache_entry WITH UNIQUE KEY key .

    CLASS-METHODS get_instance
      RETURNING
        VALUE(value) TYPE REF TO zif_cache .
    
ENDCLASS.

CLASS zcl_dynamic_cache__object IMPLEMENTATION.

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
      value ?= cache_entry->*-value.
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

    IF typedescr->type_kind NE cl_abap_typedescr=>typekind_oref.
      RAISE EXCEPTION TYPE cx_parameter_invalid_type.
    ENDIF.

    IF value IS NOT BOUND.
      RETURN.
    ENDIF.

    INSERT VALUE cache_entry( key = key value = value ) INTO TABLE cache.

  ENDMETHOD.

ENDCLASS.
