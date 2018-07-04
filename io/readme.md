# Input description

The csv file contains the following fields:

* **id**: identification string. The name of the simulation.
* **active**: the simulation is executed only if active is true. Otherwise, it is ignored.
* **nPreys**: number of prey species to simulate.
* **nPreds**: number of predator species to simulate.
* **r**: prey's growth rate (d^-1).
* **K**: prey's carrying capacity (mg l^-1).
* **g**: predation rate (d^-1).
* **f**: immigration rate (mg l^-1 d^-1).
* **e**: assimilation efficiency.
* **H**: half-saturation constant (mg l^-1).
* **l**: predator's loss rate (d^-1).
* **simTime**: simulation time. Length of the time series in days.
* **stabilTime**: numerical stabilization time. Used to reach an attractor and minimize the effects of the initial conditions.
* **steps**: number of time steps. Length of the time series in steps.
* **lyapTime**: length of the simulation (in days) used for estimating the Lyapunov exponent.
* **lyapPert**: initial perturbation used for estimating the Lyapunov exponent.
* **reps**: number of times the experiment should be repeated. Provided some dynamical parameters are randomly generated, different runs will lead to different time series. Repeating the simulation opens the possibility of a statistical analysis.
* **compPars**: string containing details to reconstruct the competition parameters to be tested. The structure is: _"start step medium step end"_. For instance: -1 0.05 0 0.2 1 generates the concatenation of -1:0.05:0 and 0.2:0.2:1
* **seed**: seed for the random number generator. Fixing the seed ensures reproducitiblity of simulations involving random numbers. If you don't know how this works, just use any integer number (0, 1, ...).
* **results_folder**: path where the analysis results will be stored.
* **timeseries_folder**: path where the timeseries will be stored. The timeseries may require some Gb of disk space.

# Example

## Plain text
```
id;active;nPreys;nPreds;r;K;g;f;e;H;l;simTime;stabilTime;steps;lyapTime;lyapPert;reps;compPars;seed;results_folder;timeseries_folder
sim1;true;2;3;0.5;10;0.4;1e-5;0.6;2;0.15;5000;2000;5000;100;1e-8;200;-0.9 0.05 0 0.2 0.9;1;io/;io/
sim2;true;4;6;0.5;10;0.4;1e-5;0.6;2;0.15;5000;2000;5000;100;1e-8;200;-0.9 0.05 0 0.2 0.9;1;io/;io/
```

## Formatted

|     id      | active | nPreys | nPreds |  r  |  K  |  g  |  f  |  e  |  H  |  l  | simTime | stabilTime | steps | lyapTime | lyapPert | reps |    compPars     | seed | results_folder | timeseries_folder |
|:-----------:|:------:|:------:|:------:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:-------:|:----------:|:-----:|:--------:|:--------:|:----:|:---------------:|:----:|:--------------:|:-----------------:|
| Simulation1 |  true  |   8    |   6    | 1e3 | 1e3 | 1e3 | 1e3 | 1e3 | 1e3 | 1e3 |   1e3   |    5e3     |  2e3  |   100    |   1e-8   |  50  | -1 0.05 0 0.2 1 |  1   |      io/       |        io/        |
| Simulation2 |  true  |   4    |   3    | 1e3 | 1e3 | 1e3 | 1e3 | 1e3 | 1e3 | 1e3 |   1e3   |    5e3     |  2e3  |   100    |   1e-8   |  75  | -1 0.05 0 0.2 2 |  1   |      io/       |        io/        |

Please note that the separators are:

* **semicolon (;)** for new column
* **new line** for new row
