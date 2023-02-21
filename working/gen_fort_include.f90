program main
implicit none
integer ::  fi=11
integer ::  nx, ny, nc
integer ::  c, x, y
integer ::  map

nc = 255
nx = 9
ny = 15

allocate(map(1:nc,1:nx,1:ny))
map = 0

open(fi, file='font_9_15.txt', 'w')


do c=1,nc
   do y=1,ny
      read(fi,*) (map(n,x,y), x=1,nx)
   end do
end do

close(fi)

write(*,'(9I)') map(52,:,:)

end program main
