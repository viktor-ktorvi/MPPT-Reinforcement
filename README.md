# MPPT-Reinforcement

Maximum power point tracking([MPPT](https://en.wikipedia.org/wiki/Maximum_power_point_tracking)) algortihms and reinforcement learning. This repository is, for now, limited to solar cells. You can also do it with wind.

## What's is MPPT?
It's like climbing a hill except the hill is made of power and all you have is voltage. Sometimes, if you're really unlucky, you're climbing multiple hills... We'll get to that.

![untitled](https://user-images.githubusercontent.com/69254199/149011438-c53af46e-cf2e-4a34-87e4-5e945fd84d21.png)

Fig 1. PV curve with the maximum power point(MPP, the red thing). The goal is to get to the red thing.
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

### Perturb and observe

Climbs a hill. Knows what left, right, up and down are. Does the job well. Is short sighted - optimizes locally.

![pno](https://user-images.githubusercontent.com/69254199/149156013-2e73ce2a-b972-4c35-89bc-731606ecd50a.png)

Fig 2. Perturb and observe algorithm. Quick, clean, realiable.
<hr>

### Q learning with Q table

Climbs a hill without knowing what a hill is. Never heard of up and down, left or right. Only knows what actions are on the table. Climbs the hill nevertheless. Can't ask for much more than that. Uses a lot of memory, though. I don't know if it optimizes locally, that remains to be seen.


![qtable](https://user-images.githubusercontent.com/69254199/149156056-14f91d4a-a12a-419f-8211-96fb46a5debc.png)

Fig 3. Q learning with Q table. Takes a while to warm up, is a little sloppy but gets the job done.
