#!/usr/bin/python3

import time
import os
import sys

arg = sys.argv
cmd = sys.argv[1]
comment = input('Comment : ')
start = time.time()
os.system(cmd)
end = time.time()
seconds = end - start
minutes = seconds/60
hours = minutes/60
print("Elapsed time : %d hours %d minutes %d seconds"%(hours,minutes,seconds))

with open("logfile","a") as f:
	f.write("# "+comment+"\n")
	f.write("$ "+' '.join(arg[1:])+"\n")
	f.write("Elapsed time : %d hours %d minutes %d seconds"%(hours,minutes,seconds)+"\n\n")
