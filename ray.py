import sys
import struct
import pandas
import matplotlib.pyplot as plt
import matplotlib.colors
import numpy

if len(sys.argv) > 1:
  fn = sys.argv[1]
else:
  exit()

f = open(fn, 'rb')
data = {'x': [], 'y': [], 'z': [], 'E': [], 'R': [], 'theta': [], 'phi': [], 'conc': [], 'steel': []}
while f:
  cumConcrete = 0.
  cumSteel = 0.

  if f.read(4) == b'':
    break
  NRAYRN = struct.unpack('i', f.read(4))
  MREG = struct.unpack('i', f.read(4))
  MLATTC = struct.unpack('q', f.read(8))
  MMAT = struct.unpack('i', f.read(4))
  EKIN = struct.unpack('f', f.read(4))

  f.read(8)
  XX = struct.unpack('f', f.read(4))
  YY = struct.unpack('f', f.read(4))
  ZZ = struct.unpack('f', f.read(4))
  R2 = struct.unpack('f', f.read(4))
  R3 = struct.unpack('f', f.read(4))
  THETAP = struct.unpack('f', f.read(4))
  PHIPOS = struct.unpack('f', f.read(4))

  f.read(8)
  TXX = struct.unpack('f', f.read(4))
  TYY = struct.unpack('f', f.read(4))
  TZZ = struct.unpack('f', f.read(4))
  THETAD = struct.unpack('f', f.read(4))
  PHIDIR = struct.unpack('f', f.read(4))
  ETADIR = struct.unpack('f', f.read(4))

  while True:
    f.read(8)
    MREGLD = struct.unpack('i', f.read(4))
    MLATLD = struct.unpack('q', f.read(8))
    MMATLD = struct.unpack('i', f.read(4))
    MATNAM = struct.unpack('8s', f.read(8))
    IDISC = struct.unpack('i', f.read(4))

    f.read(8)
    XX = struct.unpack('f', f.read(4))
    YY = struct.unpack('f', f.read(4))
    ZZ = struct.unpack('f', f.read(4))
    R2 = struct.unpack('f', f.read(4))
    R3 = struct.unpack('f', f.read(4))
    THETAP = struct.unpack('f', f.read(4))
    PHIPOS = struct.unpack('f', f.read(4))

    f.read(8)
    RCM = struct.unpack('f', f.read(4))
    ALAMDI = struct.unpack('f', f.read(4))
    ALAMDP = struct.unpack('f', f.read(4))
    ALAMDN = struct.unpack('f', f.read(4))
    ALAMDG = struct.unpack('f', f.read(4))
    ALAMDR = struct.unpack('f', f.read(4))
    DEKMIP = struct.unpack('f', f.read(4))
    GMOCM2 = struct.unpack('f', f.read(4))
    DELAGE = struct.unpack('f', f.read(4))

    f.read(8)
    RCMTOT = struct.unpack('f', f.read(4))
    ALITOT = struct.unpack('f', f.read(4))
    ALPTOT = struct.unpack('f', f.read(4))
    ALNTOT = struct.unpack('f', f.read(4))
    ALGTOT = struct.unpack('f', f.read(4))
    ALRTOT = struct.unpack('f', f.read(4))
    TOTMIP = struct.unpack('f', f.read(4))
    SRHTOT = struct.unpack('f', f.read(4))
    AGEAGE = struct.unpack('f', f.read(4))

    if MATNAM[0] in [b'CONCRETE', b'SOIL    ']:
      cumConcrete = cumConcrete + RCM[0]
    elif MATNAM[0] in [b'Stainles', b'INGOT   ', b'ENESOLUT', b'IRONLITE', b'A36STEEL', b'NEWPB   ']:
      cumSteel = cumSteel + RCM[0]
    elif MATNAM[0] not in [b'AIR     ', b'VACUUM  ', b'ALUMINUM']:
      print(MATNAM[0])

    data['x'].append(XX[0]/100.)
    data['y'].append(YY[0]/100.)
    data['z'].append(ZZ[0]/100.)
    data['E'].append(EKIN[0])
    data['R'].append(RCMTOT[0]/100.)
    data['theta'].append(THETAD[0])
    data['phi'].append(PHIDIR[0])
    data['conc'].append(cumConcrete/100.)
    data['steel'].append(cumSteel/100.)

    if IDISC[0] != 0:
      f.read(4)
      break

db = pandas.DataFrame.from_dict(data)
db['mu'] = numpy.arccos(numpy.cos(db['phi'])*numpy.sin(db['theta']))
db['H'] = 17100 * db['E']**0.76 * 0.7 * 140. / db['R']**2 \
                * numpy.exp(-3.2 * db['mu']) \
                * numpy.exp(-db['conc']/0.42) * numpy.exp(-db['steel']/0.21)

cryopit_bottom = db.query(' 1.0 < x <  4.5 and  0.9 < y < 4.6 and  1.2 < z < 4.0')['H'].max()
cryopit_top =    db.query(' 1.0 < x <  4.5 and  0.9 < y < 4.2 and  4.0 < z < 6.0')['H'].max()
cave_right =     db.query('-4.5 < x < -2.9 and -0.8 < y < 3.1 and -0.1 < z < 2.5')['H'].max()
cave_left =      db.query('-4.5 < x < -0.6 and -0.8 < y < 1.5 and -0.1 < z < 2.5')['H'].max()
pumppit =        db.query('-4.5 < x <  1.0 and  0.3 < y < 4.2 and  3.6 < z < 6.0')['H'].max()
print('Cryopit bottom: {0:.2g}\nCryopit top: {1:.2g}\nService cave right: {2:.2g}\nService cave left: {3:.2g}\nPump pit: {4:.2g}'.format(cryopit_bottom, cryopit_top, cave_right, cave_left, pumppit))

#maxidx = db.query('-4.5 < x < -4. and 2.5 < y < 3. and 0 < z < 2.')['H'].idxmax()
db.query('3.5 < z < 4.').plot.scatter('x', 'y', c = 'H', colormap = 'jet', norm = matplotlib.colors.LogNorm(1e-5, 10.))
#print(db.loc[maxidx])
plt.show()
