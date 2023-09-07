using StateTransitionNetworks
using DynamicalSystems
using Test


@testset "stn creation from stochastic matrix" begin
	P = [0 1. 1.;1. 0. 0.;0 0 0.]
	
	stn,retcode = create_stn(P)
	@test retcode == :NotConnected


	stn,retcode = create_stn(P;make_ergodic=true,verbose=true)
	@test retcode == :Success
	@test isnormalized(prob_matrix(stn))
	
end


@testset "stn creation from timeseries" begin
	ds = PredefinedDynamicalSystems.lorenz()
	timeseries, = trajectory(ds,100;Ttr = 1000,Δt = 1e-2)
	grid_size = 20
	plane = (1,15.0);
	
	psection = DynamicalSystemsBase.poincaresos(timeseries, plane; direction=+1, save_idxs=[2,3]);
    d_traj, v_names = timeseries_to_grid(psection, grid_size);
    stn, retcode = create_stn(d_traj, v_names; make_ergodic=true,verbose=false);
	@test retcode == :Success
	@test isnormalized(prob_matrix(stn))
	
end
