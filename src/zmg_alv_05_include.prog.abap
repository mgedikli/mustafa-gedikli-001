*&---------------------------------------------------------------------*
*& Report ZMG_ALV_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMG_ALV_05_INCLUDE.

"LVC_FIELDCATALOG_MERGE ve REUSE_ALV_GRID_DISPLAY_LVC /  S.197
"4Ocak Dk.2:44 Dinamik ALV, Manuel FCAT hazırlama (bir STR veya DB (Z'li) tablosu yoksa)
"Örn. SFLIGT tabl. bazi kolonlarini iceren ITAB olustur. Bu durumda SFLIGT' FCAT olarak kullanmak mantikli degil!!!
"carrid icin DE kullanmak daha avantajli; ama daha zorunu ögrenmek icin DE kullanmayalim.

INCLUDE ZMG_ALV_05_top.
INCLUDE ZMG_ALV_05_form.

START-OF-SELECTION.

  PERFORM select_data.
  PERFORM fcat.
  PERFORM layout.
  PERFORM show_alv.
