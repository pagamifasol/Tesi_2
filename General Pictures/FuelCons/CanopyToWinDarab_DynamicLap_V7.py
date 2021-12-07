import numpy as np
import tkinter as tk
from tkinter import filedialog
import re
import os

file_path = os.path.dirname(__file__)

root = tk.Tk()
root.withdraw()

print('Select Canopy .csv file(s)')
DLFiles = filedialog.askopenfilenames(initialdir=file_path)

for DLFile in DLFiles:
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
    dam_3rd_front[mm] dam_3rd_rear[mm] \
    CamberFL[deg] CamberFR[deg] CamberRL[deg] CamberRR[deg] \
    ToeFL[deg] ToeFR[deg] ToeRL[deg] ToeRR[deg] \
    CLA[m2] \
    Fx_FL[kN] Fx_FR[kN] Fx_RL[kN] Fx_RR[kN] \
    Fy_FL[kN] Fy_FR[kN] Fy_RL[kN] Fy_RR[kN] '


    ### Import file
    print('\nLoading file: ',DLFile)

    lookup = 'DynamicLap'

    c=0
    with open(DLFile) as myFile:
        for num, line in enumerate(myFile, 1):
            if num==2:
                names = line
            if lookup in line:
                c = c+1
                if c==2:
                    footerpos = num

    print('Footer position: ', footerpos)
    myFile.close()

    flen=0
    with open(DLFile) as f:
        for i, l in enumerate(f):
            flen = flen + 1

    print('File length: ', flen)
    myFile.close()

    footerlen = flen - footerpos +1

    DL = np.genfromtxt(DLFile,delimiter=',',skip_header=3,skip_footer=footerlen,names=names)


    ### Build output data
    print('File loaded. Extracting columns...')

    wd = np.vstack((DL['tRun'],DL['sRun'],DL['vCar']*3.6,DL['nEngine']/6.28*60,DL['NGear'],DL['gLong']/9.81,-DL['gLat']/9.81,-DL['gVert']/9.81,-DL['aSteerWheel']*57.325,DL['nYaw']*57.325,
                    -DL['xBumpStopFL']*1000,-DL['xBumpStopFR']*1000,-DL['xBumpStopRL']*1000,-DL['xBumpStopRR']*1000,
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
                    -DL['xTriBumpStopF']*1000,-DL['xTriBumpStopR']*1000,
                     DL['aCamberTyreFL']*57.325,DL['aCamberTyreFR']*57.325,DL['aCamberTyreRL']*57.325,DL['aCamberTyreRR']*57.325,
                     DL['aSteerTotalFL']*57.325,DL['aSteerTotalFR']*57.325,DL['aSteerTotalRL']*57.325,DL['aSteerTotalRR']*57.325,
                     DL['CLiftTotal'],
                     DL['FxTyreFL']/1000,DL['FxTyreFR']/1000,DL['FxTyreRL']/1000,DL['FxTyreRR']/1000,
                     DL['FyTyreFL']/1000,DL['FyTyreFR']/1000,DL['FyTyreRL']/1000,DL['FyTyreRR']/1000))

    wd = wd.transpose()

    print('Done.')


    ### Export to file
    print('Exporting to: ',wdFile)

    np.savetxt(wdFile,wd,fmt='%.3f',header=wd_header,delimiter=' ',comments='')

    print('Completed.')

