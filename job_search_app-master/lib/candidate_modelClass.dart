

class candidate_modelClass {
  late String city;
  late String company;
  late String company_id;
  late String contact_num;
  late String job_id;
  late String jobTitle;
  late String userId;
  late String userName;
  late String high_edu;
  late String skill;
  late String experience;
  late String candidate_status;
  late String email;

  candidate_modelClass(
      this.company_id,
      this.job_id,
      this.company,
      this.city,
      this.jobTitle,
      this.userName,
      this.contact_num,
      this.userId,
      this.high_edu,
      this.skill,
      this.experience,
      this.candidate_status,
      this.email);

  candidate_modelClass.fromJson(Map<String, dynamic> json) {
    city = json['city'] ?? "";
    company = json['company_name'] ?? "";
    userId = json['user_id'] ?? "";
    job_id = json['job_id'] ?? "";
    company_id = json['company_id'] ?? "";
    jobTitle = json['job_title'] ?? "";
    userName = json['user_name'] ?? "";
    contact_num = json['contact_number'].toString() ?? "";
    high_edu = json['high_edu'].toString() ?? "";
    skill = json['skill'].toString() ?? "";
    experience = json['experience'].toString() ?? "";
    candidate_status = json['candidate_status'].toString() ?? "";
    email = json['email'].toString();


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['company'] = this.company;
    data['user_id'] = this.userId;
    data['job_id'] = this.job_id;
    data['company_id'] = this.company_id;
    data['job_title'] = this.jobTitle;
    data['user_name'] = this.userName;
    data['contact_number'] = this.contact_num;
    data['email'] = this.email;

    return data;
  }
}
