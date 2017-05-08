############################################################
[Mesh]
  file = mesh.e
[]
############################################################
[Variables]
  [./P]
    initial_condition = 20e6
  [../]
[]
############################################################
[AuxVariables]
  [./v_x]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./v_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./k]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]
############################################################
[Kernels]
  [./P_mass_residual]
    type = PTMassResidual
    variable = P
  [../]
[]
############################################################
[AuxKernels]
  [./vx]
    type = PTFluidVelocityAux
    variable = v_x
    component = 0
  [../]
  [./vy]
    type = PTFluidVelocityAux
    variable = v_y
    component = 1
  [../]
  [./k]
    type = PTPermeabilityAux
    variable = k
  [../]
[]
############################################################
[BCs]
  [./P_in]
    type = PresetBC
    variable = P
    boundary = '5'
    value = 20e6
  [../]

  [./P_out]
    type = PresetBC
    variable = P
    boundary = '6'
    value = 1e6
  [../]
[]
############################################################
[Materials]
  [./fractures]
    type = PTGeothermal
    block = '1'

    pressure = P
    #temperature = T

    fluid_property_formulation = 'constant'
    stabilizer = 'none'

    permeability_function_type = '2'

    permeability         = 4.368e-11
    porosity             = 1
    compressibility      = 4.0e-10
    density_rock         = 2700
    density_water        = 1000
    viscosity_water      = 0.001
    specific_heat_rock   = 790
    specific_heat_water  = 4181
    thermal_conductivity = 1.5
    gravity              = 0.0
    gravity_direction    = '0 0 0'

    constant_pressure_gradient = '0 0 0'
  [../]

  [./matrix]
    type = PTGeothermal
    block = '2'

    pressure = P
    #temperature = T

    fluid_property_formulation = 'constant'
    stabilizer = 'none'

    permeability         = 1e-20
    porosity             = 0.01
    compressibility      = 4.0e-10
    density_rock         = 2700
    density_water        = 1000
    viscosity_water      = 0.001
    specific_heat_rock   = 790
    specific_heat_water  = 4181
    thermal_conductivity = 3
    gravity              = 0.0
    gravity_direction    = '0 0 0'

    constant_pressure_gradient = '0 0 0'
  [../]
[]
############################################################
[Executioner]
  type = Steady

  solve_type = 'PJFNK' # default = PJFNK | NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type
                         -ksp_gmres_restart -snes_ls
                         -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre boomeramg 201 cubic 0.7'

  l_max_its = 1000
  l_tol = 1e-3
  nl_max_its = 500
  #nl_rel_tol = 1e-12
  nl_abs_tol = 1e-9
[]

############################################################
[Outputs]
  [./Exodus]
    type = Exodus
    file_base = out2
  [../]
  [./CSV]
    type = CSV
    file_base = out2_post
  [../]
  [./console]
    type = Console
    perf_log = false
    output_linear = true
    output_nonlinear = true
  [../]
[]
############################################################
[Postprocessors]
  [./InMassFlowRate]
    type = PTMassSideFluxIntegral
    variable = P
    boundary = '5'
  [../]
  [./OutMassFlowRate]
    type = PTMassSideFluxIntegral
    variable = P
    boundary = '6'
  [../]
[]
