*&---------------------------------------------------------------------*
*& Report ZMG_ALV_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMG_ALV_05_COLUMN1.
"REUSE_ALV_GRID_DISPLAY/I_CALLBACK_HTML_TOP_OF_PAGE yapisi

INCLUDE ZMG_ALV_05_TOP7.
INCLUDE ZMG_ALV_05_FORM7.

DATA: gv_color_flag TYPE c LENGTH 1. "Renk durumu kontrol flag'i

START-OF-SELECTION.

  PERFORM select_data.
  PERFORM fcat.
  PERFORM layout.
  PERFORM show_alv.
