# The algorithms

## The hill climbers
The two most common MPPT algorithms are locally optimizing hill climb algorithms - Perturb and Observe(P&O) and Incremental conductance(IC). The essence of both alogorithms is the following: 

**If you're on the left of the MPP go right, if you're on the right of the point go left.**

### Perturb and Observe

P&O determines on which side of the MPP it is by observing the sign of the previous dV and dP. Depending on that info it increases(V++) or decreases(V--) the voltage. For more information google the flowchart.

|dV \ dP|+|-|
|-|-|-|
|+|V++|V--|
|-|V--|V++|


### Incremental conductance

Now, the literature(citation needed) says that P&O has some problems with oscillating around the MPP and initially moving in the wrong direction when the environmental conditions change. IC apparently doesn't have those problems(citation needed).

The way IC determines where it is on the PV curve is by observing derivative of the power but in a different way. By representing dP as 

![eq1](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D%20%5Cbg_white%20%5Cfrac%7BdP%7D%7BdV%7D%20=%20%5Cfrac%7Bd(I%20%5Ccdot%20V)%7D%7BdV%7D%20%5CRightarrow%20%5Cfrac%7B1%7D%7BV%7D%20%5Ccdot%20%5Cfrac%7BdP%7D%7BdV%7D%20=%20%5Cfrac%7BdI%7D%7BdV%7D%20&plus;%20%5Cfrac%7BI%7D%7BV%7D)

The dI/dV part is called the incremental conductance. Now the sign of the expression on the right is the same as the sign of the change of power. Now the flowchart becomes a little more complicated, again, google it.

## The fun stuff

The hill climbing algorithms are boring. One thing to spice things up is to implement learning algorithms.

### Q-learning using the Q table
One way to do this is to implement the [Q - learning](https://en.wikipedia.org/wiki/Q-learning) algorithm with a learnable lookup table. This is described in [this paper](https://www.sciencedirect.com/science/article/pii/S0960148117301891?casa_token=WqIOVCRvBw0AAAAA:PU-jqcnGc76td_uuvWQwrWFNM-yPNtJM_Qfl8zh_JT025l77q4VT-yyF-U3cW0xqIP85w1GP). 

The basic idea is to:
* have a table of dimension (_num_voltage_levels, num_current_levels, 2, num_actions_) initialized to all zeros. The first two dimensions indicate the numbers of discrete levels that we want for our voltage and current measurements, they set the resolution. The third indicates whether we are near the MPP or not. The fourth indicates how many predefined actions we can take, these actions are increasing or decreasing the voltage by a fixed amount or not changing it at all.
* explore the state space and change the values of the table according to a reward function and the Bellman equation
* control the voltage by choosing the best actions for the current state according to the Q table

Now, this works, which is fantastic. It's not better than the hill climbing algorthms since it needs time to learn. It also uses a lot of memory for storing the Q table.

### TODO Q table using kd trees
### TODO Deep Q learning
