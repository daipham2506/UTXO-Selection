param n; param m;

set U := {1..n};
set O := {1..m};

param alpha; param beta;
param T; param M; param epsilon;

param value{U} >= 0;

param size{U} >= 0;

param Value{O} >= 0;

param Size{O} >= 0;
param txsize >=0;
param iosize >=0;
param big := 100000000000000 integer;
var X{U} binary; 	# Decision variables
var z_s >=0;		# Intermediate variables
var z_v >=0;		# A value of change output
var u binary; 		# Variables check (z_v > epxilon) ? 1 : 0;
#Objective function
minimize y : sum{j in U} (size[j] * X[j]) + sum{i in O} (Size[i]) + z_s;

#file to save output
param f, symbolic := "resultmd1.txt";
#Constraint

# A transaction size may not exceed maximum block data size
s.t. constraint1: sum{j in U} (size[j] * X[j]) + sum{i in O} (Size[i]) + z_s+txsize-iosize <= M; 

# A transaction must have sufficient value for consuming
s.t. constraint2: sum{i in U} (value[i] * X[i]) = sum{j in O} (Value[j]) + alpha * (sum{j in U} (size[j] * X[j]) + sum{i in O} (Size[i]) + z_s) + z_v;

# All the transaction outputs must be higher than the dust threshold
s.t. constraint3: T <= sum{i in O} Value[i];
s.t. input: sum{i in U} X[i] >= 1;
# If z_v = epxilon, z_s should be zero; otherwise, z_s should be equal to beta
s.t. constraint4: z_s = beta*u;
#If (z_v > epxilon) u = 1 else u = 0; 
s.t. c1: z_v 	 >= epsilon + 1 - big*(1-u); 
s.t. c2: epsilon >= z_v  - big*u;

solve;

printf {i in U} " x[%d] = %d\n",i,X[i];
printf " zs = %d\n",z_s>>f;
printf " zv = %d\n", z_v>>f;
printf " num selected: %d\n", sum{j in U}X[j]>>f;
printf " minimize y = %d\n",sum{j in U} (size[j] * X[j]) + sum{i in O} (Size[i]) + z_s+txsize-iosize>>f;

#printf "\n\n">>f;
data;

end;