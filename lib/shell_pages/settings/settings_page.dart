import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/user_settings/user_theme.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    Key key,
    @required this.userThemeSettings,
    @required this.participatingOrganizationInfoList,
    @required this.updateUserTheme,
    @required this.handleOpenCreateNewOrganization,
    @required this.handleChangeSelectedSettingOrganizationId,
    @required this.handleOpenAccountView,
    @required this.logOut,
  });
  final UserThemeSettings userThemeSettings;
  final void Function() handleOpenCreateNewOrganization;
  final void Function(String id) handleChangeSelectedSettingOrganizationId;
  final void Function() handleOpenAccountView;
  final Future<void> Function() logOut;
  final Future<void> Function(UserThemeSettings settings) updateUserTheme;
  final List<OrganizationInfo> participatingOrganizationInfoList;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserThemeSettings _userThemeSettings;
  @override
  void initState() {
    _userThemeSettings = widget.userThemeSettings;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const FlutterLogo(),
              const Text('CMA'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const ListTile(
              title: const Text('Organizations'),
            ),
            ListTile(
              leading: const Icon(
                Icons.add,
                color: Colors.blue,
              ),
              onTap: () {
                widget.handleOpenCreateNewOrganization();
              },
              title: const Text(
                'New Organization',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            Column(children: [
              ...widget.participatingOrganizationInfoList
                  .map((e) => ListTile(
                        onTap: () {
                          widget
                              .handleChangeSelectedSettingOrganizationId(e.id);
                        },
                        leading: const Icon(Icons.people),
                        title: Text(e.name),
                      ))
                  .toList(),
            ]),
            const Divider(
              height: 8,
            ),
            const ListTile(
              title: const Text('Account'),
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text('Account Management'),
              onTap: () {
                widget.handleOpenAccountView();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'SignOut',
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await widget.logOut();
              },
            ),
            const Divider(
              height: 8,
            ),
            const ListTile(
              title: const Text('Theme'),
            ),
            ListTile(
              leading: Icon(
                Icons.color_lens,
                color: this._userThemeSettings.personalEventColor,
              ),
              title: const Text(
                'Personal Event Color',
              ),
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0),
                        contentPadding: const EdgeInsets.all(0),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor:
                                widget.userThemeSettings.personalEventColor,
                            onColorChanged: (value) {
                              this._userThemeSettings.personalEventColor =
                                  value;
                            },
                            colorPickerWidth: 300.0,
                            pickerAreaHeightPercent: 0.7,
                            enableAlpha: true,
                            displayThumbColor: true,
                            showLabel: true,
                            paletteType: PaletteType.hsv,
                            pickerAreaBorderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(2.0),
                              topRight: const Radius.circular(2.0),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                widget.updateUserTheme(this._userThemeSettings);
                                Navigator.pop(context);
                              },
                              child: const Text('Decision')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'))
                        ],
                      );
                    });
              },
            ),
            ListTile(
              leading: Icon(
                Icons.color_lens,
                color: _userThemeSettings.organizationEventColor,
              ),
              title: const Text(
                'Organization Event Color',
              ),
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0),
                        contentPadding: const EdgeInsets.all(0),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor:
                                widget.userThemeSettings.organizationEventColor,
                            onColorChanged: (value) {
                              this._userThemeSettings.organizationEventColor =
                                  value;
                            },
                            colorPickerWidth: 300.0,
                            pickerAreaHeightPercent: 0.7,
                            enableAlpha: true,
                            displayThumbColor: true,
                            showLabel: true,
                            paletteType: PaletteType.hsv,
                            pickerAreaBorderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(2.0),
                              topRight: const Radius.circular(2.0),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                widget.updateUserTheme(this._userThemeSettings);
                                Navigator.pop(context);
                              },
                              child: const Text('Decision')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'))
                        ],
                      );
                    });
              },
            ),
            const Divider(
              height: 8,
            ),
            const ListTile(title: const Text('Information')),
            const ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
          ]),
        ));
  }
}
