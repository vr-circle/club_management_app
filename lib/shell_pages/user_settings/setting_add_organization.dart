import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';

class SettingAddOrganization extends StatefulWidget {
  SettingAddOrganization({Key key, this.appState}) : super(key: key);
  final AppState appState;
  @override
  _SettingAddOrganizationState createState() => _SettingAddOrganizationState();
}

class _SettingAddOrganizationState extends State<SettingAddOrganization> {
  // String name, introduction, newCategory;
  TextEditingController name, introduction, newCategory;
  List<String> categoryList = [];
  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    introduction = TextEditingController();
    newCategory = TextEditingController();
    categoryList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Organization'),
          actions: [
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: TextButton(
                    onPressed: () async {
                      // widget.appState.
                      final newOrganization = OrganizationInfo(
                          name: name.text,
                          introduction: introduction.text,
                          categoryList: categoryList);
                      // await dbService.createOrganization(newOrganization);
                      // widget.appState.isOpenAddOrganizationPage = false;
                    },
                    child: const Text('Create'))),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Organization Name'),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'name',
                    // icon: const Icon(Icons.people),
                  ),
                  controller: name,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text('Introduction'),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(labelText: 'introduction'),
                  controller: introduction,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text('Category List'),
              categoryList.isEmpty
                  ? const ListTile(
                      title: const Text('There is no categories.'),
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Wrap(
                        children: categoryList
                            .map((e) => Card(
                                child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 0, 0, 0),
                                        child: Row(children: [
                                          const Icon(
                                            Icons.local_offer,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            e,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          IconButton(
                                            iconSize: 14,
                                            onPressed: () {
                                              setState(() {
                                                categoryList.remove(e);
                                              });
                                            },
                                            icon:
                                                const Icon(Icons.highlight_off),
                                          )
                                        ])))))
                            .toList(),
                      )),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Row(children: [
                  Flexible(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'new category',
                        // icon: Icon(Icons.category)
                      ),
                      controller: newCategory,
                      onSubmitted: (value) {
                        if (value.isEmpty) return;
                        setState(() {
                          categoryList.add(value);
                          newCategory.text = '';
                        });
                      },
                    ),
                    flex: 4,
                  ),
                  IconButton(
                      onPressed: () {
                        if (newCategory.text.isEmpty) return;
                        setState(() {
                          categoryList.add(newCategory.text);
                          newCategory.text = '';
                        });
                      },
                      icon: const Icon(Icons.add_box_outlined)),
                ]),
              ),
            ],
          ),
        ));
  }
}
