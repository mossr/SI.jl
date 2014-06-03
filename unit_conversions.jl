###### LENGTH UNIT CONVERIONS ######
@conversion kpc_to_km(kpc) = return kpc * 3.08567758 * float32(10)^16
@conversion kpc_to_m(kpc) = return kpc * 3.08567758 * float32(10)^19
@conversion kpc_to_cm(kpc) = return m_to_cm(kpc_to_m(kpc))

@conversion km_to_kpc(km) = return km * 3.24077929 * float32(10)^-17
@conversion km_to_m(km) = return cm_to_m(km_to_cm(km))
@conversion km_to_cm(km) = return kpc_to_cm(km_to_kpc(km))

@conversion m_to_kpc(m) = return m * 3.24077929 * float32(10)^-20
@conversion m_to_km(m) = return m * 0.001
@conversion m_to_cm(m) = return m * 100

@conversion cm_to_kpc(cm) = return km_to_kpc(cm_to_km(cm))
@conversion cm_to_km(cm) = return m_to_km(cm_to_m(cm))
@conversion cm_to_m(cm) = return cm * 0.01

###### TIME UNIT CONVERIONS ######
@conversion s_to_min(s) = return s/60
@conversion s_to_hr(s) = return s_to_min(s)/60

@conversion min_to_s(min) = return min*60
@conversion min_to_hr(min) = return min/60

@conversion hr_to_min(hr) = return hr*60
@conversion hr_to_s(hr) = return hr_to_min(hr)*60

###### DENSITY UNIT CONVERIONS ######
###### GeV/cm^3 to kg/km*s^2 
@conversion GeVcm3_to_kgkms2(GeV) = return GeV * 0.1602117