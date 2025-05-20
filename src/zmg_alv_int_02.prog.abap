*&---------------------------------------------------------------------*
*& Report ZMG_SCREEN_02
*&---------------------------------------------------------------------*
*&"zmg_screen_02
*&---------------------------------------------------------------------*
REPORT zmg_alv_int_02. "zmg_screen_02
TABLES: vbrk.
DATA: gs_vbrk TYPE vbrk.

PARAMETERS: p_vbeln TYPE vbrk-vbeln,  "vbeln_vf,
            p_fkart TYPE vbrk-fkart,  "fkart,
            p_fktyp TYPE vbrk-fktyp.  "fktyp.

START-OF-SELECTION.

  SELECT SINGLE * FROM vbrk INTO gs_vbrk
    WHERE vbeln EQ p_vbeln
      AND fkart EQ p_fkart
      AND fktyp EQ p_fktyp.

  CALL SCREEN 0100.

MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR 'TITTLE_0100'.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.

MODULE status_0101 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.

MODULE user_command_0101 INPUT.

ENDMODULE.

MODULE status_0102 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.

MODULE user_command_0102 INPUT.

ENDMODULE.
