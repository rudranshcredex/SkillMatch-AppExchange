import { LightningElement } from "lwc";
import experienceFieldValues from "@salesforce/apex/JobPicklistController.experienceFieldValues";
import typePickListValues from "@salesforce/apex/JobPicklistController.typePickListValues";
import IndustryPickListValues from "@salesforce/apex/JobPicklistController.IndustryPickListValues";
import TimingsPickListValues from "@salesforce/apex/JobPicklistController.TimingsPickListValues";
import postJob from "@salesforce/apex/jobObjectController.postJob";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import saveToDraft from "@salesforce/apex/jobObjectController.saveToDraft";
import { NavigationMixin } from "lightning/navigation";
import Id from "@salesforce/user/Id";
import getCompanyName from "@salesforce/apex/jobObjectController.getCompanyName";

export default class AddJobsPage extends NavigationMixin(LightningElement) {
  experienceValues = [];
  industryValues = [];
  typeValues = [];
  timingValues = [];

  jobTitle = "";
  summary = "";
  description = "";
  salaryRange = "";
  country = "";
  city = "";
  experienceValue = "";
  typeValue = "";
  industryValue = "";
  skills = "";
  userCompanyName;
  userId = Id;

  showQuestionModal = false;

  connectedCallback() {
    experienceFieldValues().then((result) => {
      this.experienceValues = result;
    });
    typePickListValues().then((result) => {
      this.typeValues = result;
    });
    IndustryPickListValues().then((result) => {
      this.industryValues = result;
    });
    TimingsPickListValues().then((result) => {
      this.timingValues = result;
    });
    getCompanyName({ userId: this.userId }).then((result) => {
      this.userCompanyName = result;
    });
  }

  handleExperienceChange(event) {
    this.experienceValue = event.target.value;
  }

  handleTypeChange(event) {
    this.typeValue = event.target.value;
  }

  handleIndustryChange(event) {
    this.industryValue = event.target.value;
  }

  handleJobTitleChange(event) {
    this.jobTitle = event.target.value;
  }
  handleDescriptionChange(event) {
    this.description = event.target.value;
  }
  handleSalaryChange(event) {
    this.salaryRange = event.target.value;
  }
  handleCityChange(event) {
    this.city = event.target.value;
  }
  handleCountryChange(event) {
    this.country = event.target.value;
  }
  handleSummaryChange(event) {
    this.summary = event.target.value;
  }
  handleSkillsChange(event) {
    this.skills = event.target.value;
  }

  postJobData() {
    postJob({
      jobTitle: this.jobTitle,
      description: this.description,
      salaryRange: this.salaryRange,
      companyName: this.userCompanyName,
      city: this.city,
      country: this.country,
      experienceValue: this.experienceValue,
      typeValue: this.typeValue,
      industryValue: this.industryValue,
      summary: this.summary,
      skills: this.skills
    })
      .then(() => {
        console.log("true");
        this.showToast("Success", "Job posted successfully", "success");
        const pageReference = {
          type: "standard__webPage",
          attributes: {
            url: "/manage-jobs"
          }
        };
        this[NavigationMixin.Navigate](pageReference);
      })
      .catch((error) => {
        console.error("Error posting job:", error);
        this.showToast(
          "Error",
          "Some Error occured, please try again",
          "error"
        );
      });
  }

  saveToDraft() {
    saveToDraft({
      jobTitle: this.jobTitle,
      description: this.description,
      salaryRange: this.salaryRange,
      companyName: this.userCompanyName,
      city: this.city,
      country: this.country,
      experienceValue: this.experienceValue,
      typeValue: this.typeValue,
      industryValue: this.industryValue,
      summary: this.summary,
      skills: this.skills
    })
      .then(() => {
        console.log("true");
        this.showToast("Success", "Draft saved successfully", "success");
        const pageReference = {
          type: "standard__webPage",
          attributes: {
            url: "/manage-jobs"
          }
        };
        this[NavigationMixin.Navigate](pageReference);
      })
      .catch((error) => {
        console.error("Error saving draft:", error);
        this.showToast(
          "Error",
          "Some Error occured, please try again",
          "error"
        );
      });
  }

  showToast(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
      })
    );
  }
}
