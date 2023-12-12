function printFunc_Results(D,Obj,Gamma1,Theta1,n,CPU_opt,Scenarios,J,NRegions,NDistricts,NClinics,I,Mixed,T,x_R_opt,x_F_opt,I_R_opt,I_F_opt,S_RR_opt,S_RF_opt,S_FR_opt,S_FF_opt,ndv)
 println("we reached out here")
# @show n
IHCIndexes=[42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81]

outputfile1 = open("result.out", "w")
outputfile2 = open("x_opt.out", "w")
#outputfile3 = open("Inv_opt.out", "w")
#outputfile4 = open("Ship_opt.out", "w")
#outputfile5 = open("Cap_opt.out", "w")
outputfile6 = open("SR.out", "w")
outputfile7 = open("FIC.out", "w")


Obj1=0
for j in IHCIndexes[1]:IHCIndexes[NClinics]
		Obj1=Obj1+n[j]
end
for i in 1:Mixed
	for j in IHCIndexes[1]:IHCIndexes[NClinics]
		for t in 1:T
			Obj1=Obj1+0.01*(x_R_opt[i,j,t]+x_F_opt[i,j,t])
		end
	end
end

@printf(outputfile1,"%1.2f \n",Obj1)


	write(outputfile1, "$Obj[1] $CPU_opt[1]")

SR_i=zeros(Mixed)
SR_is=zeros(Mixed,Scenarios)


for i in IHCIndexes[1]:IHCIndexes[NClinics]
	write(outputfile1, "n \t $i $(n[i]) \n")
end

write(outputfile1, "*******************************************************\n") 
for i in 1:I
	for j in 1:J
		for t in 1:T
			for k in 1:Scenarios
				write(outputfile1, "Gamma1 \t $i $j $t $k $(Gamma1[i,j,t,k]) \n")
			end
		end
	end
end
write(outputfile1, "*******************************************************\n")
for i in 1:I
	for j in 1:J
		for t in 1:T
			for k in 1:Scenarios
				write(outputfile1, "Theta1 \t $i $j $t $k $(Theta1[i,j,t,k]) \n")
			end
		end
	end
end

#####################X values#####################
for i in 1:Mixed
	for j in 1:J
		for t in 1:T
			write(outputfile2, "x_R_opt \t $i $j $t $(x_R_opt[i,j,t]) \n")
			SR_i[i]=SR_i[i]+x_R_opt[i,j,t]
		end
	end
end
write(outputfile2, "*******************************************************\n")
for i in 1:Mixed
	for j in 1:J
		for t in 1:T
			write(outputfile2, "x_F_opt \t $i $j $t $(x_F_opt[i,j,t]) \n")
			SR_i[i]=SR_i[i]+x_F_opt[i,j,t]
		end
	end
end



###################Calculate FIC_j##############


SP=zeros(NRegions,Scenarios)  ##########Population served by each region
FICR=zeros(NRegions)  ##########Number of fully immunized children by each reagion

for s in 1:Scenarios
	for t in 1:T
		SP[1,s] =SP[1,s]+D[1,42,t,s]+D[1,43,t,s]+D[1,44,t,s]+D[1,45,t,s]
	end
end

FICR[1] =n[42]+n[43]+n[44]+n[45]

for s in 1:Scenarios
	for t in 1:T
		for j=46:50
			SP[2,s] =SP[2,s]+D[1,j,t,s]
		end
	end
end

for j=46:50
	FICR[2] =FICR[2]+n[j]
end


for s in 1:Scenarios
	for t in 1:T
		for j in 51:57	
			SP[3,s] =SP[3,s]+D[1,j,t,s]
		end
	end
end
for j=51:57
	FICR[3] =FICR[3]+n[j]
end

for s in 1:Scenarios
	for t in 1:T
		for j in 58:70	
			SP[4,s] =SP[4,s]+D[1,j,t,s]
		end
	end
end
for j=58:70
	FICR[4] =FICR[4]+n[j]
end

for s in 1:Scenarios
	for t in 1:T
		for j in 71:71	
			SP[5,s] =SP[5,s]+D[1,j,t,s]
		end
	end
end
for j=71:71
	FICR[5] =FICR[5]+n[j]
end

for s in 1:Scenarios
	for t in 1:T
		for j in 72:79	
			SP[6,s] =SP[6,s]+D[1,j,t,s]
		end
	end	
end
for j=72:79
	FICR[6] =FICR[6]+n[j]
end	
for s in 1:Scenarios
	for t in 1:T
		for j in 80:80	
			SP[7,s] =SP[7,s]+D[1,j,t,s]
		end
	end	
end			

FICR[7] =FICR[7]+n[80]

for s in 1:Scenarios
	for t in 1:T
		for j in 81:81	
			SP[8,s] =SP[8,s]+D[1,j,t,s]
		end
	end	
end	
FICR[8] =FICR[8]+n[81]

		
		
		
for s in 1:Scenarios
	for j in 1:NRegions
		write(outputfile7, "FIC_js  $j $s $(100*FICR[j]/SP[j,s])\n")
	end
end

###################Calculate SR_i##############
TotalDemand=zeros(I,Scenarios)
for i in 1:I
	for j in 1:J
		for t in 1:T
			for s in 1:Scenarios
				TotalDemand[i,s]=TotalDemand[i,s]+D[i,j,t,s]
			end
		end	
	end
end

TotalX=zeros(Mixed)
for i in 1:Mixed
	for j in 1:J
		for t in 1:T
			TotalX[i]=TotalX[i]+ndv[i]*(x_R_opt[i,j,t]+x_F_opt[i,j,t])
		end
	end
end

for i in 1:I-1
	for s in 1:Scenarios
	  write(outputfile6, "SR_is \t $i $s $(TotalX[i]/TotalDemand[i,s])\n")
	end 
end
for i in I:Mixed
for s in 1:Scenarios
	 write(outputfile6, "SR_is \t $i $s $((TotalX[i])/TotalDemand[i,s])\n")
end 
end


close(outputfile1)
close(outputfile2)
#close(outputfile3)
#close(outputfile4)
#close(outputfile5)
close(outputfile6)
close(outputfile7)


end

