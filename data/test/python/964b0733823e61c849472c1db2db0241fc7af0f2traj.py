import mdtraj as md

traj=md.load("traj0.xtc",top="conf.gro")
traj1=traj[:100]
traj2=traj[:1000]
traj3=traj[:5000]
traj4=traj[:10000]
traj5=traj[:25000]
traj6=traj[:50000]
traj7=traj[:75000]
traj8=traj[:100000]
traj9=traj[:125000]
traj10=traj[:150000]
traj11=traj[:175000]
traj1.save("1ns.xtc")
traj2.save("10ns.xtc")
traj3.save("50ns.xtc")
traj4.save("100ns.xtc")
traj5.save("250ns.xtc")
traj6.save("500ns.xtc")
traj7.save("750ns.xtc")
traj8.save("1000ns.xtc")
traj9.save("1250ns.xtc")
traj10.save("1500ns.xtc")
traj11.save("1750ns.xtc")
