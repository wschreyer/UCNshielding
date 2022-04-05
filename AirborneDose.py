import radioactivedecay as rd
import matplotlib.pyplot as plt
import numpy

with open('Air_Nuclide-specific_EffectiveDose.txt') as file:
  lines = file.readlines()

dose_coefficients = {}
for line in lines[9:-1]:
  fields = line.split()
  dose_coefficients[rd.nuclide.Nuclide(fields[0]).nuclide] = float(fields[1]) # nSv/h per Bq/m3
  
inhale_coefficients = {'H-3': 1.8e-6*1.2,
                       'Be-7': 5.2e-2*1.2,
                       'Be-10': 3.2e1*1.2,
                       'C-11': 2.2e-3*1.2,
                       'C-14': 6.5e-3*1.2,
                       'F-18': 9.3e-2*1.2,
                       'Na-22': 2.0e0*1.2,
                       'Na-24': 5.3e-1*1.2,
                       'Mg-28': 1.7e0*1.2,
                       'Al-26': 1.8e1*1.2,
                       'Si-31': 1.1e-1*1.2,
                       'Si-32': 1.1e2*1.2,
                       'P-32': 3.2e0*1.2,
                       'P-33': 1.4e0*1.2,
                       'S-35': 1.3e0*1.2} # nSv/h per Bq/m3 (1.2 m3/h breathing)

release_limits = {'H-3': 6.37e16,
                  'C-11': 1.09e16,
                  'N-13': 1.37e16,
                  'O-15': 5.00e16,
                  'Ar-41': 7.14e15} # Bq out BL1A stack


proton_rate = 2.499e14 # 1/s
duct_volume = 4.232 # m3

for filename, simulation_volume, air_volume, name in zip(['ucn_21_tab.lis', 'ucn_22_tab.lis'], [0.947670, 0.462550], [72, 2.8], ['Cryostat pit', 'Target pit']):
  with open(filename) as file:
    lines = file.readlines()

  fig, axes = plt.subplots(1, 2, figsize = (12, 6))

  for line in lines:
    fields = line.split()
    if fields[0] != '#' and len(fields) == 4:
      nuclide_production = float(fields[2]) * proton_rate / simulation_volume * air_volume # nuclides/s
      delta = float(fields[3])/100.
      if nuclide_production != 0:
        zzzaaassss = '{0:03d}{1:03d}0000'.format(int(fields[1]), int(fields[0]))
        try:
          nuc = rd.nuclide.Nuclide(int(zzzaaassss))
        except ValueError:
          print('No half life data for ' + zzzaaassss)
          continue
        if nuc.half_life() < float('inf'):
          decay_rate = 1./numpy.log(2)/nuc.half_life()
          if nuc.nuclide not in dose_coefficients:
            print('No dose coefficients for ' + nuc.nuclide)
          airExchangeRate = numpy.logspace(1, 4) # m3/h
          
          released_activity = nuclide_production*decay_rate * numpy.exp(-duct_volume/2./airExchangeRate*3600*decay_rate) * 3600. * 1500 # Bq/1500 h, assume air rate through duct is same for both areas (2x)
          equilibrium_activity = 0.25*nuclide_production*(1. - numpy.exp(-air_volume/airExchangeRate*3600.*decay_rate)) # Bq, assume 25% duty cycle
          doserate = dose_coefficients[nuc.nuclide] * equilibrium_activity/air_volume / 1000. # uSv/h
          if max(doserate) > 0.1:
            color = axes[1].fill_between(airExchangeRate, doserate - doserate*delta, doserate + doserate*delta, label = nuc.nuclide + ' (immersion)').get_facecolor()
            axes[0].fill_between(airExchangeRate, released_activity - released_activity*delta, released_activity + released_activity*delta, label = nuc.nuclide, color = color)
            if nuc.nuclide in release_limits:
              axes[0].hlines(release_limits[nuc.nuclide], min(airExchangeRate), max(airExchangeRate), linestyles = 'dashed', color = color, label = 'Release limit')
          if nuc.nuclide in inhale_coefficients:
            doserate = inhale_coefficients[nuc.nuclide] * equilibrium_activity / 1000. # uSv/h
            if max(doserate) > 0.1:
              axes[1].fill_between(airExchangeRate, doserate - doserate*delta, doserate + doserate*delta, label = nuc.nuclide + ' (inhalation)')

  ax1 = axes[0].secondary_xaxis('top', functions = (lambda x: x*0.589, lambda x: x/0.589))
  axes[0].set_ylim(1e6)
  axes[0].set_xlabel('Air exchange rate (m$^3$/h)')
  ax1.set_xlabel('Air exchange rate (cfm)')
  axes[0].set_ylabel('Released activity (Bq/1500 h)')
  axes[0].set_xscale('log')
  axes[0].set_yscale('log')
  axes[0].set_title(name)
  axes[0].legend(loc = 'lower right')

  ax1 = axes[1].secondary_xaxis('top', functions = (lambda x: x*0.589, lambda x: x/0.589))
  ax2 = axes[1].secondary_yaxis('right', functions = (lambda y: y/10, lambda y: y*10))
  axes[1].set_xlabel('Air exchange rate (m$^3$/h)')
  axes[1].set_ylabel('25% duty-cycle-averaged dose rate (uSv/h)')
  ax1.set_xlabel('Air exchange rate (cfm)')
  ax2.set_ylabel('Derived air concentration')
  axes[1].set_xscale('log')
  axes[1].set_yscale('log')
  axes[1].set_title(name)
  axes[1].legend(loc = 'lower left')
  plt.tight_layout()
  fig.savefig(name + '.pdf')
  plt.show()
  
