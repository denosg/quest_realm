# quest_realm

Quest App Documentation

**Introduction**

Quest App is an application that allows users to sign up and login to access a variety of quests. The app integrates with Firebase Cloud Database to store user information and quest data. The app also features a home screen that shows all available quests, a bottom navigation bar with a home screen and my quests screen, a custom drawer with home, accepted quests, ranking, and logout options.

**Sign Up and Login**

The app allows users to sign up using their email and password. Upon signing up, the user's data is sent to Firebase Cloud Database for storage. Users can also login using their registered email and password. Upon logging in, the app retrieves the user's data from Firebase Cloud Database.

**Home Screen**

The home screen shows all available quests. When a user clicks on a quest, an animation is shown which includes a button to take on the quest. When a user accepts a quest, an "accQuests" folder is created in the Firebase Cloud Database which includes all the accepted quests for that user.

**Bottom Navigation Bar**

The bottom navigation bar includes two options: home and my quests. The home option takes the user back to the home screen, while the my quests option shows the user-made quests.

**My Quests Screen**

The my quests screen displays user-made quests. By long pressing on a quest, the user can delete the quest from the database. By tapping on a quest, the user is shown a detailed quest screen where they can edit the quest. When the user presses to edit the quest, they are shown an edit quest screen that includes all previous information regarding the quest. By saving the form with new information, the database is updated with the new information and the user's points are updated. The floating action button gives the user the option to create a new quest.

**Custom Drawer**

The custom drawer includes four options: home, accepted quests, ranking, and logout. The accepted quests option shows the user's accepted quests, the title of the quest, the amount of points, and the date in which the quest has been accepted. When the user presses on a quest, an animation with the quest's description is shown. The ranking option displays the ranking of users with the most amount of points. The logout option takes the user back to the authentication screen.

**Personal Touch: Daily Gift Function**

As a software engineer working on the Quest App, I wanted to create a feature that would encourage users to return to the app on a daily basis. To achieve this, I implemented a daily gift function with a roulette-style spin wheel. The daily gift function is accessed through a separate tab in the custom drawer. When a user clicks on the tab, they are taken to the daily gift screen where they can spin the roulette-style wheel once per day where the user can win from 0 to 75 points. I also used Firebase Cloud Database to store information about the user's daily gift spins. Overall, I'm proud of how the daily gift function turned out. It's a fun and interactive feature that encourages users to return to the app daily and engage with the content.

**Conclusion**

The Quest App is a user-friendly and efficient way for users to access a variety of quests. By integrating with Firebase Cloud Database, user information and quest data is easily stored and retrieved. The app's home screen, bottom navigation bar, and custom drawer provide easy navigation, while the my quests screen allows users to create and edit quests.

**How to install:**
// link goes here

**Install link:**
https://drive.google.com/file/d/1beij5Tyx0P1QPCaN48Tl7T-i022wRTrj/view?usp=share_link

**How the app works (video):**
https://youtu.be/kBmLHSJtVhU

**App showcase (photos)**

<img src="https://user-images.githubusercontent.com/81863134/231163225-588d7494-f9ff-4891-9049-550cd72fcdbe.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231163442-a12990a5-014a-4672-b7f9-5b6f246568fc.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231163537-11df5f84-efb9-4693-aded-c3f1474a0d67.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231163617-33fd3603-6387-4bc0-ba84-b46eae2b06c4.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231163703-aaa8172f-1b3c-4acb-b9eb-fe6b6b4598ee.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231163780-ebe1751b-6453-4092-87df-9f85b8520e2a.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231163860-2f7306d5-57ea-40cc-885b-618fad667157.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231163920-e3c1d9e4-acc1-478f-aa27-c5aee20eee0d.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231163974-6f5ca70a-7aeb-4ba4-8177-992346b814a8.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231164029-32509686-a853-4ebf-85a4-ed40646007c1.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231164097-a18eba40-09a0-42df-b6f8-c60655e4cff6.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231164185-aacdc438-73de-4549-8760-4d787aef17f3.png" width="197"> <img src="https://user-images.githubusercontent.com/81863134/231164225-fce9a792-d32e-42c9-9aa4-982d72d5cc21.png" width="197">
