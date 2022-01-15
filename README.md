# MPPT-Reinforcement

Maximum power point tracking([MPPT](https://en.wikipedia.org/wiki/Maximum_power_point_tracking)) algortihms and reinforcement learning. This repository is, for now, limited to solar cells. You can also do it with wind.

The implemented algorithms can be found [here](algorithms/Algorithms.md).

## What's MPPT?
It's like climbing a hill except the hill is made of power and all you have is voltage. Sometimes, if you're really unlucky, you're climbing multiple hills... 


Uniform irradiance | Partial shading 
:-------------------------:|:-------------------------:
![](https://user-images.githubusercontent.com/69254199/149011438-c53af46e-cf2e-4a34-87e4-5e945fd84d21.png)  |  ![](https://user-images.githubusercontent.com/69254199/149194992-f5cb5d91-46d8-4a2d-9f0f-7de6a9fc1e3f.png)
Fig 1. PV curve with the maximum power point(MPP, the red thing). The goal is to get to the red thing. | Fig 2. PV curve with multiple local maximum power points. The goal is still to get to the red thing - the global MPP.


The scenario in Fig 1. happens when there is 1 or no bypass diodes(the ones parallel to the panel) on the string of solar panels connected to one converter or if there are more  but they are all irradiated equaly. However, if there are more bypass diodes per converter and the panels are partially shaded i.e. they aren't irradiated equaly you get what's shown on Fig 2. - a mess. In that case a global search algorithm would be cool. In the first scenarion, a local one will suffice. 
<hr>

## What can you do about it?
Well, you can employ certain algorithms to climb that hill for you. Traditional algorithms include but are not limited to:
* Perturb and observe
* Incremental conductance
* TODO Others that are not as good as the first two

Newer, less traditional algorithms include but are also not limited to:
* Q learning 
* TODO Others

This is where the fun is.

## A comparison

Let's compare two algorithms as they try to track the MPP as it changes over time.

### Perturb and observe

Climbs a hill. Knows what left, right, up and down are. Does the job well. Is short sighted - optimizes locally.

![pno](https://user-images.githubusercontent.com/69254199/149156013-2e73ce2a-b972-4c35-89bc-731606ecd50a.png)

Fig 3. Perturb and observe algorithm. Quick, clean, realiable.
<hr>

### Q learning with Q table

Climbs a hill without knowing what a hill is. Never heard of up and down, left or right. Only knows what actions are on the table. Climbs the hill nevertheless. Can't ask for much more than that. Uses a lot of memory, though. I don't know if it optimizes locally, that remains to be seen.


![qtable](https://user-images.githubusercontent.com/69254199/149156056-14f91d4a-a12a-419f-8211-96fb46a5debc.png)

Fig 4. Q learning with Q table. Takes a while to warm up, is a little sloppy but gets the job done.
