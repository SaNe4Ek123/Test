/// <summary>
/// Codeunit Library - Sample (ID 50101).
/// </summary>
codeunit 50101 "Library - Sample"
{

    var
        GlobalJobsSetup: Record "Jobs Setup";
        LibraryJob: Codeunit "Library - Job";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryRandom: Codeunit "Library - Random";
        LibraryERM: Codeunit "Library - ERM";
        LibraryJournals: Codeunit "Library - Journals";
        LibrarySmallBusiness: Codeunit "Library - Small Business";
        LibrarySales: Codeunit "Library - Sales";
        HasInitForJobSetup: Boolean;
        WrongDocumentTypeErr: Label 'Document type not supported: %1';

    trigger OnRun()
    begin

    end;

    /// <summary>
    /// InitJobSetup.
    /// </summary>
    /// <param name="JobSetup">VAR Record "Jobs Setup".</param>
    procedure InitJobsSetup(var JobSetup: Record "Jobs Setup")
    var
        IsHandled: Boolean;
    begin
        if HasInitForJobSetup then begin
            JobSetup := GlobalJobsSetup;
            exit;
        end;

        OnBeforeInitJobSetup(GlobalJobsSetup, IsHandled);

        if IsHandled then begin
            JobSetup := GlobalJobsSetup;
            HasInitForJobSetup := true;
            OnAfterInitJobSetup(GlobalJobsSetup);
            exit;
        end;

        if GlobalJobsSetup.Get() then begin
            JobSetup := GlobalJobsSetup;
            HasInitForJobSetup := true;
            exit;
        end;

        JobSetup.Init();
        JobSetup.Insert(true);
        LibraryUtility.UpdateSetupNoSeriesCode(DATABASE::"Jobs Setup", JobSetup.FieldNo("Job Nos."));
        LibraryUtility.UpdateSetupNoSeriesCode(DATABASE::"Jobs Setup", JobSetup.FieldNo("Job WIP Nos."));
        LibraryUtility.UpdateSetupNoSeriesCode(DATABASE::"Jobs Setup", JobSetup.FieldNo("Price List Nos."));

        JobSetup."Apply Usage Link by Default" := false;
        JobSetup."Default WIP Method" := '';
        JobSetup."Default Job Posting Group" := LibraryJob.FindJobPostingGroup();
        JobSetup."Default WIP Posting Method" := JobSetup."Default WIP Posting Method"::"Per Job";
        JobSetup."Allow Sched/Contract Lines Def" := true;
        JobSetup."Document No. Is Job No." := false;
        JobSetup."Logo Position on Documents" := JobSetup."Logo Position on Documents"::"No Logo";
        JobSetup."Automatic Update Job Item Cost" := false;
        JobSetup."Default Sales Price List Code" := '';
        JobSetup."Default Purch Price List Code" := '';

        OnAfterInitJobSetup(GlobalJobsSetup);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitJobSetup(var JobsSetup: Record "Jobs Setup"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitJobSetup(var JobsSetup: Record "Jobs Setup")
    begin
    end;
}