import os
import sys

def run(runs, start=10, step=1):
    for x in xrange(start, runs, step):
        run_command(x)

def run_command(x):
    print 'Executing run: ' + str(x) + '\n'
    os.system("cp examples/default_gaoler.config examples/gaoler.config")
    os.system("echo \"{concurrent, " + str(x) + "}.\" >> examples/gaoler.config")
    os.system("./basho_bench examples/gaoler.config")
    os.system("./priv/summary.r -i tests/current")
    os.system("mv tests/current/summary.png results/summary_"+str(x)+".png")
    os.system("./restart.sh")

if "__main__" == __name__:
    print 'Running basho_bench...\n'
    if sys.argv[1] == '1':
        run_command(1)
    else:
        run_command(1)
        run(int(sys.argv[1]),start=int(sys.argv[2]),step=int(sys.argv[3]))
