
include("utils.jl")
#just a holder for the z partitions.
#to allow split_model to work correctly

abstract type SAFTgammaMieModel <: SAFTVRMieModel end


struct SAFTgammaMieParam <: EoSParam
    segment::SingleParam{Int}
    shapefactor::SingleParam{Float64}
    lambda_a::PairParam{Float64}
    lambda_r::PairParam{Float64}
    sigma::PairParam{Float64}
    epsilon::PairParam{Float64}
    epsilon_assoc::AssocParam{Float64}
    bondvol::AssocParam{Float64}
end


struct SAFTgammaMie{I,VR} <: SAFTgammaMieModel
    components::Vector{String}
    groups::GroupParam
    sites::SiteParam
    params::SAFTgammaMieParam
    idealmodel::I
    vrmodel::VR
    assoc_options::AssocOptions
    references::Array{String,1}
end


function SAFTgammaMie(components; 
    idealmodel=BasicIdeal,
    userlocations=String[],
    ideal_userlocations=String[],
    verbose=false,
    assoc_options = AssocOptions())

    groups = GroupParam(components, ["SAFT/SAFTgammaMie/SAFTgammaMie_groups.csv"]; verbose=verbose)
    params,sites = getparams(groups, ["SAFT/SAFTgammaMie","properties/molarmass_groups.csv"]; userlocations=userlocations, verbose=verbose)
    components = groups.components
    
    gc_segment = params["vst"]
    shapefactor = params["S"]

    mw = group_sum(groups,params["Mw"])
    
    mix_segment!(groups,shapefactor.values,gc_segment.values)
    
    segment = SingleParam("segment",components,group_sum(groups))
    
    gc_sigma = sigma_LorentzBerthelot(params["sigma"])  
    gc_sigma.values .*= 1E-10
    gc_sigma3 = PairParam(gc_sigma)
    gc_sigma3.values .^= 3
    sigma3 = group_pairsum(groups,gc_sigma3)
    sigma3.values .= cbrt.(sigma3.values)
    sigma = sigma_LorentzBerthelot(sigma3)

    gc_epsilon = epsilon_HudsenMcCoubrey(params["epsilon"], gc_sigma)
    epsilon = epsilon_HudsenMcCoubrey(group_pairsum(groups,gc_epsilon),sigma)
    
    gc_lambda_a = lambda_LorentzBerthelot(params["lambda_a"])
    gc_lambda_r = lambda_LorentzBerthelot(params["lambda_r"])

    lambda_a = group_pairsum(groups,gc_lambda_a) |> lambda_LorentzBerthelot
    lambda_r = group_pairsum(groups,gc_lambda_r) |> lambda_LorentzBerthelot
 
    #GC to component model in association
    gc_epsilon_assoc = params["epsilon_assoc"]
    gc_bondvol = params["bondvol"]
    comp_sites,idx_dict = gc_to_comp_sites(sites,groups)
    assoc_idx = gc_to_comp_assoc_idx(gc_bondvol,comp_sites,idx_dict)
    assoc_idxs,outer,inner,outer_size,inner_size = assoc_idx.values,assoc_idx.outer_indices,assoc_idx.inner_indices,assoc_idx.outer_size,assoc_idx.inner_size
    _comp_bondvol = [gc_bondvol.values.values[i] for i ∈ assoc_idxs]
    _comp_epsilon_assoc = [gc_epsilon_assoc.values.values[i] for i ∈ assoc_idxs]
    compval_bondvol = Compressed4DMatrix(_comp_bondvol,outer,inner,outer_size,inner_size)
    compval_epsilon_assoc = Compressed4DMatrix(_comp_epsilon_assoc,outer,inner,outer_size,inner_size)
    comp_bondvol = AssocParam{Float64}("epsilon assoc",components,compval_bondvol,comp_sites.sites,String[],String[])
    comp_epsilon_assoc = AssocParam{Float64}("bondvol",components,compval_epsilon_assoc,comp_sites.sites,String[],String[])
    
    gcparams = SAFTgammaMieParam(gc_segment, shapefactor,gc_lambda_a,gc_lambda_r,gc_sigma,gc_epsilon,gc_epsilon_assoc,gc_bondvol)
    vrparams = SAFTVRMieParam(segment,sigma,lambda_a,lambda_r,epsilon,comp_epsilon_assoc,comp_bondvol,mw)
    
    idmodel = init_model(idealmodel,components,ideal_userlocations,verbose)
    
    vr = SAFTVRMie(vrparams, comp_sites, idmodel; ideal_userlocations, verbose, assoc_options)
    γmierefs = ["10.1063/1.4851455", "10.1021/je500248h"]
    gmie = SAFTgammaMie(components,groups,sites,gcparams,idmodel,vr,assoc_options,γmierefs)
    return gmie
end
@registermodel SAFTgammaMie

const SAFTγMie = SAFTgammaMie
export SAFTgammaMie,SAFTγMie

SAFTVRMie(model::SAFTgammaMie) = model.vrmodel

include("equations.jl")