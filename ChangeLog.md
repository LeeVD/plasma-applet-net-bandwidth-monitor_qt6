### 20/4/2025

## v6.2025.4.20

Another bug fix release.

- Fixed widget show wrong speed [bug_#6].
- Fixed Speed Unit Selection ignore higher conversions [bug_#5].
- Fixed Network Settings page, interface list hierarchy issue [bug_#4].
- Fixed Updating from 'Install Widget From Local File' error [bug_#3].

### 17/4/2025

## v6.2025.4.17

Bug Fix Release.

- Fixed issue with bandwidth being stuck in bits and kbits only.
- added different version of bstrong5280 DBUS file for better compatability with kubuntu.

### 9/4/2025

## Qt6 Version

- Ported to Qt Version 6
- Added ability to change the color of the icons, speed and prefixes.
- Added ability to chnage the icons, speed and prefixes based on speed.
- Added default Theme, will respect the underlying default theme colours.
- Added option to toggle speed units on or off.
- Added option to remove decimal place and fraction digits at idle.
- Added 'All' option in Interface page.
- Fixed layout and theming issues in settings page.

#############################

## Features from Version 5

#############################

### 25/07/2023

## Fourth Release - v0.4

- Cleaned up lots of code in settings section, 343 lines of code removed and reworked.
- Added 'Custom Icon Style' option.
- Added 'Speed icon size' option.
- Added 'Prefix/Suffix size' option.
- Reworked 'Number font size' option.
- Added Sliders for font resizing.
- Added 'Decimal Place Filter' to manage how the decimal place in the bandwidth data is presented.
- Added 'Rounded Whole number' to manage how the rounding in the bandwidth data is presented.
- Changes made to the Settings page, info button reworked, text amendments and setting section line breaks added.

### 29/03/2023

## Fix Release - v0.3.3

- Update to the translations.
- Fixed issue with UI text and icon alignment in Horizontal layout.
- Added code to disable padding selection in Horizontal mode.
- Doubled padding option from 10 to 20.

### 21/03/2023

## Fix Release - v0.3.2

- Small fix for unchecking networks forcing one final update to reset UI data to 0.
- Added zh_CN translation files - Thanks to CatEricka.
- Corrected spelling mistakes.

### 19/03/2023

## Fix Release - v0.3.1

- Corrected issue with multiple decimal fraction digits when using 'Update Interval' above 1 second and using 'Average' or 'Accumulated' for Interval data relay options.
- Modified CMakeLists.txt file.
- Added CatEricka edits to configGeneral.qml (staging for translations).
- Started using Git for source control.

### 10/03/2023

## Third Release - v0.3

- Continued code cleanup.
- Merged a couple of similar functions.
- Rewrote function for managing suffix.
- Rewrite of the setting section to include 'information buttons' as a tooltip replacement, more touchscreen friendly.
- Fixed (I think) an issue with user settings related to network interfaces selections being ignored.
- Added more options for 'per seconds' choice | show | hide.
- Added option for Interval delay data management.

### 08/02/2023

## Second Release - v0.2

- Major code rewrite and clean.
- Reworked settings / options page.
- Reworked Network Interface(s) page.
- Fixed previous known bugs.
- Added hide when inactive.
- Added interval data relay option.
- Remembered to update the version number in 'About'.

### 15/01/2023

## Fix Release - v0.1.1

- Changed speed icons to try and fix issue with missing fonts in setting dropdown.
- Added extra speed icons. Icons taken from HACK and DejaVu Sans.
- Fixed error with update interval, should now start at 1 second.
- Fixed error with bits to bytes calculation.
- Added more info to setting section - Numbers + (1000 / 1024), renamed 'Decimal' to 'Metric'.

### 27/12/2022

## First Release - v0.1

- Added Padding option to move rows closer to each other or further apart.
- Added additional 8 icon styles.
- Added option to move icon position to the right of the down/up data.
- Added option to change data into binary or decimal.
- Added option to add digits after decimal place.
