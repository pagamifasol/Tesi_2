import numpy as np
import tkinter as tk
from tkinter import filedialog
import re
import os

file_path = os.path.dirname(__file__)

root = tk.Tk()
root.withdraw()

print('Select VI-Grade MaxPerformance .csv file(s)')
DLFiles = filedialog.askopenfilenames(initialdir=file_path,filetypes = (("VI-Grade MXP comma separated values","*.csv"),("All files","*.*")))

for DLFile in DLFiles:
    wdFile = DLFile.replace('.csv','_wd.txt')

    wd_header = 'xtime[s] xdist[m] speed[km/h] nmot[rpm] aps[] pbrake_f[bar] \
    gear[n] accx[g] accy[g] accz[g] steer[deg] yaw[deg/s] \
    dam_fl[mm] dam_fr[mm] dam_rl[mm] dam_rr[mm] \
    Ride_AxleFront[mm] Ride_AxleRear[mm] \
    SideSlipFL[deg] SideSlipFR[deg] SideSlipRL[deg] SideSlipRR[deg] SideSlipCG[deg] \
    slip_fl[pct] slip_fr[pct] slip_rl[pct] slip_rr[pct] \
    AeroBalance[pct] \
    Load_FL_Ch1[kN] Load_FR_Ch1[kN] Load_RL_Ch1[kN] Load_RR_Ch1[kN] \
    vwheel_fl[km/h] vwheel_fr[km/h] vwheel_rl[km/h] vwheel_rr[km/h] \
    acc_fl[g] acc_fr[g] acc_rl[g] acc_rr[g] \
    Fz_fl[kN] Fz_fr[kN] Fz_rl[kN] Fz_rr[kN] \
    roll[deg] \
    CamberFL[deg] CamberFR[deg] CamberRL[deg] CamberRR[deg] \
    ToeFL[deg] ToeFR[deg] ToeRL[deg] ToeRR[deg] \
    Fx_FL[kN] Fx_FR[kN] Fx_RL[kN] Fx_RR[kN] \
    Fy_FL[kN] Fy_FR[kN] Fy_RL[kN] Fy_RR[kN] '
    
##    Jounce_FL[mm] Jounce_FR[mm] Jounce_RL[mm] Jounce_RR[mm] \
##Cx[none] \
##    pbrake_f[bar] pbrake_r[bar] \
##    aps[%] me_act[Nm] md_rl[Nm] md_rr[Nm] \
##    damper_force_FC[kN] damper_force_RC[kN] \
##    dam_3rd_front[mm] dam_3rd_rear[mm] \
##    CLA[m2] \

    ### Import file
    print('\nLoading file: ',DLFile)

    c=0
    with open(DLFile) as myFile:
        for num, line in enumerate(myFile, 1):
            if num==1:
                names = line

    myFile.close()

    flen=0
    with open(DLFile) as f:
        for i, l in enumerate(f):
            flen = flen + 1

    print('File length: ', flen)
    myFile.close()

    DL = np.genfromtxt(DLFile,delimiter=',',skip_header=2,names=names)


    ### Build output data
    print('File loaded. Extracting columns...')

    wd = np.vstack((DL['timeTIME'],DL['VehicleOrigin_Distance_Traveled'],DL['Animator_Widgetlongitudinal_speed'],DL['Animator_Widgetengine_rpm'],DL['driver_demandsthrottle'],DL['driver_demandsbrake_pressure'],
                     DL['transmissiongear'],DL['chassis_accelerationslongitudinal'],-DL['chassis_accelerationslateral'],-DL['chassis_accelerationsvertical'],-DL['driver_demandssteering']*57.325,DL['chassis_velocitiesyaw']*57.325,
                    -DL['Jounce_BumperForce_At_BumperL1']*1000,-DL['Jounce_BumperForce_At_BumperR1']*1000,-DL['Jounce_BumperForce_At_BumperL2']*1000,-DL['Jounce_BumperForce_At_BumperR2']*1000,
 ##                   -DL['DamperForce_At_DamperL1']*1000/0.8,-DL['DamperForce_At_DamperR1']*1000/0.8,-DL['DamperForce_At_DamperL2']*1000/0.8,-DL['DamperForce_At_DamperR2']*1000/0.8,
                     DL['aero_forcesheight_front']*1000,DL['aero_forcesheight_rear']*1000,
                     DL['TireLateral_Slip_With_LagL1']*57.325,DL['TireLateral_Slip_With_LagR1']*57.325,DL['TireLateral_Slip_With_LagL2']*57.325,DL['TireLateral_Slip_With_LagR2']*57.325,DL['VehicleSide_Slip_Angle']*57.325,
                     DL['TireLongitudinal_Slip_With_LagL1']*100,DL['TireLongitudinal_Slip_With_LagR1']*100,DL['TireLongitudinal_Slip_With_LagL2']*100,DL['TireLongitudinal_Slip_With_LagR2']*100,
                     DL['aero_forcesaero_balance']*100,## DL['CDragTotal'],
##                     DL['pBrakeFL']/1e5,DL['pBrakeRL']/1e5,
                     DL['Pushrod_LoadL1']/1000,DL['Pushrod_LoadR1']/1000,DL['Pushrod_LoadL2']/1000,DL['Pushrod_LoadR2']/1000,
                    (DL['WheelOmegaL1']*DL['TireEffective_Rolling_RadiusL1'])*3.6,(DL['WheelOmegaR1']*DL['TireEffective_Rolling_RadiusR1'])*3.6,(DL['WheelOmegaL2']*DL['TireEffective_Rolling_RadiusL2'])*3.6,(DL['WheelOmegaR2']*DL['TireEffective_Rolling_RadiusR2'])*3.6,
                     DL['Wheelhub_center_acczfront_left']/9.81,DL['Wheelhub_center_acczfront_right']/9.81,DL['Wheelhub_center_acczrear_left']/9.81,DL['Wheelhub_center_acczrear_right']/9.81,
                    -DL['til_wheel_tire_forcesnormal_front'],-DL['tir_wheel_tire_forcesnormal_front'],-DL['til_wheel_tire_forcesnormal_rear'],-DL['tir_wheel_tire_forcesnormal_rear'],
                     DL['chassis_displacementsroll_wrt_road']*57.325,
##                     DL['rThrottlePedal']*100,DL['MEngine'],DL['MSideShaftRL'],DL['MSideShaftRR'],
##                     DL['FTriBumpStopF']/1000,DL['FTriBumpStopR']/1000,
##                    -DL['xTriBumpStopF']*1000,-DL['xTriBumpStopR']*1000,
                     DL['wheel_anglescamber_wrt_road_L1']*57.325,DL['wheel_anglescamber_wrt_road_R1']*57.325,DL['wheel_anglescamber_wrt_road_L2']*57.325,DL['wheel_anglescamber_wrt_road_R2']*57.325,
                     DL['wheel_anglestoe_L1']*57.325,DL['wheel_anglestoe_R1']*57.325,DL['wheel_anglestoe_L2']*57.325,DL['wheel_anglestoe_R2']*57.325,
##                     DL['CLiftTotal'],
                     DL['til_wheel_tire_forceslongitudinal_front']/1000,DL['tir_wheel_tire_forceslongitudinal_front']/1000,DL['til_wheel_tire_forceslongitudinal_rear']/1000,DL['tir_wheel_tire_forceslongitudinal_rear']/1000,
                     DL['til_wheel_tire_forceslateral_front']/1000,DL['tir_wheel_tire_forceslateral_front']/1000,DL['til_wheel_tire_forceslateral_rear']/1000,DL['tir_wheel_tire_forceslateral_rear']/1000
                    ))

    wd = wd.transpose()

    print('Done.')


    ### Export to file
    print('Exporting to: ',wdFile)

    np.savetxt(wdFile,wd,fmt='%.3f',header=wd_header,delimiter=' ',comments='')

    print('Completed.')

