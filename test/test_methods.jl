using Clapeyron, Test, Unitful

@testset "SAFT methods, single components" begin
    @printline
    system = PCSAFT(["ethanol"])
    p = 1e5
    T = 298.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 5.907908736304141e-5 rtol = 1e-6 
        @test Clapeyron.volume(system, p, T;phase=:v) ≈ 0.020427920501436134 rtol = 1e-6 
        @test Clapeyron.volume(system, p, T;threaded=:false) ≈ 5.907908736304141e-5 rtol = 1e-6 
        @test Clapeyron.pip(system, 5.907908736304141e-5, T, [1.]) ≈ 6.857076349623449 rtol = 1e-6
        @test Clapeyron.compressibility_factor(system, p, T) ≈ 0.002383223535444557 rtol = 1e-6
        @test Clapeyron.pressure(system, 5.907908736304141e-5, T) ≈ p rtol = 1e-6
        @test Clapeyron.entropy(system, p, T) ≈ -58.87118569239617 rtol = 1E-6
        @test Clapeyron.chemical_potential(system, p, T)[1] ≈ -18323.877542682934 rtol = 1E-6
        @test Clapeyron.internal_energy(system, p, T) ≈ -35882.22946560716 rtol = 1E-6
        @test Clapeyron.enthalpy(system, p, T) ≈ -35876.32155687084 rtol = 1E-6
        @test Clapeyron.gibbs_free_energy(system, p, T) ≈ -18323.87754268292 rtol = 1E-6
        @test Clapeyron.helmholtz_free_energy(system, p, T) ≈ -18329.785451419295 rtol = 1E-6
        @test Clapeyron.isochoric_heat_capacity(system, p, T) ≈ 48.37961296309505 rtol = 1E-6
        @test Clapeyron.isobaric_heat_capacity(system, p, T) ≈ 66.45719988319257 rtol = 1E-6
        @test Clapeyron.isothermal_compressibility(system, p, T) ≈ 1.1521981407243432e-9 rtol = 1E-6
        @test Clapeyron.isentropic_compressibility(system, p, T) ≈ 8.387789464951438e-10 rtol = 1E-6
        @test Clapeyron.speed_of_sound(system, p, T) ≈ 1236.4846683094133 rtol = 1E-6 #requires that the model has Mr
        @test Clapeyron.isobaric_expansivity(system, p, T) ≈ 0.0010874255138433413 rtol = 1E-6
        @test Clapeyron.joule_thomson_coefficient(system, p, T) ≈ -6.007581864883784e-7 rtol = 1E-6
        @test Clapeyron.second_virial_coefficient(system, T) ≈ -0.004919678119638886  rtol = 1E-6 #exact value calculated by using BigFloat
        @test Clapeyron.inversion_temperature(system, 1.1e8) ≈ 824.4137805298458 rtol = 1E-6
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 7972.550405922014 rtol = 1E-6
        @test Clapeyron.saturation_temperature(system, p)[1] ≈ 351.32529505096164 rtol = 1E-6
        @test Clapeyron.enthalpy_vap(system, T) ≈ 41712.78521121877 rtol = 1E-6
        @test Clapeyron.acentric_factor(system) ≈ 0.5730309964718605 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 533.1324329774004 rtol = 1E-6 
    end
    @printline
end

@testset "pharmaPCSAFT, single components" begin
    system = pharmaPCSAFT(["water08"])
    v1 = Clapeyron.saturation_pressure(system, 280.15)[2]
    v2 = Clapeyron.saturation_pressure(system, 278.15)[2]
    v3 = Clapeyron.saturation_pressure(system, 275.15)[2]

    @test v1 ≈ 1.8022929328333385e-5  rtol = 1E-6 
    @test v2 ≈ 1.8022662044726256e-5 rtol = 1E-6 
    @test v3 ≈ 1.802442451376152e-5 rtol = 1E-6 
    #density maxima of water
    @test v2 < v1
    @test v2 < v3
end

@testset "LJSAFT methods, single components" begin
    system = LJSAFT(["ethanol"])
    p = 1e5
    T = 298.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 5.8990680856791996e-5 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 7933.046853495474 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 533.4350720160273 rtol = 1E-6 
    end
end

@testset "softSAFT methods, single components" begin
    system = softSAFT(["ethanol"])
    p = 1e5
    T = 273.15 + 78.24
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T,phase=:v) ≈ 0.027368884099868623 rtol = 1e-6
        #volume(SAFTgammaMie(["ethanol"]),p,T,phase =:l)  =6.120507339375205e-5
        @test Clapeyron.volume(system, p, T,phase=:l) ≈ 6.245903786961202e-5 rtol = 1e-6
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 101341.9709136089 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 540.1347889779657 rtol = 1E-6 
    end
end

@testset "BACKSAFT methods, single components" begin
    system = BACKSAFT(["decane"])
    p = 1e5
    T = 298.15
    @testset "Bulk properties" begin
        #0.0001950647173402879 with SAFTgammaMie 
        @test Clapeyron.volume(system, p, T) ≈ 0.00019299766073894634 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 167.8313793818096 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 618.8455740197799 rtol = 1E-6 
    end
end

@testset "CPA methods, single components" begin
    system = CPA(["ethanol"])
    p = 1e5
    T = 298.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 5.913050998953597e-5 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 7923.883649594267 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 539.218257256262 rtol = 1E-6 
    end
end

@testset "SAFT-γ Mie methods, single components" begin
    system = SAFTγMie(["ethanol"])
    p = 1e5
    T = 298.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 5.753982584153832e-5 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 7714.849872968086 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 522.7742692078155 rtol = 1E-6 
    end
end

@testset "SAFT-VR Mie methods, single components" begin
    system = SAFTVRMie(["methanol"])
    p = 1e5
    T = 298.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 4.064466003321247e-5 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 16957.625653548406 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 524.1487001618932 rtol = 1E-6 
    end
end

@testset "sCKSAFT methods, single component" begin
    system = sCKSAFT(["ethane"])
    tc_test,pc_test,vc_test = (321.00584034360014, 6.206975436514129e6, 0.0001515067748592245)
    tc,pc,vc = Clapeyron.crit_pure(system)
    @test tc ≈ tc_test rtol = 1E-3
    @test pc ≈ pc_test rtol = 1E-3
    @test vc ≈ vc_test rtol = 1E-3
end


@testset "SAFT methods, multi-components" begin
    @printline
    system = PCSAFT(["methanol","cyclohexane"])
    p = 1e5
    T = 313.15
    z = [0.5,0.5]
    p2 = 2e6
    T2 = 443.15
    z2 = [0.27,0.73]
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T, z) ≈ 7.779694485714412e-5 rtol = 1e-6 
        @test Clapeyron.speed_of_sound(system, p, T, z) ≈ 1087.0303138908864 rtol = 1E-6
        @test Clapeyron.activity_coefficient(system, p, T, z)[1] ≈ 1.794138454452822 rtol = 1E-6
        @test Clapeyron.fugacity_coefficient(system, p, T, z)[1] ≈ 0.5582931304564298 rtol = 1E-6
        @test Clapeyron.mixing(system, p, T, z, Clapeyron.gibbs_free_energy) ≈ -178.10797973342596 rtol = 1E-6
        @test Clapeyron.excess(system, p, T, z, Clapeyron.volume) ≈ 1.004651584989827e-6 rtol = 1E-6
        @test Clapeyron.excess(system, p, T, z, Clapeyron.entropy) ≈ -2.832281578281112 rtol = 1E-6
        @test Clapeyron.excess(system, p, T, z, Clapeyron.gibbs_free_energy) ≈ 1626.6212908893858 rtol = 1E-6
    end
    @testset "Equilibrium properties" begin
        #Those are the highest memory-intensive routines. i suspect that this is causing the 
        #failures on windows 1.6. testing if adding GC pauses helps the problem
        GC.gc()
        @test Clapeyron.gibbs_solvation(system,T) ≈ -13131.087644740426 rtol = 1E-6
        GC.gc()
        @test Clapeyron.UCEP_mix(system)[1] ≈ 319.36877456397684 rtol = 1E-6
        GC.gc()
        @test Clapeyron.bubble_pressure(system,T,z)[1] ≈ 54532.249600937736 rtol = 1E-6
        GC.gc()
        @test Clapeyron.bubble_temperature(system,p2,z)[1] ≈ 435.80890506865 rtol = 1E-6
        GC.gc()
        @test Clapeyron.dew_pressure(system,T2,z)[1] ≈ 1.6555486543884084e6 rtol = 1E-6
        GC.gc()
        @test Clapeyron.dew_temperature(system,p2,z)[1] ≈ 453.0056727580934 rtol = 1E-6
        GC.gc()
        @test Clapeyron.LLE_pressure(system,T,z2)[1] ≈ 737971.7522006684 rtol = 1E-6
        GC.gc()
        @test Clapeyron.LLE_temperature(system,p,z2)[1] ≈ 312.9523684945214 rtol = 1E-6
        GC.gc()
        @test Clapeyron.azeotrope_pressure(system,T2)[1] ≈ 2.4435462800998255e6 rtol = 1E-6
        GC.gc()
        @test Clapeyron.azeotrope_temperature(system,p)[1] ≈ 328.2431049077264 rtol = 1E-6
        GC.gc()
        @test Clapeyron.UCST_mix(system,T2)[1] ≈ 1.0211532467788119e9 rtol = 1E-6
        GC.gc()
        @test Clapeyron.VLLE_pressure(system, T)[1] ≈ 54504.079665621306 rtol = 1E-6
        GC.gc()
        @test Clapeyron.VLLE_temperature(system, p)[1] ≈ 328.2478837563423 rtol = 1E-6
        GC.gc()
        @test Clapeyron.crit_mix(system,z)[1] ≈ 518.0004062881115 rtol = 1E-6
    end
    @printline
end

@testset "Cubic methods, single components" begin
    system = RK(["ethane"])
    p = 1e7
    p2 = 1e5
    T = 250.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 6.819297582048736e-5 rtol = 1e-6 
        @test Clapeyron.volume(system, p2, T) ≈ 0.020539807199804024 rtol = 1e-6
        @test Clapeyron.volume(system, p2, T;phase=:vapour) ≈ 0.020539807199804024 rtol = 1e-6  
        @test Clapeyron.volume(system, p2, T;phase=:liquid) ≈ 7.563111462588624e-5 rtol = 1e-6 
        @test Clapeyron.speed_of_sound(system, p, T) ≈ 800.288303407983 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 1.409820798879772e6 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 305.31999999999994 rtol = 1E-6 
    end
end

@testset "Cubic methods, multi-components" begin
    system = RK(["ethane","undecane"])
    p = 1e7
    T = 298.15
    z = [0.5,0.5]
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T, z) ≈ 0.00017378014541520907 rtol = 1e-6 
        @test Clapeyron.speed_of_sound(system, p, T, z) ≈ 892.4941848133369 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.bubble_pressure(system, T, z)[1] ≈ 1.5760730143760687e6 rtol = 1E-6
        @test Clapeyron.crit_mix(system, z)[1] ≈ 575.622237585033 rtol = 1E-6 
    end
end

@testset "Activity methods, pure components" begin
    system = Wilson(["methanol"])
    p = 1e5
    T = 298.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 4.736782417401261e-5 rtol = 1e-6 
        @test Clapeyron.speed_of_sound(system, p, T) ≈ 2136.2222361829276 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.crit_pure(system)[1] ≈ 512.6399509413803 rtol = 1E-6
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 15525.980361987053 rtol = 1E-6
    end
end

@testset "Activity methods, multi-components" begin
    system = Wilson(["methanol","benzene"])
    p = 1e5
    T = 298.15
    z = [0.5,0.5]
    z_bulk = [0.2,0.8]
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T, z_bulk) ≈ 8.602344040626639e-5 rtol = 1e-6 
        @test Clapeyron.speed_of_sound(system, p, T, z_bulk) ≈ 1371.9014493149134 rtol = 1e-6 
        @test Clapeyron.mixing(system, p, T, z_bulk, Clapeyron.gibbs_free_energy) ≈ -356.86007792929263 rtol = 1e-6 
        @test Clapeyron.mixing(system, p, T, z_bulk, Clapeyron.enthalpy) ≈ 519.0920708672975 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.gibbs_solvation(system, T) ≈ -24707.145697543132 rtol = 1E-6
        @test Clapeyron.bubble_pressure(system, T, z)[1] ≈ 23758.647133460465 rtol = 1E-6
    end
end

@testset "GERG2008 methods, single components" begin
    system = GERG2008(["water"])
    p = 1e5
    T = 298.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 1.8067969591040684e-5 rtol = 1e-6 
        @test Clapeyron.speed_of_sound(system, p, T) ≈ 1484.0034692716843 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 3184.83242429761 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 647.0960000000457 rtol = 1E-6 
    end
end

@testset "GERG2008 methods, multi-components" begin
    @testset "Bulk properties" begin
        model = Clapeyron.GERG2008(["nitrogen","methane","ethane","propane","butane","isobutane","pentane"])
        lng_composition = [0.93,92.1,4.64,1.7,0.42,0.32,0.09]
        lng_composition_molar_fractions = lng_composition ./sum(lng_composition)
        @test Clapeyron.molar_density(model,(380.5+101.3)*1000.0,-153.0+273.15,lng_composition_molar_fractions)/1000 ≈ 24.98 rtol = 1E-2
        @test Clapeyron.mass_density(model,(380.5+101.3)*1000.0,-153.0+273.15,lng_composition_molar_fractions) ≈ 440.73 rtol = 1E-2
        @test Clapeyron.molar_density(model,(380.5+101.3)u"kPa",-153.0u"°C",lng_composition_molar_fractions;output=u"mol/L") ≈ 24.98*u"mol/L"  rtol=1E-2
        @test Clapeyron.mass_density(model,(380.5+101.3)u"kPa",-153.0u"°C",lng_composition_molar_fractions;output=u"kg/m^3")  ≈ 440.73*u"kg/m^3" rtol=1E-2
    end
    @testset "VLE properties" begin
        system = GERG2008(["carbon dioxide","water"])
        T = 298.15
        z = [0.8,0.2]
        @test Clapeyron.bubble_pressure(system, T,z)[1] ≈ 5.853909891112583e6 rtol = 1E-5
    end
end

@testset "EOS-LNG methods, multi-components" begin
    @testset "Bulk properties" begin
        system = EOS_LNG(["methane","isobutane"])
        z = [0.6,0.4]
        V = 1/17241.868
        @test Clapeyron.VT_speed_of_sound(system,1e16,210.0,z) ≈ 252.48363281981858
        @test Clapeyron.volume(system,5e6,160.0,z) ≈ 5.9049701669337714e-5
        @test Clapeyron.pressure(system,0.01,350,z) ≈ 287244.4789047023
    end
end

@testset "IAPWS95 methods" begin
    system = IAPWS95()
    p = 1e5
    T = 298.15
    T_v = 380.15
    T_c = 750.
    p_c = 250e5
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 1.8068623941501927e-5 rtol = 1e-6 
        @test Clapeyron.volume(system, p, T_v;phase=:vapour) ≈ 0.03116877990373624 rtol = 1e-6 
        @test Clapeyron.volume(system, p_c, T_c) ≈ 0.00018553711945962424 rtol = 1e-6 
        @test Clapeyron.volume(system, p_c, T_c;phase=:sc) ≈ 0.00018553711945962424 rtol = 1e-6 
        @test Clapeyron.speed_of_sound(system, p, T) ≈ 1496.699163371358 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 3169.9293390134403 rtol = 1E-6
        tc,pc,vc =  Clapeyron.crit_pure(system)
        @test tc ≈ 647.096 rtol = 1E-5 
        v2 =  volume(system,pc,tc)
        @test pressure(system,v2,tc) ≈ pc rtol = 1E-6
    end
end

@testset "PropaneRef methods" begin
    system = PropaneRef()
    p = 1e5
    T = 230.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 7.577761282115866e-5 rtol = 1e-6 
        @test Clapeyron.volume(system, p, T;phase=:vapour) ≈ 0.018421882342664616 rtol = 1e-6 
        @test Clapeyron.speed_of_sound(system, p, T) ≈ 1166.6704395959607 rtol = 1e-6 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 97424.11102152328 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 369.8900089509652 rtol = 1E-6 
    end
end

@testset "LJRef methods" begin
    system = LJRef(["methane"])
    T = 1.051*Clapeyron.T_scale(system)
    p = 0.035*Clapeyron.p_scale(system)
    v = Clapeyron._v_scale(system)/0.673
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ v rtol = 1e-5 
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ p rtol = 1E-1
        @test Clapeyron.crit_pure(system)[1]/Clapeyron.T_scale(system) ≈ 1.32 rtol = 1E-4 
    end
end

@testset "SPUNG methods" begin
    system = SPUNG(["ethane"])
    p = 1e5
    T = 313.15
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T) ≈ 0.035641472902311774 rtol = 1e-6 
        @test Clapeyron.volume(system, p, T;phase=:vapour) ≈ 0.035641472902311774 rtol = 1e-6 
        @test Clapeyron.speed_of_sound(system, p, T) ≈ 357.8705332163255 rtol = 1e-6 
    end

    T_sat = 250.15
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T_sat)[1] ≈ 3.5120264571020138e6 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1] ≈ 270.27247485012657 rtol = 1E-6 
    end
end

@testset "lattice methods" begin
    p = 1e5
    T = 298.15
    T1 = 301.15
    system = Clapeyron.SanchezLacombe(["carbon dioxide"])
    @testset "Bulk properties" begin
        @test Clapeyron.volume(system, p, T1) ≈ 0.02492944175392707 rtol = 1E-6
        @test Clapeyron.speed_of_sound(system, p, T1) ≈ 307.7871016597499 rtol = 1E-6
    end
    @testset "VLE properties" begin
        @test Clapeyron.saturation_pressure(system, T)[1] ≈ 6.468653945184592e6 rtol = 1E-6
        @test Clapeyron.crit_pure(system)[1]  ≈ 304.21081254005446 rtol = 1E-6
    end
end

@testset "association" begin
    no_comb = Clapeyron.AssocOptions()
    no_comb_dense = Clapeyron.AssocOptions(combining = :dense_nocombining)
    elliott = Clapeyron.AssocOptions(combining = :elliott)
    
    model_no_comb = PCSAFT(["methanol","ethanol"],assoc_options = no_comb)
    model_no_comb_dense = PCSAFT(["methanol","ethanol"],assoc_options = no_comb_dense)
    model_elliott_comb = PCSAFT(["methanol","ethanol"],assoc_options = elliott)

    V = 5e-5
    T = 298.15
    z = [0.5,0.5]
    @test Clapeyron.nonzero_extrema(0:3) == (1, 3)
    @test Clapeyron.a_assoc(model_no_comb,V,T,z) ≈ -4.667036481159167  rtol = 1E-6
    @test Clapeyron.a_assoc(model_no_comb,V,T,z) ≈ Clapeyron.a_assoc(model_no_comb_dense,V,T,z)  rtol = 1E-6
    @test Clapeyron.a_assoc(model_elliott_comb,V,T,z) ≈ -5.323430326406561  rtol = 1E-6
end

@testset "Tp flash algorithms" begin
    system = PCSAFT(["water","cyclohexane","propane"])
    T = 298.15
    p = 1e5
    z = [0.333, 0.333, 0.334]

    @testset "RR Algorithm" begin
        @test Clapeyron.tp_flash(system, p, T,z, RRTPFlash())[3] ≈ -6.539976318817461 rtol = 1e-6 
    end

    @testset "DE Algorithm" begin
        @test Clapeyron.tp_flash(system, p, T,z, DETPFlash(numphases=3))[3] ≈ -6.759674475174073 rtol = 1e-6 
    end
end

@testset "Unitful Methods" begin
    model11 = GERG2008(["methane"])
    model10 = GERG2008(["butane"])
    #example 3.11 abott van ness, 7th ed.
    #pressure. 189 atm with CS compressibility relation
    p11 = 185.95465583962599u"atm"
    v11 = 2u"ft^3"
    T11 = 122u"°F"
    n11 = 453.59237u"mol" #1 lb-mol
    z11 = 0.8755772456569365 #t0.89 from CS compressibility relation
    @test Clapeyron.pressure(model11,v11,T11,n11,output = u"atm") ≈ p11
    @test Clapeyron.pressure(model11,v11,T11,[n11],output = u"atm") ≈ p11
    @test Clapeyron.compressibility_factor(model11,v11,T11,n11) ≈ z11 rtol = 1E-6
    @test Clapeyron.compressibility_factor(model11,p11,T11,n11) ≈ z11 rtol = 1E-6

    #example 3.10 abott van ness, 7th ed.
    #volume, 1480 cm3, with CS virial correlation
    p10 = 25u"bar"
    T10 = 510u"K"
    Tc10 = 425.75874890467253u"K"
    pc10 = 3.830319495176967e6u"Pa"
    R = (Clapeyron.R̄)u"J/(K*mol)"
    v10 = 1478.2681326033257u"cm^3"
    @test volume(model10,p10,T10,output=u"cm^3") ≈ v10 rtol = 1E-6
    #generalized pitzer CS virial gives -0.220 
    @test Clapeyron.second_virial_coefficient(model10,T10)*pc10/(R*Tc10) |> Unitful.ustrip ≈ -0.22346581496303466 rtol = 1E-6
    
    #example 3.13, abbott and van ness, 7th ed.
    model13 = PR(["ammonia"],translation = RackettTranslation)
    v13 = 26.545208120801895u"cm^3"
    T13 = 310u"K"
    #experimental value is 29.14 cm3/mol. PR default is ≈ 32, Racckett overcorrects
    @test saturation_pressure(model13,T13,output = (u"atm",u"cm^3",u"cm^3"))[2] ≈ v13 rtol = 1E-6
    @test Clapeyron.pip(model13,v13,T13) > 1 #check if is a liquid phase

    #problem 3.1 abbott and van ness, 7th ed.
    model31 = IAPWS95()
    v31 = volume(model31,1u"bar",50u"°C")
    #experimental value is 44.18e-6. close enough.

    @test isothermal_compressibility(model31,1u"bar",50u"°C",output = u"bar^-1") ≈ 44.17306906730427e-6u"bar^-1" rtol = 1E-6
    @test isothermal_compressibility(model31,1u"bar",50u"°C",output = u"bar^-1") ≈ 44.17306906730427e-6u"bar^-1" rtol = 1E-6
    #enthalpy of vaporization of water at 100 °C
    @test enthalpy_vap(model31,100u"°C",output = u"kJ") ≈ 40.64971775824767u"kJ" rtol = 1E-6
end
