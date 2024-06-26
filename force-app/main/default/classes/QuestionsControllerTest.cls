/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class QuestionsControllerTest {
  @isTest
  static void TestQuestionTypeValue() {
    list<string> result = QuestionsController.questionTypeValue();
    System.assertEquals(2, result.size());
  }

  @isTest
  static void TestFetchQuestions() {
    Job__c job = TestDataFactory.createJob();
    List<Question__c> question = TestDataFactory.createSubjectiveQuestion(
      job.id
    );
    List<Options__c> option = TestDataFactory.createSubjectiveOptions(
      question[0].id
    );
    list<Question__c> result = QuestionsController.fetchQuestions(job.id);
    System.assertEquals(1, result.size());
  }

  @isTest
  static void TestGetResponsesAndQuestions() {
    Job__c job = TestDataFactory.createJob();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );
    List<Question__c> question = TestDataFactory.createSubjectiveQuestion(
      job.id
    );
    List<Options__c> option = TestDataFactory.createSubjectiveOptions(
      question[0].id
    );
    string result = QuestionsController.getResponsesAndQuestions(
      job.id,
      candidate.id
    );
    System.assert(result != null);
  }

  @isTest
  static void TestUpdateScore() {
    Job__c job = TestDataFactory.createJob();
    Candidate_Details__c candidate = TestDataFactory.createCandidateDetails();
    Job_Applicants__c applicant = TestDataFactory.createJobApplicant(
      candidate.id,
      job.id
    );
    QuestionsController.updateScore(25.0, job.id, candidate.id);
    String result;
    for (Job_Applicants__c app : [
      SELECT Assesment_Status__c
      FROM Job_Applicants__c
      WHERE id = :applicant.id
    ]) {
      result = app.Assesment_Status__c;
    }
    System.assert(result != null);
    System.assertEquals('Evaluated', result);
  }

  @isTest
  static void TestDeleteQuestion() {
    Job__c job = TestDataFactory.createJob();
    List<Question__c> question = TestDataFactory.createSubjectiveQuestion(
      job.id
    );
    QuestionsController.deleteQuestion(question[0].id);
    integer result = [SELECT COUNT() FROM Question__c WHERE Job__c = :job.id];
    System.assert(result == 0);
  }

  @isTest
  static void TestInsertQuestionAndOption() {
    Job__c job = TestDataFactory.createJob();

    string questionName = 'Test';
    Decimal weightage = 2.0;
    string type_1 = 'Objective';
    string type_2 = 'Subjective';
    string optionA = 'a';
    string optionB = 'b';
    string optionC = 'c';
    string optionD = 'd';
    boolean checkbox_1 = false;
    boolean checkbox_2 = true;
    boolean checkbox_3 = false;
    boolean checkbox_4 = false;
    string answer = 'abcd';

    test.startTest();
    QuestionsController.insertQuestionAndOptions(
      questionName,
      weightage,
      type_1,
      optionA,
      optionB,
      optionC,
      optionD,
      checkbox_1,
      checkbox_2,
      checkbox_3,
      checkbox_4,
      job.id,
      answer
    );
    QuestionsController.insertQuestionAndOptions(
      questionName,
      weightage,
      type_2,
      optionA,
      optionB,
      optionC,
      optionD,
      checkbox_1,
      checkbox_2,
      checkbox_3,
      checkbox_4,
      job.id,
      answer
    );
    test.stopTest();
    integer questionCount = [SELECT COUNT() FROM Question__c];
    integer optionCount = [SELECT COUNT() FROM options__c];

    integer questionCount_2 = [SELECT COUNT() FROM Question__c];
    integer optionCount_2 = [SELECT COUNT() FROM options__c];

    System.assert(questionCount != 0 && optionCount != 0);
    System.assert(questionCount_2 != 0 && optionCount_2 != 0);
  }
}
