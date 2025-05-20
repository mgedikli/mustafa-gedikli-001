*&---------------------------------------------*
*& Report ZMG_ALV_200U2
*&---------------------------------------------*
*&
*&---------------------------------------------*
REPORT zmg_alv_200u2.

TYPES: BEGIN OF gty_table,
         box.
    INCLUDE STRUCTURE zmg_stravelag_1.
TYPES: END OF gty_table.

DATA: gt_table  TYPE TABLE OF gty_table,
      gs_table  TYPE gty_table,
      gs_layout TYPE  slis_layout_alv,
      gt_fcat   TYPE  slis_t_fieldcat_alv.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: so_agnum FOR gs_table-agencynum
MATCHCODE OBJECT zmg_sh_stravelag.
SELECTION-SCREEN END OF BLOCK a1.

START-OF-SELECTION.

  PERFORM select_data.
  PERFORM fcat.
  PERFORM layout.
  PERFORM show_alv.
*&---------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------*
FORM select_data .
  SELECT * FROM zmg_stravelag_1
    INTO CORRESPONDING FIELDS OF TABLE gt_table
    WHERE agencynum IN so_agnum.
ENDFORM.
*&----------------------------------------------*
*&      Form  FCAT
*&----------------------------------------------*
FORM fcat .
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = 'ZMG_STRAVELAG_1'
      i_bypassing_buffer     = abap_true
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
    LEAVE PROGRAM.
  ENDIF.
ENDFORM.
*&-----------------------------------------------*
*&      Form  LAYOUT
*&-----------------------------------------------*
FORM layout .
  gs_layout-zebra             = 'X'.
  gs_layout-colwidth_optimize = 'x'.
  gs_layout-box_fieldname     = 'BOX'.
ENDFORM.
*&------------------------------------------------*
*&      Form  SHOW_ALV
*&------------------------------------------------*
FORM show_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fcat
    TABLES
      t_outtab           = gt_table
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    LEAVE PROGRAM.
  ENDIF.
ENDFORM.
