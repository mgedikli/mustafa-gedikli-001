*&---------------------------------------------------------------------*
*& Report ZMG_ALV_200U4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmg_alv_200u4.

DATA: gt_stravelag    TYPE TABLE OF zmg_stravelag,
      gt_selected_row TYPE TABLE OF zmg_stravelag,
      gs_selected_row TYPE zmg_stravelag,
      gs_stravelag    TYPE zmg_stravelag,
      gt_fieldcat     TYPE lvc_t_fcat,
      gt_fieldcat_row TYPE slis_t_fieldcat_alv,
      gs_layout       TYPE lvc_s_layo.

DATA: gv_row     TYPE n LENGTH 3,
      gv_msg     TYPE string,
      gv_counter TYPE n LENGTH 3,
      gv_city    TYPE city.

SELECT-OPTIONS: so_agnum FOR gs_stravelag-agencynum
                         MATCHCODE OBJECT zmg_sh_stravelag.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM fieldcat.
  PERFORM layout.
  PERFORM display_alv.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT *  FROM stravelag
    INTO TABLE gt_stravelag
    WHERE agencynum IN so_agnum .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
FORM fieldcat .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZMG_STRAVELAG'
      i_bypassing_buffer     = 'X'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
    LEAVE PROGRAM.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LAYOUT
*&---------------------------------------------------------------------*
FORM layout .
  gs_layout-cwidth_opt    = 'X'.
  gs_layout-sel_mode      = 'A'.
  gs_layout-zebra         = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM display_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'STATUS_100'
      i_callback_user_command  = 'UCOMM_100'
      is_layout_lvc            = gs_layout
      it_fieldcat_lvc          = gt_fieldcat
    TABLES
      t_outtab                 = gt_stravelag
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

  IF sy-subrc <> 0.
    LEAVE PROGRAM.
  ENDIF.
ENDFORM.

FORM status_100 USING lt_extab TYPE slis_t_extab.
  SET PF-STATUS 'PF_STATUS_STRAVELAG'.
ENDFORM.

FORM ucomm_100 USING lv_ucomm TYPE sy-ucomm
                    ls_selfied TYPE slis_selfield.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.  "Geri Dön / "Zurückgehen
    WHEN 'ROW'.
      DESCRIBE TABLE gt_stravelag LINES gv_row.
      SHIFT gv_row LEFT DELETING LEADING '0'.
      CONCATENATE TEXT-002 gv_row INTO gv_msg SEPARATED BY space.
      MESSAGE gv_msg TYPE 'I'.
    WHEN 'CITY'.
      SORT gt_stravelag BY city.
      LOOP AT gt_stravelag INTO gs_stravelag.
        IF sy-tabix > 1 AND gs_stravelag-city = gv_city.
          CONTINUE.
        ENDIF.
        gv_city = gs_stravelag-city.
        gv_counter = gv_counter + 1.
      ENDLOOP.
      SHIFT gv_counter LEFT DELETING LEADING '0'.
      CONCATENATE TEXT-003 gv_counter INTO gv_msg SEPARATED BY space.
      MESSAGE gv_msg TYPE 'I'.
      CLEAR: gv_counter.
    WHEN 'ROW_POPUP'.
      READ TABLE gt_stravelag INTO gs_stravelag INDEX ls_selfied-tabindex.
      IF sy-subrc IS INITIAL.
        APPEND gs_stravelag TO gt_selected_row.
      ENDIF.

      CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name       = 'ZMG_STRAVELAG'
          i_bypassing_buffer     = 'X'
        CHANGING
          ct_fieldcat            = gt_fieldcat_row
        EXCEPTIONS
          inconsistent_interface = 1
          program_error          = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        LEAVE PROGRAM.
      ENDIF.

      CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
        EXPORTING
          i_title               = 'Selected Rows INFO' " TEXT-004
*         I_ZEBRA               = ' '
          i_screen_start_column = 5
          i_screen_start_line   = 5
          i_screen_end_column   = 160
          i_screen_end_line     = 9
          i_tabname             = 'GT_SELECTED_ROW'
          it_fieldcat           = gt_fieldcat_row
          i_callback_program    = sy-repid
        TABLES
          t_outtab              = gt_selected_row
        EXCEPTIONS
          program_error         = 1
          OTHERS                = 2.

      IF sy-subrc <> 0.
        MESSAGE 'Popup seçim ekranı hatalı.' TYPE 'E'.
        RETURN.
      ENDIF.
**      " 2. Seçilen satırları gösterilecek tabloya ata
**      lt_final_output = lt_selected_rows.
*
*      " 3. Fieldcatalog oluştur (bu tablo için yeniden)
*      CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*        EXPORTING
*          i_structure_name   = 'ZMG_STRAVELAG'
*          i_bypassing_buffer = abap_true
*        CHANGING
*          ct_fieldcat        = gt_fieldcat_row
*        EXCEPTIONS
*          OTHERS             = 1.
*
*      " 4. İkinci popup: Seçilen satırları göster
*      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*        EXPORTING
*          i_callback_program = sy-repid
*          i_structure_name   = 'ZMG_STRAVELAG'
*          is_layout          = gs_layout
*          it_fieldcat        = gt_fieldcat_row
*        TABLES
*          t_outtab           = gt_selected_row
*        EXCEPTIONS
*          program_error      = 1
*          OTHERS             = 2.
      CLEAR: gt_selected_row.
  ENDCASE.
ENDFORM.
