
abstract type PRModel <: ABCubicModel end

const PRParam = ABCubicParam

struct PR{T <: IdealModel,α,c,γ} <:PRModel
    components::Array{String,1}
    icomponents::UnitRange{Int}
    alpha::α
    mixing::γ
    translation::c
    params::PRParam
    idealmodel::T
    references::Array{String,1}
end

@registermodel PR

"""
    PR(components::Vector{String}; idealmodel=BasicIdeal,
    alpha = PRAlpha,
    mixing = vdW1fRule,
    activity=nothing,
    translation=NoTranslation,
    userlocations=String[],
    ideal_userlocations=String[],
    alpha_userlocations = String[],
    mixing_userlocations = String[],
    activity_userlocations = String[],
    translation_userlocations = String[],
    verbose=false)

## Input parameters
- `Tc`: Single Parameter (`Float64`) - Critical Temperature `[K]`
- `Pc`: Single Parameter (`Float64`) - Critical Pressure `[Pa]`
- `Mw`: Single Parameter (`Float64`) - Molecular Weight `[g/mol]`
- `k`: Pair Parameter (`Float64`)

## Model Parameters
- `Tc`: Single Parameter (`Float64`) - Critical Temperature `[K]`
- `Pc`: Single Parameter (`Float64`) - Critical Pressure `[Pa]`
- `Mw`: Single Parameter (`Float64`) - Molecular Weight `[g/mol]`
- `a`: Pair Parameter (`Float64`)
- `b`: Pair Parameter (`Float64`)

## Input models
- `idealmodel`: Ideal Model
- `alpha`: Alpha model
- `mixing`: Mixing model
- `activity`: Activity Model, used in the creation of the mixing model.
- `translation`: Translation Model

## Description
Peng-Robinson Equation of state.
```
P = RT/(V-Nb) + a•α(T)/(V-Nb₁)(V-Nb₂)
b₁ = (1 + √2)b
b₂ = (1 - √2)b
```

## References
1. Peng, D.Y., & Robinson, D.B. (1976). A New Two-Constant Equation of State. Industrial & Engineering Chemistry Fundamentals, 15, 59-64. doi:10.1021/I160057A011
"""
PR


export PR
function PR(components::Vector{String}; idealmodel=BasicIdeal,
    alpha = PRAlpha,
    mixing = vdW1fRule,
    activity=nothing,
    translation=NoTranslation,
    userlocations=String[], 
    ideal_userlocations=String[],
    alpha_userlocations = String[],
    mixing_userlocations = String[],
    activity_userlocations = String[],
    translation_userlocations = String[],
     verbose=false)
    params = getparams(components, ["properties/critical.csv", "properties/molarmass.csv","SAFT/PCSAFT/PCSAFT_unlike.csv"]; userlocations=userlocations, verbose=verbose)
    k  = params["k"]
    pc = params["pc"]
    Mw = params["Mw"]
    Tc = params["Tc"]
    init_mixing = init_model(mixing,components,activity,mixing_userlocations,activity_userlocations,verbose)
    a,b = ab_premixing(PR,init_mixing,Tc,pc,k)
    init_idealmodel = init_model(idealmodel,components,ideal_userlocations,verbose)
    init_alpha = init_model(alpha,components,alpha_userlocations,verbose)
    init_translation = init_model(translation,components,translation_userlocations,verbose)
    icomponents = 1:length(components)
    packagedparams = PRParam(a,b,Tc,pc,Mw)
    references = String["10.1021/I160057A011"]
    model = PR(components,icomponents,init_alpha,init_mixing,init_translation,packagedparams,init_idealmodel,references)
    return model
end

function ab_consts(::Type{<:PRModel})
    return 0.457235,0.077796
end

function cubic_abp(model::PRModel, V, T, z) 
    n = sum(z)
    āᾱ ,b̄, c̄ = cubic_ab(model,V,T,z,n)
    v = V/n+c̄
    _1 = one(b̄)
    denom = evalpoly(v,(-b̄*b̄,2*b̄,_1))
    p = R̄*T/(v-b̄) - āᾱ /denom
    return āᾱ, b̄, p
end

function cubic_poly(model::PRModel,p,T,z)
    a,b,c = cubic_ab(model,p,T,z)
    RT⁻¹ = 1/(R̄*T)
    A = a*p*RT⁻¹*RT⁻¹
    B = b*p*RT⁻¹
    k₀ = B*(B*(B+1.0)-A)
    k₁ = -B*(3*B+2.0) + A
    k₂ = B-1.0
    k₃ = one(A) # important to enable autodiff
    return (k₀,k₁,k₂,k₃),c
end
#=
 (-B2-2(B2+B)+A)
 (-B2-2B2-2B+A)
 (-3B2-2B+A)
=#
function a_res(model::PRModel, V, T, z,_data = data(model,V,T,z))
    n,ā,b̄,c̄ = _data
    Δ1 = 1+√2
    Δ2 = 1-√2
    ΔPRΔ = 2*√2
    RT⁻¹ = 1/(R̄*T)
    ρt = (V/n+c̄)^(-1) # translated density
    ρ  = n/V
    return -log(1+(c̄-b̄)*ρ) - ā*RT⁻¹*log((Δ1*b̄*ρt+1)/(Δ2*b̄*ρt+1))/(ΔPRΔ*b̄)

    #return -log(V-n*b̄) + āᾱ/(R̄*T*b̄*2^(3/2)) * log((2*V-2^(3/2)*b̄*n+2*b̄*n)/(2*V+2^(3/2)*b̄*n+2*b̄*n))
end

cubic_zc(::PRModel) = 0.3074