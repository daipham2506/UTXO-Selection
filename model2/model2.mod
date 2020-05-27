param n; param m;

set U := {1..n};
set O := {1..m};

param alpha; param beta;
param T; param M; param epsilon;
param Y >=0;
param value{U} >= 0;
param size{U} >= 0;
param Value{O} >= 0;
param Size{O} >= 0;
param big := 100000000 integer;
param txsize >=0;
param iosize >=0;
var X{U} binary; 	# Decision variables
var z_s >=0;		# Intermediate variables
var z_v >=0;		# A value of change output
var u binary; 		# Variables check (z_v > epxilon) ? 1 : 0;
#Objective function

maximize UTXO : sum{j in U} ( X[j]) - z_s/beta;

#file to save output
param f, symbolic := "resultmodel2_5.txt";

#Constraint

# A transaction size may not exceed maximum block data size
s.t. constraint1: sum{j in U} (size[j] * X[j]) + sum{i in O} (Size[i]) + z_s <= (1+0.05)*(Y-(txsize-iosize)); 

# A transaction must have sufficient value for consuming
s.t. constraint2: sum{i in U} (value[i] * X[i]) = sum{j in O} (Value[j]) + alpha * (sum{j in U} (size[j] * X[j]) + sum{i in O} (Size[i]) + z_s) + z_v;

# All the transaction outputs must be higher than the dust threshold
s.t. constraint3: T <= sum{i in O} Value[i];

# If z_v = epxilon, z_s should be zero; otherwise, z_s should be equal to beta
s.t. constraint4: z_s = beta*u;
#If (z_v > epxilon) u = 1 else u = 0; 
s.t. c1: z_v 	 >= epsilon + 1 - big*(1-u); 
s.t. c2: epsilon >= z_v  - big*u;
solve;

printf {i in U} " x[%d] = %d\n",i,X[i];
printf " zs = %d\n",z_s;
printf " zv = %d\n", z_v;
printf "number of UTXOs = %d\n",sum{j in U} ( X[j]);
printf " objective function = %d\n",sum{j in U} ( X[j]) - z_s/beta;
printf " size : %d\n",sum{j in U} (size[j] * X[j]) + sum{i in O} (Size[i]) + z_s+txsize-iosize;
printf "value in: %d\n",sum{i in U} (value[i] * X[i]);

######### write to file
printf " zs = %d\n",z_s>>f;
printf " zv = %d\n", z_v>>f;
printf "number of UTXOs = %d\n",sum{j in U} ( X[j])>>f;
printf " transaction size y = %d\n",sum{j in U} (size[j] * X[j]) + sum{i in O} (Size[i]) + z_s+txsize-iosize>>f;
printf "value of input : %d\n",sum{i in U} (value[i] * X[i])>>f;
printf "value of output : %d\n", sum{ i in O}Value[i]>>f;


data;

end;