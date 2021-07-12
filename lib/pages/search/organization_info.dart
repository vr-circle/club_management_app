class OrganizationInfo {
  OrganizationInfo({
    this.id,
    this.name,
    this.introduction,
    this.memberNum,
    this.otherInfo,
    this.categoryList,
  });
  String id;
  String name;
  int memberNum;
  String introduction;
  List<String> categoryList;
  List<Map<String, dynamic>> otherInfo; // Users set info
}
