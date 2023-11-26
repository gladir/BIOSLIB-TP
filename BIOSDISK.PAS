{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSDISK;

INTERFACE

Function _BiosDisk(Cmd,Drive,Head,Track,Sector,NSects:Integer;Var Buffer):Integer;
Procedure DiskReset;
Function  GetErrorDiskMessage(Error:Byte):String;
Function  ReadTrack(Lecteur,Face,Piste,Start,Nombre:Byte;Var Buffer):Byte;
Function  WriteTrack(Lecteur,Face,Piste,Start,Nombre:Byte;Var Buffer):Byte;

IMPLEMENTATION

Uses DOS;

Function _BiosDisk(Cmd,Drive,Head,Track,Sector,NSects:Integer;Var Buffer):Integer;
Var
 Regs:Registers;
Begin
 Regs.AH:=Cmd;
 Regs.AL:=NSects;
 Regs.CH:=Track;
 Regs.CL:=Sector;
 Regs.DH:=Head;
 Regs.DL:=Drive;
 Regs.ES:=Seg(Buffer);
 Regs.BX:=Ofs(Buffer);
 Intr($13,Regs);
 _BiosDisk:=Regs.AH;
End;

Procedure DiskReset;
{$IFDEF Windows}
 Begin
  WriteLn('Cette operation n''est pas mise en oeuvre.');
  Halt;
 End;
{$ElSE}
 Var
  Regs:Registers;
 Begin
  Regs.AH:=$00;
  Regs.DL:=0;
  Intr($13,Regs);
 End;
{$ENDIF}

Function ReadTrack(Lecteur,Face,Piste,Start,Nombre:Byte;Var Buffer):Byte;
{$IFDEF Windows}
 Begin
  WriteLn('Cette operation n''est pas mise en oeuvre.');
  Halt;
 End;
{$ElSE}
 Var
  Essais:Byte;
  Regs:Registers;
 Begin
  essais:=5;
  Repeat
   WriteLn(Essais);
   Regs.AH:=$02;        { Numero de fonction pour appel interruption }
   Regs.AL:=Nombre;     { Nombre Secteurs par Piste }
   Regs.CH:=Piste;      { Numero de Piste }
   Regs.CL:=Start;      { Commencer par le secteur 1 }
   Regs.DL:=Lecteur;    { Numero de lecteur }
   Regs.DH:=Face;       { Numero de la face }
   Regs.ES:=Seg(Buffer);{ Adresse pour tampon }
   Regs.BX:=Ofs(Buffer);
   Intr($13,Regs);
   If Regs.flags and fcarry=1Then DiskReset;
   Dec(essais);
  Until(Regs.flags and fcarry=0)or(Essais=0);
  ReadTrack:=Regs.AH;
 End;
{$ENDIF}

Function WriteTrack(Lecteur,Face,Piste,Start,Nombre:Byte;Var Buffer):Byte;
{$IFDEF Windows}
 Begin
  WriteLn('Cette operation n''est pas mise en oeuvre.');
  Halt;
 End;
{$ElSE}
 Var
  Essais:Byte;
  Regs:Registers;
 Begin
  essais:=5;
  Repeat
   Regs.AH:=$03;        { Numero de fonction pour appel interruption }
   Regs.AL:=Nombre;     { Nombre Secteurs par Piste }
   Regs.CH:=Piste;      { Numero de Piste }
   Regs.CL:=Start;      { Commencer par le secteur 1 }
   Regs.DL:=Lecteur;    { Numero de lecteur }
   Regs.DH:=Face;       { Numero de la face }
   Regs.ES:=Seg(Buffer);{ Adresse pour tampon }
   Regs.BX:=Ofs(Buffer);
   Intr($13,Regs);
   If Regs.flags and fcarry=1Then DiskReset;
   Dec(essais);
  Until(Regs.flags and fcarry=0)or(Essais=0);
  WriteTrack:=Regs.AH;
 End;
{$ENDIF}

Function  GetErrorDiskMessage(Error:Byte):String;Begin
 GetErrorDiskMessage:='';
 Case Error of
  $01:GetErrorDiskMessage:='Cette valeur indique le num‚ro de la fonction est invalide';
  $02:GetErrorDiskMessage:='Cette valeur indique la marque d''adresse introuvable';
  $03:GetErrorDiskMessage:='Cette valeur indique une tentative d''‚criture sur l''unit‚ de disque prot‚g‚e contre l''‚criture';
  $04:GetErrorDiskMessage:='Cette valeur indique un secteur appel‚ introuvable';
  $05:GetErrorDiskMessage:='Cette valeur indique un ‚chec de r‚initialisation';
  $06:GetErrorDiskMessage:='Cette valeur indique une disquette absente';
  $07:GetErrorDiskMessage:='Cette valeur indique une mauvaise table de paramŠtres';
  $08:GetErrorDiskMessage:='Cette valeur indique un d‚bordement DMA';
  $09:GetErrorDiskMessage:='Cette valeur indique un transfert de donn‚es par-del… la limite de segment';
  $0A:GetErrorDiskMessage:='Cette valeur indique un secteur d‚fectueux';
  $0B:GetErrorDiskMessage:='Cette valeur indique une piste d‚fectueux';
  $0C:GetErrorDiskMessage:='Cette valeur indique un type de m‚dia introuvable';
  $0D:GetErrorDiskMessage:='Cette valeur indique un nombre de secteur invalides';
  $0E:GetErrorDiskMessage:='Cette valeur indique une marque de contr“le d‚tect‚e';
  $0F:GetErrorDiskMessage:='Cette valeur indique un niveau de DMA interdit';
  $10:GetErrorDiskMessage:='Cette valeur indique une erreur de lecture ou d''ECC';
  $11:GetErrorDiskMessage:='Cette valeur indique une erreur CRC corrig‚e';
  $20:GetErrorDiskMessage:='Cette valeur indique une erreur sur le contr“leur de disque';
  $40:GetErrorDiskMessage:='Cette valeur indique une piste introuvable';
  $80:GetErrorDiskMessage:='Cette valeur indique une erreur de d‚passement de d‚lai ou de lecture ne r‚agissant pas';
  $AA:GetErrorDiskMessage:='Cette valeur indique une unit‚ pas prˆte';
  $BB:GetErrorDiskMessage:='Cette valeur indique une erreur ind‚finie';
  $CC:GetErrorDiskMessage:='Cette valeur indique une erreur d''‚criture';
  $E0:GetErrorDiskMessage:='Cette valeur indique une erreur dans le registre d''‚tat';
  $FF:GetErrorDiskMessage:='Cette valeur indique une ‚chec de l''op‚ration demandant l''‚tat';
 End;
End;

END.