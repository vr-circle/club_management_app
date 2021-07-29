import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/store/store_service.dart';

class CreateOrganization extends StatefulWidget {
  CreateOrganization({Key key, this.appState}) : super(key: key);
  final AppState appState;
  @override
  _CreateOrganizationState createState() => _CreateOrganizationState();
}

class _CreateOrganizationState extends State<CreateOrganization> {
  TextEditingController name, introduction, newTag;
  List<String> tagList = [];
  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    introduction = TextEditingController();
    newTag = TextEditingController();
    tagList = [];
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
                      final newOrganization = OrganizationInfo(
                          name: name.text,
                          members: [],
                          memberNum: 1,
                          introduction: introduction.text,
                          tagList: tagList);
                      await dbService.createOrganization(newOrganization);
                      widget.appState.isOpenAddOrganizationPage = false;
                    },
                    child: const Text('Create'))),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(32),
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
              const Text('Tag List'),
              tagList.isEmpty
                  ? const ListTile(
                      title: const Text('There is no categories.'),
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Wrap(
                        children: tagList
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
                                                tagList.remove(e);
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
                        labelText: 'Add a tag',
                      ),
                      controller: newTag,
                      onSubmitted: (value) {
                        if (value.isEmpty) return;
                        setState(() {
                          tagList.add(value);
                          newTag.text = '';
                        });
                      },
                    ),
                    flex: 4,
                  ),
                  IconButton(
                      onPressed: () {
                        if (newTag.text.isEmpty) return;
                        setState(() {
                          tagList.add(newTag.text);
                          newTag.text = '';
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
