*&---------------------------------------------------------------------*
*& Report ZMG_ALV_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmg_alv_05_column2.
"REUSE_ALV_GRID_DISPLAY/ Sscrfields buton, kodlama

INCLUDE zmg_alv_05_top8.
INCLUDE zmg_alv_05_form8.

INITIALIZATION. "Ekran gelmeden önce
  "DEFAULT varyant kontrolü yap; varsa parametreye ata
  PERFORM initialize.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_varant.
  "Varyant listesi sun; seçilen varyantı parametreye ata
  PERFORM alv_variant.

START-OF-SELECTION.

  PERFORM select_data.
  PERFORM fcat.
  PERFORM layout.
  PERFORM show_alv.
