unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids;

type
  TAnalizator = class(TForm)
    Load_: TButton;
    StartWork_: TButton;
    Exit_: TButton;
    TableSpen_: TStringGrid;
    ProgramText_: TRichEdit;
    DlgOpen_: TOpenDialog;
    ResultText_: TRichEdit;
    TableChapinFull_: TStringGrid;
    TableChapinIO_: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Exit_Click(Sender: TObject);
    procedure Load_Click(Sender: TObject);
    procedure StartWork_Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Analizator: TAnalizator;

implementation

{$R *.dfm}

const
  N_MAX = 1000;
  COUNT_COLS_CHAP = 5;
  COUNT_ROWS_CHAP = 101;
  COUNT_COLS_SPEN = 2;
  COUNT_ROWS_SPEN = 101;

type
  TArray = array [1..N_MAX] of string;

  TOperand = record
    Oper : string[100];
    Spen : integer;
    IsInput : boolean;
    IsOutput : boolean;
    IsManage : boolean;
    IsModified : boolean;
  end;
  
  TOperandArr = array [1..N_MAX] of TOperand;
  
procedure TAnalizator.FormCreate(Sender: TObject);
begin
  TableSpen_.Cells[0, 0] := 'Идентификатор';
  TableSpen_.Cells[1, 0] := 'Спен';

  TableChapinFull_.Cells[0, 0] := 'Группа';
  TableChapinFull_.Cells[1, 0] := 'P';
  TableChapinFull_.Cells[2, 0] := 'M';
  TableChapinFull_.Cells[3, 0] := 'C';
  TableChapinFull_.Cells[4, 0] := 'T';

  TableChapinIO_.Cells[0, 0] := 'Группа';
  TableChapinIO_.Cells[1, 0] := 'P';
  TableChapinIO_.Cells[2, 0] := 'M';
  TableChapinIO_.Cells[3, 0] := 'C';
  TableChapinIO_.Cells[4, 0] := 'T';
end;

procedure TAnalizator.Load_Click(Sender: TObject);
begin
  if DlgOpen_.Execute(Handle) then
    begin
      ProgramText_.Lines.LoadFromFile(DlgOpen_.FileName);

      Analizator.ResultText_.Lines[1] := '';
      Analizator.ResultText_.Lines[3] := '';
      Analizator.ResultText_.Lines[5] := '';
    end
  else
    exit;
end;

function CheckOperand(var OperandsArray : TOperandArr; var OperandStr : string; NumOperands : integer) : integer;
var
  i : integer;
  
begin
  for i := 1 to NumOperands do
    begin
      if OperandsArray[i].Oper = OperandStr then
        begin
          Result := i;
          exit;
        end;
    end;

  Result := -1;
end;

procedure CalculateMetrics(var OperatorsArray : TArray; var OperandsArray : TOperandArr;
                        var NumOperands : integer);
var
  i, j, k, FoundOperand : integer;
  buf, CurrOperandStr : string;
  IsOperator, IsDef, IsKav : boolean;
  LastOperand : integer;
  fCondition : boolean;
  fInput : boolean;
  fOutput : boolean;
  
begin
  for i := 0 to Analizator.ProgramText_.Lines.Count - 1 do
    begin
      buf := ' ' + Analizator.ProgramText_.Lines[i] + ' ';

      j := 2;
      LastOperand := -1;
      fCondition := false;
      fInput := false;
      fOutput := false;
      IsDef := false;
      IsKav := false;
      while j <= Length(buf) - 1 do
        begin 
          if buf[j] = '#' then break;
          if (not IsKav) and ((buf[j] = '''') or (buf[j] = '"')) then
            begin
              IsKav := true;
              inc(j);
              continue;
            end;

          if (IsKav) and ((buf[j] = '''') or (buf[j] = '"')) then
            begin
              IsKav := false;
              inc(j);
              continue;
            end;

          if (IsKav) or (buf[j] = ' ') or (buf[j] in ['0'..'9']) or (buf[j] = '[') or (buf[j] = ']') or
             (buf[j] = '{') or (buf[j] = '}') or (buf[j] = '(') or (buf[j] = ')')
          then
            begin
              inc(j);
              continue;
            end;

          IsOperator := false;
          for k := 1 to 19 do
            if OperatorsArray[k] = buf[j] then
              if ((buf[j - 1] = ' ') or (buf[j - 1] = '(') or (buf[j - 1] = '{') or (buf[j - 1] = '[') or (buf[j - 1] in ['0'..'9']) or (buf[j - 1] = '''') or (buf[j - 1] = '"'))
                 and (buf[j + 1] = ' ')
              then
                begin
                  if OperatorsArray[k] = '=' then OperandsArray[LastOperand].IsModified := true;

                  IsOperator := true;
                  inc(j);
                  break;
                end;
          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if j <= Length(buf) - 2 then
          begin
            for k := 20 to 39 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] then
                if ((buf[j - 1] = ' ') and (buf[j + 2] = ' ') or (buf[j - 1] = '.')) then
                  begin
                    if (OperatorsArray[k] = '+=') or (OperatorsArray[k] = '-=') or
                       (OperatorsArray[k] = '*=') or (OperatorsArray[k] = '/=') or
                       (OperatorsArray[k] = '%=')  then OperandsArray[LastOperand].IsModified := true;
                    if (OperatorsArray[k] = 'if') then fCondition := true;
                  
                    IsOperator := true;
                    inc(j, 2);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if j <= Length(buf) - 3 then
          begin
            for k := 40 to 51 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] then
                if ((buf[j - 1] = ' ') and (buf[j + 3] = ' ') or (buf[j - 1] = '.')) then
                  begin
                    if (OperatorsArray[k] = 'def') then 
                      begin
                        IsDef := true;
                        break;
                      end;
                    if (OperatorsArray[k] = '**=') then OperandsArray[LastOperand].IsModified := true;
                    if (OperatorsArray[k] = 'for') then fCondition := true;
                  
                    IsOperator := true;
                    inc(j, 3);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if IsDef then break;

          if j <= Length(buf) - 4 then
          begin
            for k := 52 to 77 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] then
                if ((buf[j - 1] = ' ') and (buf[j + 4] = ' ') or (buf[j - 1] = '.')) then
                  begin
                    if (OperatorsArray[k] = 'gets') then fInput := true;
                    if (OperatorsArray[k] = 'puts') then fOutput := true;

                    IsOperator := true;
                    inc(j, 4);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if j <= Length(buf) - 5 then
          begin
            for k := 78 to 101 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] then
                if ((buf[j - 1] = ' ') and ((buf[j + 5] = ' ') or (buf[j + 5] = '('))) or (buf[j - 1] = '.') then
                  begin
                    if (OperatorsArray[k] = 'while') or (OperatorsArray[k] = 'until') then fCondition := true;
                    if (OperatorsArray[k] = 'scanf') then fInput := true;

                    IsOperator := true;
                    inc(j, 5);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if j <= Length(buf) - 6 then
          begin
            for k := 102 to 116 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] + buf[j + 5] then
                if ((buf[j - 1] = ' ') and ((buf[j + 6] = ' ') or (buf[j + 6] = '('))) or (buf[j - 1] = '.') then
                  begin
                    if (OperatorsArray[k] = 'printf') then fOutput := true;

                    IsOperator := true;
                    inc(j, 6);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if j <= Length(buf) - 7 then
          begin
            for k := 117 to 122 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] + buf[j + 5]
                                      + buf[j + 6] + buf[j + 7] 
              then
                if ((buf[j - 1] = ' ') and (buf[j + 8] = ' ')) or (buf[j - 1] = '.') then 
                  begin
                    IsOperator := true;
                    inc(j, 7);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if j <= Length(buf) - 8 then
          begin
            for k := 123 to 129 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] + buf[j + 5]
                                      + buf[j + 6] + buf[j + 7] + buf[8]
              then
                if ((buf[j - 1] = ' ') and (buf[j + 9] = ' ')) or (buf[j - 1] = '.') then 
                  begin
                    IsOperator := true;
                    inc(j, 8);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if j <= Length(buf) - 9 then
          begin
            for k := 130 to 134 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] + buf[j + 5]
                                      + buf[j + 6] + buf[j + 7] + buf[8] + buf[9]
              then
                if ((buf[j - 1] = ' ') and (buf[j + 10] = ' ')) or (buf[j - 1] = '.') then 
                  begin
                    IsOperator := true;
                    inc(j, 9);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;
          
          if j <= Length(buf) - 10 then
          begin
            for k := 135 to 135 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] + buf[j + 5]
                                      + buf[j + 6] + buf[j + 7] + buf[8] + buf[9] + buf[10]
              then
                if ((buf[j - 1] = ' ') and (buf[j + 11] = ' ')) or (buf[j - 1] = '.') then 
                  begin
                    IsOperator := true;
                    inc(j, 10);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if j <= Length(buf) - 11 then
          begin
            for k := 136 to 137 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] + buf[j + 5]
                                      + buf[j + 6] + buf[j + 7] + buf[8] + buf[9] + buf[10] + buf[11]
              then
                if ((buf[j - 1] = ' ') and (buf[j + 12] = ' ')) or (buf[j - 1] = '.') then 
                  begin
                    IsOperator := true;
                    inc(j, 11);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if j <= Length(buf) - 12 then
          begin
            for k := 138 to 138 do
              if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] + buf[j + 5]
                                      + buf[j + 6] + buf[j + 7] + buf[8] + buf[9] + buf[10] + buf[11]
                                      + buf[j + 12]
              then
                if ((buf[j - 1] = ' ') and (buf[j + 13] = ' ')) or (buf[j - 1] = '.') then 
                  begin
                    IsOperator := true;
                    inc(j, 12);
                    break;
                  end;
          end;

          if IsOperator then 
            begin
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              continue;
            end;

          if not IsOperator then
            begin
              k := j;
              CurrOperandStr := '';
              while (buf[k] <> ' ') and (buf[k] <> '.') and (buf[k] <> '(') and (buf[k] <> ')') and 
                    (buf[k] <> '[') and (buf[k] <> ']') and (buf[k] <> '{') and (buf[k] <> '}')
              do
                begin
                  CurrOperandStr := CurrOperandStr + buf[k];
                  inc(k);
                end;
              inc(j, Length(CurrOperandStr));
              if (buf[j] = ' ') or (buf[j] = '.') then inc(j);
              
              if (CurrOperandStr = 'true') or (CurrOperandStr = 'false') or
                 (CurrOperandStr = 'end') or (CurrOperandStr = '') then continue;

              FoundOperand := CheckOperand(OperandsArray, CurrOperandStr, NumOperands);  
              if FoundOperand <> -1 then
                begin
                  inc(OperandsArray[FoundOperand].Spen);
                  OperandsArray[FoundOperand].IsInput := OperandsArray[FoundOperand].IsInput or fInput;
                  OperandsArray[FoundOperand].IsOutput := OperandsArray[FoundOperand].IsOutput or fOutput;
                  OperandsArray[FoundOperand].IsManage := OperandsArray[FoundOperand].IsManage or fCondition;
                  fInput := false;
                  fOutput := false;
                  LastOperand := FoundOperand;
                end
              else
                begin
                  inc(NumOperands);
                  OperandsArray[NumOperands].Oper := CurrOperandStr;
                  OperandsArray[NumOperands].IsInput := OperandsArray[NumOperands].IsInput or fInput;
                  OperandsArray[NumOperands].IsOutput := OperandsArray[NumOperands].IsOutput or fOutput;
                  OperandsArray[NumOperands].IsManage := OperandsArray[NumOperands].IsManage or fCondition;
                  fInput := false;
                  fOutput := false;

                  LastOperand := NumOperands;
                end;
            end;
 
        end;
    end;  
end;

procedure OutputSpen(var OperandsArray : TOperandArr; NumOperands : integer);
var
  i, ResultSpen : integer;

begin
  ResultSpen := 0;
  for i := 1 to NumOperands do
    begin
      Analizator.TableSpen_.Cells[0, i] := OperandsArray[i].Oper;
      Analizator.TableSpen_.Cells[1, i] := IntToStr(OperandsArray[i].Spen);
      ResultSpen := ResultSpen + OperandsArray[i].Spen;
    end;
  Analizator.ResultText_.Lines[0] := 'Суммарный спен программы: ' + IntToStr(ResultSpen);
end;

procedure OutputChapinFull(var OperandsArray : TOperandArr; NumOperands : integer);
var
  i, MaxCount : integer;
  Count : array [1..4] of integer;

begin
  Analizator.TableChapinFull_.Cells[0, 1] := 'Переменные';

  Count[1] := 0;
  Count[2] := 0;
  Count[3] := 0;
  Count[4] := 0;
  for i := 1 to NumOperands do
    begin
      if (OperandsArray[i].IsInput) and (not OperandsArray[i].IsModified)
         and (not OperandsArray[i].IsManage) then
        begin
          Analizator.TableChapinFull_.Cells[1, Count[1] + 1] := OperandsArray[i].Oper;
          inc(Count[1]);
        end else
      if (((OperandsArray[i].Spen > 0) and (OperandsArray[i].IsModified)) or (OperandsArray[i].IsOutput)) and (not OperandsArray[i].IsManage)
      then
        begin
          Analizator.TableChapinFull_.Cells[2, Count[2] + 1] := OperandsArray[i].Oper;
          inc(Count[2]);
        end else
      if (OperandsArray[i].IsManage) then
      begin
          Analizator.TableChapinFull_.Cells[3, Count[3] + 1] := OperandsArray[i].Oper;
          inc(Count[3]);
      end else
      if (OperandsArray[i].Spen = 0) and (not OperandsArray[i].IsManage)
         and (not OperandsArray[i].IsInput) and (not OperandsArray[i].IsOutput) then
      begin
          Analizator.TableChapinFull_.Cells[4, Count[4] + 1] := OperandsArray[i].Oper;
          inc(Count[4]);
      end
    end;

  MaxCount := Count[1];
  for i := 2 to 4 do
    if MaxCount < Count[i] then MaxCount := Count[i];
  inc(MaxCount);

  Analizator.TableChapinFull_.Cells[0, MaxCount] := 'Количество';

  Analizator.TableChapinFull_.Cells[1, MaxCount] := IntToStr(Count[1]);
  Analizator.TableChapinFull_.Cells[2, MaxCount] := IntToStr(Count[2]);
  Analizator.TableChapinFull_.Cells[3, MaxCount] := IntToStr(Count[3]);
  Analizator.TableChapinFull_.Cells[4, MaxCount] := IntToStr(Count[4]);

  Analizator.ResultText_.Lines[1] := 'Полная метрика Чепина: ' + FloatToStrF(1 * Count[1] + 2 * Count[2] + 3 * Count[3] + 0.5 * Count[4], ffNumber, 4, 2);
end;

procedure OutputChapinIO(var OperandsArray : TOperandArr; NumOperands : integer);
var
  i, MaxCount : integer;
  Count : array [1..4] of integer;

begin
  Analizator.TableChapinIO_.Cells[0, 1] := 'Переменные';

  Count[1] := 0;
  Count[2] := 0;
  Count[3] := 0;
  Count[4] := 0;
  for i := 1 to NumOperands do
    begin
      if (OperandsArray[i].IsInput) and (not OperandsArray[i].IsModified)
         and (not OperandsArray[i].IsManage) then
        begin
          Analizator.TableChapinIO_.Cells[1, Count[1] + 1] := OperandsArray[i].Oper;
          inc(Count[1]);
        end else
      if ((OperandsArray[i].IsOutput) or ((OperandsArray[i].IsInput) and (OperandsArray[i].IsModified))) and (not OperandsArray[i].IsManage)
      then
        begin
          Analizator.TableChapinIO_.Cells[2, Count[2] + 1] := OperandsArray[i].Oper;
          inc(Count[2]);
        end else
      if ((OperandsArray[i].IsOutput) or (OperandsArray[i].IsInput)) and (OperandsArray[i].IsManage) then
      begin
          Analizator.TableChapinIO_.Cells[3, Count[3] + 1] := OperandsArray[i].Oper;
          inc(Count[3]);
      end else
      if ((OperandsArray[i].IsOutput) or (OperandsArray[i].IsInput)) and (OperandsArray[i].Spen = 0) and (not OperandsArray[i].IsManage) then
      begin
          Analizator.TableChapinIO_.Cells[4, Count[4] + 1] := OperandsArray[i].Oper;
          inc(Count[4]);
      end
    end;

  MaxCount := Count[1];
  for i := 2 to 4 do
    if MaxCount < Count[i] then MaxCount := Count[i];
  inc(MaxCount);

  Analizator.TableChapinIO_.Cells[0, MaxCount] := 'Количество';

  Analizator.TableChapinIO_.Cells[1, MaxCount] := IntToStr(Count[1]);
  Analizator.TableChapinIO_.Cells[2, MaxCount] := IntToStr(Count[2]);
  Analizator.TableChapinIO_.Cells[3, MaxCount] := IntToStr(Count[3]);
  Analizator.TableChapinIO_.Cells[4, MaxCount] := IntToStr(Count[4]);

  Analizator.ResultText_.Lines[2] := 'Метрика Чепина ввода/вывода: ' + FloatToStrF(1 * Count[1] + 2 * Count[2] + 3 * Count[3] + 0.5 * Count[4], ffNumber, 4, 2);
end;

procedure Analyze();
var
  F : TextFile;
  i, j, NumOperands : integer;
  OperatorsArray : TArray;
  OperandsArray : TOperandArr;

begin
  Assign(F, 'Dictionary.txt');
  Reset(F);
  i := 1;
  while (not eof(F)) do
    begin
      ReadLn(F, OperatorsArray[i]);
      inc(i);
    end;
  Close(F);

  for i := 0 to COUNT_COLS_CHAP - 1 do
    for j := 1 to COUNT_ROWS_CHAP - 1 do
      begin
        Analizator.TableChapinFull_.Cells[i, j] := '';
        Analizator.TableChapinIO_.Cells[i, j] := '';
      end;

  for i := 0 to COUNT_COLS_SPEN - 1 do
    for j := 1 to COUNT_ROWS_SPEN - 1 do
      begin
        Analizator.TableSpen_.Cells[i, j] := '';
        Analizator.TableSpen_.Cells[i, j] := '';
      end;

  Analizator.ResultText_.Lines[0] := '';
  Analizator.ResultText_.Lines[1] := '';
  Analizator.ResultText_.Lines[2] := '';

  for i := 1 to N_MAX do
    begin
      OperandsArray[i].Oper := '';
      OperandsArray[i].Spen := 0;
      OperandsArray[i].IsInput := false;
      OperandsArray[i].IsOutput := false;
      OperandsArray[i].IsManage := false;
      OperandsArray[i].IsModified := false;
    end;

  NumOperands := 0;
  CalculateMetrics(OperatorsArray, OperandsArray, NumOperands);

  OutputSpen(OperandsArray, NumOperands);
  OutputChapinFull(OperandsArray, NumOperands);
  OutputChapinIO(OperandsArray, NumOperands);
end;

procedure TAnalizator.StartWork_Click(Sender: TObject);
begin
  if Analizator.ProgramText_.Lines.Count <> 0 then
    Analyze
  else
    ShowMessage('Загрузите код...');
end;


procedure TAnalizator.Exit_Click(Sender: TObject);
begin
  Analizator.Close;
end;

end.
