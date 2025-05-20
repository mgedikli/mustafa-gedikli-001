*&---------------------------------------------------------------------*
*& Report ZMG_ALV_POPUP_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMG_ALV_POPUP_01.
DATA: gt_stravelag TYPE TABLE OF stravelag,
      gs_stravelag TYPE stravelag..

START-OF-SELECTION.

  SELECT * FROM stravelag INTO TABLE gt_stravelag.

  LOOP AT  gt_stravelag INTO gs_stravelag.
    INSERT zmg_stravelag FROM gs_stravelag.
  ENDLOOP.
  BREAK-POINT.
