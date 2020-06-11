package character;

import character.data.*;
import java.io.Serializable;

public class DekaederCharacter implements Serializable {
	//variabler
	private ConceptHandler      conceptHandler;
	private PointHandler        pointHandler;
        private SkillHandler        skillHandler;
        private SpecialityHandler   specialityHandler;
        private HookHandler         hookHandler;
        private AdvantageHandler    advantageHandler;

	public DekaederCharacter(ConceptHandler conceptHandler, 
            PointHandler pointHandler, SkillHandler skillHandler,
            SpecialityHandler specialityHandler, HookHandler hookHandler,
            AdvantageHandler advantageHandler) {
            this.conceptHandler = conceptHandler;
            this.pointHandler = pointHandler;
            this.skillHandler = skillHandler;
            this.specialityHandler = specialityHandler;
            this.hookHandler = hookHandler;
            this.advantageHandler = advantageHandler;
	}

	public ConceptHandler getConceptHandler() {
            return conceptHandler;
	}

	public PointHandler getPointHandler() {
            return pointHandler;
	}

        public SkillHandler getSkillHandler() {
            return skillHandler;
        }

        public SpecialityHandler getSpecialityHandler() {
            return specialityHandler;
        }

        public HookHandler getHookHandler() {
            return hookHandler;
        }

        public AdvantageHandler getAdvantageHandler() {
            return advantageHandler;
        }
}