function SC_Function(I,J,Mixed,NClinics,T,Scenarios)
IHCIndexes=[42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81]
Region1=[42,10,11,12]
Region2=[46,13,14,15,16]
Region3=[51,17,18,19,20,21,22]
Region4=[58,23,24,25,26,27,28,29,30,31,32,33,34]
Region5=[72,35,36,37,38,39,40,41] 
Region6=[80]
Region7=[81]
 
w_O=zeros(Mixed,J,T)
D= zeros(I,J,T,Scenarios)	
mu= zeros(I,J,T)
data=readxl("Demand.xls","DemandDist!A1:Q13")
data1=readxl("Demand.xls","DemandDist!B17:I17")
data2=readxl("data_V2.xls","Sheet1!F1:M7")
#var=readxl("Demand.xls","Sheet3!A2:I8")
#outputfilename = @sprintf("scenarios.out")
outputfile1 = open("scenarios.out", "w")

Random.seed!(1234)

######Genreting open vial wastage and demand###################
			
for s in 1:Scenarios
	for i in 1:Mixed
		for t in 1:T
			for j in 1:4
				w_O[i,Region1[j],t]=data2[i+1,1]
			end
			for j in 1:5	
				w_O[i,Region2[j],t]=data2[i+1,2]
			end
			for j in 1:7	
				w_O[i,Region3[j],t]=data2[i+1,3]
			end
			for j in 1:13
				w_O[i,Region4[j],t]=data2[i+1,4]
			end
			for j in 1:1
				w_O[i,71,t]=data2[i+1,5]
			end
			for j in 1:8
				w_O[i,Region5[j],t]=data2[i+1,6]
			end
			for j in 1:1
				w_O[i,Region6[j],t]=data2[i+1,7]
			end
			for j in 1:1
				w_O[i,Region7[j],t]=data2[i+1,8]
			end
		end
	end
end

##### I have to divide the demand by the number of clinics here
RegIHC1=[5,13,5,21]
RegIHC2=[12,16,7,18,19]
RegIHC3=[20,19,10,8,15,10,10]
RegIHC4=[7,20,14,24,17,16,14,28,12,10,14,9,15]
RegIHC5=[21,12,17,19,15,11,35,28]

###Polio, Agadez###
for s in 1:Scenarios
	for t in 1:T
		for j in 42:45
			D[1,j,t,s]=((data[3,3] - log(1-rand())*data[3,2])*data1[1,1])/44
			D[1,j,t,s] = D[1,j,t,s]* RegIHC1[j-41]
		end
	end
end

###BCG, Agadez###
for s in 1:Scenarios
	for t in 1:T
		for j in 42:45
			D[2,j,t,s]=((data[5,3] - log(1-rand())*data[5,2])*data1[1,1])/44
			D[2,j,t,s] = D[2,j,t,s]* RegIHC1[j-41]
		end
	end
end

###YF, Agadez###
for s in 1:Scenarios
	for t in 1:T
		for j in 42:45
			D[3,j,t,s]=((data[7,3] - log(1-rand())*data[7,2])*data1[1,1])/44
			D[3,j,t,s] = D[3,j,t,s]* RegIHC1[j-41]
		end
	end
end

###TT, Agadez###
for s in 1:Scenarios
	for t in 1:T
		for j in 42:45
			D[4,j,t,s]=((data[9,3] - log(1-rand())*data[9,2])*data1[1,1])/44
			D[4,j,t,s] = D[4,j,t,s]* RegIHC1[j-41]
		end
	end
end

###DTP, Agadez###
for s in 1:Scenarios
	for t in 1:T
		for j in 42:45
			D[5,j,t,s]=(data[11,2]*(log(1/(1-rand())))^(1/data[11,3])) *data1[1,1] /44
			D[5,j,t,s] = D[5,j,t,s]* RegIHC1[j-41]
		end
	end
end

###Measles, Agadez###
for s in 1:Scenarios
	for t in 1:T
		for j in 42:45
			D[6,j,t,s]= (rand(Gamma(data[13,3],data[13,2])))*data1[1,1]/44
			D[6,j,t,s] = D[6,j,t,s]* RegIHC1[j-41]
		end
	end
end

############################################################

###Polio, Diffa###
for s in 1:Scenarios
	for t in 1:T
		for j in 46:50
			D[1,j,t,s]=((data[3,5] - log(1-rand())*data[3,4])*data1[1,2])/72
			D[1,j,t,s] = D[1,j,t,s]* RegIHC2[j-45]
		end
	end
end

###BCG, Diffa###
for s in 1:Scenarios
	for t in 1:T
		for j in 46:50
			D[2,j,t,s]=((data[5,5] - log(1-rand())*data[5,4])*data1[1,2])/72
			D[2,j,t,s] = D[2,j,t,s]* RegIHC2[j-45]
		end
	end
end

###YF, Diffa###
for s in 1:Scenarios
	for t in 1:T
		for j in 46:50
			D[3,j,t,s]=((data[7,5] - log(1-rand())*data[7,4])*data1[1,2])/72
			D[3,j,t,s] = D[3,j,t,s]* RegIHC2[j-45]
		end
	end
end

###TT, Diffa###
for s in 1:Scenarios
	for t in 1:T
		for j in 46:50
			D[4,j,t,s]=((data[9,5] - log(1-rand())*data[9,4])*data1[1,2])/72
			D[4,j,t,s] = D[4,j,t,s]* RegIHC2[j-45]
		end
	end
end

###DTP, Diffa### weibull
for s in 1:Scenarios
	for t in 1:T
		for j in 46:50
			D[5,j,t,s]=(data[11,4]*(log(1/(1-rand())))^(1/data[11,5])) *data1[1,2] /72
			D[5,j,t,s] = D[5,j,t,s]* RegIHC2[j-45]
		end
	end
end

###Measles, Diffa### johnsontransformation
for s in 1:Scenarios
	for t in 1:T
		for j in 46:50
			D[6,j,t,s]= (rand(Gamma(data[13,5],data[13,4]))) *data1[1,2]/72
			D[6,j,t,s] = D[6,j,t,s]* RegIHC2[j-45]
		end
	end
end

#######################################################################

###Polio, Dosso###
for s in 1:Scenarios
	for t in 1:T
		for j in 51:57	
			D[1,j,t,s]=((data[3,7] - log(1-rand())*data[3,6])*data1[1,3])/92
			D[1,j,t,s] = D[1,j,t,s]* RegIHC3[j-50]
		end
	end
end

###BCG, Dosso###
for s in 1:Scenarios
	for t in 1:T
		for j in 51:57	
			D[2,j,t,s]=((data[5,7] - log(1-rand())*data[5,6])*data1[1,3])/92
			D[2,j,t,s] = D[2,j,t,s]* RegIHC3[j-50]
		end
	end
end

###YF, Dosso###
for s in 1:Scenarios
	for t in 1:T
		for j in 51:57	
			D[3,j,t,s]=((data[7,7] - log(1-rand())*data[7,6])*data1[1,3])/92
			D[3,j,t,s] = D[3,j,t,s]* RegIHC3[j-50]
		end
	end
end

###TT, Dosso###
for s in 1:Scenarios
	for t in 1:T
		for j in 51:57	
			D[4,j,t,s]=((data[9,7] - log(1-rand())*data[9,7])*data1[1,3])/72
			D[4,j,t,s] = D[4,j,t,s]* RegIHC3[j-50]
		end
	end
end

###DTP, Dosso### weibull
for s in 1:Scenarios
	for t in 1:T
		for j in 51:57	
			D[5,j,t,s]=(data[11,6]*(log(1/(1-rand())))^(1/data[11,7])) *data1[1,3] /72
			D[5,j,t,s] = D[5,j,t,s]* RegIHC3[j-50]
		end
	end
end

###Measles, Dosso### weibull
for s in 1:Scenarios
	for t in 1:T
		for j in 51:57	
			D[6,j,t,s]=(data[13,6]*(log(1/(1-rand())))^(1/data[13,7])) *data1[1,3] /72
			D[6,j,t,s] = D[6,j,t,s]* RegIHC3[j-50]
		end
	end
end

#######################################################################

###Polio, Maradi###
for s in 1:Scenarios
	for t in 1:T
		for j in 58:70	
			D[1,j,t,s]=((data[3,9] - log(1-rand())*data[3,8])*data1[1,4])/140
			D[1,j,t,s] = D[1,j,t,s]* RegIHC4[j-57]
		end
	end
end

###BCG, Maradi###
for s in 1:Scenarios
	for t in 1:T
		for j in 58:70	
			D[2,j,t,s]=((data[5,9] - log(1-rand())*data[5,8])*data1[1,4])/140
			D[2,j,t,s] = D[2,j,t,s]* RegIHC4[j-57]
		end
	end
end

###YF, Maradi###
for s in 1:Scenarios
	for t in 1:T
		for j in 58:70	
			D[3,j,t,s]=((data[7,9] - log(1-rand())*data[7,8])*data1[1,4])/140
			D[3,j,t,s] = D[3,j,t,s]* RegIHC4[j-57]
		end
	end
end

###TT, Maradi###
for s in 1:Scenarios
	for t in 1:T
		for j in 58:70	
			D[4,j,t,s]=((data[9,9] - log(1-rand())*data[9,8])*data1[1,4])/140
			D[4,j,t,s] = D[4,j,t,s]* RegIHC4[j-57]
		end
	end
end

###DTP, Maradi### weibull
for s in 1:Scenarios
	for t in 1:T
		for j in 58:70	
			D[5,j,t,s]=(data[11,8]*(log(1/(1-rand())))^(1/data[11,9]))*data1[1,4] /140
			D[5,j,t,s] = D[5,j,t,s]* RegIHC4[j-57]
		end
	end
end

###Measles, Maradi### weibull
for s in 1:Scenarios
	for t in 1:T
		for j in 58:70	
			D[6,j,t,s]=(data[13,8]*(log(1/(1-rand())))^(1/data[13,9]))*data1[1,4] /140
			D[6,j,t,s] = D[6,j,t,s]* RegIHC4[j-57]
		end
	end
end

#######################################################################

###Polio, Tillaberi### weibull
for s in 1:Scenarios
	for t in 1:T	
		D[1,71,t,s]=(data[3,10]*(log(1/(1-rand())))^(1/data[3,11]))*data1[1,5]
	end
end

###BCG, Tillaberi###
for s in 1:Scenarios
	for t in 1:T	
		D[2,71,t,s]=(data[5,11] - log(1-rand())*data[5,10])*data1[1,5]		
	end
end

###YF, Tillaberi###
for s in 1:Scenarios
	for t in 1:T
		D[3,71,t,s]=(data[7,10]*(log(1/(1-rand())))^(1/data[7,11]))*data1[1,5]
	end
end

###TT, Tillaberi###
for s in 1:Scenarios
	for t in 1:T
		D[4,71,t,s]=(data[9,11] - log(1-rand())*data[9,10])*data1[1,5]
	end
end

###DTP, Tillaberi### 
for s in 1:Scenarios
	for t in 1:T
		D[5,71,t,s]=(data[11,10]*(log(1/(1-rand())))^(1/data[11,11])) *data1[1,5] 
	end
end

###Measles, Tillaberi### weibull
for s in 1:Scenarios
	for t in 1:T
		D[6,71,t,s]=(data[13,10]*(log(1/(1-rand())))^(1/data[13,11])) *data1[1,5] 
	end
end

#######################################################################

###Polio, Tahoua### lognormal
for s in 1:Scenarios 
	for t in 1:T
		for j in 72:79		
			D[1,j,t,s]=(exp(rand(Normal(data[3,13],data[3,12]))))*data1[1,6]/158
			D[1,j,t,s] = D[1,j,t,s]* RegIHC5[j-71]
		end
	end
end

###BCG, Tahoua### lognormal
for s in 1:Scenarios
	for t in 1:T
		for j in 72:79	
			D[2,j,t,s]=(exp(rand(Normal(data[5,13],data[5,12]))))*data1[1,6]/158
			D[2,j,t,s] = D[2,j,t,s]* RegIHC5[j-71]
		end
	end
end

###YF, Tahoua### lognormal
for s in 1:Scenarios
	for t in 1:T
		for j in 72:79	
			D[3,j,t,s]=(exp(rand(Normal(data[7,13],data[7,12]))))*data1[1,6]/158
			D[3,j,t,s] = D[3,j,t,s]* RegIHC5[j-71]
		end
	end
end

###TT, Tahoua###lognormal
for s in 1:Scenarios
	for t in 1:T
		for j in 72:79	
			D[4,j,t,s]=(exp(rand(Normal(data[9,13],data[9,12]))))*data1[1,6]/158
			D[4,j,t,s] = D[4,j,t,s]* RegIHC5[j-71]
		end
	end
end

###DTP, Tahoua### weibull
for s in 1:Scenarios
	for t in 1:T
		for j in 72:79	
			D[5,j,t,s]=(data[11,12]*(log(1/(1-rand())))^(1/data[11,13]))*data1[1,6] /158
			D[5,j,t,s] = D[5,j,t,s]* RegIHC5[j-71]
		end
	end
end

###Measles, Tahoua### weibull
for s in 1:Scenarios
	for t in 1:T
		for j in 72:79	
			D[6,j,t,s]=(data[13,12]*(log(1/(1-rand())))^(1/data[13,13]))*data1[1,6] /158
			D[6,j,t,s] = D[6,j,t,s]* RegIHC5[j-71]
		end
	end
end

#######################################################################

###Polio, Zinder### weibull
for s in 1:Scenarios
	for t in 1:T	
		D[1,80,t,s]=(data[3,14]*(log(1/(1-rand())))^(1/data[3,15]))*data1[1,7]
	end
end

###BCG, Zinder###2-param
for s in 1:Scenarios
	for t in 1:T	
		D[2,80,t,s]=(data[5,15] - log(1-rand())*data[5,14])*data1[1,7]		
	end
end

###YF, Zinder###weibull
for s in 1:Scenarios
	for t in 1:T
		D[3,80,t,s]=(data[7,14]*(log(1/(1-rand())))^(1/data[7,15]))*data1[1,7]
	end
end

###TT, Zinder###2-param
for s in 1:Scenarios
	for t in 1:T
		D[4,80,t,s]=(data[9,15] - log(1-rand())*data[9,14])*data1[1,7]
	end
end

###DTP, Zinder### weibull
for s in 1:Scenarios
	for t in 1:T
		D[5,80,t,s]=(data[11,14]*(log(1/(1-rand())))^(1/data[11,15])) *data1[1,7] 
	end
end

###Measles, Zinder### weibull
for s in 1:Scenarios
	for t in 1:T
		D[6,80,t,s]=(data[13,14]*(log(1/(1-rand())))^(1/data[13,15])) *data1[1,7] 
	end
end

#################################################################################

###Polio, Niamey### 2-param
for s in 1:Scenarios
	for t in 1:T	
		D[1,81,t,s]=(data[3,17] - log(1-rand())*data[3,16])*data1[1,8]
	end
end

###BCG, Niamey###weibull
for s in 1:Scenarios
	for t in 1:T	
		D[2,81,t,s]=(data[5,16]*(log(1/(1-rand())))^(1/data[5,17]))*data1[1,8]	
	end
end

###YF, Niamey###2-param
for s in 1:Scenarios
	for t in 1:T
		D[3,81,t,s]=(data[7,17] - log(1-rand())*data[7,16])*data1[1,8]
	end
end

###TT, Niamey###weibull
for s in 1:Scenarios
	for t in 1:T
		D[4,81,t,s]=(data[9,16]*(log(1/(1-rand())))^(1/data[9,17]))*data1[1,8]
	end
end

###DTP, Niamey### weibull
for s in 1:Scenarios
	for t in 1:T
		D[5,81,t,s]=(data[11,16]*(log(1/(1-rand())))^(1/data[11,17]))*data1[1,8]
	end
end

###Measles, Niamey### Gamma
for s in 1:Scenarios
	for t in 1:T
		D[6,81,t,s]=(rand(Gamma(data[13,17],data[13,16]))) *data1[1,7] 
	end
end

#################################################################################

for i in 1:I
	for j in 1:J
		for t in 1:T
			for s in 1:Scenarios
				mu[i,j,t]=mu[i,j,t]+D[i,j,t,s]
			end
			mu[i,j,t]=mu[i,j,t]/30
		end
	end
end
	
	
for i in 1:I
		for t in 1:T
			for s in 1:Scenarios
				for j in 1:J
					@printf(outputfile1, "%d %d %d %d %f \n",i,j,t,s,D[i,j,t,s])
			end
		end	
	end
end


return D,w_O,mu

end