# octoburrs

This is an implementation of the [code assignment](
https://gist.github.com/djtarazona/c1fc928a6004decba9db) that was assigned by WeWork.

### Installation

1. From the command line navigate to the project directory.
2. Run `gem install cocoapods && pod install`
3. After the pods install, open `octoburrs.xcworkspace`
4. Build and run
5. Tap on the public repositories button to interact.

### Design Considerations

* I primarily used MVVM as the dominant pattern.  I prefer to break out any service calls into its own object- be it a web service or data service.  I then use it to configure a viewModel which in turn serves as backing data for a ViewController.

### Concessions Made Due to Time
* Unit tests: In a project that typically follows this flow - hitting an api and returning some native code, I typically write most tests at the networking and transformation layers.  Since I was using a 3rd party library Octokit, there were no tests to write at that layer since the framework does that for me.  If you want to get a better idea of how I write tests please reference [this file](https://github.com/alonecuzzo/ImageGram/blob/develop/ImageGramTests/Spec/DeepFeedViewModelSpec.swift) which is taken from a code challenge that I submitted for another opportunity.  The project structure is similar, but I wrote the [mapping layer](https://github.com/alonecuzzo/ImageGram/blob/develop/ImageGram/Network/Serialization.swift) myself.  Here is how it is implemented on a [Photo Model](https://github.com/alonecuzzo/ImageGram/blob/develop/ImageGram/Model/Photo.swift).
* I would have also loved to refactor the `IssuesViewController` and `RepositoriesViewController` into a single ViewController object backed by a generic ModelType.  They are both essentially TableViewControllers backed by a datasource.
* I typically prefer to use a Router + Presenter pattern when handling navigation within an app.  I don't like to burden the ViewController with those responsibilities.  Here's an example of a network level [Router](https://github.com/alonecuzzo/ImageGram/blob/develop/ImageGram/Network/Router.swift) that I designed.  Note that I also like to add sample response code to aid any readers about what data should be expected from a route.
* I like to forward cell creation to factories to minimize configuration details found in the ViewController.
* The framework that I'm using only shows open issues.  I'm going to leave that functionality out in the interest of time, rather than writing my own custom service that does that, as I think my submission represents how I'd handle that.
* There's a timing issue when adding a new Issue to github.  When you create an issue, it makes the call to github, and pops the top ViewController when an Issue response comes back from the server.  I make a fresh call for the new issues, but sometimes the new issue doesn't appear in the issues list.  If you re-run the app it updates as expected.  I would've liked to come up with a more robust solution to this - perhaps doing a comparison between the issues that I have and what I'm expecting back - I'm considering this beyond the scope of the challenge.
* I would've like to have preloader and empty states when there are no issues or repositories for a user.  
* Lastly, I would've liked to have error states and proper handling, but I considered it beyond the scope of this project.

The project [ImageGram](https://github.com/alonecuzzo/ImageGram) also has examples of how I'd handle CI and fastlane.

Please contact me at jabari.bell@pxlflu.net if there are any issues or if you have any questions.

Thanks for the consideration!
