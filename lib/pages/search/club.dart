class ClubInfo {
  ClubInfo({
    this.id,
    this.name,
    this.introduction,
    this.memberNum,
    this.otherInfo,
  });
  int id;
  String name;
  int memberNum;
  String introduction;
  List<String> categoryList;
  List<Map<String, dynamic>> otherInfo; // Users set info
}
