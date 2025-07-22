class AppDetails {
  static String appVersion = "2.2.0";
  static String appName = "Playlist Saver Fschmatz";
  static String appNameHomePage = "Playlist Saver";
  static String backupFileName = "playlist_saver_backup";
  static String repositoryLink = "https://github.com/Fschmatz/playlist_saver";

  static String changelogCurrent = '''
$appVersion
- Async Redux
- Update Flutter 3.32
- Themed icon
- Bug fixes
''';

  static String changelogsOld = '''
2.1.1
- Changed method to parse metadata from Spotify
- Bug fixes

2.0.4  
- Removed tags
- Only Gridview
- Select as new album on save
- UI changes
- Bug fixes
 
1.8.6
- Create and restore backup 
- New album icon
- Flutter 3.19
- UI changes
- Bug fixes

1.7.4
- Monet
- Gridview option 
- Flutter 3.16
- Bug fixes

1.6.5
- Downloads page
- UI changes
- Flutter 3.7
- Bug fixes

1.5.3
- Added favorites page
- Compress cover images
- Bug fixes
- UI changes
    
1.4.14
- Print playlists
- Clear intent
- Show SnackBar on delete
- Fixed parsing data
- Show playlist and artist name when sharing 
- Remove Spotify share phrase
- Bug fixes
- UI changes
- Flutter 3.3 update

1.3.8
- Parse artist name
- Tags
- Tags manager

1.2.1
- Receive share
- Bug fixes

1.1.0
- Added archive page
- UI changes

1.0.0
- Technically usable
- Share link
- Edit playlist

0.6.0
- Open link
- Delete playlist
- Bug fixes

0.5.0
- Home

0.4.0
- Get API data

0.3.0
- Save playlist page
- DB

0.2.0
- Theme

0.1.0
- Project start 
''';
}
