module init
  use vars
  implicit none
contains

  subroutine init_data()
    call allocate_number()
    call position_init()
    call velocity_init()
    call density_init()
    call pressure_energy_init()
    call merge_init()
    call calculate_init()
  end subroutine init_data

  subroutine allocate_number()
    dim = 2
    num_x_1 = 20
    num_y_1 = 20
    num_x_2 = 20
    num_y_2 = 20

    num_x = num_x_1 + num_x_2
    num_y = num_y_1
    num_1 = num_x_1 * num_y_1
    num_2 = num_x_2 * num_y_2
    num = num_x * num_y

    allocate(xy_1_0(dim,num_1), xy_1(dim,num_1))
    allocate(rho_1_0(num_1), rho_1(num_1), mass_1(num_1), tag_1(num_1))
    allocate(velocity_1_0(dim,num_1), pressure_1(num_1))

    allocate(xy_2_0(dim,num_2), xy_2(dim,num_2))
    allocate(rho_2_0(num_2), rho_2(num_2), mass_2(num_2), tag_2(num_2))
    allocate(velocity_2_0(dim,num_2), pressure_2(num_2))

    allocate(xy_0(dim,num), xy(dim,num), dxy(dim,num))
    allocate(velocity_0(dim,num), velocity(dim,num), velocity_old(dim,num))
    allocate(dvelocity(dim,num), acceleration(dim,num))
    allocate(rho_0(num), rho(num), rho_temp(num), mass(num), tag(num))
    allocate(pressure_0(num), pressure(num), energy_internal(num))
    allocate(stress(dim,dim,num), deviatoric_stress(dim,dim,num))
    allocate(strain_rate_tensor(dim,dim,num), identity(dim,dim))
    allocate(mark(num))
  end subroutine allocate_number

  subroutine position_init()
    integer :: i, j, id

    L_x_1 = 0.0
    R_x_1 = 1.0
    D_y_1 = 0.0
    U_y_1 = 1.0

    L_x_2 = 1.1
    R_x_2 = 2.1
    D_y_2 = 0.0
    U_y_2 = 1.0

    dx_1 = abs(R_x_1 - L_x_1) / real(num_x_1)
    dy_1 = abs(U_y_1 - D_y_1) / real(num_y_1)
    dx_2 = abs(R_x_2 - L_x_2) / real(num_x_2)
    dy_2 = abs(U_y_2 - D_y_2) / real(num_y_2)

    do i = 1, num_x_1
      do j = 1, num_y_1
        id = (i - 1) * num_y_1 + j
        xy_1_0(1,id) = L_x_1 + (i - 0.5) * dx_1
        xy_1_0(2,id) = D_y_1 + (j - 0.5) * dy_1
      end do
    end do

    do i = 1, num_x_2
      do j = 1, num_y_2
        id = (i - 1) * num_y_2 + j
        xy_2_0(1,id) = L_x_2 + (i - 0.5) * dx_2
        xy_2_0(2,id) = D_y_2 + (j - 0.5) * dy_2
      end do
    end do

    xy_1 = xy_1_0
    xy_2 = xy_2_0
  end subroutine position_init

  subroutine velocity_init()
    integer :: i, j, id

    velocity_1_0 = 0.0
    velocity_2_0 = 0.0

    do i = 1, num_x_1
      do j = 1, num_y_1
        id = (i - 1) * num_y_1 + j
        velocity_1_0(1,id) = 0.05
        tag_1(id) = 1.0
      end do
    end do

    do i = 1, num_x_2
      do j = 1, num_y_2
        id = (i - 1) * num_y_2 + j
        tag_2(id) = 2.0
      end do
    end do
  end subroutine velocity_init

  subroutine density_init()
    rho_init = 18.087
    rho_1_0 = rho_init
    rho_2_0 = rho_init
    rho_1 = rho_1_0
    rho_2 = rho_2_0
    mass_1 = dx_1 * dy_1 * rho_init
    mass_2 = dx_2 * dy_2 * rho_init
  end subroutine density_init

  subroutine pressure_energy_init()
    c = 0.0251
    s = 0.151
    gamma_eos = 2.03
    shear_modulus = 0.0
    energy_internal = 0.0
    pressure_1 = 0.0
    pressure_2 = 0.0
  end subroutine pressure_energy_init

  subroutine merge_init()
    integer :: i

    dx = dx_1
    dy = dy_1

    do i = 1, num_1
      xy_0(:,i) = xy_1_0(:,i)
      velocity_0(:,i) = velocity_1_0(:,i)
      mass(i) = mass_1(i)
      rho_0(i) = rho_1_0(i)
      pressure_0(i) = pressure_1(i)
      tag(i) = tag_1(i)
    end do

    do i = num_1 + 1, num
      xy_0(:,i) = xy_2_0(:,i-num_1)
      velocity_0(:,i) = velocity_2_0(:,i-num_1)
      mass(i) = mass_2(i-num_1)
      rho_0(i) = rho_2_0(i-num_1)
      pressure_0(i) = pressure_2(i-num_1)
      tag(i) = tag_2(i-num_1)
    end do

    xy = xy_0
    velocity = velocity_0
    rho = rho_0
    pressure = pressure_0
  end subroutine merge_init

  subroutine calculate_init()
    h = 1.5 * dx
    dt = 0.02
    t = 3.0
    identity = 0.0
    identity(1,1) = 1.0
    identity(2,2) = 1.0
  end subroutine calculate_init
end module init
