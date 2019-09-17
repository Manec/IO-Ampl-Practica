param n;
param numDependencies;
param Times{1..n}; 
param Costs{1..n}; 
param CrashCosts{1..n};
param TimeCrash{1..n};
param Pareto{1..n} binary;
param costProporcional;
param Dependencies{1..numDependencies,1..2};
param SumCostsTotal = sum{i in 1..n} (if Pareto[i] == 1 then CrashCosts[i] else Costs[i]);
param pressupost;
param Interes;

# decision variables
var Start{1..n} >= 0 integer;
var SumTimes = sum{i in 1..n} Start[i];
var CostAux = SumCostsTotal + Start[n]*costProporcional;
var aux = pressupost - CostAux;
var Prestec = (if aux >= 0 then 0 else -aux * Interes);
var CostTotal = Prestec + CostAux;
var TempsTotal = (if Pareto[n] == 1 then Start[n] + TimeCrash[n] else Start[n] + Times[n]);

minimize obj: CostTotal + TempsTotal;
# minimize obj Gurobi: Start[n];

s.t. c1{i in 1..numDependencies}:
      Start[Dependencies[i,1]] >= (if Pareto[Dependencies[i,2]] == 1 then 
      Start[Dependencies[i,2]] + TimeCrash[Dependencies[i,2]]
      else Start[Dependencies[i,2]] + Times[Dependencies[i,2]]);
      

      