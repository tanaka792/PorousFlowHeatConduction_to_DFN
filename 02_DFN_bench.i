[Mesh]
  [gen]
    type = FileMeshGenerator
    file = 02_mesh_create_in.e
    allow_renumbering = false
    skip_partitioning = true
  []
[]

[GlobalParams]
  PorousFlowDictator = dictator
  gravity = '0 0 0'
[]

[Variables]
  [pwater]
  []
  [temperature]
    initial_condition = 273
  []
[]

[Kernels]
 [mass_dot]
   type = PorousFlowMassTimeDerivative
   fluid_component = 0
   variable = pwater
   block = 'frac' 
 []
 
  [advection]
    type = PorousFlowFullySaturatedDarcyBase
    variable = pwater
    use_displaced_mesh = false
    block = 'frac'
  []


  [heat]
    type = ADHeatConduction
    variable = temperature
    block =  'frac'
  []
#  [energy_dot]
#    type = PorousFlowEnergyTimeDerivative
#    variable = temperature
#        block = 'frac' 
#        thermal_conductivity = k_fracture
#   []

  [convection]
    type = PorousFlowHeatAdvection
    variable = temperature
    block = 'frac'          
 []
#  [heat_conduction]
#    type = PorousFlowHeatConduction
#    variable = temperature
#        block = 'frac'  
#   []

    # ★ box dummy NullKernel ★
  [null_pwater_box]
    type = NullKernel
    variable = pwater
    block = 'box'
  []
  [null_temperature_box]
    type = NullKernel
    variable = temperature
    block = 'box'
  []
[]

[AuxVariables]
  [massfrac_ph0_sp0]
    initial_condition = 1 # all H20 in phase=0
  []
  [velocity_x]
    family = MONOMIAL
    order = CONSTANT
  []
  [velocity_y]
    family = MONOMIAL
    order = CONSTANT
  []
  [velocity_z]
    family = MONOMIAL
    order = CONSTANT
  []
    [lambda_x]
    order = CONSTANT
    family = MONOMIAL
  []
  [lambda_y]
    order = CONSTANT
    family = MONOMIAL
  []
  [lambda_z]
    order = CONSTANT
    family = MONOMIAL
  []
  [rho_f]
    order = FIRST
    family = MONOMIAL
  []
[]

[AuxKernels]
  [velocity_x]
    type = PorousFlowDarcyVelocityComponent
    variable = velocity_x
    component = x
            block = 'frac'
  []
  [velocity_y]
    type = PorousFlowDarcyVelocityComponent
    variable = velocity_y
    component = y
            block = 'frac'
  []
  [velocity_z]
    type = PorousFlowDarcyVelocityComponent
    variable = velocity_z
    component = z
            block = 'frac'
  []
  [rho_f]
    type = PorousFlowPropertyAux
    variable = rho_f
    property = density
    phase = 0
            block = 'frac'
  []
   [lambda_x]
    type = MaterialRealTensorValueAux
    property = PorousFlow_thermal_conductivity_qp
    row = 0
    column = 0
    variable = lambda_x
        block = 'frac'
  []
  [lambda_y]
    type = MaterialRealTensorValueAux
    property = PorousFlow_thermal_conductivity_qp
    row = 1
    column = 1
    variable = lambda_y
        block = 'frac'
  []
  [lambda_z]
    type = MaterialRealTensorValueAux
    property = PorousFlow_thermal_conductivity_qp
    row = 2
    column = 2
    variable = lambda_z
        block = 'frac'
  []
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pwater temperature'
    number_fluid_phases = 1
    number_fluid_components = 1
  []
[]

[FluidProperties]
  [water]
    type = SimpleFluidProperties
    bulk_modulus = 2.2e9
    density0 = 1000
    viscosity = 1e-3
    cp = 0.2
  []
[]

[ICs]
  [mat_pwater]
    type = ConstantIC
    variable = pwater
    value = 0
  []
[]

[BCs]
   [inlet_p]
    type = DirichletBC
    boundary = 5
    variable = pwater
    value = 20000
  []
  [pp1]
    type = DirichletBC
    variable = pwater
    boundary = 6
    value = 0      
    []
 
  [spit_heat]
    type = DirichletBC
    variable = temperature
    boundary = 5
    value = 373
  []
  [suck_heat]
    type = DirichletBC
    variable = temperature
    boundary = 6
    value = 273  # 
    []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
    temperature = temperature
  []
  [massfrac]
    type = PorousFlowMassFraction
  []
  [porosity_box]
    type = PorousFlowPorosityConst
    porosity = 2e-4
    block = 'box'
  []
  [rock_heat]
    type = PorousFlowMatrixInternalEnergy
    specific_heat_capacity = 800
    density = 1700
    block = 'box'
  []
  [permeability_box]
    type = PorousFlowPermeabilityConst
    permeability = '0 0 0  0 0 0  0 0 0'
    block = 'box'
  []

  [rock_heat2]
    type = PorousFlowMatrixInternalEnergy
    specific_heat_capacity = 0
    density = 0
    block = 'frac'
  []
  # only fluid in frac
  [porosity_frac]
    type = PorousFlowPorosityConst
    porosity = 1
    block = 'frac'
  []
  [simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = water
    phase = 0
    block = 'frac'
  []
  [PS]
    type = PorousFlow1PhaseFullySaturated
    porepressure = pwater
    block = 'frac'
  []
  [relperm]
    type = PorousFlowRelativePermeabilityConst
    phase = 0
    block = 'frac'
  []
  [permeability_frac]
    type = PorousFlowPermeabilityConst
    permeability = '1.2e-9 0 0   0 1.2e-9 0   0 0 1.2e-9'
    block = 'frac'
  []

  #（k_f = 1.6 W/m/K ）
  [lambda_frac]
    type = PorousFlowThermalConductivityFromPorosity
    lambda_s = '0 0 0  0 0 0  0 0 0'
    lambda_f = '1.6 0 0  0 1.6 0  0 0 1.6'
    block = 'frac'#      
    []
 
  #  [k_fracture]
  #  type = ADGenericConstantMaterial
  #  prop_names = 'thermal_conductivity'
  #  prop_values = '16.6'#
  #  []
[]

[Preconditioning]
  active = basic
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
  [preferred_but_might_not_be_installed]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time = 5000
  compute_scaling_once = false
   [TimeStepper]
    type = IterationAdaptiveDT
    #optimal_iterations = 10
    growth_factor = 2
    #linear_iteration_ratio = 20 #
    dt = 0.01
    []
  dtmax = 0.5
  dtmin=1e-8
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  nl_forced_its = 1
  #automatic_scaling = true 
[]



[Outputs]
  exodus = true
  print_linear_residuals = true
[exodus_all_time]
  type = Exodus
  file_base = result_time_step
[]
[]
