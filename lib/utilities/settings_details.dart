class SettingsDetails {
  String title;
  String subtitle;
  //THe variable determines whether the setting is opening other page like
  //information, email or not. If false it opens other pages otherwise it is a setting.
  bool isSetting = false;
  //This variable determines which value is dependent for settings, eg: Gobals.darkMode
  //for dark mode setting
  bool dependentValue;

  SettingsDetails({
    required this.title,
    required this.subtitle,
    this.isSetting = false,
    this.dependentValue = false,
  });
}
