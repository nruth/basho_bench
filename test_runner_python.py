import os
import sys

def run(runs, step=1):
    for x in xrange(2, runs, step):
        run_command(x)

def run_command(x):
    print 'Executing run: ' + str(x) + '\n'
    os.system("cp examples/default_gaoler.config examples/gaoler.config")
    os.system("echo \"{concurrent, " + str(x) + "}.\" >> examples/gaoler.config")
    os.system("./basho_bench examples/gaoler.config")
    os.system("make results")
    os.system("mv tests/current/summary.png results/summary_"+str(x)+".png")

if __main__ == '__name__':
    print 'Running basho_bench...\n'
    if sys.argv[1] == '1':
        run_command(1)
    else:
        run_command(1)
        run(int(sys.argv[1]),step=int(sys.argv[2]))
