INTERFACE zif_cache
  PUBLIC .

  METHODS write
    IMPORTING
      !key   TYPE clike
      !value TYPE any
    RAISING
      cx_parameter_invalid_type .

  METHODS read
    IMPORTING
      !key   TYPE clike
    EXPORTING
      !value TYPE any
    RAISING
      cx_entry_not_found .

  METHODS delete
    IMPORTING
      !key TYPE clike .

  METHODS clear .

  METHODS size
    RETURNING
      VALUE(value) TYPE i .

ENDINTERFACE.
