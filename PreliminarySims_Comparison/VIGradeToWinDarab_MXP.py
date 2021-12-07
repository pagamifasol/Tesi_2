import numpy as np
import tkinter as tk
from tkinter import filedialog

root = tk.Tk()
root.withdraw()

crtFile = filedialog.askopenfilename()
wdFile = crtFile.replace('.csv','_wd.txt')

wd_header = 'xtime [s] xdist [m] Speed [km/h] nmot [rpm] gear [] accx [g] accy [g] steer [deg] yaw [deg/s] \
dam_fl [mm] dam_fr [mm] dam_rl [mm] dam_rr [mm] \
rh_front [mm] rh_rear [mm]    \
slip_lat_fl [deg] slip_lat_fr [deg] slip_lat_rl [deg] slip_lat_rr [deg] slip_lat_CG [deg] \
slip_lon_fl [pct] slip_lon_fr [pct] slip_lon_rl [pct] slip_lon_rr [pct] \
aero_balance [pct]'

print('Loading file: ',crtFile)

crt = np.genfromtxt(crtFile,delimiter=',',skip_header=1)

print('File loaded. Extracting columns...')

wd = np.vstack((crt[:,0],crt[:,209],crt[:,103],crt[:,217],crt[:,713],crt[:,88],-crt[:,87],crt[:,195]*57.325,crt[:,107]*57.325,
                crt[:,133]*1000,crt[:,135]*1000,crt[:,134]*1000,crt[:,136]*1000,
                crt[:,12]*1000,crt[:,13]*1000,
                crt[:,632]*57.325,crt[:,634]*57.325,crt[:,633]*57.325,crt[:,635]*57.325,crt[:,765]*57.325,
                crt[:,648]*100,crt[:,650]*100,crt[:,649]*100,crt[:,651]*100,
                crt[:,1]*100))

wd = wd.transpose()

print('Done.')
print('Exporting to: ',wdFile)

np.savetxt(wdFile,wd,fmt='%.6f',header=wd_header,delimiter=' ',comments='')

print('Completed.')
