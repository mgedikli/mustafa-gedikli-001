*&---------------------------------------------------------------------*
*& Report ZMG_ALV_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMG_ALV_05_COLUMN.
"REUSE_ALV_GRID_DISPLAY/I_CALLBACK_HTML_TOP_OF_PAGE yapisi

INCLUDE ZMG_ALV_05_TOP6.
INCLUDE ZMG_ALV_05_FORM6.

START-OF-SELECTION.

  PERFORM select_data.
  PERFORM fcat.
  PERFORM layout.
  PERFORM show_alv.
