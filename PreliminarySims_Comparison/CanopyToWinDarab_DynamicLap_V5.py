import numpy as np
import tkinter as tk
from tkinter import filedialog

root = tk.Tk()
root.withdraw()

DLFile = filedialog.askopenfilename()
wdFile = DLFile.replace('.csv','_wd.txt')

wd_header = 'xtime[s] xdist[m] speed[km/h] nmot[rpm] gear[n] accx[g] accy[g] accz[g] steer[deg] yaw[deg/s] \
dam_fl[mm] dam_fr[mm] dam_rl[mm] dam_rr[mm] \
Jounce_FL[mm] Jounce_FR[mm] Jounce_RL[mm] Jounce_RR[mm] \
Ride_AxleFront[mm] Ride_AxleRear[mm] \
SideSlipFL[deg] SideSlipFR[deg] SideSlipRL[deg] SideSlipRR[deg] SideSlipCG[deg] \
slip_fl[pct] slip_fr[pct] slip_rl[pct] slip_rr[pct] \
AeroBalance[pct] Cx[none] \
pbrake_f[bar] pbrake_r[bar] \
Load_FL_Ch1[kN] Load_FR_Ch1[kN] Load_RL_Ch1[kN] Load_RR_Ch1[kN] \
vwheel_fl[km/h] vwheel_fr[km/h] vwheel_rl[km/h] vwheel_rr[km/h] \
acc_fl[g] acc_fr[g] acc_rl[g] acc_rr[g] \
Fz_fl[kN] Fz_fr[kN] Fz_rl[kN] Fz_rr[kN] \
roll[deg] \
aps[%] me_act[Nm] md_rl[Nm] md_rr[Nm] \
damper_force_FC[kN] damper_force_RC[kN] \
dam_3rd_front[mm] dam_3rd_rear[mm] '

print('Loading file: ',DLFile)

DL = np.genfromtxt(DLFile,delimiter=',',skip_header=1,names=True)

print('File loaded. Extracting columns...')

wd = np.vstack((DL['tRun'],DL['sRun'],DL['vCar']*3.6,DL['nEngine']/6.28*60,DL['NGear'],DL['gLong']/9.81,-DL['gLat']/9.81,-DL['gVert']/9.81,-DL['aSteerWheel']*57.325,DL['nYaw']*57.325,
                -DL['xDamperFL']*1000,-DL['xDamperFR']*1000,-DL['xDamperRL']*1000,-DL['xDamperRR']*1000,
                -DL['xDamperFL']*1000/0.8,-DL['xDamperFR']*1000/0.8,-DL['xDamperRL']*1000/0.8,-DL['xDamperRR']*1000/0.8,
                 DL['hRideF']*1000,DL['hRideR']*1000,
                 DL['aSlipTyreFL']*57.325,DL['aSlipTyreFR']*57.325,DL['aSlipTyreRL']*57.325,DL['aSlipTyreRR']*57.325,DL['aSlipCar']*57.325,
                 DL['rSlipTyreFL']*100,DL['rSlipTyreFR']*100,DL['rSlipTyreRL']*100,DL['rSlipTyreRR']*100,
                 DL['rAeroBalTotalF']*100,DL['CDragTotal'],
                 DL['pBrakeFL']/1e5,DL['pBrakeRL']/1e5,
                 DL['FPushRodFL']/1000,DL['FPushRodFR']/1000,DL['FPushRodRL']/1000,DL['FPushRodRR']/1000,
                (DL['nWheelFL']*DL['rTyreRollingRadiusFL'])*3.6,(DL['nWheelFR']*DL['rTyreRollingRadiusFR'])*3.6,(DL['nWheelRL']*DL['rTyreRollingRadiusRL'])*3.6,(DL['nWheelRR']*DL['rTyreRollingRadiusRR'])*3.6,
                 DL['gVertHubFL']/9.81,DL['gVertHubFR']/9.81,DL['gVertHubRL']/9.81,DL['gVertHubRR']/9.81,
                -DL['FzTyreFL'],-DL['FzTyreFR'],-DL['FzTyreRL'],-DL['FzTyreRR'],
                 DL['aRoll']*57.325,
                 DL['rThrottlePedal']*100,DL['MEngine'],DL['MSideShaftRL'],DL['MSideShaftRR'],
                 DL['FTriBumpStopF']/1000,DL['FTriBumpStopR']/1000,
                -DL['xTriBumpStopF']*1000,-DL['xTriBumpStopR']*1000))

wd = wd.transpose()

print('Done.')
print('Exporting to: ',wdFile)

np.savetxt(wdFile,wd,fmt='%.3f',header=wd_header,delimiter=' ',comments='')

print('Completed.')
