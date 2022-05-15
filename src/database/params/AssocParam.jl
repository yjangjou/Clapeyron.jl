"""
    AssocParam{T}

Struct holding association parameters.
"""
struct AssocParam{T} <: ClapeyronParam
    name::String
    components::Vector{String}
    groups::Vector{String}
    grouptype::Union{Symbol,Nothing}
    values::Compressed4DMatrix{T,Vector{T}}
    sites::Vector{Vector{String}}
    sourcecsvs::Vector{String}
    sources::Vector{String}
end

function AssocParam(
        name::String,
        components::Vector{String},
        groups::Vector{String},
        grouptype::Union{Symbol,Nothing},
        values::MatrixofMatrices,
        allcomponentsites,
        sourcecsvs,
        sources,
    ) where T
    _values = Compressed4DMatrix(values)
    return AssocParam(
        name,
        components,
        groups,
        grouptype,
        _values,
        allcomponentsites,
        sourcecsvs,
        sources,
    )
end

# Legacy format without groups
function AssocParam(
        name::String,
        components::Vector{String},
        values::MatrixofMatrices,
        allcomponentsites,
        sourcecsvs,
        sources
    ) where T
    Base.depwarn("Params should be constructed with group info.", :AssocParam; force=true)
    _values = Compressed4DMatrix(values)
    return AssocParam(
        name,
        components,
        String[],
        nothing,
        _values,
        allcomponentsites,
        sourcecsvs,
        sources,
    )
end

# Name changing for constructing params from inputparams
function AssocParam(
        x::AssocParam,
        name::String = x.name;
        isdeepcopy = true,
        sources = x.sources)
    if isdeepcopy
        return AssocParam(
            name,
            x.components,
            x.groups,
            x.grouptype,
            deepcopy(x.values),
            x.sites,
            x.sourcecsvs,
            sources
        )
    end
    return AssocParam(
        name,
        x.components,
        x.groups,
        x.grouptype,
        x.values,
        x.sites,
        x.sourcecsvs,
        sources
    )
end

# function AssocParam{T}(x::AssocParam, v::Matrix{Matrix{T}}) where T
#     return AssocParam{T}(
#         x.name,
#         x.components
#         Compressed4DMatrix(v),
#         x.sites,
#         x.sourcecsvs,
#         x.sources)
# end

# function AssocParam{T}(name::String, components::Vector{String}) where T
#     n = length(components)
#     return AssocParam{T}(name, 
#         components,
#         Compressed4DMatrix{T}(),
#         [String[] for _ ∈ 1:n], 
#         String[],
#         String[])
# end

# # If no value is provided, just initialise empty param.
# function AssocParam(
#         ::Type{T},
#         name::String,
#         components::Vector{String}
#         sites::Vector{Vector{String}};
#         sources = String[]
#     ) where T <: AbstractString
#     values = fill("", length(components))
#     return AssocParam{T}(name, components, values, String[], sources)
# end

# function AssocParam(
#         ::Type{T},
#         name::String,
#         components::Vector{String};
#         sources = String[]
#     ) where T <: Number
#     values = zeros(T, length(components))
#     return AssocParam{T}(name, components, values, String[], sources)
# end

# Show
function Base.show(io::IO, mime::MIME"text/plain", param::AssocParam{T}) where T
    print(io, "AssocParam{", string(T), "}")
    print(io, param.components)
    println(io, ") with values:")
    comps = param.components
    vals = param.values
    sitenames = param.sites
    for (idx, (i,j), (a,b)) in indices(vals)
        try
        s1 = sitenames[i][a]
        s2 = sitenames[j][b]
        print(io, "(\"", comps[i], "\", \"", s1, "\")")
        print(io, " >=< ")
        print(io, "(\"", comps[j], "\", \"", s2, "\")")
        print(io, ": ")
        println(io, vals.values[idx])
        catch
        println("error at i = $i, j = $j a = $a, b = $b")
        end
    end
end

function Base.show(io::IO, param::AssocParam)
    print(io, typeof(param), "(\"", param.name, "\")")
    print(io, param.values.values)
end

# Operations
function Base.:(+)(param::AssocParam, x::Number)
    values = param.values + x
    return AssocParam(
        param.name,
        param.components,
        param.groups,
        param.grouptype,
        values,
        param.sites,
        param.sourcecsvs,
        param.sources,
    )
end

function Base.:(*)(param::AssocParam, x::Number)
    values = param.values * x
    return AssocParam(
        param.name,
        param.components,
        param.groups,
        param.grouptype,
        values,
        param.sites,
        param.sourcecsvs,
        param.sources,
    )
end

function Base.:(^)(param::AssocParam, x::Number)
    values = param.values ^ x
    return AssocParam(
        param.name,
        param.components,
        param.groups,
        param.grouptype,
        values,
        param.sites,
        param.sourcecsvs,
        param.sources,
    )
end
