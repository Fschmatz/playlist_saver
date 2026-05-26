import 'package:flutter/material.dart';
import 'package:playlist_saver/util/app_constants.dart';
import 'package:playlist_saver/util/utils_string.dart';
import 'package:url_launcher/url_launcher.dart';

class UtilsFunctions {
  static void openGithubRepository() {
    launchBrowser(AppConstants.repositoryLink);
  }

  static void launchBrowser(String url) {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  static String getThemeStringFormatted(ThemeMode? currentTheme) {
    String theme = currentTheme.toString().replaceAll('ThemeMode.', '');

    if (theme == 'system') {
      theme = 'system default';
    }

    return UtilsString.capitalizeFirstLetterString(theme);
  }
}
