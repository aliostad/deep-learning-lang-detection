using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Magus.Data {
    interface DataLoader {

        void loadRaces();

        void loadClasses();

        void loadPerks();

        void loadSkills();

        void loadCommonItems();

        void loadArmors();

        void loadShields();

        void loadWeapons();

        void loadMaterials();

        void loadDeities();

        void loadMagicShools();

        void loadAreas();

        void loadPantheons();
    }
}
