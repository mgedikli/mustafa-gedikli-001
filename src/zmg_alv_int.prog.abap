*&-------------------------------------------*
*& Report ZMG_ALV_INT
*&-------------------------------------------*
*&
*&-------------------------------------------*
REPORT zmg_alv_int.
"ALV VBRK, VBRP

TYPE-POOLS: slis.
TABLES: vbrk, vbrp.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: so_vbeln FOR vbrk-vbeln.
SELECTION-SCREEN END OF BLOCK a1.

TYPES: BEGIN OF st_vbrk,
         vbeln TYPE vbrk-vbeln,
         fkart TYPE vbrk-fkart,
         fktyp TYPE vbrk-fktyp,
       END OF st_vbrk.

DATA: it_vbrk TYPE TABLE OF st_vbrk,
      wa_vbrk TYPE st_vbrk.

TYPES: BEGIN OF st_vbrp,
         vbeln TYPE vbrp-vbeln,
         posnr TYPE vbrp-posnr,
         matnr TYPE vbrp-matnr,
         arktx TYPE vbrp-arktx,
         fklmg TYPE vbrp-fklmg,
         vrkme TYPE vbrp-vrkme,
       END OF st_vbrp.

DATA: it_vbrp TYPE TABLE OF st_vbrp,
      wa_vbrp TYPE st_vbrp.

DATA: it_fcat1 TYPE slis_t_fieldcat_alv,
      wa_fcat1 TYPE slis_fieldcat_alv.

DATA: it_fcat2 TYPE slis_t_fieldcat_alv,
      wa_fcat2 TYPE slis_fieldcat_alv.

DATA: wa_layout TYPE slis_layout_alv.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM display_alv.
*&----------------------------------------------*
*&      Form  GET_DATA
*&----------------------------------------------*
FORM get_data .
  SELECT vbeln
         fkart
         fktyp FROM vbrk INTO TABLE it_vbrk
    WHERE vbeln IN so_vbeln.

  SORT it_vbrk BY vbeln.
ENDFORM.
*&--------------------------------------------*
*&      Form  DISPLAY_ALV
*&--------------------------------------------*
FORM display_alv .

  CLEAR: it_fcat1[].
  REFRESH: it_fcat1[].

  "LAYOUT
  wa_layout-colwidth_optimize = 'X'.
  wa_layout-zebra             = 'X'.

  DATA: col TYPE i.

  "FIELDCAT_1 "FCAT_VBRK

*  wa_fcat1-col_pos = col.
*  col = col + 1.
  wa_fcat1-fieldname  = 'VBELN'.
  wa_fcat1-seltext_l  = 'Bill Document Number'.
  wa_fcat1-hotspot    = 'X'.
  APPEND wa_fcat1 TO it_fcat1.
  CLEAR wa_fcat1.

*  wa_fcat1-col_pos = col.
*  col = col + 1.
  wa_fcat1-fieldname  = 'FKART'.
  wa_fcat1-seltext_l  = 'Billing Type'.
  APPEND wa_fcat1 TO it_fcat1.
  CLEAR wa_fcat1.

*  wa_fcat1-col_pos = col.
*  col = col + 1.
  wa_fcat1-fieldname  = 'FKTYP'.
  wa_fcat1-seltext_l  = 'Billing Category'.
  APPEND wa_fcat1 TO it_fcat1.
  CLEAR wa_fcat1.

  "FIELDCAT_1 "FCAT_VBRP

*  wa_fcat2-col_pos = col.
*  col = col + 1.
  wa_fcat2-fieldname  = 'VBELN'.
  wa_fcat2-seltext_l  = 'Bill No'.
  APPEND wa_fcat2 TO it_fcat2.
  CLEAR wa_fcat2.

*  wa_fcat2-col_pos = col.
*  col = col + 1.
  wa_fcat2-fieldname  = 'POSNR'.
  wa_fcat2-seltext_l  = 'Billing Item'.
  APPEND wa_fcat2 TO it_fcat2.
  CLEAR wa_fcat2.

*  wa_fcat2-col_pos = col.
*  col = col + 1.
  wa_fcat2-fieldname  = 'MATNR'.
  wa_fcat2-seltext_l  = 'Material No'.
  APPEND wa_fcat2 TO it_fcat2.
  CLEAR wa_fcat2.

*  wa_fcat2-col_pos = col.
*  col = col + 1.
  wa_fcat2-fieldname  = 'ARKTX'.
  wa_fcat2-seltext_l  = 'Sales Order Item Text'.
  APPEND wa_fcat2 TO it_fcat2.
  CLEAR wa_fcat2.

*  wa_fcat2-col_pos = col.
*  col = col + 1.
  wa_fcat2-fieldname  = 'FKLMG'.
  wa_fcat2-seltext_l  = 'Bill Quantity Unit'.
  APPEND wa_fcat2 TO it_fcat2.
  CLEAR wa_fcat2.

*  wa_fcat2-col_pos = col.
*  col = col + 1.
  wa_fcat2-fieldname  = 'VRKME'.
  wa_fcat2-seltext_l  = 'Sales Unit'.
  APPEND wa_fcat2 TO it_fcat2.
  CLEAR wa_fcat2.

  "Display
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'INTERACT'
      is_layout               = wa_layout
      it_fieldcat             = it_fcat1
    TABLES
      t_outtab                = it_vbrk
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&--------------------------------------------*
*&      Form  INTERACT
*&--------------------------------------------*
FORM interact USING r_ucomm LIKE sy-ucomm
                    rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN '&IC1'.
      READ TABLE it_vbrk INTO wa_vbrk INDEX rs_selfield-tabindex.

      IF it_vbrk IS NOT INITIAL.
        SELECT vbeln
               posnr
               matnr
               arktx
               fklmg
               vrkme FROM vbrp
          INTO CORRESPONDING FIELDS OF TABLE it_vbrp
          WHERE vbeln = rs_selfield-value.
      ENDIF.
  ENDCASE.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fcat2
    TABLES
      t_outtab           = it_vbrp
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
