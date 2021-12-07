import numpy as np
import tkinter as tk
from tkinter import filedialog

root = tk.Tk()
root.withdraw()

crtFile = filedialog.askopenfilename()
wdFile = crtFile.replace('.csv','_wd.txt')

wd_header = 'xtime[s] xdist[m] speed[km/h] nmot[rpm] gear[n] \
accx[g] accy[g] steer[deg] yaw[deg/s] \
aps[%] pbrake_f[bar]'

print('Loading file: ', crtFile)

crt = np.genfromtxt(crtFile,delimiter=',',skip_header=0,names=True)

print('File loaded. Extracting columns...')

wd  = np.vstack((crt['time.TIME'],crt['driving_machine_monitor.path_distance'],crt['Animator_Widget.longitudinal_speed'],crt['Animator_Widget.engine_rpm'],
                 crt['chassis_accelerations.longituddinal'],crt['chassis_acceleration.lateral'],crt['driver_demands.steering'],crt['chassis_velocities.yaw'],
                 crt['driver_demands.throttle'],crt['driver_demands.brake_pressure']))

wd = wd.transpose()

print('Done.')
print('Exporting to: ', wdFile)

np.savetxt(wdFile,wd,fmt='%.3f',header=wd_header,delimiter=' ',comments='')

print('Completed.')
                 
