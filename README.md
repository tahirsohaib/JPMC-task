# SWAPI App
Implemented Star Wars iOS App using SwiftUI, Combine, Dependency Container, Clean Layered Architecture and MVVM.
  
## Recommendations
A Star Wars app might contain a wide range of features. Here are a few concepts:

- Have a planet details page that includes all the planet's information as well as a carousel of its residents and films, both of which can be clicked to get more details. 

- On the home page, there may be a tab bar with three or four tabs for things like planets, people, vehicles, and films.  

- A colour scheme and icon set inspired by Star Wars would greatly enhance the user interface.



## Design Decisions
I choose the MVVM for presentation, SwiftUI, Combine, Dependency container, Clean Layered Architecture, and repository pattern for the app's development.


I chose SwiftUI since iOS 17 will launch shortly, and since iOS 15, it has been quite smooth to use in production. SwiftUI is a modern UI framework that enables you to create user interfaces more efficiently. And I chose Combine to make the app reactive. 

I choose Clean Layered Architecture as an architectural pattern that promotes separation of concerns and clean code structure by dividing the application into independent layers.

Even though this small app didn't require this architecture, I went with it to demonstrate how we can create well-structured, maintainable, and scalable apps. 

There are many ways to manage locally stored data while also getting new data from the server, but I kept it simple.  As soon as the view is created, I display the data from the local database while simultaneously retrieving data from the server, saving it to the local database, and getting an update. I'd argue that we need to decide on a policy on how to handle this situation in live apps.




# Task
_iOS Recruitment Challenge_

**Overview**
Create an iOS app which makes use of the following API: [https://swapi.dev/api/planets/](https://swapi.dev/api/planets/)

This will return a JSON list of planets.

Provide a list of recommendations for future features and improvements.

**Minimum Requirements**

· The application should have a screen which displays a list of planet names from the first page of planet data

· Planets should be persisted for offline viewing

· Minimum iOS version should be 15.0

· The app should be universal

· The app should be appropriately unit tested

· UIKit, SwiftUI, or a mix of both is fine.

· Code should be appropriately documented

· You do not have to load more than the first page of data

· Only use the standard Apple iOS frameworks, do not use any third-party libraries

If you are invited for an interview, part of that will involve expanding upon your solution to the challenge. Keep that in mind as you design your app.
