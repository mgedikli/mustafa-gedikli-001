*&---------------------------------------------------------------------*
*& Report ZMG_ALV_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmg_alv_03.
"FUNCTION 'LVC_FIELDCATALOG_MERGE'  i_internal_tabname  = 'GT_TABLE'

DATA: gt_data  TYPE TABLE OF sflight,   " ALV'de gösterilecek veri
      gt_fcat  TYPE lvc_t_fcat,         " ALV alan kataloğu
      lo_alv   TYPE REF TO cl_gui_alv_grid,  " ALV nesnesi
      lo_cont  TYPE REF TO cl_gui_custom_container. " Konteyner nesnesi

START-OF-SELECTION.

  CALL SCREEN 0100.
* --- 📌 Veri Seçimi
SELECT * FROM sflight INTO TABLE gt_data UP TO 10 ROWS.

* --- 📌 Field Catalog oluşturma (I_INTERNAL_TABNAME kullanarak)
CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
  EXPORTING
    i_internal_tabname = 'GT_DATA'  " İç tablo adı string olarak verilmeli!
  CHANGING
    ct_fieldcat        = gt_fcat.

* --- 📌 Konteyner oluşturma (Eğer Dynpro 100 kullanılacaksa)
CREATE OBJECT lo_cont
  EXPORTING
    container_name = 'CON_ALV'.  " SE51'de Custom Control eklenmeli!

* --- 📌 ALV Grid oluşturma
CREATE OBJECT lo_alv
  EXPORTING
    i_parent = lo_cont.

* --- 📌 ALV'yi göster
CALL METHOD lo_alv->set_table_for_first_display
  EXPORTING
    i_structure_name = 'SFLIGHT'  " Alternatif olarak iç tablo adı da verilebilir
  CHANGING
    it_outtab       = gt_data
    it_fieldcatalog = gt_fcat.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR 'TITLE_0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
CASE sy-ucomm.
  WHEN 'BACK'.
    LEAVE PROGRAM.
ENDCASE.
ENDMODULE.
