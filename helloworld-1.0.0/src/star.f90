module star
  implicit none
contains
  subroutine printstar(n)
    integer, intent(in) :: n
    integer :: i

    print*, ('*', i = 1,n)
  end subroutine printstar
end module star

