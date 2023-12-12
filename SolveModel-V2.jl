function solvemodel_VSCD(m)
start=time()
#solver=GurobiSolver(Method=1, IterationLimit=100)
#setparams!(env; IterationLimit=100, Method=1) 
 optimize!(m)
   
    if termination_status(m) == MOI.OPTIMAL
	println("Solved")
	
		Obj = objective_value(m)
		CPU_opt = time()-start
		Gamma1_opt=JuMP.value.(getindex(m, :Gamma1))
		Theta1_opt=JuMP.value.(getindex(m, :Theta1))
		n_opt=JuMP.value.(getindex(m, :n))
		x_R_opt=JuMP.value.(getindex(m, :x_R))
		x_F_opt=JuMP.value.(getindex(m, :x_F))
		I_R_opt=JuMP.value.(getindex(m, :I_R))
		I_F_opt=JuMP.value.(getindex(m, :I_F))
		S_RR_opt=JuMP.value.(getindex(m, :S_RR))
		S_RF_opt=JuMP.value.(getindex(m, :S_RF))
		S_FR_opt=JuMP.value.(getindex(m, :S_FR))
		S_FF_opt=JuMP.value.(getindex(m, :S_FF))
		
elseif termination_status(m) == MOI.TIME_LIMIT && has_values(m)
		println("Status 2:", status)
		#Obj = getobjectivevalue.(m)
		Obj = objective_value(m)
		CPU_opt = time()-start
		Gamma1_opt=JuMP.value.(getindex(m, :Gamma1))
		Theta1_opt=JuMP.value.(getindex(m, :Theta1))
		n_opt=JuMP.value.(getindex(m, :n))
		x_R_opt=JuMP.value.(getindex(m, :x_R))
		x_F_opt=JuMP.value.(getindex(m, :x_F))
		I_R_opt=JuMP.value.(getindex(m, :I_R))
		I_F_opt=JuMP.value.(getindex(m, :I_F))
		S_RR_opt=JuMP.value.(getindex(m, :S_RR))
		S_RF_opt=JuMP.value.(getindex(m, :S_RF))
		S_FR_opt=JuMP.value.(getindex(m, :S_FR))
		S_FF_opt=JuMP.value.(getindex(m, :S_FF))
		
	else
	println("Not Solved")
		Obj = 0
		CPU_opt = time()-start
  Obj = objective_value(m)
		CPU_opt = time()-start
		Gamma1_opt=JuMP.value.(getindex(m, :Gamma1))
		Theta1_opt=JuMP.value.(getindex(m, :Theta1))
		n_opt=JuMP.value.(getindex(m, :n))
		x_R_opt=JuMP.value.(getindex(m, :x_R))
		x_F_opt=JuMP.value.(getindex(m, :x_F))
		I_R_opt=JuMP.value.(getindex(m, :I_R))
		I_F_opt=JuMP.value.(getindex(m, :I_F))
		S_RR_opt=JuMP.value.(getindex(m, :S_RR))
		S_RF_opt=JuMP.value.(getindex(m, :S_RF))
		S_FR_opt=JuMP.value.(getindex(m, :S_FR))
		S_FF_opt=JuMP.value.(getindex(m, :S_FF))
	end
   

   return Obj,CPU_opt,Gamma1_opt,Theta1_opt,n_opt,x_R_opt,x_F_opt,I_R_opt,I_F_opt,S_RR_opt,S_RF_opt,S_FR_opt,S_FF_opt
end