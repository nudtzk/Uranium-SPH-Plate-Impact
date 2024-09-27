# -*- coding: utf-8 -*-
"""
Created on Mon Oct 19 08:14:30 2020

@author: Wountry
"""

import math
from matplotlib import pyplot as plt  
import numpy as np  


dt=0.00001
x11=0
x21=5
x31=10
k=10
l1=5
l2=5
t=0
m1=1
m2=2
m3=3
p=[]
q1=[]
q2=[]
q3=[]
v11=2
v21=0
v31=0

while (t<20):
  
    p.append(t)
    q1.append(x11)
    q2.append(x21)
    q3.append(x31)
    f1=k*(x21-x11-l1)
    f2=k*(x31-x21-l2)
      
    a11=f1/m1
    a21=(f2-f1)/m2
    a31=-f2/m3
    
    v12=v11+a11*dt
    v22=v21+a21*dt
    v32=v31+a31*dt
    
    x12=x11+v11*dt
    x22=x21+v21*dt
    x32=x31+v31*dt
    
    t=t+dt
    x11=x12
    x21=x22
    x31=x32
    
    v11=v12
    v21=v22
    v31=v32


plt.scatter(p,q1,s=10)
plt.scatter(p,q2,s=10)
plt.scatter(p,q3,s=10)

plt.show