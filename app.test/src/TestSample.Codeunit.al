codeunit 50100 "Test Sample"
{
    // [FEATURE] [Unit test] [Ref. helper library]
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Assert";
        LibAssert: Codeunit "Library Assert";
        Lib: Codeunit "Library - Sample";
        RefHelper: Codeunit "Ref. Helper";
        JobsSetup: Record "Jobs Setup";

    [Test]
    procedure "Test GetFieldValueByRecordId Success"()
    begin
        // [Scenario] RefHelper TestSystemId function unit test
        // [Given] Jobs Setup
        Lib.InitJobsSetup(JobsSetup);
        // [When] Existing jobs setup is loaded
        RefHelper.TestSystemId(Database::"Jobs Setup", JobsSetup.SystemId);
        // [Then] no error
    end;

    [Test]
    procedure "Test GetFieldValueByRecordId Expected Failure"()
    begin
        // [Scenario] RefHelper TestSystemId function unit test
        // [Given] Jobs Setup intiated
        Lib.InitJobsSetup(JobsSetup);
        // [When] Non-Existing record is loaded
        asserterror RefHelper.TestSystemId(Database::Customer, JobsSetup.SystemId);
        // [Then] no error
        LibAssert.ExpectedError(
            StrSubstNo('Record %1 not found in table %2. Component: %3. Function: %4',
                Format(JobsSetup.SystemId),
                'Customer',
                'Ref Helper',
                'TestGetRecordRefBySystemId')
            );
    end;

    [Test]
    procedure "Test GetFieldValueByRecordId Just Failure"()
    begin
        // [Scenario] RefHelper TestSystemId function unit test
        // [Given] Jobs Setup intiated
        Lib.InitJobsSetup(JobsSetup);
        // [When] Non-Existing record is loaded raise Error
        asserterror RefHelper.TestSystemId(Database::Customer, JobsSetup.SystemId);
        // [Then] error
        /*
        TODO: test 1
        LibAssert.ExpectedError(
            StrSubstNo('x Record %1 not found in table %2. Component: %3. Function: %4',
                Format(JobsSetup.SystemId),
                'Customer',
                'Ref Helper',
                'TestGetRecordRefBySystemId')
            );
        */
    end;
}