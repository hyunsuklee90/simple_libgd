import numpy as np

lines = open('font_9_15.txt').readlines()

nc = 255
nx = 9
ny = 15

bmap = np.zeros((nc,nx,ny), dtype=np.int16)

i = -1
for line in lines:
    if (line.find('!') > -1):
        continue
    
    if (line.strip() == ""):
        continue
    
    wd = line.replace(',',' ').split()
    
    i=i+1
    c = int((i)/ny)
    y = i - c*ny
    
    
    bmap[c,:,y] = np.array(wd)
    # print (wd)
    # stop

# %%    
    
fo=open('oo.f90', 'w')


varname='font_x'
fo.write(f'integer :: {varname}({nc},{nx},{ny})\n')
for c in range(nc):
    fo.write(f'data {varname}({c+1},:,:) /&\n   ')
    for y in range(ny):
        for x in range(nx):
    
            if (y == ny-1 and x == nx-1):
                fo.write(f'{bmap[c,x,y]}')
            else:    
                fo.write(f'{bmap[c,x,y]},')
        
        if (y == ny-1):
            fo.write('/\n')
        else:
            fo.write('&\n   ')

fo.close()