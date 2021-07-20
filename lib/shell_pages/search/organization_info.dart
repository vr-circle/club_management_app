class OrganizationInfo {
  OrganizationInfo({
    this.id,
    this.name,
    this.introduction,
    this.memberNum,
    this.otherInfo,
    this.tagList,
  });
  String id;
  String name;
  int memberNum;
  String introduction;
  List<String> tagList;
  List<Map<String, dynamic>> otherInfo; // Users set info
}
