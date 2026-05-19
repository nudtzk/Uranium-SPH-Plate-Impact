module vars
  implicit none

  integer, save :: dim
  integer, save :: loop_time
  integer, save :: num_x_1, num_y_1, num_x_2, num_y_2
  integer, save :: num_x, num_y, num_1, num_2, num

  real, save :: t, dt, h
  real, save :: L_x_1, R_x_1, D_y_1, U_y_1
  real, save :: L_x_2, R_x_2, D_y_2, U_y_2
  real, save :: dx_1, dy_1, dx_2, dy_2, dx, dy
  real, save :: c, s, gamma_eos, shear_modulus, rho_init

  real, allocatable, save :: xy_1_0(:,:), xy_2_0(:,:)
  real, allocatable, save :: xy_1(:,:), xy_2(:,:)
  real, allocatable, save :: xy_0(:,:), xy(:,:), dxy(:,:)
  real, allocatable, save :: rho_0(:), rho(:), rho_temp(:), mass(:), tag(:)
  real, allocatable, save :: rho_1_0(:), rho_2_0(:), rho_1(:), rho_2(:)
  real, allocatable, save :: mass_1(:), mass_2(:), tag_1(:), tag_2(:)
  real, allocatable, save :: pressure_0(:), pressure(:), energy_internal(:)
  real, allocatable, save :: velocity_0(:,:), velocity(:,:), velocity_old(:,:)
  real, allocatable, save :: dvelocity(:,:), acceleration(:,:)
  real, allocatable, save :: velocity_1_0(:,:), velocity_2_0(:,:)
  real, allocatable, save :: pressure_1(:), pressure_2(:)
  real, allocatable, save :: stress(:,:,:), deviatoric_stress(:,:,:)
  real, allocatable, save :: strain_rate_tensor(:,:,:), identity(:,:)
  integer, allocatable, save :: mark(:)
end module vars
