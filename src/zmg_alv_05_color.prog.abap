*&---------------------------------------------------------------------*
*& Report ZMG_ALV_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMG_ALV_05_COLOR.
"REUSE_ALV_GRID_DISPLAY/I_CALLBACK_HTML_TOP_OF_PAGE yapisi

INCLUDE ZMG_ALV_05_TOP4.
*INCLUDE ZMG_ALV_05_TOP3.
INCLUDE ZMG_ALV_05_FORM4.
*INCLUDE ZMG_ALV_05_FORM3.
START-OF-SELECTION.

  PERFORM select_data.
  PERFORM fcat.
  PERFORM layout.
  PERFORM show_alv.
