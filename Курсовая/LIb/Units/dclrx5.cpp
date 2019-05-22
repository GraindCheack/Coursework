//---------------------------------------------------------------------------
// Delphi VCL Extensions (RX)
// Copyright (c) 1999 Master-Bank
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vclx50.bpi");
USEPACKAGE("dclstd50.bpi");
USEPACKAGE("rxctl5.bpi");
USEUNIT("RxLConst.pas");
USEUNIT("HintProp.pas");
USEUNIT("CheckItm.pas");
USEUNIT("StrLEdit.pas");
USEUNIT("RxColors.pas");
USEUNIT("RxDsgn.pas");
USEUNIT("PresrDsn.pas");
USEUNIT("MinMaxEd.pas");
USEUNIT("SbEdit.pas");
USEUNIT("PgMngrEd.pas");
USEUNIT("TimLstEd.pas");
USEUNIT("IcoLEdit.pas");
USEUNIT("RxResExp.pas");
USEUNIT("PictEdit.pas");
USEUNIT("RxDirFrm.pas");
USEUNIT("GradEdit.pas");
USEUNIT("RxCtlReg.pas");
USEUNIT("RxTooReg.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------
