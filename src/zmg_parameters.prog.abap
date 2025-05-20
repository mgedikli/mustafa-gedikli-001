*&---------------------------------------------------------------------*
*& Report ZMG_PARAMETERS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmg_parameters.

TABLES: zmg_pers_table.
DATA: perssad TYPE zmg_perssurname_de.
PARAMETERS: p_num1   TYPE int4,
            p_persad TYPE zmg_persname_de.

SELECT-OPTIONS: s_sad FOR perssad,
                s_gender for ZMG_PERS_TABLE-pers_gender.
