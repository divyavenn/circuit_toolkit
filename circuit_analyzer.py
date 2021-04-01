
import numpy as np




class Mesh:
    val = None

    def __init__(self, sym):
        self.sym = sym

# any element can maximum be part of two meshes
class Element:
    def __init__(self, mesh1, mesh2):
        self.mesh1 = mesh1
        self.mesh2 = mesh2 
        self.c = None
        self.v = None
        self.p = None
    def getName(self):
        return "element"
    def findC(self):
        self.c = None
    def findV(self):
        self.v = None
    def findP(self):
        if not((self.c == None) or (self.v == None)):
            self.p = self.c*self.v
    def printStats(self):
        print('For ' + self.getName() + ':\n')
        if not(self.c ==  None):
            print('\t Current Across: ' + str(self.c))
        if not(self.v ==  None):
            print('\t Voltage Across: ' + str(self.v))
        if not(self.p ==  None):
            print('\t Power Across: ' + str(self.p))
        print('\n \n')


class Resistor(Element):
    def __init__(self, ohms, mesh1, mesh2):
        self.ohms = ohms
        super().__init__(mesh1, mesh2)
    def getName(self):
        return ('R_' + str(self.ohms))
    def findC(self):
        if ((isinstance(self.mesh1, Mesh)) and not(isinstance(self.mesh2, Mesh))): 
                self.c = self.mesh1.val;
        elif ((isinstance(self.mesh1, Mesh)) and (isinstance(self.mesh2, Mesh))):
                self.c = self.mesh1.val - self.mesh2.val;
    def findV(self):
        self.v = self.c*self.ohms;

# dir1 can equal either +1 or -1, depending on whether
# the current source flows in the same (+1) or different (-1)
# direction as the current in mesh1


class CurrentSource(Element):
    def __init__(self, amps, mesh1, dir1, mesh2):
        self.amps = amps
        self.dir1 = dir1
        super().__init__(mesh1, mesh2)
        self.c = amps
    def getName(self):
        return ('Is_' + str(self.amps))
    def findC(self):
            self.c = self.amps

# dir1 can equal +1 or -1, depending on whether
# the voltage source absorbs(+1) or delivers (-1)
# power in mesh1's current.


class VoltageSource(Element):
    def __init__(self, volts, mesh1, dir1, mesh2):
        self.volts = volts
        self.dir1 = dir1
        super().__init__(mesh1, mesh2)
        self.v = volts 
    def getName(self):
        return ('Vs_' + str(self.volts))
    def findC(self):
        if ((isinstance(self.mesh1, Mesh)) and not(isinstance(self.mesh2, Mesh))): 
                self.c = self.mesh1.val;
        elif ((isinstance(self.mesh1, Mesh)) and (isinstance(self.mesh2, Mesh))):
                self.c = self.mesh1.val - self.mesh2.val;
    def findV(self):
            self.v = self.volts
'''
class DepVoltageSource(Element):
    def __init__(self, k, mesh1, dir1, mesh2, dmesh1, dmesh2):
        self.k = k
        self.dir1 = dir1
        self.dmesh1 = dmesh1
        self.dmesh2 = dmesh2
        super().__init__(mesh1, mesh2)
    def getName(self):
        return ('dVs_' + str(self.k))
'''
# Define meshes
numMeshes = 3
m = []
for i in range(numMeshes):
    m.append(Mesh(i))

# Add elements
# For voltage sources
# CURRENT SOURCES MUST BE LAST
elem = []
elem.append(Resistor(-10*1j, m[0], m[2]))
elem.append(Resistor(10*1j, m[2], None))
elem.append(Resistor(10, m[0], m[1]))
elem.append(Resistor(10, m[1], m[2]))


elem.append(VoltageSource(-50*1j, m[0], -1, None))
elem.append(VoltageSource(25*1j, m[1], -1, None))

# INITLIAZE SYSTEMS OF EQUATIONS
num_dvs = 0
num_e = numMeshes + num_dvs
equs = np.zeros(numMeshes*numMeshes,dtype=np.complex_)
equs = equs.reshape(numMeshes, numMeshes)
coeff = np.zeros(numMeshes, dtype=np.complex_)
t = np.arange(numMeshes)
toTrim = []

def currentImpact(i):
    # current source is in exactly one mesh - DONE!
    if ((isinstance(i.mesh1, Mesh)) and (not(isinstance(i.mesh2, Mesh)))):
        loc = i.mesh1.sym
        i.mesh1.val = i.amps*i.dir1
        for n in range(numMeshes):
            equs[loc][n] = 0
        for n in range(numMeshes):
            x = equs[n][loc]*i.amps*i.dir1
            equs[n][loc] = 0
            coeff[n] -= x
        toTrim.append(loc)
    elif ((isinstance(i.mesh1, Mesh)) and ((isinstance(i.mesh2, Mesh)))):
        loc1 = i.mesh1.sym
        loc2 = i.mesh2.sym
        for n in range(numMeshes):
            equs[loc1][n] += equs[loc2][n]
            equs[loc2][n] = 0
        coeff[loc1] += coeff[loc2]
        coeff[loc2] = -i.amps*i.dir1
        equs[loc2][loc1] = 1
        equs[loc2][loc2] = -1


#done!
def voltageImpact(v):
    # voltage source has to be in at least one mesh
    if (isinstance(v.mesh1, Mesh)):
        loc = v.mesh1.sym
        coeff[loc] -= v.volts*v.dir1
        if (isinstance(v.mesh2, Mesh)):
            loc2 = v.mesh2.sym
            coeff[loc2] += v.volts*v.dir1

#Done!
def resistorImpact(r):
    # resistor has to be in at least one mesh
    if (isinstance(r.mesh1, Mesh)):
        loc1 = r.mesh1.sym
        equs[loc1][loc1] += r.ohms
        # resistor can max be in two meshes
        if(isinstance(r.mesh2, Mesh)):
            loc2 = r.mesh2.sym
            equs[loc2][loc2] += r.ohms
            equs[loc1][loc2] -= r.ohms
            equs[loc2][loc1] -= r.ohms


def assembleEqus():
    for e in elem:
        if (isinstance(e, Resistor)):
            resistorImpact(e)
        elif (isinstance(e, CurrentSource)):
            currentImpact(e)
        elif (isinstance(e, VoltageSource)):
            voltageImpact(e) 

assembleEqus()
#Array must be trimmed before solving to avoid singular matrix error

for i in toTrim:
        for x in range(len(t)):
            if t[x] == i:
                n = x
        equs = np.delete(equs, n , 0)
        equs = np.delete(equs, n , 1)
        coeff = np.delete(coeff , n , 0)
        t = np.delete(t,n,0)

        
#SOLVE FOR CURRENTS
#numpy's solve cannot handle one-dimensional arrays, so must handle manually
ans = np.zeros(len(coeff),dtype=np.complex_)
if (len(coeff)==1):
    ans[0] = (coeff[0]/equs[0])
else:
    ans = np.linalg.solve(equs, coeff)

#PLACE CURRENTS CORRECTLY IN MESH ARRAY
for i in range(len(t)):
    m[t[i]].val = ans[i]
    
#PRINT ANSWERS
for mesh in m:
    print('Mesh' + str(mesh.sym) + ': ' + str(mesh.val) + ' A')

#POPULATE CORRECT ANSWERS FOR ELEMENTS
for e in elem:
    e.findC()
    e.findV()
    e.findP()
    e.printStats()
