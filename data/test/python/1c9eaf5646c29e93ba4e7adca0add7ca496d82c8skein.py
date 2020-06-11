from  lib.skeinforge.skeinforge_application.skeinforge_plugins.analyze_plugins.statistic import StatisticRepository
from  lib.skeinforge.skeinforge_application.skeinforge_plugins.analyze_plugins.statistic import StatisticSkein
#from lib.skeinforge.fabmetheus_utilities import writeOutput


repository = StatisticRepository()
repository.density = 930.0
repository.material = 20.0


def skein(filename):
  gcode = gcodec.getGcodeFileText(filename,' ')
  gfile ="%s.gcode" % filename 
  statistics = StatisticSkein().getCraftedGcode(gcode, repository )
  print statistics

