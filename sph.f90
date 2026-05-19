program sph_plate_impact
  use vars
  use subs
  use init
  implicit none

  real :: time_begin, time_end

  call init_data()
  call init_output()
  call cpu_time(time_begin)

  do loop_time = 1, int(t / dt)
    if (mod(loop_time, 10) == 0) then
      print *, "Step", loop_time, "of", int(t / dt)
    end if

    call strain_rate()
    call energy()
    call gruneisen()
    call stress_update()
    call kinematic()
    call movement()
    call density()
  end do

  call cpu_time(time_end)
  call terminate_output()
  print *, "Simulation completed in", time_end - time_begin, "seconds"
end program sph_plate_impact
