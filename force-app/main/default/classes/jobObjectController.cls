/**
 * @description       : this class creates a job record in the database
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 04-29-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class jobObjectController {
  @AuraEnabled
  public static void postJob(
    string value,
    string jobTitle,
    string description,
    Decimal salaryRange,
    string companyName,
    string city,
    string country,
    string experienceValue,
    string typeValue,
    string industryValue,
    string summary,
    string skills,
    string timing,
    date publishStartDate,
    date publishEndDate
  ) {
    system.debug('start');
    system.debug('jobTitle' + jobTitle);

    try {
      list<job__c> jobRecordsList = new List<job__c>();
      job__c newJob = new job__c();

      newJob.Title_of_position__c = jobTitle;
      newJob.Description__c = description;
      newJob.Summary__c = summary;
      newJob.Salary__c = salaryRange;
      newJob.Industry__c = industryValue;
      newJob.Experience__c = experienceValue;
      newJob.Country__c = country;
      newJob.Company_Name__c = companyName;
      newJob.Type__c = typeValue;
      newJob.City__c = city;
      newJob.Status__c = value;
      newJob.Skills_Required__c = skills;
      newJob.Test_Timing__c = timing;
      newJob.Publish_start_date__c = publishStartDate;
      newJob.Publish_end_date__c = publishEndDate;

      jobRecordsList.add(newJob);

      if (!jobRecordsList.isEmpty()) {
        insert jobRecordsList;
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage() + e.getLineNumber());
    }
  }

  @AuraEnabled(cacheable=true)
  public static list<job__c> getDraftJobList(id userId) {
    user u = [SELECT companyName FROM user WHERE id = :userId LIMIT 1];
    string companyname = u.CompanyName;
    system.debug('companyname---->'+companyname);
    list<job__c> draftJobList = new List<job__c>();



    for (job__c job : [
      SELECT
        Title_of_position__c,
        Description__c,
        Summary__c,
        Salary__c,
        Industry__c,
        Experience__c,
        Country__c,
        Company_Name__c,
        Type__c,
        City__c,
        Status__c,
        Id
      FROM Job__c
      WHERE Status__c = 'Draft' AND Company_Name__c = :companyname
      LIMIT 4
    ]) {
      draftJobList.add(job);
    }
    System.debug('draftJobList-------->' + draftJobList);
    return draftJobList;
  }

  @AuraEnabled(cacheable=true)
  public static list<job__c> getPostedJobListBasedOnId(id jobId) {
    list<job__c> jobDetails = new List<job__c>();

    try {
      jobDetails = [
        SELECT
          City__c,
          Company_Name__c,
          Country__c,
          CreatedById,
          Description__c,
          Experience__c,
          External_Application_Link__c,
          Industry__c,
          Name,
          LastModifiedById,
          Location__c,
          OwnerId,
          Publish_end_date__c,
          Publish_start_date__c,
          Salary__c,
          Status__c,
          Summary__c,
          Title_of_position__c,
          Skills_Required__c,
          Type__c,
          Id
        FROM Job__c
        WHERE id = :jobId
        LIMIT 1
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage() + e.getLineNumber());
    }

    system.debug('jobDetails------->' + jobDetails);
    return jobDetails;
  }

  @AuraEnabled(cacheable=true)
  public static string getTestTimings(Id jobId) {
    try {
      return [SELECT Test_Timing__c FROM Job__c WHERE id = :jobId LIMIT 1][0]
      .Test_Timing__c;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static string getCompanyName(id userId) {
    try {
      user u = [SELECT companyName, id FROM user WHERE id = :userId];
      string companyName = u.CompanyName;
      return companyName;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static void deleteJob(id jobId) {
    try {
      Job__c job = [SELECT id FROM Job__c WHERE id = :jobId LIMIT 1];
      if (job != null) {
        delete job;
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
