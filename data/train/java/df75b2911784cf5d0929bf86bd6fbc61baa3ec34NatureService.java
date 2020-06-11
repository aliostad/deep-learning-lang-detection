package se.patrikbergman.java.mockito;

class NatureService {
	private final AnimalService animalService;
	private final FlowerService flowerService;

	public NatureService(AnimalService animalService, FlowerService flowerService) {
		this.animalService = animalService;
		this.flowerService = flowerService;
	}

	public void makeAnimalsMoveAndFlowersBlossom() {
		animalService.moveAnimals();
		flowerService.makeFlowersBlossom();
	}

	public Animal getOldestAnimalInNature() {
		return animalService.getOldestAnimal();
	}
}
