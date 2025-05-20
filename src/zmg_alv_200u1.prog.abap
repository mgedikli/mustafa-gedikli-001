*&---------------------------------------------------------------------*
*& Report ZMG_ALV_200U1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmg_alv_200u1.

DATA: gt_stravelag TYPE TABLE OF stravelag,
      gs_stravelag TYPE stravelag.

START-OF-SELECTION.

  SELECT * FROM stravelag INTO TABLE gt_stravelag.

  LOOP AT gt_stravelag INTO gs_stravelag.
    INSERT zmg_stravelag_1 FROM gs_stravelag.
  ENDLOOP.

  cl_demo_output=>display( gt_stravelag ).
