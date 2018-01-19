# Description

The csv file contains the following fields:

* **id**: identification string. The name of the simulation.
* **active**: the simulation is executed only if active is true. Otherwise, it is ignored.
* **nPreys**: number of prey species to simulate.
* **nPreds**: number of predator species to simulate.
* **simTime**: simulation time. Length of the time series in days.
* **stabilTime**: numerical stabilization time. Used to reach an attractor and minimize the effects of the initial conditions.
* **steps**: number of time steps. Length of the time series in steps.
* **lyapTime**: length of the simulation (in days) used for estimating the Lyapunov exponent.
* **lyapPert**: initial perturbation used for estimating the Lyapunov exponent.
* **reps**: number of times the experiment should be repeated. Provided some dynamical parameters are randomly generated, different runs will lead to different time series. Repeating the simulation opens the possibility of a statistical analysis.
* **compPars**: string containing details to reconstruct the competition parameters to be tested. The structure is: _"start step medium step end"_. For instance: -1 0.05 0 0.2 1 generates the concatenation of -1:0.05:0 and 0.2:0.2:1

# Example

## Formatted

|id|active|nPreys|nPreds|simTime|stabilTime|steps|lyapTime|lyapPert|reps|compPars|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|Simulation1|true|8|6|1e3|5e3|2e3|100|1e-8|50|-1 0.05 0 0.2 1|
|Simulation2|true|4|3|1e3|5e3|2e3|100|1e-8|75|-1 0.05 0 0.2 2|

## Plain text
```
sep=;
id;active;nPreys;nPreds;simTime;stabilTime;steps;lyapTime;lyapPert;reps;compPars
Simulation1;true;8;6;1e3;5e3;2e3;100;1e-8;50;-1 0.05 0 0.2 1
Simulation2;true;6;-4;1e3;5e3;2e3;100;1e-8;75;-1 0.05 0 0.2 1
```
Please note that the separators are:

* **semicolon (;)** for new column
* **new line** for new row
