//---------------------------------------------------------------------------
// Delphi VCL Extensions (RX)
// Copyright (c) 1999 Master-Bank
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEPACKAGE("vcl50.bpi");
USEPACKAGE("rxctl5.bpi");
USEPACKAGE("vcldb50.bpi");
USEUNIT("RxDBCtrl.pas");
USEUNIT("RxLookup.pas");
USEUNIT("RxLogin.pas");
USEUNIT("RxDConst.pas");
USEUNIT("DBUtils.pas");
USEUNIT("RxDBComb.pas");
USEUNIT("DBRichEd.pas");
USEUNIT("RxMemDS.pas");
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
