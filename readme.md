
# Project Setup

To set up the project environment, run the following commands in the Julia REPL:

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()

#Data Injgestion and Cleaning
#== 
For part 1, we will replace each missing/empty, or '-' values with 'nothing'. In Julia, many functions and operations are designed to handle 'nothing' quite well, and it is used to represent null values. 

Checklist (before running actual test):
OEM column: works as intended (nothing is invalid here)
Model column: works as intended (nothing is invalid here)
launch_announced: works as intended (any string of year xxxx replaces the entire string)
launch_status: works as intended
body_dimensions: works as intended, just check for missing or values containing '-', output everything else. 

