Visualization Community
=======================
Course project in TDDD27 - Advanced Web Programming.

Screen Cast
-----------------------
A screen cast (in swedish) of a live version of the community can be found here: http://youtu.be/siqVHve1lOs.
The version used in the screen cast is hosted here: http://130.236.248.228/ (missing profile edit functionality added in later versions). This is provided as is, without warranty, but will hopefully work :).

Scope
-----------------------
During the course, a community style app will be developed. The theme that the community will revolve around is the MathGL engine. MathGL is a webGL framework (developed by MT students) used to plot mathematical expressions from multivariable calculus in 3d. The framework is used in http://continuous.se/.

This project will not consist in further developing the graphics engine, but rather to implement a platform that lets users build, save and share their creations in MathGL.

Functional Specification
-----------------------
The app will have two major functionality groups.

* The Community - Allowing users to share and group visualizations/plots together as well as to follow each other and recieve updates. Similarly to how the community functionality of GitHub is structured. This might be the best focus for TDDD27 as it is straight on classic client-server with database, registered users etc.
* The Editor - This is arguably the more interesting part. I think of this as a Google Drive-style editor where a user e.g. inputs a mathematical expression, colors the corresponding surface, adjusts transparency and lighting, labels axes etc. All while the client asynchronously saves a state/snapshot in the database.

The reason why the editor part would not fit this project is that I think there would be too much refactoring inside MathGL and that will take focus from the examination goals in this course. However, this will be seen as a "nice to have" for the course project and will probably be implemented in my own time.

Technological Specification
-----------------------
###Server
I have reviewed several frameworks and have (kind of) decided on an express/nodejs backend with either mongodb/mongoose or mysql/sequelize as database abstraction. There are a lot of cool extentions and plugins for node. For example the Passport authentication framework which I will look more into.

###Client
Even though I have worked with AngularJS before it is, as far as I know, the js-client framework of choice for a many web developers. So I will continue to use it.

###Automation
I have no previous experience from [Grunt](http://gruntjs.com/), so I will try it out. It looks like it could provide a neat workflow.

###Testing
I will use mocha or jasmine as testing framework. I have used jasmine before, but mocha looks promising. I will perhaps use karma as test runner, but I hope to avoid it using e.g. grunt + mocha instead.


To mix it up, I will try to develop in coffeescript this time. I have never written anything in coffeescript, but I hear developers like it. So let's try it out!

I have began to work on the general structure of the project on GitHub. I will try to write everything myself instead of scaffolding, knowing that it will take more time but hopefully result in more knowledge. Feel free to examine the code at https://github.com/J-Zeitler/sean.

Group
-----------------------
Jonas Zeitler - jonze168