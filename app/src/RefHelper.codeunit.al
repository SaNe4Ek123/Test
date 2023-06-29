/// <summary>
/// Codeunit Ref. Helper (ID 50000).
/// </summary>
codeunit 50000 "Ref. Helper"
{
    var
        ComponentName: Label 'Ref Helper', Locked = true;
        PageManagement: Codeunit "Page Management";
        DataTypeMgt: Codeunit "Data Type Management";

    /// <summary>
    /// LookupRecordRefByTableNo.
    /// </summary>
    /// <param name="RecRef">VAR RecordRef.</param>
    /// <param name="SourceTableNo">Integer.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure LookupRecordRefByTableNo(var RecRef: RecordRef; SourceTableNo: Integer): Boolean
    var
        RecVariant: Variant;
    begin
        RecRef.Open(SourceTableNo);
        RecRef.FindSet(false);
        RecVariant := RecRef;
        if Page.RunModal(0, RecVariant) = Action::LookupOK then begin
            RecRef := RecVariant;
            exit(true);
        end;
        exit(false);
    end;
    /// <summary>
    /// OpenCardByRecordId.
    /// </summary>
    /// <param name="RecId">VAR RecordId.</param>
    procedure OpenCardByRecordId(var RecId: RecordId)
    var
        RecRef: RecordRef;
        RecordVariant: Variant;
    begin
        if Format(RecId) = '' then
            exit;
        RecRef := RecId.GetRecord();
        OpenCardByRecordRef(RecRef);
    end;
    /// <summary>
    /// OpenCardByRecordRef.
    /// </summary>
    /// <param name="RecRef">VAR RecordRef.</param>
    procedure OpenCardByRecordRef(var RecRef: RecordRef)
    var
        RecordVariant: Variant;
    begin
        if RecRef.Number = 0 then
            exit;
        RecordVariant := RecRef;
        PageManagement.PageRun(RecordVariant);
    end;
    /// <summary>
    /// GetSystemIdByRecordId.
    /// </summary>
    /// <param name="RecId">RecordId.</param>
    /// <returns>Return value of type Guid.</returns>
    procedure GetSystemIdByRecordId(RecId: RecordId): Guid
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        SystemId: Guid;
    begin
        RecRef.Open(RecId.TableNo);
        RecRef.Get(RecId);
        FldRef := RecRef.Field(RecRef.SystemIdNo);
        SystemId := FldRef.Value;
        exit(SystemId);
    end;
    /// <summary>
    /// GetRecordIdBySource.
    /// </summary>
    /// <param name="TableNo">Integer.</param>
    /// <param name="SystemId">Guid.</param>
    /// <returns>Return value of type RecordId.</returns>
    procedure GetRecordIdBySystemId(TableNo: Integer; SystemId: Guid): RecordId
    var
        RecRef: RecordRef;
    begin
        TestSystemId(TableNo, SystemId);
        RecRef.Open(TableNo);
        RecRef.GetBySystemId(SystemId);
        exit(RecRef.RecordId);
    end;
    /// <summary>
    /// GetFieldValueByRecordId.
    /// </summary>
    /// <param name="SourceRecordId">RecordId.</param>
    /// <param name="SourceFieldNo">Integer.</param>
    /// <returns>Return value of type Variant.</returns>
    procedure GetFieldValueByRecordId(SourceRecordId: RecordId; SourceFieldNo: Integer) FieldValue: Variant
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        RecRef.Open(SourceRecordId.TableNo);
        RecRef.Get(SourceRecordId);
        FldRef := RecRef.Field(SourceFieldNo);
        FieldValue := FldRef.Value;
    end;
    /// <summary>
    /// TestSystemId.
    /// </summary>
    /// <param name="TableNo">Integer.</param>
    /// <param name="SystemId">Guid.</param>
    procedure TestSystemId(TableNo: Integer; SystemId: Guid)
    var
        FunctionName: Label 'TestGetRecordRefBySystemId', Locked = true;
        RecRef: RecordRef;
        ErrorRecordNotFound: Label 'Record %1 not found in table %2. Component: %3. Function: %4';
    begin
        TestRecordRef(TableNo);
        RecRef.Open(TableNo);
        if not RecRef.GetBySystemId(SystemId) then
            Error(ErrorRecordNotFound, SystemId, RecRef.Name, ComponentName, FunctionName);
    end;
    /// <summary>
    /// TestFieldRef.
    /// </summary>
    /// <param name="TableNo">Integer.</param>
    /// <param name="FieldNo">Integer.</param>
    procedure TestFieldRef(TableNo: Integer; FieldNo: Integer)
    var
        FunctionName: Label 'TestFieldRef', Locked = true;
        ErrorFieldNotFound: Label 'Field No. %1 not found in table %2. Component: %3. Function: %4';
        RecRef: RecordRef;
    begin
        RecRef.Open(TableNo);
        if not RecRef.FieldExist(FieldNo) then
            Error(ErrorFieldNotFound, FieldNo, RecRef.Name, ComponentName, FunctionName);
    end;
    /// <summary>
    /// TestOpenRecordRef.
    /// </summary>
    /// <param name="TableNo">Integer.</param>
    procedure TestRecordRef(TableNo: Integer)
    var
        FunctionName: Label 'TestOpenRecordRef', Locked = true;
        ErrorTableNotFound: Label 'Table No. %1 not found. Component: %2. Function: %3';
    begin
        if not TryOpenRecordRef(TableNo) then
            Error(ErrorTableNotFound, TableNo, ComponentName, FunctionName);
    end;

    [TryFunction]
    local procedure TryOpenRecordRef(TableNo: Integer)
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(TableNo);
    end;
    /// <summary>
    /// ValidateTableField.
    /// </summary>
    /// <param name="RecordVariant">VAR Variant.</param>
    /// <param name="FieldName">Text.</param>
    /// <param name="FieldValue">Variant.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ValidateTableField(var RecordVariant: Variant; FieldName: Text; FieldValue: Variant): Boolean
    begin
        if DataTypeMgt.ValidateFieldValue(RecordVariant, FieldName, FieldValue) then
            exit(true);
    end;
    /// <summary>
    /// ModifyRecord.
    /// </summary>
    /// <param name="RecordVariant">VAR Variant.</param>
    /// <param name="RunTrigger">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ModifyRecord(var RecordVariant: Variant; RunTrigger: Boolean): Boolean
    var
        RecRef: RecordRef;
    begin
        if DataTypeMgt.GetRecordRef(RecordVariant, RecRef) then
            RecRef.Modify(RunTrigger);
        exit(true);
    end;

    //TODO: smth
}