import numpy as np
import matplotlib.pyplot as plt
import csv

file_1 = open('SoundScape1.txt', 'r')
file_2 = open('SoundScape2.txt', 'r')


dat_1 = np.loadtxt('participant_1_condition_A.txt', delimiter=',')
dat_2 = np.loadtxt('participant_1_condition_B.txt', delimiter=',')

# columns represent:
# elapsedTime,eventRecognized_tap,eventRecognized_hold,frq_rt, col_rt, frq_m, col_m, amp_rt,orbitSpeed,amp_m,shape_m_value, framerate
time_a = dat_1[:, 0]
event_tap_a = dat_1[:, 1]
event_hold_a = dat_1[:, 2]
frq_rt_a = dat_1[:, 3]
col_rt_a = dat_1[:, 4]
frq_m_a = dat_1[:, 5]
col_m_a = dat_1[:, 6]
amp_rt_a = dat_1[:, 7]
orbit_a = dat_1[:, 8]
amp_m_a = dat_1[:, 9]
m_a = dat_1[:, 10]
fr_a = dat_1[:, 11]

time_b = dat_2[:, 0]
event_tap_b = dat_2[:, 1]
event_hold_b = dat_2[:, 2]
frq_rt_b = dat_2[:, 3]
col_rt_b = dat_2[:, 4]
frq_m_b = dat_2[:, 5]
col_m_b = dat_2[:, 6]
amp_rt_b = dat_2[:, 7]
orbit_b = dat_2[:, 8]
amp_m_b = dat_2[:, 9]
m_b = dat_2[:, 10]
fr_b = dat_2[:, 11]

plt.figure()
plt.plot(frq_rt_a)
plt.plot(frq_m_a)

#plt.figure()
#plt.plot(col_rt_a)
#plt.plot(col_m_a)

plt.subplot(amp_rt_a[:])
plt.subplot(amp_m_a[:])
#plt.plot(fr_1[600:]/600)

#plt.figure()
plt.subplot(event_tap_a[:])
#plt.plot(event_hold_a[:])

fig, (ax0, ax1, ax2) = plt.subplots(3)
ax0.plot(frq_rt_a)
ax0.plot(frq_m_a)
ax1.plot(amp_rt_a[:])
ax1.plot(amp_m_a[:])
ax2.plot(event_tap_a[:])


fig2, (ax0, ax1, ax2) = plt.subplots(3)
ax0.plot(frq_rt_b)
ax0.plot(frq_m_b)
ax1.plot(amp_rt_b[:])
ax1.plot(amp_m_b[:])
ax2.plot(event_tap_b[:])