using JuMP,  MathProgBase, Gurobi , JLD, Distributions, ExcelReaders , Printf, Random

include("Model-Central-V2.jl")
include("SolveModel-V2.jl")
include("SenarioFunctions-V2.jl")
include("printFunctions-V2.jl")
outputfile1 = open("penalty.out", "w")


Scenarios =  300
MaxIter =  1
eps =  0.01
I = 6
Mixed =6
T =  13
J =  81
NRegions =  8
NDistricts =  33
NClinics =  40
delta =  0.05
beta1 = zeros(I,J,T)  ##### The probbaility of first chance constraint
pi1 = zeros(I,J,T)  ##### The penalty of violating the chance constraint
Min_pi1 = zeros(I,J,T)  ##### The lower bound for penalty of violating the first constraint
Max_pi1 = zeros(I,J,T)  ##### The upper bound for penalty of violating the second constraint

for i=1:I
	for j=1:J
		for t=1:T
			beta1[i,j,t]=0.99
			Min_pi1[i,j,t]=0
			Max_pi1[i,j,t]=1000
			pi1[i,j,t]=10
		end
	end
end

##########
w_O=zeros(I,J,T)      #Fraction of open vial wastage for vaccine i of mixed in location in time period 
D=zeros(I,J,T,Scenarios)
mu= zeros(I,J,T)

D,w_O,mu=SC_Function(I,J,Mixed,NClinics,T,Scenarios)

Dmin=zeros(J)
minimum = zeros(I,J,T)
Dmax=zeros(J)
maximum = zeros(I,J,T)
for i=1:I
	for j=1:J
		for t=1:T
    minval=D[i,j,t,1]
   for s=1:Scenarios
    if (D[i,j,t,s] < minval)
     minval=D[i,j,t,s]
  end
 minimum[i,j,t]=minval
end
end
end
end
for j=1:J
 for i=1:I
  for t=1:T
   Dmin[j]=Dmin[j]+ minimum[i,j,t]
end
end
end

for i=1:I
for j=1:J
	for t=1:T
 maxval=D[i,j,t,1]
 for s=1:Scenarios
 if (D[i,j,t,s] > maxval)
   maxval=D[i,j,t,s]
  end
  maximum[i,j,t]=maxval
 end
 end
  end
end
for j=1:J
 for i=1:I
  for t=1:T
   Dmax[j]=Dmax[j]+ maximum[i,j,t]
end
end
end
#mu=zeros(I,NClinics)
#beta=zeros(I,NClinics)
#u_V1=zeros(1,NRegions)
#u_V2=zeros(NRegions,NDistricts)
#u_V3=zeros(NDistricts,NClinics)
w_R=zeros(Mixed,J,T)
w_F=zeros(Mixed,J,T)
w_FR=zeros(Mixed,J,J,T)
w_FF=zeros(Mixed,J,J,T)
w_RF=zeros(Mixed,J,J,T)
w_RR=zeros(Mixed,J,J,T)


for i in 1:Mixed
	for j in 1:J
		for t in 1:T
			w_R[i,j,t] = 0.01
			w_F[i,j,t] = 0.01
		end
	end
end

#for i in 1:NRegions
#	u_V1[1,i] = 1	
#end
#for i in 1:NRegions
	#for j=1:NDistricts
	#	u_V2[i,j]=1
	#end
#end

#for i in 1:NDistricts
	#for j in 1:NClinics
		#u_V3[i,j]=1
	#end
#end

#for i in 1:I
	#for j in 1:NClinics
		#beta[i,j] = 0.3
		#mu[i,j] = 1
	#end
#end



for i in 1:Mixed
	for j in 1:J
		for k in 1:J
			for t in 1:T
				w_RR[i,j,k,t] = 0.01
				w_RF[i,j,k,t] = 0.01
				w_FR[i,j,k,t] = 0.01
				w_FF[i,j,k,t] = 0.01
			end
		end
	end
end

data1=readxl("data_V1.xls","Sheet1!A2:D82")
C_R_opt = data1[1:J,1]  
C_F_opt = data1[1:J,2] 
u_R=data1[1:J,3]

#u_R1=data1[2:8,3]
#u_R2=data1[9:48,3]
#u_R3=data1[49:J,3]
#u_R3=data1[49:692,3]

u_F=data1[1:J,4]
#u_F3=data1[49:692,4]

data2=readxl("data_V2.xls","Sheet1!A1:E7")
ndv=data2[2:7,2] #number of doses per vial
q=data2[2:7,3] #Packed volume
r=data2[2:7,4] #Diluent volume
a=data2[2:7,5] #Dose administred


Obj_iter = zeros(MaxIter)
T_cpu = zeros(MaxIter)
Gamma1_iter = zeros(Mixed,J,T,Scenarios)
Theta1_iter = zeros(Mixed,J,T,Scenarios)
n_iter = zeros(J)
x_R_opt = zeros(Mixed,J,T)
x_F_opt = zeros(Mixed,J,T) 
S_RR_opt = zeros(Mixed,J,J,T)    
S_RF_opt = zeros(Mixed,J,J,T) 
S_FR_opt = zeros(Mixed,J,J,T)
S_FF_opt = zeros(Mixed,J,J,T)
 

IHCIndexes=[42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81]

############ Create Model ###########
m = createmodel_VSCD(Mixed,T,eps,D,w_R,w_F,w_RR,w_RF,w_FR,w_FF,w_O,u_R,u_F,q,r,a,Scenarios,pi1,ndv,mu)
##########Running the model####################### 

cond = zeros(I,J,T)

#for cnt in 1:10
while (true)

	for i in 1:I
		for j in 1:J
			for t in 1:T
				if (cond[i,j,t] == 0)
				pi1[i,j,t] = (Min_pi1[i,j,t] + Max_pi1[i,j,t])/2
				end
			end
		end
	end

	#@show pi1 -sum(pi1[i,j,t]*getindex(m, :Gamma1)[i,j,t,s] for i=1:I,j in IHCIndexes,t=1:T,s=1:Scenarios)
	@objective(m, Max, sum(getindex(m, :n)[j] for j in IHCIndexes) + eps*(sum(getindex(m, :x_R)[i,j,t]+getindex(m, :x_F)[i,j,t] for i=1:Mixed,j in IHCIndexes,t=1:T))-sum(pi1[i,j,t]*getindex(m, :Theta1)[i,j,t,s] for i=1:I,j in IHCIndexes,t=1:T,s=1:Scenarios))
	Obj_iter,T_cpu,Gamma1_iter,Theta1_iter,n_iter, x_R_opt,x_F_opt,I_R_opt,I_F_opt,S_RR_opt,S_RF_opt,S_FR_opt,S_FF_opt = solvemodel_VSCD(m)
	println("*******************************************")
	println("Objective value: ", Obj_iter)
	println("*******************************************")		
	#@show Gamma1_iter	
	M = zeros(I,J,T)

	for i in 1:I
		for j in 1:J
			for t in 1:T	
				for s in 1:Scenarios
				if Theta1_iter[i,j,t,s] > 0
				println("ThetaPositive")
					M[i,j,t] = M[i,j,t] + 1
					end	
				end
			end
		end
	end

	for i in 1:I
		for j in 1:J
			for t in 1:T	
				if (M[i,j,t] >= beta1[i,j,t]*Scenarios + eps)
					Min_pi1[i,j,t] =(Min_pi1[i,j,t] + Max_pi1[i,j,t])/2	
				elseif (M[i,j,t] <= beta1[i,j,t]*Scenarios - eps)
					Max_pi1[i,j,t] =(Min_pi1[i,j,t] + Max_pi1[i,j,t])/2
				end
			end
		end
	end	
  
for i in 1:I
	for j in 1:J
		for t in 1:T
		@printf(outputfile1,"absolute value calcualtion: %1.2f %1.2f \n",abs(pi1[i,j,t] - (Min_pi1[i,j,t] + Max_pi1[i,j,t])/2), delta)
					@printf(outputfile1,"pi1[%d,%d,%d] = %1.2f \n",i,j,t,pi1[i,j,t])
					
			if (abs(pi1[i,j,t] - (Min_pi1[i,j,t] + Max_pi1[i,j,t])/2) <= delta)
					
			cond[i,j,t] = 1
			end
		end
	end
end	
	
	cond1=0
	for i in 1:I
		for j in IHCIndexes[1]:IHCIndexes[NClinics]
			for t in 1:T	
				if (cond[i,j,t] > 0)
					cond1=cond1+1
				end
			end
		end
	end	
		
	if (cond1==Mixed*NClinics*T)
		printFunc_Results(D,Obj_iter,Gamma1_iter,Theta1_iter,n_iter, T_cpu,Scenarios,J,NRegions,NDistricts,NClinics,I,Mixed,T,x_R_opt,x_F_opt,I_R_opt,I_F_opt,S_RR_opt,S_RF_opt,S_FR_opt,S_FF_opt,ndv)
		break
	end
end
 	println("Objective value: ", Obj_iter)
   #@show(n_iter)
   #@show x_R_opt
   #@show x_F_opt
  
