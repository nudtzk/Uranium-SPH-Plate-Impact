module subs
  use vars
  implicit none
contains

  subroutine density()
    integer :: i, j
    real :: d_rho
    real :: relative_velocity(2), grad_w(2)

    rho_temp = rho
    do i = 1, num
      d_rho = 0.0
      do j = 1, num
        relative_velocity = velocity(:,i) - velocity(:,j)
        call gradient_w(i, j, grad_w, h)
        d_rho = d_rho + mass(j) * dot_product(relative_velocity, grad_w) * dt
      end do
      rho(i) = rho_temp(i) + d_rho
    end do
  end subroutine density

  subroutine strain_rate()
    integer :: i, j
    real :: grad_w(2), relative_velocity(2), divergence

    strain_rate_tensor = 0.0
    do i = 1, num
      do j = 1, num
        relative_velocity = velocity(:,j) - velocity(:,i)
        call gradient_w(i, j, grad_w, h)
        divergence = dot_product(relative_velocity, grad_w)
        strain_rate_tensor(1,1,i) = strain_rate_tensor(1,1,i) + &
          2.0 * mass(j) / rho(j) * relative_velocity(1) * grad_w(1) - &
          (2.0 / 3.0) * mass(j) / rho(j) * divergence
        strain_rate_tensor(1,2,i) = strain_rate_tensor(1,2,i) + &
          mass(j) / rho(j) * (relative_velocity(2) * grad_w(1) + relative_velocity(1) * grad_w(2))
        strain_rate_tensor(2,1,i) = strain_rate_tensor(1,2,i)
        strain_rate_tensor(2,2,i) = strain_rate_tensor(2,2,i) + &
          2.0 * mass(j) / rho(j) * relative_velocity(2) * grad_w(2) - &
          (2.0 / 3.0) * mass(j) / rho(j) * divergence
      end do
    end do
  end subroutine strain_rate

  subroutine pressure_linear()
    integer :: i
    do i = 1, num
      pressure(i) = c**2 * rho(i)
    end do
  end subroutine pressure_linear

  subroutine stress_update()
    integer :: i
    do i = 1, num
      deviatoric_stress(:,:,i) = shear_modulus * strain_rate_tensor(:,:,i)
      stress(:,:,i) = -pressure(i) * identity(:,:) + deviatoric_stress(:,:,i)
    end do
  end subroutine stress_update

  subroutine kinematic()
    integer :: i, j
    real :: grad_w(2), q

    dvelocity = 0.0
    q = 0.0
    do i = 1, num
      do j = 1, num
        call gradient_w(i, j, grad_w, h)
        dvelocity(1,i) = dvelocity(1,i) + mass(j) * &
          ((stress(1,1,i) / rho(i)**2 + stress(1,1,j) / rho(j)**2 + q) * grad_w(1))
        dvelocity(2,i) = dvelocity(2,i) + mass(j) * &
          ((stress(2,2,i) / rho(i)**2 + stress(2,2,j) / rho(j)**2 + q) * grad_w(2))
      end do
    end do
    dvelocity = dvelocity * dt
  end subroutine kinematic

  subroutine energy()
    integer :: i, j
    real :: grad_w(2), de, relative_velocity(2)

    do i = 1, num
      de = 0.0
      do j = 1, num
        relative_velocity = velocity(:,i) - velocity(:,j)
        call gradient_w(i, j, grad_w, h)
        de = de + 0.5 * mass(j) * ( &
          ((stress(1,1,i) / rho(i)**2 + stress(1,1,j) / rho(j)**2) * grad_w(1) + &
           (stress(1,2,i) / rho(i)**2 + stress(1,2,j) / rho(j)**2) * grad_w(2)) * (-relative_velocity(1)) + &
          ((stress(2,1,i) / rho(i)**2 + stress(2,1,j) / rho(j)**2) * grad_w(1) + &
           (stress(2,2,i) / rho(i)**2 + stress(2,2,j) / rho(j)**2) * grad_w(2)) * (-relative_velocity(2)) )
      end do
      energy_internal(i) = energy_internal(i) + de * dt
    end do
  end subroutine energy

  subroutine gruneisen()
    integer :: i
    real :: ph, eh, rho_ref, rho_now, denominator

    do i = 1, num
      rho_ref = rho_0(i)
      rho_now = rho(i)
      denominator = rho_ref - s * (rho_ref - rho_now)
      if (abs(denominator) < 1.0e-12) denominator = sign(1.0e-12, denominator)
      ph = c**2 * (rho_ref - rho_now) / denominator**2
      eh = 0.5 * ph * (rho_ref - rho_now)
      pressure(i) = ph + gamma_eos * rho_now * (energy_internal(i) - eh)
    end do
  end subroutine gruneisen

  subroutine movement()
    integer :: i
    do i = 1, num
      velocity_old(:,i) = velocity(:,i)
      velocity(:,i) = velocity_old(:,i) + dvelocity(:,i)
      dxy(:,i) = 0.5 * (velocity(:,i) + velocity_old(:,i)) * dt
      xy(:,i) = xy(:,i) + dxy(:,i)
    end do
  end subroutine movement

  real function kernel_w(i, j, h_value)
    integer, intent(in) :: i, j
    real, intent(in) :: h_value
    real :: pi, alpha_d, r, distance
    real :: vector_ij(2)

    pi = acos(-1.0)
    vector_ij = xy(:,i) - xy(:,j)
    distance = sqrt(dot_product(vector_ij, vector_ij))
    r = distance / h_value
    if (r > 1.0) then
      kernel_w = 0.0
    else
      alpha_d = 5.0 / (pi * h_value**2)
      kernel_w = alpha_d * (1.0 + 3.0 * r) * (1.0 - r)**3
    end if
  end function kernel_w

  subroutine gradient_w(i, j, grad_w, h_value)
    integer, intent(in) :: i, j
    real, intent(out) :: grad_w(2)
    real, intent(in) :: h_value
    real :: pi, alpha_d, r, distance, grad
    real :: vector_ij(2)

    grad_w = 0.0
    if (i == j) return

    pi = acos(-1.0)
    vector_ij = xy(:,i) - xy(:,j)
    distance = sqrt(dot_product(vector_ij, vector_ij))
    if (distance <= 1.0e-12) return

    r = distance / h_value
    if (r > 1.0) return

    alpha_d = 5.0 / (pi * h_value**2)
    grad = alpha_d * (3.0 * (1.0 - r)**3 - 3.0 * (1.0 - r)**2 * (1.0 + 3.0 * r)) / &
      (h_value * distance)
    grad_w = grad * vector_ij
  end subroutine gradient_w

  subroutine init_output()
    integer :: i
    open(100, file="ans_initial.txt", status="replace")
    do i = 1, num
      write(100,*) xy(1,i), xy(2,i), velocity(1,i), pressure(i), tag(i)
    end do
    close(100)
  end subroutine init_output

  subroutine terminate_output()
    integer :: i
    open(101, file="ans_final.txt", status="replace")
    do i = 1, num
      write(101,*) xy(1,i), xy(2,i), rho(i), pressure(i), tag(i)
    end do
    close(101)
  end subroutine terminate_output
end module subs
