    module LINK_GD
    USE ISO_C_BINDING
    implicit none
   
    interface  
    subroutine gdImageGif(nx, ny, fmap, fname, s_fname) BIND(C, name='gd_print_image')
    USE ISO_C_BINDING
    ! USE, INTRINSIC :: ISO_C_BINDING!, ONLY: C_INT
    implicit none
    integer(c_int)                 :: nx, ny, s_fname
    integer(c_int), allocatable    :: fmap(:,:,:)
    character(1)                   :: fname
    end subroutine gdImageGif
    
    end interface
    
    contains
    
    subroutine test1()
    implicit none
    integer                         ::  x, y
    integer(c_int)                  :: nx, ny
    integer(c_int), allocatable     :: fmap(:,:,:)
    character(128)                  ::  fname
    
    nx = 20000
    ny = 20000
    write(*,*) ""
    write(*,*) "RUN TEST1"
    write(*,*) "Allocate Map..."
    allocate(fmap(1:3, 1:nx, 1:ny))
    
    do x=1, nx
        do y= 1, ny
            fmap(1, x, y) = x
            fmap(2, x, y) = 0
            fmap(3, x, y) = 0
        end do
    end do
    
    fname = "test.gif"
    write(*,*) "run gdImageGif..."
    call gdImageGif(nx, ny, fmap, fname(1:1), len(trim(fname)))
    
    end subroutine test1
    
    subroutine test2()
    implicit none
    integer     ::  bmap(5,8)
    data bmap   /0, 0, 0, 0, 0,&
	             0, 0, 1, 0, 0,&
	             0, 1, 1, 0, 0,&
	             1, 0, 1, 0, 0,&
	             1, 1, 1, 1, 0,&
	             0, 0, 1, 0, 0,&
	             0, 0, 1, 0, 0,&
                 0, 0, 0, 0, 0/
    integer                         ::  x, y
    integer(c_int)                  :: nx, ny
    integer(c_int), allocatable     :: fmap(:,:,:)
    character(128)                  ::  fname
    integer                         ::  en=100
    
    
    nx = 5*en
    ny = 8*en
    write(*,*) ""
    write(*,*) "RUN TEST1"
    write(*,*) "Allocate Map..."
    allocate(fmap(1:3, 1:nx, 1:ny))
    
    do x=1, nx
        do y= 1, ny
            fmap(1, x, y) = bmap(int((x-1)/en)+1,int((y-1)/en)+1)*255
            fmap(2, x, y) = 0
            fmap(3, x, y) = 0
        end do
    end do
    
    fname = "test.gif"
    write(*,*) "run gdImageGif..."
    call gdImageGif(nx, ny, fmap, fname(1:1), len(trim(fname)))
    
    end subroutine test2
    
    end module LINK_GD
    
