# NHL-Tracker

## About

Tabbed Storyboard iOS application built in Xcode with Swift allowing users to track their favourite NHL team.

This app utilizes the NHL API to retrieve data which is processed and displayed through several views, including an intuitive next game tab, a table view tab of the selected teams entire season of games and a simple settings page for setting the users favourite team. Documentation for the NHL API was found in the following repository: https://gitlab.com/dword4/nhlapi.

I built this app following the MVC architecture as much as possible, however most of the View code is handled by the Storyboards.

I am an avid fan of the NHL and really enjoyed making this app, it was an excellent experience and greatly strengthened my skills with MVC architecture, working with Api's, JSON parsing and table views. It was created for fun and will not be submitted to the iOS App Store mainly because of NHL liscencing and copyrights.

Screen shots throughout were taken on an iPhone X simulator.

## System Requirements

This app requires iOS 13.0+ to run. It is optimized for iPhones meeting the iOS version requirement.

## App Functionality

Currently, this app contains three tabs containing various information and functionalities as shown below. The next tab which will be worked on is a Stanley Cup Playoffs tab for displaying whether the users favourite team is in the Stanley Cup Playoffs and all the rounds they played in a table view similar to the season games.

### Next Game Tab

* Displays the favourite teams next game
* If a next game is not found then the previous game played is shown instead
* Shows time of game in EST, arena of the game, both teams involved and their league records
* Shows the score of the game and a status of whether the game is scheduled, in progress or finished
* If the game is in progress then buttons appear representing if a team has an empty net or power play (these buttons turn green/grey based on the live state of the game)
* Games that are in progress also show the current period/intermission and time left in the period
* The home team is bolded since the users favourite team is always shown on the left

### Device Screenshots for Live Games

Live Game from September 5, 2020 PHI Empty Net | Live Game from September 9, 2020 TBL Power Play | Live Game from September 9, 2020 First Intermission
---------------------------------------------- | ----------------------------------------------- | ---------------------------------------------------
![alt text](NHL-Tracker-Screenshots/NYIvsPHILiveEmptyNet.png?raw=true) | ![alt text](NHL-Tracker-Screenshots/TBLLivePowerPlay.png?raw=true) | ![alt text](NHL-Tracker-Screenshots/TBLLiveIntermission.png?raw=true)

### Device Screenshots for Scheduled/Finished Games

Upcoming Game for NYI | Upcoming Game for VGK | Previous Game for WSH
----------------------| --------------------- | ---------------------
![alt text](NHL-Tracker-Screenshots/NYINextGame.png?raw=true) | ![alt text](NHL-Tracker-Screenshots/VGKNextGame.png?raw=true) | ![alt text](NHL-Tracker-Screenshots/WSHPreviousGame.png?raw=true)

### Season Games Tab

* Displays all games of the users favourite team for the current season in a table view
* Shows both teams playing, the date, the arena, the score and the game number
* If the game is completed then the cell will turn green or red depending on whether the result was a win or loss
* If the game hasn't occurred yet then the cell will remain white/black depending on whether the user has dark mode on
* Similarly to the next game view, the home team of each game is bolded

### Device Screenshots for Season Schedules

WSH 2019-2020 Schedule | TOR 2019-2020 Schedule 1 | TOR 2019-2020 Schedule 2
-----------------------| ------------------------ | ------------------------
![alt text](NHL-Tracker-Screenshots/WSHSchedule1.png?raw=true) | ![alt text](NHL-Tracker-Screenshots/TORSchedule2.png?raw=true) | ![alt text](NHL-Tracker-Screenshots/TORSchedule3.png?raw=true)

### Settings Tab

* Contains a UIPicker to allow the user to select and update their favourite team, this is saved to the device so it is known for future launches of the app
* Contains 2 switches for permissions which relate to the future plans of notification and Apple Calendar support

### Device Screenshots for Settings Tab and Initial Views

Next Game Initial View | Season Games Initial View | Settings Tab | Settings Tab Update Team Alert
-----------------------| ------------------------- | ------------ | ------------------------------
![alt text](NHL-Tracker-Screenshots/DefaultNextGameTab.png?raw=true) | ![alt text](NHL-Tracker-Screenshots/InitialSeasonGamesTab.png?raw=true) | ![alt text](NHL-Tracker-Screenshots/Settings1.png?raw=true) | ![alt text](NHL-Tracker-Screenshots/Settings2.png?raw=true)

## Current Development/Future Plans

This app is currently being worked on!

### Some of my current work or future plans involve:

* Creating a Stanley Cup Playoffs tab with a table view showing playoff rounds for the current season
* Integrating push notifications to alert users of the start of their favouirte teams next game
* Integrating the app with the native iOS Calendar to add games/season schedule to the users calendar

## Disclaimer
This application is not affiliated with the NHL in any way, it simply uses the NHL API and was built by an NHL fan to practice iOS development.
