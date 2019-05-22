//---------------------------------------------------------------------------
// Delphi VCL Extensions (RX)
// Copyright (c) 1999 Master-Bank
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("vclbde50.bpi");
USEPACKAGE("rxctl5.bpi");
USEPACKAGE("rxdb5.bpi");
USEUNIT("DBQBE.pas");
USEUNIT("DBFilter.pas");
USEUNIT("DBLists.pas");
USEUNIT("DBIndex.pas");
USEUNIT("DBPrgrss.pas");
USEUNIT("DBSecur.pas");
USEUNIT("RxRemLog.pas");
USEUNIT("LoginDlg.pas");
USEUNIT("ChPswDlg.pas");
USEUNIT("BdeUtils.pas");
USEUNIT("RxQuery.pas");
USEUNIT("MemTable.pas");
USEUNIT("DBExcpt.pas");
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
