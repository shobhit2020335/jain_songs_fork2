class SettingsDetails {
  String title;
  String subtitle;
  //THe variable determines whether the setting is opening other page like
  //information, email or not. If false it opens other pages otherwise it is a setting.
  bool isSetting = false;

  SettingsDetails({
    required this.title,
    required this.subtitle,
    this.isSetting: false,
  });
}
