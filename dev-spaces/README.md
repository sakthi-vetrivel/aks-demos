**Dev Spaces Connect**

So we have this rock, paper, scissors, lizard, spock application, which allows us to play against an AI written in a few different languages. We have this application deployed in an AKS cluster. What happens if we have a bug in one of these seven different microservices. 

Let's see how we can troubleshoot this using Azure Dev Spaces. So we're going to go ahead and start a game. We're going to go ahead and choose Node as our opponent, and let's go with scissors as our move, and start the battle.

Now, on the right hand side, we should see the opponent's move, along with the corresponding icon. The bug is not that we lost the game, but it looks like there's a bug in the Node service, because I'm not getting any indication of what move the opponent played. 

Let's see how Azure Dev Spaces enables us to confidently debug this application even in a microservices architecture.

Let's step into VS Code, and use the Azure Dev Spaces extension, available right from the Marketplace. We have our Azure Dev Spaces extension installed. 

Now, let's open up the fixed-strategy.js file. We'll set a breakpoint where the opponent chooses a move, and connect to Azure Dev Spaces. We're going to redirect that node service to my instance of VS code, and clone that instance for an isolated version of that service in our own persoanl sandbox environment.

Then, enter the port for the application (3000). Now Azure Dev Spaces Connect will direct all of the traffic for the Node service to my application, so we can debug this own service but still have the entire application involved.

We see that all of those environment variables are also exported.

Now, we can go ahead and start our debugged. We don't need to add anything extra to connect it. It'll just automatically connect to the port and set everything up. In fact, here we can see that the dev spaces is connected to our sandbox on the proper port.

If we click this on the bottom of the screen, we can go directly to the web, which takes us to our own DNS, which is just a subdomain of our URL, that only we, the developler, can access.

So, let's type in our username here, and go through the actions to trigger our breakpoint. Choose Node, then Scissors. 

So, we see VS code flashing in the corner here. We've hit our breakpoint. Now, let's hover over to see what the values in the array are. And we can see that the issue is the mispelling of paper. 

Let's go ahead and fix that, refresh, and we should see that the problem has been resolved. 

The Node service properly shows its move.

**Github Actions & Pull Request Flow**

We've confidently debugged this. Now how can we share this with the rest of our team? Through GitHub Actions.

We already have actions set up on this repo. You see that we're working on my our branch. And because we have actions and a workflow set up, when we open up a pull request, that workflow is actually going to get started.

So before this, you might have noticed that we didn't have to deal with any Kubernetes concepts, or Docker, or Helm. Dev Spaces took care of all of that for us.

So as it starts the workflow, it's going to set up the job, build the images, and set up a private, isolated instance of this PR, so that the rest of the team can access it as well. 

This is going to take a while to run, so let's take a look at a previous pull request.

So here, we can see that the GitHub actions bot adds a private repo version that gives me a full url, where we can take a look and see this PR in action, to see that the bug has been resolved.



